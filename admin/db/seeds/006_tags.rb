require 'csv'

tags = []
CSV.table('db/fixtures/tags.tsv', col_sep: "\t", converters: nil).each do |t|
  tags << Tag.new(
    name: t[:name],
    type: t[:type],
  ) unless Tag.exists?(name: t[:name])
end

return if tags.blank?
Tag.import tags, on_duplicate_key_ignore: true
