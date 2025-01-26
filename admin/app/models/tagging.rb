class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  acts_as_list scope: [ :taggable_type, :taggable_id ]

  validates :taggable_type, presence: true, inclusion: { in: %w[Album Song Circle ArtistName] }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
