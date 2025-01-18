class ArtistName < ApplicationRecord
  # 列挙型の定義
  enum :first_character_type, {
    symbol: "symbol",
    number: "number",
    alphabet: "alphabet",
    hiragana: "hiragana",
    katakana: "katakana",
    kanji: "kanji",
    other: "other"
  }

  # 関連
  belongs_to :artist
  has_many :songs_artist_roles
  has_many :songs, through: :songs_artist_roles
  has_many :artist_roles, through: :songs_artist_roles

  # バリデーション
  validates :name, presence: true
  validates :first_character_type, presence: true
  validates :is_main_name, inclusion: { in: [ true, false ] }

  # first_characterとfirst_character_rowの条件付きバリデーション
  validates :first_character, presence: true, if: -> { %w[alphabet hiragana katakana].include?(first_character_type) }
  validates :first_character_row, presence: true, if: -> { %w[hiragana katakana].include?(first_character_type) }
end
