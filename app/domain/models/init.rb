# frozen_string_literal: true

folders = %w[events filters]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
