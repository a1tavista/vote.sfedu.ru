#if Rails.env.production?
  Sentry.init do |config|
    config.dsn = ENV.fetch("SENTRY_URL", nil)
    config.environment = ["production"]
    config.before_send = lambda do |event|
      event.request[:data] = event.request[:data].except(*Rails.application.config.filter_parameters.map(&:to_s))
      event
    end
  end
#end
