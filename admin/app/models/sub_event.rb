class SubEvent < ApplicationRecord
  belongs_to :event

  enum event_status: {
    scheduled: 'scheduled', # 開催済み
    cancelled: 'cancelled', # 中止
    postpone: 'postpone', # 延期(開催日未定)
    rescheduled: 'rescheduled', # 延期(開催日決定)
    moved_online: 'moved_online', # オンライン開催に変更
  }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
