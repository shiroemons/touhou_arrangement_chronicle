class Event < ApplicationRecord
  belongs_to :event_series

  has_many :albums, dependent: :destroy

  validate :start_date_before_end_date

  enum format: {
    offline: 'offline', # オフライン開催
    online: 'online', # オンライン開催
    mixed: 'mixed' # オフライン・オンライン両方開催
  }

  enum event_status: {
    scheduled: 'scheduled', # 開催済み
    cancelled: 'cancelled', # 中止
    postpone: 'postpone', # 延期(開催日未定)
    rescheduled: 'rescheduled', # 延期(開催日決定)
    moved_online: 'moved_online' # オンライン開催に変更
  }

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end

  def start_date
    event_dates&.begin
  end

  def end_date
    event_dates&.end&.- 1.day
  end

  def start_date=(start_date)
    start_date = Date.parse(start_date) if start_date.is_a?(String)
    self.event_dates = (start_date...end_date) if start_date.present?
  end

  def end_date=(end_date)
    end_date = Date.parse(end_date) if end_date.is_a?(String)
    self.event_dates = (start_date...(end_date + 1.day)) if end_date.present?
  end

  private

  def start_date_before_end_date
    return unless start_date.present? && end_date.present? && start_date > end_date

    errors.add(:start_date, "must be before end_date")
  end
end
