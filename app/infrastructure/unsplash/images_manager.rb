# frozen_string_literal: false

require 'http'
require 'cgi'
require 'open-uri'
require 'fileutils'

require_relative '../s3/init'

module FantasticProject
  # :reek:NestedIterators
  module Unsplash
    # Library for download images by  Web API link
    class ImagesManager
      def initialize(tag, config, files = nil)
        @files = files
        @config = config
        @tag = tag.gsub(/[^0-9A-Za-z]/, '')
        @download_path = "#{config.IMAGE_PATH}/#{tag}"
      end

      def download_files
        false unless @files
        self.check_folder
        @files.map do |file|
          sleep 3
          DownloadFile.new(file, @download_path, @config).download
        end
      end

      def check_folder
        Dir.mkdir @download_path unless exists?
      end

      def exists?
        Dir.exist? @download_path
      end

      def delete
        FileUtils.rm_rf @download_path
      end

      def local_images
        Dir.glob("#{@download_path}/*.jpg")
      end
    end

    # Download class
    class DownloadFile
      def initialize(file, path, config)
        @name = file.origin_id
        @url = file.url
        @path = "#{path}/#{@name}.jpg"
        @config = config
      end

      def file_exists?
        File.file? @path
      end

      # rubocop:disable Security/Open
      def download
        false unless file_exists?
        open(@url) do |fcloud|
          File.open(@path, 'wb') do |file|
            file.puts fcloud.read
          end
        end
        S3::UploadFileS3.new('test-app', @config).uploadImage(@path)
      end
      # rubocop:enable Security/Open
    end
  end
end
