require 'spec_helper'
require 'webmock/rspec'

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require File.expand_path('../server', __dir__)

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    RESTServer
  end
end
