source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.5'

gem 'rails', '~> 6.1.0'

gem 'action_args'
gem 'active_decorator'
gem 'active_model_serializers'
gem 'activerecord-import'
gem 'administrate'
gem 'administrate-field-i18n_enum'
gem 'bootsnap'
gem 'counter_culture'
gem 'enum_help'
gem 'friendly_id'
gem 'gravtastic'
gem 'hamlit-rails'
gem 'i18n_generators'
gem 'jbuilder', '~> 2.8'
gem 'moji'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.0'
gem 'rails-i18n'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'sass-rails', '~> 5.0'
gem 'seed-fu'
gem 'smarter_csv'
gem 'sorcery'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

group :development do
  gem 'annotate'
  gem 'byebug', platform: :mri, group: :test
  gem 'listen'
  gem 'onkcop', require: false
  gem 'overcommit', require: false
  gem 'pry', group: :test
  gem 'pry-byebug', group: :test
  gem 'pry-doc', group: :test
  gem 'pry-rails', group: :test
  gem 'pry-stack_explorer', group: :test
  gem 'rails-env-credentials'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'chromedriver-helper' unless ENV.has_key?('CIRCLECI')
  gem 'factory_bot_rails', group: :development
  gem 'ffaker', group: :development
  gem 'gimei', group: :development
  gem 'rspec-rails', group: :development
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: :master
  gem 'spring-commands-rspec', group: :development
end
