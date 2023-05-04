class SongsOriginalSongResource < Avo::BaseResource
  self.title = :song_id
  self.visible_on_sidebar = false
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :song, as: :belongs_to
  field :original_song, as: :belongs_to
end
