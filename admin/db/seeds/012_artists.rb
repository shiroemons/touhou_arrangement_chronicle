require 'csv'
require 'activerecord-import'

# TSVファイルのパス
tsv_path = Rails.root.join('tmp/artists.tsv')

# TSVファイルを読み込む
artists_data = CSV.read(tsv_path, col_sep: "\t", headers: true)

# アーティストとその名義の関係を整理
artist_groups = {}

artists_data.each do |row|
  # ダブルクォートを除去
  artist_name = row['artist_name'].gsub(/^"(.*)"$/, '\1')
  parent_name = row['parent_artist_name']&.gsub(/^"(.*)"$/, '\1')
  is_main_name = row['is_main_name'] == 'true'

  if parent_name.present?
    # 別名義の場合、親アーティストのグループに追加
    artist_groups[parent_name] ||= { names: [] }
    artist_groups[parent_name][:names] << {
      name: artist_name,
      is_main_name: false
    }
  else
    # 親アーティストの場合、新しいグループを作成
    artist_groups[artist_name] ||= { names: [] }
    artist_groups[artist_name][:names] << {
      name: artist_name,
      is_main_name: is_main_name
    }
  end
end

# インポート用の配列を作成
artists = []
artist_names = []

artist_groups.each do |main_name, group|
  # アーティストレコードを作成
  artist = Artist.new(
    name: main_name, # 管理用の名前として親アーティスト名を使用
    created_at: Time.current,
    updated_at: Time.current
  )
  artists << artist

  # 名義レコードを作成
  group[:names].each do |name_data|
    artist_name = ArtistName.new(
      name: name_data[:name],
      is_main_name: name_data[:is_main_name],
      created_at: Time.current,
      updated_at: Time.current
    )
    artist_names << artist_name
  end
end

# アーティストのバルクインサート実行
Artist.import artists, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [ :updated_at ]
}

# アーティストのIDを取得
artist_name_to_id = Artist.where(name: artists.map(&:name)).pluck(:name, :id).to_h

# artist_namesにartist_idを設定
artist_names.each do |artist_name|
  # 親アーティストを探す
  parent_name = artist_groups.find { |_, group|
    group[:names].any? { |n| n[:name] == artist_name.name }
  }&.first

  artist_name.artist_id = artist_name_to_id[parent_name] if parent_name
end

# 既存のレコードを確認
existing_artist_names = ArtistName.where(name: artist_names.map(&:name)).index_by(&:name)

# 新規レコードと更新レコードを分離
new_artist_names = []
update_artist_names = []

artist_names.each do |artist_name|
  existing = existing_artist_names[artist_name.name]
  if existing
    existing.assign_attributes(
      artist_id: artist_name.artist_id,
      is_main_name: artist_name.is_main_name,
      updated_at: Time.current
    )
    update_artist_names << existing
  else
    new_artist_names << artist_name
  end
end

# 新規レコードのインポート
ArtistName.import new_artist_names if new_artist_names.present?

# 既存レコードの更新
update_artist_names.each(&:save!) if update_artist_names.present?
