# frozen_string_literal: true

folders = %w[root]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
