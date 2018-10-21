# frozen_string_literal: true

require_relative 'spec_helper.rb'

describe 'Test PHQ API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_senstive_data('<PHQ_TOKEN>') { PHQ_TOKEN }
    c.filter_sensitive_data('<PHQ_TOKEN_ESC>') { CGI.escape(PHQ_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Event information' do
    it 'HAPPY: should provide correct event attributes' do
      event = FantasticProject::phq_api.new(PHQ_TOKEN)
                                       .event()
