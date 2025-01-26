require 'csv'
require 'activerecord-import'

# TSVファイルのパス
tsv_path = Rails.root.join('db/fixtures/event_series.tsv')

# TSVファイルを読み込む
event_series_data = CSV.read(tsv_path, col_sep: "\t", headers: true)

# インポート用の配列を作成
event_series = []
position = 1

event_series_data.each do |row|
  event_series << EventSeries.new(
    name: row['series_name'],
    display_name: row['series_display_name'],
    display_name_reading: row['series_display_name_reading'],
    slug: row['series_slug'],
    position: position,
    published_at: Time.zone.now,
  )
  position += 1
end

# バルクインサート実行
EventSeries.import event_series, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :display_name_reading,
    :slug,
    :published_at
  ]
}
