class Avo::Resources::OriginalSong < Avo::BaseResource
  self.title = :name
  self.translation_key = "activerecord.resources.original_song"
  self.includes = [ :product, :origin_original_song ]
  self.default_sort_column = :id 
  self.default_sort_direction = :asc

  def fields
    field :id, as: :text
    field :created_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :updated_at, as: :date_time, hide_on: [ :index, :new, :edit ]
    field :product, as: :belongs_to, required: true
    field :name, as: :text, required: true,
      help: "原曲名"

    field :name_reading, as: :text,
      help: "原曲名読み方"

    field :composer, as: :text,
      help: "作曲者"

    field :arranger, as: :text,
      help: "編曲者（原作側）"

    field :track_number, as: :number, required: true,
      help: "作品中でのトラック番号"

    field :is_original, as: :boolean, required: true,
      help: "初出オリジナル曲か否か"

    field :origin_original_song, as: :belongs_to,
      help: "派生元となった原曲"

    # 逆方向の関連
    field :derived_original_songs, as: :has_many,
      help: "この原曲から派生した原曲"

    field :songs, as: :has_many, through: :songs_original_songs
  end
end
