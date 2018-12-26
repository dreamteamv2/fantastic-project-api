# frozen_string_literal: true

module GetInfo
  # Infrastructure to get info while yielding progress
  module GetInfoMonitor
    GET_INFO_PROGRESS = {
      "STARTED" => 15,
      "images" => 85,
      "weather" => 95,
      "FINISHED" => 100,
    }.freeze

    def self.starting_percent
      GET_INFO_PROGRESS["STARTED"].to_s
    end

    def self.finished_percent
      GET_INFO_PROGRESS["FINISHED"].to_s
    end

    def self.progress(line)
      GET_INFO_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      GET_INFO_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
