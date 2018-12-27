# frozen_string_literal: true

folders = %w[entities mappers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
