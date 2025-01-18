require "simplecov"
SimpleCov.start "rails" do
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/test/"
  add_filter "/config/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "factory_bot"

# factory_botのサポートファイルを読み込む
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(
    color: true
  )
]

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  parallelize(workers: 1) # デッドロック防止のため1プロセスで実行

  # テスト開始前にスキーマをロード
  def self.load_schema
    connection = ActiveRecord::Base.connection

    # 既存のテーブルをクリーンアップ
    connection.tables.each do |table|
      connection.drop_table(table, force: :cascade)
    end

    # enumの型を作成
    connection.execute("DROP TYPE IF EXISTS first_character_type CASCADE")
    connection.execute("CREATE TYPE first_character_type AS ENUM ('symbol', 'number', 'alphabet', 'hiragana', 'katakana', 'kanji', 'other')")

    connection.execute("DROP TYPE IF EXISTS product_type CASCADE")
    connection.execute("CREATE TYPE product_type AS ENUM ('pc98', 'windows', 'zuns_music_collection', 'akyus_untouched_score', 'commercial_books', 'tasofro', 'other')")

    # スキーマをロード
    load Rails.root.join("db/schema.rb")
  end

  # テストスイート実行前にスキーマをロード
  load_schema

  # データベース接続を設定
  def setup
    super
  end

  # テスト後にデータベースをクリーンアップ
  def teardown
    # トランザクションを使用してデッドロックを防ぐ
    ActiveRecord::Base.transaction do
      tables_to_clean.each do |table|
        table.delete_all
      end
    end
  end

  private

  def tables_to_clean
    ActiveRecord::Base.connection.tables.map do |table_name|
      next if table_name == "schema_migrations"
      table_name.classify.safe_constantize
    end.compact
  end
end
