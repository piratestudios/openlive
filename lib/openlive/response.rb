module Openlive
  class Response < Base
    # @return [Faraday::Response]
    attr_reader :response

    # Initialize the response object
    #
    # @param [Faraday::Response] faraday_response
    def initialize(faraday_response)
      @response = faraday_response
    end

    # Was the request successful?
    #
    # @return [Truthy]
    def success?
      response.success?
    end

    # Return the response status
    #
    # @return [Integer]
    def status
      response.status
    end

    # Parse the response from the server
    #
    # @return [Hash,Nil]
    def body
      @body ||= JSON.parse(response.body)
    end

    # Convenience method for fetching the error message
    #
    # @return [String]
    def error_message
      if !success?
        body
      end
    rescue JSON::ParserError => ex
      ex.message
    end

    # Simple method missing accessor for reading returned attributes
    #
    # @return [String] the raw returned string from the API
    def method_missing(method_name, *opts, &block)
      body[method_name.to_s] if body.is_a?(Hash)
    end
  end
end
