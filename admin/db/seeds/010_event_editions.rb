require 'csv'
require 'activerecord-import'

# TSVファイルのパス
tsv_path = Rails.root.join('tmp/events.tsv')

# TSVファイルを読み込む
events_data = CSV.read(tsv_path, col_sep: "\t", headers: true)

# イベントシリーズのマッピングを取得
event_series_mapping = EventSeries.pluck(:name, :id).to_h

# インポート用の配列を作成
event_editions = []
event_days = []
current_edition = nil
position = 1

events_data.each do |row|
  series_name = row[0]
  edition_name = row[1]
  edition_display_name = row[2]
  edition_display_name_reading = row[3]
  start_date = row[4]
  end_date = row[5]
  touhou_date = row[6]
  base_slug = row[7]
  day_number = row[8]
  day_display_name = row[9]
  event_date = row[10]
  region_code = row[11]
  is_cancelled = row[12] == 'true'
  is_online = row[13] == 'true'

  # イベントシリーズIDを取得
  series_id = event_series_mapping[series_name]
  next unless series_id

  # 新しいeditionの場合
  if current_edition.nil? || current_edition[:name] != edition_name
    # slugを一意にするために年月を追加
    unique_slug = if start_date.present?
                   date = Date.parse(start_date)
                   "#{date.strftime('%Y%m')}-#{base_slug}"
    else
                   "#{SecureRandom.hex(4)}-#{base_slug}"
    end

    current_edition = {
      event_series_id: series_id,
      name: edition_name,
      display_name: edition_display_name,
      display_name_reading: edition_display_name_reading,
      slug: unique_slug,
      start_date: start_date,
      end_date: end_date,
      touhou_date: touhou_date,
      position: position,
      published_at: Time.zone.now
    }
    event_editions << EventEdition.new(current_edition)
    position += 1
  end

  # event_daysレコードを作成
  event_days << EventDay.new(
    event_edition: event_editions.last,
    day_number: day_number,
    display_name: day_display_name,
    event_date: event_date,
    region_code: region_code,
    is_cancelled: is_cancelled,
    is_online: is_online,
    position: day_number || 1,
    published_at: Time.zone.now
  )
end

# バルクインサート実行前にデータを一意にする
unique_editions = {}
event_editions.each do |edition|
  key = [ edition.event_series_id, edition.name ]
  unique_editions[key] = edition unless unique_editions.key?(key)
end

unique_edition_values = unique_editions.values
batch_size = 100

# 既存のレコードを取得
existing_editions = EventEdition.all.map { |e| {
  id: e.id,
  series_id: e.event_series_id,
  name: e.name,
  record: e
} }

# 重複チェックとスキップ/更新
skipped_editions = []
new_editions = []
updated_editions = []

unique_edition_values.each do |edition|
  existing = existing_editions.find { |e| e[:series_id] == edition.event_series_id && e[:name] == edition.name }
  if existing
    # 更新が必要か確認
    record = existing[:record]
    if record.display_name != edition.display_name ||
       record.display_name_reading != edition.display_name_reading ||
       record.slug != edition.slug ||
       record.start_date != edition.start_date ||
       record.end_date != edition.end_date ||
       record.touhou_date != edition.touhou_date ||
       record.position != edition.position
      updated_editions << edition
      record.update!(
        display_name: edition.display_name,
        display_name_reading: edition.display_name_reading,
        slug: edition.slug,
        start_date: edition.start_date,
        end_date: edition.end_date,
        touhou_date: edition.touhou_date,
        position: edition.position,
        updated_at: Time.current
      )
    else
      skipped_editions << edition
    end
  else
    new_editions << edition
  end
end

# 新規レコードのみバッチインサート
if new_editions.any?
  new_editions.each_slice(batch_size) do |batch|
    EventEdition.import batch
  end
end

# event_daysも同様に既存/新規を分けて処理
existing_days = EventDay.all.map { |d| {
  id: d.id,
  edition_id: d.event_edition_id,
  day_number: d.day_number,
  is_online: d.is_online,
  record: d
} }

# 重複チェックとスキップ/更新
skipped_days = []
new_days = []
updated_days = []

event_days.each do |day|
  existing = existing_days.find { |d|
    d[:edition_id] == day.event_edition_id &&
    d[:day_number] == day.day_number &&
    d[:is_online] == day.is_online
  }

  if existing
    record = existing[:record]
    if record.display_name != day.display_name ||
       record.event_date != day.event_date ||
       record.region_code != day.region_code ||
       record.is_cancelled != day.is_cancelled ||
       record.position != day.position
      updated_days << day
      record.update!(
        display_name: day.display_name,
        event_date: day.event_date,
        region_code: day.region_code,
        is_cancelled: day.is_cancelled,
        position: day.position,
        updated_at: Time.current
      )
    else
      skipped_days << day
    end
  else
    new_days << day
  end
end

# 新規レコードのみバッチインサート
if new_days.any?
  new_days.each_slice(batch_size) do |batch|
    EventDay.import batch
  end
end
