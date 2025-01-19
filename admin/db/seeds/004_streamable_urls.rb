require 'csv'

# 作品の配信URL
product_urls = []
CSV.table('db/fixtures/product_distribution_service_urls.tsv', col_sep: "\t", converters: nil).each do |p|
  %w[spotify apple_music youtube_music line_music].each do |service|
    url = p[:"#{service}_url"]
    next if url.blank?

    product_urls << {
      streamable_type: 'Product',
      streamable_id: p[:product_id],
      service_name: service,
      url: url,
      position: 1
    }
  end
end

# 楽曲の配信URL
original_song_urls = []
CSV.table('db/fixtures/original_song_distribution_service_urls.tsv', col_sep: "\t", converters: nil).each do |os|
  %w[spotify apple_music youtube_music line_music].each do |service|
    url = os[:"#{service}_url"]
    next if url.blank?

    original_song_urls << {
      streamable_type: 'OriginalSong',
      streamable_id: os[:original_song_id],
      service_name: service,
      url: url,
      position: 1
    }
  end
end

urls = product_urls + original_song_urls
return if urls.blank?

StreamableUrl.import urls,
  on_duplicate_key_update: {
    conflict_target: [ :streamable_type, :streamable_id, :service_name ],
    columns: [ :url, :position, :updated_at ]
  }
