require 'csv'

products = []
CSV.table('db/fixtures/products.tsv', col_sep: "\t", converters: nil).each do |p|
  products << Product.new(
    id: p[:id],
    name: p[:name],
    short_name: p[:short_name],
    product_type: p[:product_type],
    series_number: p[:series_number],
  )
end

return if products.blank?
Product.import products, on_duplicate_key_update: {
  conflict_target: [ :id ],
  columns: [
    :name,
    :short_name,
    :product_type,
    :series_number
  ]
}
