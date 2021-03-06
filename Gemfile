source 'https://rubygems.org'
gem 'rails', '3.2.12'
gem 'sqlite3'
gem 'jquery-rails', '2.2.1'
gem "hobo", "= 2.0.1"
# Hobo's version of will_paginate is required.
gem "will_paginate", :git => "git://github.com/Hobo/will_paginate.git"
gem "hobo_bootstrap", "2.0.1"
gem "hobo_jquery_ui", "2.0.1"
gem "hobo_bootstrap_ui", "2.0.1"
gem "jquery-ui-themes", "~> 0.0.4"
gem 'bootswatch-rails'
gem 'hobo-metasearch', :git => "git://github.com/suyccom/hobo-metasearch"
gem "rails-settings-cached", "0.2.4"
gem 'exception_notification'
gem "barby" # Barcodes
gem "chunky_png"
gem "prawn-labels" # Labels
gem "wicked_pdf" # Invoice PDFs

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

# Development gems
group :development do
  gem 'wirb'
  gem 'hirb'
  gem "better_errors", '1.1.0'
  gem "binding_of_caller"
  gem "awesome_print"
  gem "debugger"
  gem 'thin'
  # Stop cluttering the log in development mode.
  gem 'quiet_assets'
  gem "whisk_deploy"
end

# Testing gems
group :test do
  gem "rspec-rails", "~> 2.14.2"
  gem "spork", ">= 1.0.0rc3"
  gem "capybara", "2.0.2"
  gem "capybara-webkit", "1.1.0"
  gem "timecop"
  gem "headless"
  gem "factory_girl_rails", "4.2.0", :require => false
  gem "faker", :git => 'git://github.com/jorgegorka/faker'
end
