require 'csv'
require 'activerecord-import'

# TSVファイルのパス
tsv_path = Rails.root.join('tmp/circles.tsv')

# TSVファイルを読み込む
circles_data = CSV.read(tsv_path, col_sep: "\t", headers: true)

# インポート用の配列を作成
circles = []
reference_urls = []

circles_data.each do |row|
  # ダブルクォートを除去
  name = row['circle_name'].gsub(/^"(.*)"$/, '\1')

  circle = Circle.new(
    name: name,
    slug: SecureRandom.uuid, # 一時的なスラッグを生成
    published_at: Time.zone.now
  )
  circles << circle

  # URLとblog_urlが存在する場合、reference_urlsに追加
  if row['url'].present?
    reference_urls << {
      referenceable_type: 'Circle',
      url_type: 'official',
      url: row['url'].strip
    }
  end

  if row['blog_url'].present?
    reference_urls << {
      referenceable_type: 'Circle',
      url_type: 'blog',
      url: row['blog_url'].strip
    }
  end
end

# サークルのバルクインサート実行
Circle.import circles, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :first_character_type,
    :first_character,
    :first_character_row,
    :updated_at
  ]
}

# サークルのIDを取得
circle_name_to_id = Circle.where(name: circles.map(&:name)).pluck(:name, :id).to_h

# reference_urlsにcircle_idを設定
reference_urls.each do |ref_url|
  circle_name = circles_data.find { |row| row['url'] == ref_url[:url] || row['blog_url'] == ref_url[:url] }['circle_name'].gsub(/^"(.*)"$/, '\1')
  ref_url[:referenceable_id] = circle_name_to_id[circle_name]
end

# 重複を除去（referenceable_type, referenceable_id, urlの組み合わせで一意）
unique_reference_urls = reference_urls.uniq { |ref| [ ref[:referenceable_type], ref[:referenceable_id], ref[:url] ] }

# reference_urlsのバルクインサート実行
ReferenceUrl.import unique_reference_urls, on_duplicate_key_update: {
  conflict_target: [ :referenceable_type, :referenceable_id, :url ],
  columns: [ :url_type, :updated_at ]
}
