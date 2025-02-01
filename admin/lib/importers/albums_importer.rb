require "progress_bar"

class AlbumsImporter
  def self.import(json_path)
    json_data = JSON.parse(File.read(json_path))

    # プログレスバーの初期化
    bar = ProgressBar.new(json_data.length) do |b|
      b.bar_mark = "="
      b.bar_end = ">"
      b.title = "Importing Albums"
      b.remaining_mark = " "
    end

    json_data.each do |album_data|
      begin
        ActiveRecord::Base.transaction do
          album_attrs = album_data["album"]

          # サークルの取得
          circles = album_attrs["circles"].map do |circle_name|
            Circle.find_by!(name: circle_name)
          end

          # アルバムの取得または作成
          album = Album.find_or_initialize_by(
            name: album_attrs["name"]
          )

          # サークル関連の処理
          if circles.length == 1
            album.release_circle = circles.first
            album.release_circle_name = nil
          else
            album.release_circle = nil
            album.release_circle_name = circles.map(&:name).join("×")
          end

          # イベント日程の取得
          event_day = nil
          if album_attrs["event"] && album_attrs["event"]["name"].present?
            event_edition = EventEdition.find_by(
              name: album_attrs["event"]["name"]
            )
            event_day = EventDay.find_by(
              event_edition: event_edition,
              event_date: album_attrs["event"]["date"]
            )
          end

          # アルバム情報の更新
          album.assign_attributes(
            release_date: album_attrs["release_date"],
            release_year: album_attrs["release_year"],
            release_month: album_attrs["release_month"],
            event_day: event_day,
            slug: SecureRandom.uuid
          )
          album.save!

          # アルバムとサークルの関連付け更新
          existing_circle_ids = album.albums_circles.pluck(:circle_id)
          circles.each do |circle|
            next if existing_circle_ids.include?(circle.id)
            AlbumsCircle.create!(album: album, circle: circle)
          end

          # 配信サービスURLの更新
          if album_attrs["distribution_services"].present?
            update_distribution_services(album, album_attrs["distribution_services"])
          end

          # ディスク情報の更新
          disc_numbers = album_attrs["songs"].map { |s| s["disc_number"] }.uniq
          disc_numbers.each do |disc_number|
            album_disc = AlbumDisc.find_or_initialize_by(
              album: album,
              disc_number: disc_number
            )
            album_disc.save! if album_disc.new_record?
          end

          # 楽曲の作成/更新
          album_attrs["songs"].each do |song_attrs|
            # 楽曲の取得または作成
            song = Song.find_or_initialize_by(
              name: song_attrs["name"],
              album: album
            )

            # 楽曲情報の更新
            if circles.length == 1
              song.circle = circles.first
            else
              song.circle = nil
            end

            song.assign_attributes(
              disc_number: song_attrs["disc_number"],
              track_number: song_attrs["track_number"],
              release_date: album_attrs["release_date"],
              release_year: album_attrs["release_year"],
              release_month: album_attrs["release_month"],
              slug: SecureRandom.uuid
            )
            song.save!

            # 複数サークルの場合、songs_arrange_circlesを作成
            if circles.length > 1
              circles.each do |circle|
                SongsArrangeCircle.find_or_create_by!(song:, circle:)
              end
            end

            # アーティストと役割の関連付け更新
            update_artist_roles(song, song_attrs["arrangers"], "arranger")
            update_artist_roles(song, song_attrs["composers"], "composer")
            update_artist_roles(song, song_attrs["lyricists"], "lyricist")
            update_artist_roles(song, song_attrs["vocalists"], "vocalist")

            # 原曲との関連付け更新
            update_original_songs(song, song_attrs["original_songs"])

            # タグの関連付け更新
            update_tags(song, song_attrs["tags"])

            # 楽曲の配信サービスURLの更新
            if song_attrs["distribution_services"].present?
              update_distribution_services(song, song_attrs["distribution_services"])
            end
          end
        end
      rescue => e
        Rails.logger.error "Failed to import album: #{album_data["album"]["name"]}"
        Rails.logger.error "Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      ensure
        # エラーが発生しても進捗バーは進める
        bar.increment!
      end
    end
  end

  private

  def self.update_distribution_services(streamable, distribution_services)
    return if distribution_services.blank?

    existing_urls = streamable.streamable_urls.pluck(:service_name, :url).to_h

    distribution_services.each do |service|
      service_name = service["name"]
      url = service["url"]
      next if existing_urls[service_name] == url

      streamable_url = StreamableUrl.find_or_initialize_by(
        streamable: streamable,
        streamable_type: streamable.class.name,
        service_name: service_name
      )
      streamable_url.url = url
      streamable_url.save!
    end
  end

  def self.update_artist_roles(song, artist_names, role_type)
    return if artist_names.blank?

    role = ArtistRole.find_by!(name: role_type)
    existing_artist_roles = song.songs_artist_roles.where(artist_role: role)
    existing_artist_name_ids = existing_artist_roles.pluck(:artist_name_id)

    artist_names.each do |name|
      artist_name = ArtistName.find_by!(name: name)
      next if existing_artist_name_ids.include?(artist_name.id)

      SongsArtistRole.create!(
        song: song,
        artist_name: artist_name,
        artist_role: role
      )
    end
  end

  def self.update_original_songs(song, original_songs_data)
    return if original_songs_data.blank?

    existing_original_song_ids = song.songs_original_songs.pluck(:original_song_id)

    original_songs_data.each do |original|
      Rails.logger.info "Processing original song: #{original.inspect}"
      original_song_name = original["name"]
      if original_song_name == "アンノウンX　～ Occultly Madness"
        original_song_name = "アンノウンＸ　～ Occultly Madness"
      end

      begin
        original_song = OriginalSong.find_by(
          name: original_song_name,
          is_original: true,
        )
        original_song ||= OriginalSong.joins(:product).find_by(
          name: original_song_name,
          product: {
            name: original["product_name"]
          }
        )
        original_song ||= OriginalSong.find_by!(name: original_song_name)
        next if existing_original_song_ids.include?(original_song.id)

        SongsOriginalSong.create!(
          song: song,
          original_song: original_song
        )
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error "Failed to find original song: #{original_song_name}"
        Rails.logger.error "Song being processed: #{song.name} (Album: #{song.album.name})"
        raise e
      end
    end
  end

  def self.update_tags(song, tag_names)
    existing_tag_ids = song.taggings.pluck(:tag_id)

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by!(name: tag_name)
      next if existing_tag_ids.include?(tag.id)

      Tagging.create!(
        taggable: song,
        taggable_type: "Song",
        tag: tag
      )
    end
  end
end
