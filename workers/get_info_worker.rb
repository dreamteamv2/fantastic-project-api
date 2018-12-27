# frozen_string_literal: true

require_relative '../app/domain/init.rb'
require_relative '../app/application/values/init.rb'
require_relative '../app/presentation/representers/init.rb'
require_relative '../app/infrastructure/unsplash/init.rb'

require_relative 'progress_reporter.rb'
require_relative 'get_info_monitor.rb'

require 'econfig'
require 'shoryuken'

# :reek:DuplicateMethodCall
# :reek:UtilityFunction
module GetInfo
  # Shoryuken worker class to clone repos in parallel
  class Worker
    extend Econfig::Shortcut
    Econfig.env = ENV["RACK_ENV"] || "development"
    Econfig.root = File.expand_path("..", File.dirname(__FILE__))

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION,
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = {wait_time_seconds: 20}
    shoryuken_options queue: config.GET_INFO_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      tag, reporter = setup_job(request)
      get_images(tag, reporter)
      each_second(5) { reporter.publish(GetInfoMonitor.finished_percent) }
    end

    private

    def setup_job(request)
      download_request = FantasticProject::Representer::DownloadRequest
        .new(OpenStruct.new).from_json(request)

      [download_request.tag,
       ProgressReporter.new(Worker.config, download_request.id)]
    end

    def get_images(tag, reporter)
      images = FantasticProject::Mapper::ImageFileMapper
        .new(tag, Worker.config.UNSPLASH_KEY)
        .load_data

      FantasticProject::Repository::ImageRepo.new(tag, Worker.config, images)
        .download_images

      reporter.publish GetInfoMonitor.progress("images")
    end

    def each_second(seconds)
      seconds.times do
        sleep(1)
        yield if block_given?
      end
    end
  end
end
