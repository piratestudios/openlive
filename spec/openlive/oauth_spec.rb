require 'spec_helper'

describe Openlive::OAuth do
  subject(:oauth) { Openlive::OAuth.new }

  it { is_expected.to respond_to(:current_token) }
  it { is_expected.to respond_to(:current_token=) }

  describe "#client" do
    let(:credentials) do
      {
        client_id: "test",
        client_secret: "gubbins"
      }
    end

    before { allow(Openlive.configuration).to receive(:oauth_credentials) { credentials } }
    after { subject.client }

    it "instantiates the OAuth2 client" do
      expect(OAuth2::Client).to receive(:new).with(
        credentials[:client_id],
        credentials[:client_secret],
        Openlive.configuration.oauth_settings
      )
    end
  end
end
