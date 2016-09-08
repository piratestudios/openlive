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
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    match_requests_on: [:method, :host, :path]
  }

  config.ignore_request do |request|
    request.uri =~ /identity\.openlive\.co/
  end

  %w(OAUTH_CLIENT_ID OAUTH_CLIENT_SECRET).each do |env_var|
    config.filter_sensitive_data("<#{env_var}>") { ENV[env_var] }
  end
end
