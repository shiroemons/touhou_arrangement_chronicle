require 'csv'

artist_roles = []
CSV.table('db/fixtures/artist_roles.tsv', col_sep: "\t", converters: nil).each do |ar|
  artist_roles << ArtistRole.new(
    name: ar[:name],
    display_name: ar[:display_name],
    description: ar[:description],
    note: ar[:note]
  )
end

return if artist_roles.blank?
ArtistRole.import artist_roles, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :display_name,
    :description,
    :note
  ]
}
