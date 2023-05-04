class EventSeries < ApplicationRecord
  has_many :events, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end
end
