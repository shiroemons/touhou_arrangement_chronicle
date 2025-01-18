class EntityGenre < ApplicationRecord
  # 関連
  belongs_to :entity, polymorphic: true
  belongs_to :genre

  # バリデーション
  validates :entity_type, presence: true, inclusion: { in: [ "album", "circle", "artist" ] }
  validates :position, presence: true, numericality: { only_integer: true }
end
