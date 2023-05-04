class OriginalSongPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def search?
    true
  end

  def attach_children?
    false
  end

  def detach_children?
    false
  end

  def edit_children?
    false
  end

  def create_children?
    false
  end

  def destroy_children?
    false
  end

  def attach_original_song_distribution_service_urls?
    false
  end

  def detach_original_song_distribution_service_urls?
    false
  end

  def show_original_song_distribution_service_urls?
    false
  end

  def edit_original_song_distribution_service_urls?
    false
  end

  def create_original_song_distribution_service_urls?
    false
  end

  def destroy_original_song_distribution_service_urls?
    false
  end

  def attach_songs?
    false
  end

  def detach_songs?
    false
  end

  def edit_songs?
    false
  end

  def create_songs?
    false
  end

  def destroy_songs?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
