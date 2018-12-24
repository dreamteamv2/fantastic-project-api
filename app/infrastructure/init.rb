# frozen_string_literal: true

folders = %w[database phq local_files unsplash]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
