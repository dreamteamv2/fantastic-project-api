# frozen_string_literal: true
module FantasticProject
  module Value
    # Value of a file's full path (delegates to String)
    class FilePath < SimpleDelegator
      # rubocop:disable Style/RedundantSelf
      FILE_PATH_REGEX = %r{(?<directory>.*\/)(?<filename>[^\/]+)}

      attr_reader :directory, :
      
      def initialize(filepath)
        super(filepath)
        parse_path
      end

    end
  end
end