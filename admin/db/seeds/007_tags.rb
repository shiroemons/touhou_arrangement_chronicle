require 'csv'

tags = []
CSV.table('db/fixtures/tags.tsv', col_sep: "\t", converters: nil).each do |t|
  tags << Tag.new(
    name: t[:name],
    description: t[:description],
    note: t[:note]
  )
end

return if tags.blank?
Tag.import tags, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :description,
    :note
  ]
}
