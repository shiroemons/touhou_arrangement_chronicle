require 'csv'

product_distribution_service_urls = []
CSV.table('db/fixtures/product_distribution_service_urls.tsv', col_sep: "\t", converters: nil).each do |sr|
  if sr[:spotify_url].present? && !ProductDistributionServiceUrl.exists?(product_id: sr[:product_id], service: "spotify")
    product_distribution_service_urls << ProductDistributionServiceUrl.new(
      product_id: sr[:product_id],
      service: "spotify",
      url: sr[:spotify_url],
    )
  end
  if sr[:apple_music_url].present? && !ProductDistributionServiceUrl.exists?(product_id: sr[:product_id], service: "apple_music")
    product_distribution_service_urls << ProductDistributionServiceUrl.new(
      product_id: sr[:product_id],
      service: "apple_music",
      url: sr[:apple_music_url],
    )
  end
  if sr[:youtube_music_url].present? && !ProductDistributionServiceUrl.exists?(product_id: sr[:product_id], service: "youtube_music")
    product_distribution_service_urls << ProductDistributionServiceUrl.new(
      product_id: sr[:product_id],
      service: "youtube_music",
      url: sr[:youtube_music_url],
    )
  end
  if sr[:line_music_url].present? && !ProductDistributionServiceUrl.exists?(product_id: sr[:product_id], service: "line_music")
    product_distribution_service_urls << ProductDistributionServiceUrl.new(
      product_id: sr[:product_id],
      service: "line_music",
      url: sr[:line_music_url],
    )
  end
end

return if product_distribution_service_urls.blank?
ProductDistributionServiceUrl.import product_distribution_service_urls, on_duplicate_key_update: {
  conflict_target: [:product_id, :service],
  columns: [
    :url,
  ],
}
