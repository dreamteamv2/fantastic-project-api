# frozen_string_literal: true

require_relative 'helpers/spec_helper.rb'
require_relative 'helpers/database_helper.rb'
require_relative 'helpers/vcr_helper.rb'
require 'headless'
require 'watir'

describe 'Acceptance Tests' do
  DatabaseHelper.setup_database_cleaner
   before do
    DatabaseHelper.wipe_database
    @headless = Headless.new
    @browser = Watir::Browser.new
  end
  
   after do
    @browser.close
    @headless.destroy
  end
