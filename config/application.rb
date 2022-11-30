require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StockRollingApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.active_job.queue_adapter = :sidekiq
    config.time_zone = 'Asia/Tokyo'
    

    I18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    I18n.default_locale = :ja
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
