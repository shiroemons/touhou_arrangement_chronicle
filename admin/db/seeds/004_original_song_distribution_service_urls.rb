require 'csv'

original_song_distribution_service_urls = []
CSV.table('db/fixtures/original_song_distribution_service_urls.tsv', col_sep: "\t", converters: nil).each do |sr|
  if sr[:spotify_url].present? && !OriginalSongDistributionServiceUrl.exists?(original_song_id: sr[:original_song_id], service: "spotify")
    original_song_distribution_service_urls << OriginalSongDistributionServiceUrl.new(
      original_song_id: sr[:original_song_id],
      service: "spotify",
      url: sr[:spotify_url],
    )
  end
  if sr[:apple_music_url].present? && !OriginalSongDistributionServiceUrl.exists?(original_song_id: sr[:original_song_id], service: "apple_music")
    original_song_distribution_service_urls << OriginalSongDistributionServiceUrl.new(
      original_song_id: sr[:original_song_id],
      service: "apple_music",
      url: sr[:apple_music_url],
    )
  end
  if sr[:youtube_music_url].present? && !OriginalSongDistributionServiceUrl.exists?(original_song_id: sr[:original_song_id], service: "youtube_music")
    original_song_distribution_service_urls << OriginalSongDistributionServiceUrl.new(
      original_song_id: sr[:original_song_id],
      service: "youtube_music",
      url: sr[:youtube_music_url],
    )
  end
  if sr[:line_music_url].present? && !OriginalSongDistributionServiceUrl.exists?(original_song_id: sr[:original_song_id], service: "line_music")
    original_song_distribution_service_urls << OriginalSongDistributionServiceUrl.new(
      original_song_id: sr[:original_song_id],
      service: "line_music",
      url: sr[:line_music_url],
    )
  end
end

return if original_song_distribution_service_urls.blank?
OriginalSongDistributionServiceUrl.import original_song_distribution_service_urls, on_duplicate_key_update: {
  conflict_target: [:original_song_id, :service],
  columns: [
    :url,
  ],
}
