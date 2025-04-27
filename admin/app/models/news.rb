class News < ApplicationRecord
  # コールバック
  before_validation :generate_slug, if: -> { slug.blank? }

  # バリデーション
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :published_at, presence: true
  validates :category, inclusion: { in: %w[update maintenance event other] }, allow_nil: true

  # スコープ
  scope :published, -> { where("published_at <= ?", Time.current) }
  scope :not_expired, -> { where("expired_at IS NULL OR expired_at > ?", Time.current) }
  scope :active, -> { published.not_expired }
  scope :important, -> { where(is_important: true) }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  # カテゴリの定数
  CATEGORIES = {
    "更新情報" => "update",
    "メンテナンス情報" => "maintenance",
    "イベント情報" => "event",
    "その他" => "other"
  }.freeze

  # カテゴリ名を日本語で取得するメソッド
  def category_name
    CATEGORIES[category] if category.present?
  end

  # ステータスを取得するメソッド
  def status
    return :upcoming if published_at > Time.current
    return :expired if expired_at.present? && expired_at < Time.current
    :active
  end

  private

  # スラッグを自動生成するメソッド
  def generate_slug
    base_slug = title.to_s.parameterize
    unique_slug = base_slug
    counter = 0

    # スラッグが既に存在する場合は、一意になるまで番号を付加
    while News.where(slug: unique_slug).exists?
      counter += 1
      unique_slug = "#{base_slug}-#{counter}"
    end

    self.slug = unique_slug
  end
end
