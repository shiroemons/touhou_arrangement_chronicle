require 'csv'

distribution_services = []
CSV.table('db/fixtures/distribution_services.tsv', col_sep: "\t", converters: nil).each do |ds|
  distribution_services << {
    service_name: ds[:service_name],
    display_name: ds[:display_name],
    base_urls: ds[:base_urls].split(','),
    description: ds[:description],
    position: ds[:position]
  }
end

return if distribution_services.blank?

DistributionService.upsert_all(
  distribution_services,
  unique_by: :service_name,
  record_timestamps: true
)
