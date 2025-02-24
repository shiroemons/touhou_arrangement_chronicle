class Avo::Filters::ReleaseCircle < Avo::Filters::MultipleSelectFilter
  self.name = "頒布サークル"
  self.button_label = "頒布サークルで絞り込む"

  def apply(request, query, value)
    return query if value.blank?

    query.where(release_circle_id: value)
  end

  def options
    ::Circle
      .select(:id, :name)
      .order(:name)
      .each_with_object({}) { |circle, options| options[circle.id] = circle.name }
  end
end
