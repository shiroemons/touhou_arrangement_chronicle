require 'csv'
require 'activerecord-import'

# TSVファイルのパス
tsv_path = Rails.root.join('tmp/circles.tsv')

# TSVファイルを読み込む
circles_data = CSV.read(tsv_path, col_sep: "\t", headers: true)

# インポート用の配列を作成
circles = []
circles_data.each do |row|
  # ダブルクォートを除去
  name = row['circle_name'].gsub(/^"(.*)"$/, '\1')

  circle = Circle.new(
    name: name,
    slug: SecureRandom.uuid, # 一時的なスラッグを生成
    published_at: Time.zone.now
  )
  circles << circle
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
