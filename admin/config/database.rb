ActiveRecord::Base.establish_connection(ENV["TEST_DATABASE_URL"]) if Rails.env.test?
