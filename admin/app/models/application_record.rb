class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # 基本的な検索可能な属性を定義（created_at, updated_atを除外）
  def self.ransackable_attributes(auth_object = nil)
    # 機密性の高い属性や、検索に適さない属性を除外
    excluded_attributes = %w[created_at updated_at encrypted_password password_digest]
    column_names - excluded_attributes
  end

  # 関連付けを通じた検索を許可
  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map(&:name)
  end
end
