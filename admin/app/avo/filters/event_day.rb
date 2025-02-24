class Avo::Filters::EventDay < Avo::Filters::MultipleSelectFilter
  self.name = "イベント日程"
  self.button_label = "イベント日程で絞り込む"

  def apply(request, query, value)
    return query if value.blank?

    query.where(event_day_id: value)
  end

  def options
    ::EventDay
      .select(:id, :display_name, :event_date, :event_edition_id)
      .includes(:event_edition)
      .order(event_date: :desc)
      .each_with_object({}) { |event_day, options| options[event_day.id] = "#{event_day.event_full_name} (#{event_day.event_date})" }
  end
end
