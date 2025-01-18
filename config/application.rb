module Admin
  class Application < Rails::Application
    # ... 既存の設定 ...

    # デフォルトのロケールを日本語に設定
    config.i18n.default_locale = :ja
    
    # ロケールファイルのパスを追加
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end 