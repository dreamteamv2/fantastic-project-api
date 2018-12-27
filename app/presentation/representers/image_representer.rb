# frozen_string_literal: true

require "roar/decorator"
require "roar/json"

module FantasticProject
  module Representer
    # Represents essential Image information for API output
    class Image < Roar::Decorator
      include Roar::JSON

      property :url
    end
  end
end
