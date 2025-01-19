class Product < ApplicationRecord
  # 列挙型の定義
  enum :product_type, {
    pc98: "pc98",
    windows: "windows",
    zuns_music_collection: "zuns_music_collection",
    akyus_untouched_score: "akyus_untouched_score",
    commercial_books: "commercial_books",
    tasofro: "tasofro",
    other: "other"
  }

  # 関連
  has_many :original_songs, dependent: :restrict_with_error
  has_many :streamable_urls, -> { order(position: :asc) }, as: :streamable, dependent: :destroy

  # バリデーション
  validates :id, presence: true
  validates :name, presence: true
  validates :short_name, presence: true
  validates :product_type, presence: true
  validates :series_number, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
