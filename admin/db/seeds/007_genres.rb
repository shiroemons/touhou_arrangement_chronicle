require 'csv'

genres = []
CSV.table('db/fixtures/genres.tsv', col_sep: "\t", converters: nil).each do |g|
  genres << Genre.new(
    name: g[:name],
  ) unless Genre.exists?(name: g[:name])
end

return if genres.blank?
Genre.import genres, on_duplicate_key_ignore: true
