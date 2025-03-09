source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

# Rails gem and related gems
gem "rails", "~> 7.0.2", ">= 7.0.2.3"
gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "stimulus-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sassc-rails"

# Development and test group gems
group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
end

# Development-only gems
group :development do
  gem "web-console"
end

# For fixing issues with io-console dependency
gem "io-console", platforms: [:ruby, :mri]
