module Openlive
  class User < Base
    class << self
      # Find and return a user record
      #
      # @param id [String]
      # @return [User]
      # @raise [APIError] Will raise an error on unsuccessful response
      def find(id)
        response = Request.get("users/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body, response: response)
        end
      end

      # Find and return a user by email address
      #
      # @param email [String]
      # @return [User]
      # @raise [APIError] Will raise an error on unsuccessful response
      def find_by_email(email)
        response = Request.get("users", email: email)

        handle_response(response, error_class: APIError) do |response|
          new(response.body, response: response)
        end
      end

      # Create a new user on Openlive
      #
      # @param [Hash] attributes A hash of attributes to set
      # @option attributes [String] :username
      # @option attributes [String] :email
      # @option attributes [String] :password Optional, will be automatically generated
      # @return [User] the created user object
      # @raise [APIError] Will raise an error on unsuccessful response
      def create(attributes)
        response = Request.post("users", attributes)

        handle_response(response, error_class: APIError) do |response|
          new(response.body, response: response)
        end
      end
    end
  end
end
