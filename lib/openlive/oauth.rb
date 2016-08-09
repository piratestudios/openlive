require "oauth2"

module Openlive
  class OAuth
    attr_accessor :current_token

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

    def token
      if current_token.nil?
        requisition_token
      else
        current_token
        #TODO: Expiration handling
      end
    end

    def requisition_token
      self.current_token = client.client_credentials.get_token(scope: Openlive.configuration.oauth_settings[:scope])
    end
  end
end
