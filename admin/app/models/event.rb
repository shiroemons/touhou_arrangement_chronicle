class Event < ApplicationRecord
  belongs_to :event_series

  has_many :albums, dependent: :destroy

  validate :start_date_before_end_date

  enum format: {
    offline: 'offline', # オフライン開催
    online: 'online', # オンライン開催
    hybrid: 'hybrid' # オフライン・オンライン両方開催
  }

  enum event_status: {
    scheduled: 'scheduled', # 開催予定
    completed: 'completed', # 開催済み
    cancelled: 'cancelled', # 中止
    postpone: 'postpone', # 延期(開催日未定)
    rescheduled: 'rescheduled', # 延期(開催日決定)
    moved_online: 'moved_online' # オンライン開催に変更
  }

  def self.ransackable_attributes(_auth_object = nil)
    ["name"]
  end

  private

  def start_date_before_end_date
    return unless start_date.present? && end_date.present? && start_date > end_date

    errors.add(:start_date, "must be before end_date")
  end
end
