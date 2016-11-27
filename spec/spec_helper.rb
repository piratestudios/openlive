$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# Ensure .env file is loaded before openlive lib
require 'dotenv'
Dotenv.load

require 'openlive'
require 'vcr'
require 'vcr_rewinder'
require 'pry'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
  config.default_cassette_options = {
    match_requests_on: [:method, :host, :path]
  }

  %w(OAUTH_CLIENT_ID OAUTH_CLIENT_SECRET).each do |env_var|
    config.filter_sensitive_data("<#{env_var}>") { ENV[env_var] }
  end

  config.around_http_request do |request|
    VCR.use_cassette("oauth_token", &request)
  end
end

RSpec.configure do |config|
  config.before(:all) do
    Openlive.configuration.oauth_credentials = {
      client_id: "test",
      client_secret: "gubbins",
    }
  end
end
