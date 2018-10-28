# frozen_string_literal: true

require_relative 'spec_helper.rb'

describe 'Test PHQ API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<PHQ_TOKEN>') { PHQ_TOKEN }
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

  describe 'Events information' do
    before do
      @events = FantasticProject::PredictHQ::EventMapper
        .new(PHQ_TOKEN)
        .find(country: 'TW')
    end

    it 'HAPPY: should has the same values' do
      first_event = @events.first
      _(first_event.title).wont_be_nil
      _(first_event.description).wont_be_nil
      _(first_event.title).must_equal CORRECT['events']['results'][0]['title']
      _(first_event.description).must_equal CORRECT['events']['results'][0]['description']
    end

    it 'HAPPY: should identify events' do
      events = @events
      _(events.count).must_equal CORRECT['events']['results'].count
    end

    it 'BAD: should raise exception when unauthorized' do
      proc do
        FantasticProject::PredictHQ::EventMapper
          .new('Bad-Token')
          .find(country: 'TW')
      end.must_raise FantasticProject::PredictHQ::Api::Response::Unauthorized
    end
  end
end
