class Genre < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end
end
