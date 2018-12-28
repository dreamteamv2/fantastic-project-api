# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module FantasticProject
  module Representer
    # Representer object for events requests
    class DownloadRequest < Roar::Decorator
      include Roar::JSON

      property :tag
      property :id
    end
  end
end
