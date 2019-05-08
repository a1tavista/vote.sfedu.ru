web: bundle exec puma -p 3000 -C ./config/puma.rb
worker: bundle exec sidekiq -c 5 -q default -q event_queue
