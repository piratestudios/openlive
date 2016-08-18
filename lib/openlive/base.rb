module Openlive
  class Base
    def connection
      self.class.connection
    end

    def oauth
      self.class.oauth
    end

    class << self
      def connection
        @connection ||= Faraday.new(url: Openlive.configuration.base_uri) do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
      end

      def oauth
        @oauth ||= OAuth.new
      end
    end
  end
end

require "openlive/request"
require "openlive/response"
require "openlive/master_builder"
