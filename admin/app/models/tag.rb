class Tag < ApplicationRecord
  enum tag_type: {
    unknown: 'unknown', # 不明
    genre: 'genre', # ジャンル
    ambience: 'ambience', # 雰囲気
    instrument: 'instrument', # 楽器
  }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
