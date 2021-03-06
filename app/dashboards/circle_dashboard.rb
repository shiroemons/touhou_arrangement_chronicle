require "administrate/base_dashboard"

class CircleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    name_ja: Field::String,
    name_en: Field::String,
    site_url: Field::String,
    blog_url: Field::String,
    note_ja: Field::Text,
    note_en: Field::Text,
    discographies: Field::HasMany,
    category: Field::I18nEnum.with_options(class_name: 'Artist'),
    detail_category: Field::String,
    artists: Field::HasMany,
    songs: Field::HasMany,
    circle_type: Field::I18nEnum.with_options(class_name: 'Circle'),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name_ja,
    :category,
    :detail_category,
    :artists,
    :discographies,
    :songs,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name_ja,
    :name_en,
    :site_url,
    :blog_url,
    :note_ja,
    :note_en,
    :discographies,
    :category,
    :detail_category,
    :artists,
    :songs,
    :circle_type,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name_ja,
    :name_en,
    :site_url,
    :blog_url,
    :note_ja,
    :note_en,
    :circle_type,
  ].freeze

  # Overwrite this method to customize how circles are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(circle)
    circle.name_ja
  end
end
