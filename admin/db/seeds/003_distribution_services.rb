require 'csv'

distribution_services = []
CSV.table('db/fixtures/distribution_services.tsv', col_sep: "\t", converters: nil).each do |ds|
  distribution_services << DistributionService.new(
    service_name: ds[:service_name],
    display_name: ds[:display_name],
    base_urls: ds[:base_urls].split(','),
    description: ds[:description],
    position: ds[:position]
  )
end

return if distribution_services.blank?

DistributionService.import distribution_services,
  on_duplicate_key_update: {
    conflict_target: [ :service_name ],
    columns: [ :display_name, :base_urls, :description, :position, :updated_at ]
  }
