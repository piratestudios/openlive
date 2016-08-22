module Openlive
  class User < Base
    class << self
      # Find and return a user record
      #
      # @param id [String]
      # @return [Openlive::User]

      def find(id)
        response = Request.get("users/#{id}")

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Find and return a user by email address
      #
      # @param email [String]
      # @return [Openlive::User]

      def find_by_email(email)
        response = Request.get("users", email: email)

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end

      # Create a new user on Openlive
      #
      # @param [Hash] params A hash of attributes to set
      # @option params [String] :username
      # @option params [String] :email
      # @option params [String] :password Optional, will be automatically generated
      # @return [User] the created user object

      def create(params)
        response = Request.post("users", { request: params })

        handle_response(response, error_class: APIError) do |response|
          new(response.body)
        end
      end
    end
  end
end
