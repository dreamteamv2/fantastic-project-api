# frozen_string_literal: true

folders = %w[application domain infrastructure cache]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
