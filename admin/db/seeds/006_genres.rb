require 'csv'

genres = []
CSV.table('db/fixtures/genres.tsv', col_sep: "\t", converters: nil).each do |g|
  genres << Genre.new(
    name: g[:name],
    description: g[:description],
    note: g[:note]
  )
end

return if genres.blank?
Genre.import genres, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :description,
    :note
  ]
}
