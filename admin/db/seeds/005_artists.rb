require 'csv'

artists = []
CSV.table('db/fixtures/artists.tsv', col_sep: "\t", converters: nil).each do |a|
  artists << Artist.new(name: a[:name]) unless Artist.exists?(name: a[:name])
end

return if artists.blank?
Artist.import artists, validate: true, on_duplicate_key_ignore: true
