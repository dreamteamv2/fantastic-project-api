# frozen_string_literal: true

require_relative '../app/domain/init.rb'
require_relative '../app/application/values/init.rb'
require_relative '../app/presentation/representers/init.rb'

require_relative 'progress_reporter.rb'
require_relative 'get_info_monitor.rb'

require 'econfig'
require 'shoryuken'

module GetInfo
  # Shoryuken worker class to clone repos in parallel
  class Worker
    extend Econfig::Shortcut
    Econfig.env = ENV['RACK_ENV'] || 'development'
    Econfig.root = File.expand_path('..', File.dirname(__FILE__))

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.GET_INFO_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      country_code, category, reporter = setup_job(request)

      reporter.publish(GetInfoMonitor.starting_percent)

      # CodePraise::GitRepo.new(project, Worker.config).clone_locally do |line|
      #  reporter.publish GetInfoMonitor.progress(line)
      # end

      # Keep sending finished status to any latecoming subscribers
      each_second(5) { reporter.publish(GetInfoMonitor.finished_percent) }
    end

    private

    def setup_job(request)
      event_request = FantasticProject::Representer::EventsRequest
        .new(OpenStruct.new).from_json(request)

      [event_request.country_code,
       event_request.category,
       ProgressReporter.new(Worker.config, event_request.id)]
    end

    def each_second(seconds)
      seconds.times do
        sleep(1)
        yield if block_given?
      end
    end
  end
end
