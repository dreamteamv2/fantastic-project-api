# frozen_string_literal: true

require 'aws-sdk-s3'

module FantasticProject
  # :reek:FeatureEnvy
  # :reek:UncommunicativeModuleName
  module S3
    ## Queue wrapper for AWS s3
    class UploadFileS3
      def initialize(bucket_name, config)
        @bucket_name = bucket_name
        @client = Aws::S3::Client.new(
          access_key_id: config.AWS_ACCESS_KEY_ID,
          secret_access_key: config.AWS_SECRET_ACCESS_KEY,
          region: config.AWS_REGION
        )
        @resource = Aws::S3::Resource.new(client: @client)
      end

      def upload_image(path)
        @resource.bucket(@bucket_name)
          .object(path).upload_file path, acl: 'public-read'
      end

      def exists_folder?(path)
        @resource.bucket(@bucket_name)
          .objects(prefix: path).limit(1).any?
      end

      def s3_images(path)
        @resource.bucket(@bucket_name)
          .objects(prefix: path)
      end
    end
  end
end
