# frozen_string_literal: true

folders = %w[forms services controllers values]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
