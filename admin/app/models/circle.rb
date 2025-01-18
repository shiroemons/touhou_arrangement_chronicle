class Circle < ApplicationRecord
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
  has_many :albums_circles
  has_many :albums, through: :albums_circles
  has_many :songs_arrange_circles
  has_many :songs, through: :songs_arrange_circles
  has_many :entity_urls, as: :entity
  has_many :entity_genres, as: :entity
  has_many :entity_tags, as: :entity

  # バリデーション
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :first_character_type, presence: true

  # first_characterとfirst_character_rowの条件付きバリデーション
  validates :first_character, presence: true, if: -> { %w[alphabet hiragana katakana].include?(first_character_type) }
  validates :first_character_row, presence: true, if: -> { %w[hiragana katakana].include?(first_character_type) }
end
