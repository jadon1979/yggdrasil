source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "rails", "~> 7.0.4"
gem "puma", "~> 5.0"
gem "bootsnap", require: false
gem 'rack-cors'
gem "pg", "~> 1.1"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'pry-rails'

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'database_cleaner-active_record'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

