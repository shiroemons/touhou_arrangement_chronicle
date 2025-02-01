class Tagging < ApplicationRecord
  acts_as_list scope: [ :taggable_type, :taggable_id ]
  # 関連
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :taggable_type, presence: true, inclusion: { in: %w[Album Song Circle ArtistName] }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
