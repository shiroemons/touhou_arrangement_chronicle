class OriginalSongDistributionServiceUrlResource < Avo::BaseResource
  self.record_selector = false
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :original_song, as: :belongs_to
  field :service, as: :badge, options: { success: %w[spotify line_music], danger: %w[apple_music youtube_music] }
  field :url, as: :text
end
