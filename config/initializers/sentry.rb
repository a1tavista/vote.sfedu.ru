# if Rails.env.production?
  Raven.configure do |config|
    config.dsn = ENV.fetch('SENTRY_URL')
    config.environments = ['production']
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
# end
