class EntityTag < ApplicationRecord
  # 関連
  belongs_to :entity, polymorphic: true
  belongs_to :tag

  # バリデーション
  validates :entity_type, presence: true, inclusion: { in: [ "album", "song", "circle", "artist" ] }
end
