# frozen_string_literal: false

require "http"
require "cgi"
require "open-uri"
require "fileutils"

module FantasticProject
  module Unsplash
    # Library for download images by  Web API link
    class ImagesManager
      def initialize(tag, path, files = nil)
        @files = files
        @tag = tag.gsub(/[^0-9A-Za-z]/, "")
        @download_path = "#{path}/#{tag}"
      end

      def download_files
        if @files
          check_folder
          @files.map do |file|
            DownloadFile.new(file, @download_path).download
          end
        end
      end

      def check_folder
        if !self.exists?
          FileUtils.mkdir_p @download_path
        end
      end

      def exists?
        Dir.exist? @download_path
      end

      def delete
        FileUtils.rm_rf(@download_path)
      end
    end

    class DownloadFile
      def initialize(file, path)
        @name = file.origin_id
        @url = file.url
        @path = path
      end

      def download
        puts @url
        open(@url) { |f|
          File.open("#{@path}/#{@name}.jpg", "wb") do |file|
            file.puts f.read
          end
        }
      end
    end
  end
end
