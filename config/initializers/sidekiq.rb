require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.load_from_hash(YAML.load_file(Rails.root.join('config', 'sidekiq_schedule.yml')))