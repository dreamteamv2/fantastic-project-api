# frozen_string_literal: true

module GetInfo
  # Infrastructure to get info while yielding progress
  module GetInfoMonitor
    CLONE_PROGRESS = {
      'STARTED'   => 15,
      'First page'   => 30,
      'Second page'    => 70,
      'images' => 85,
      'weather' => 95,
      'FINISHED'  => 100
    }.freeze

    def self.starting_percent
      CLONE_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      CLONE_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      CLONE_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      CLONE_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
