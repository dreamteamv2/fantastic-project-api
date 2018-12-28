# frozen_string_literal: false

require 'http'
require 'cgi'
require 'open-uri'
require 'fileutils'

module FantasticProject
  # :reek:NestedIterators
  module Unsplash
    # Library for download images by  Web API link
    class ImagesManager
      def initialize(tag, path, files = nil)
        @files = files
        @tag = tag.gsub(/[^0-9A-Za-z]/, '')
        @download_path = "#{path}/#{tag}"
      end

      def download_files
        false unless @files
        check_folder
        @files.map do |file|
          puts 'aca 2'
          puts file.url
          DownloadFile.new(file, @download_path).download
        end
      end

      def check_folder
        puts @download_path
        FileUtils.mkdir_p @download_path unless exists?
      end

      def exists?
        Dir.exist? @download_path
      end

      def delete
        FileUtils.rm_rf(@download_path)
      end

      def local_images
        Dir.glob("#{@download_path}/*.jpg")
      end
    end

    # Download class
    class DownloadFile
      def initialize(file, path)
        @name = file.origin_id
        @url = file.url
        @path = "#{path}/#{@name}.jpg"
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
      end
      # rubocop:enable Security/Open
    end
  end
end
