class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def search?
    true
  end

  def attach_original_songs?
    false
  end

  def detach_original_songs?
    false
  end

  def edit_original_songs?
    false
  end

  def create_original_songs?
    false
  end

  def destroy_original_songs?
    false
  end

  def attach_product_distribution_service_urls?
    false
  end

  def detach_product_distribution_service_urls?
    false
  end

  def show_product_distribution_service_urls?
    false
  end

  def edit_product_distribution_service_urls?
    false
  end

  def create_product_distribution_service_urls?
    false
  end

  def destroy_product_distribution_service_urls?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
