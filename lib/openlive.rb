require "gem_config"
require "openlive/version"
require "openlive/oauth"
require "openlive/request"
require "openlive/response"

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
      client_id: "",
      client_secret: "",
    }

    has :default_headers, classes: Hash, default: {}
    has :base_uri, classes: String, default: "https://api.openlive.co/v1"
  end

  class << self
    def connection
      @connection ||= Faraday.new(url: Openlive.configuration.base_uri) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
