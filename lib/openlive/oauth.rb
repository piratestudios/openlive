require "oauth2"
require "oauth2/access_token"

module Openlive
  class OAuth
    # @return [OAuth2::AccessToken] Used to store the existing token
    attr_accessor :current_token

    # Return or instantiate the OAuth client
    #
    # @return [OAuth2::Client]

    def client
      @client ||= (
        credentials = Openlive.configuration.oauth_credentials

        OAuth2::Client.new(
          credentials[:client_id],
          credentials[:client_secret],
          Openlive.configuration.oauth_settings
        )
      )
    end

    # Return an existing unexpired token for this OAuth instance
    # or requisition a new one from the server.
    #
    # @return [OAuth2::AccessToken]

    def token
      if current_token.nil? || current_token.expired?
        requisition_token
      else
        current_token
      end
    end

    # Fetch a new token from the OAuth server
    #
    # @return [OAuth2::AccessToken]

    def requisition_token
      self.current_token = client.client_credentials.get_token(scope: Openlive.configuration.oauth_settings[:scope])
    end
  end
end
