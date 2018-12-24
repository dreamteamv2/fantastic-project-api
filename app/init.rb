# frozen_string_literal: true

folders = %w[application domain infrastructure presentation]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
