class EntityUrl < ApplicationRecord
  # 関連
  belongs_to :entity, polymorphic: true

  # バリデーション
  validates :entity_type, presence: true, inclusion: { in: [ "artist_name", "circle" ] }
  validates :url_type, presence: true
  validates :url, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end
