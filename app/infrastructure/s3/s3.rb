# frozen_string_literal: true

require 'aws-sdk-s3'

module FantasticProject
  # :reek:FeatureEnvy
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
      end

      def uploadImage(path)
        resource = Aws::S3::Resource.new(client: @client)
        resource.bucket(@bucket_name).object(key: path, acl: "public-read").upload_file(path)
      end
    end
  end
end
