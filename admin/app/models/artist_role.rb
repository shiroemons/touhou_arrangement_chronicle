class ArtistRole < ApplicationRecord
  # 関連
  has_many :songs_artist_roles
  has_many :songs, through: :songs_artist_roles
  has_many :artist_names, through: :songs_artist_roles

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true

  # キャッシュを利用したロール取得メソッド
  def self.role_for(name)
    @roles ||= {}
    @roles[name] ||= find_by(name: name)
  end

  # 役割の種類を簡単に取得するためのスコープ
  scope :arranger, -> { find_by(name: "arranger") }
  scope :composer, -> { find_by(name: "composer") }
  scope :vocalist, -> { find_by(name: "vocalist") }
  scope :lyricist, -> { find_by(name: "lyricist") }
end
