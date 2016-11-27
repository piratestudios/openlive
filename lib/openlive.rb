require "gem_config"
require "openlive/version"
require "openlive/oauth"
require "openlive/base"

module Openlive
  include GemConfig::Base

  with_configuration do
    has :oauth_settings, classes: Hash, default: {
      site: "https://staging-identity.openlive.co",
      authorize_url: "/connect/authorize",
      token_url: "/connect/token",
      scope: "tenant"
    }

    has :oauth_credentials, classes: Hash, default: {
      client_id: ENV['OPENLIVE_OAUTH_CLIENT_ID'],
      client_secret: ENV['OPENLIVE_OAUTH_CLIENT_SECRET'],
    }

    has :default_headers, classes: Hash, default: {}
    has :base_uri, classes: String, default: (ENV['OPENLIVE_BASE_URI'] || "https://staging-api.openlive.co/v1")
  end

  class Error < StandardError; end
  class APIError < Error; end
end
