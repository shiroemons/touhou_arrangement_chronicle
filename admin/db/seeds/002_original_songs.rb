require 'csv'

original_songs = []
CSV.table('db/fixtures/original_songs.tsv', col_sep: "\t", converters: nil).each do |os|
  original_songs << OriginalSong.new(
    id: os[:id],
    product_id: os[:product_id],
    track_number: os[:track_number],
    name: os[:name],
    composer: os[:composer],
    arranger: os[:arranger],
    is_original: os[:is_original],
    origin_original_song_id: os[:origin_original_song_id],
  )
end

return if original_songs.blank?
OriginalSong.import original_songs, on_duplicate_key_update: {
  conflict_target: [ :id ],
  columns: [
    :product_id,
    :track_number,
    :name,
    :composer,
    :arranger,
    :is_original,
    :origin_original_song_id
  ]
}
