class SongDistributionServiceUrlResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :song, as: :belongs_to, required: true
  field :service, as: :badge, options: { success: %w[spotify line_music], danger: %w[apple_music youtube_music] }
  field :url, as: :text, required: true
end
