class AlbumPrice < ApplicationRecord
  acts_as_list scope: :album

  # 関連
  belongs_to :album
  belongs_to :shop, optional: true

  # バリデーション
  validates :price_type, presence: true, inclusion: { in: [ "event", "shop" ] }
  validates :is_free, inclusion: { in: [ true, false ] }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tax_included, inclusion: { in: [ true, false ] }
  validates :position, presence: true, numericality: { only_integer: true }

  # カスタムバリデーション
  validate :price_consistency_with_is_free

  private

  def price_consistency_with_is_free
    if is_free && price != 0
      errors.add(:price, :must_be_0_when_is_free)
    elsif !is_free && price == 0
      errors.add(:price, :must_be_greater_than_0_when_is_free)
    end
  end
end
