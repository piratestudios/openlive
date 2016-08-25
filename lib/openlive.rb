require "gem_config"
require "openlive/version"
require "openlive/oauth"
require "openlive/base"

module Openlive
  include GemConfig::Base

  with_configuration do
    has :oauth_settings, classes: Hash, default: {
      site: "https://identity.openlive.co",
      authorize_url: "/connect/authorize",
      token_url: "/connect/token",
      scope: "tenant"
    }

    has :oauth_credentials, classes: Hash, default: {
      client_id: ENV['OAUTH_CLIENT_ID'],
      client_secret: ENV['OAUTH_CLIENT_SECRET'],
    }

    has :default_headers, classes: Hash, default: {}
    has :base_uri, classes: String, default: "https://api.openlive.co/v1"
  end

  class Error < StandardError; end
  class APIError < Error; end
end
