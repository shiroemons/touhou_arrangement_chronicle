require 'csv'

shops = []
CSV.table('db/fixtures/shops.tsv', col_sep: "\t", converters: nil).each do |s|
  shops << Shop.new(
    name: s[:name],
    display_name: s[:display_name],
    description: s[:description],
    note: s[:note],
    website_url: s[:website_url],
    base_urls: s[:base_urls].split(','),
    position: s[:position]
  )
end

return if shops.blank?
Shop.import shops, on_duplicate_key_update: {
  conflict_target: [ :name ],
  columns: [
    :display_name,
    :description,
    :note,
    :website_url,
    :base_urls,
    :position
  ]
}
