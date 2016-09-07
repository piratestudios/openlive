module Openlive
  class Base
    extend Forwardable

    # @return [Hash] a hash of data returned from the API
    attr_accessor :api_data

    # Convenience method for accessing the API response data
    attr_accessor :response

    # Initialize an instance (used by subclasses) with API data
    #
    # @param data [Hash]
    # @return [Hash] the API data
    def initialize(data = nil, response: nil)
      self.api_data = data
      self.response = response
    end

    # Instance convenience method for the connection
    #
    # @return [Faraday::Connection]
    def connection
      self.class.connection
    end

    # Instance convenience method for oauth instance
    #
    # @return [Openlive::OAuth]
    def oauth
      self.class.oauth
    end

    # Pass method calls through to the API data
    def method_missing(name, *args, &block)
      if api_data.is_a?(Hash)
        api_data[name.to_s]
      end
    end

    class << self
      # Faraday connection
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= (
          conn = Faraday.new(url: Openlive.configuration.base_uri) do |faraday|
            faraday.request  :url_encoded
            faraday.response :logger
            faraday.adapter  Faraday.default_adapter
          end

          conn.authorization(:Bearer, oauth.token.token)
          conn.url_prefix = Openlive.configuration.base_uri
          conn
        )
      end

      # OAuth handler
      #
      # @return [Openlive::OAuth]
      def oauth
        @oauth ||= OAuth.new
      end

      # Raise an exception or execute the following block,
      # used for generic error handling for all routes
      #
      # @param response [Response]
      # @param error_class [OpenliveError]
      # @param message [String] an optional message for the exception if raised
      # @yield [Response] Block called for success condition
      # @raise [OpenliveError] Will raise an error on unsuccessful response
      def handle_response(response, error_class: Openlive::Error, message: nil, &block)
        message = case
        when !message.nil?
          message
        when error_class == Openlive::APIError
          "endpoint returned a #{response.status} status"
        end

        if response.success?
          block.call(response)
        else
          raise error_class, message
        end

      rescue Exception => ex
        raise error_class, ex.message
      end
    end
  end
end

require "openlive/request"
require "openlive/response"
require "openlive/artist"
require "openlive/booking"
require "openlive/master_builder"
require "openlive/user"
