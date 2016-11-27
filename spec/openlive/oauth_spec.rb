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

  describe "#token" do
    before do
      allow(subject).to receive(:requisition_token) { true }
      allow(subject).to receive(:current_token) { current_token }
    end

    after { subject.token }

    context "no current token" do
      let(:current_token) { nil }
      it { is_expected.to receive(:requisition_token) }
    end

    context "token expired" do
      let(:current_token) { double('current_token', expired?: true) }
      it { is_expected.to receive(:requisition_token) }
    end

    context "existing valid token" do
      let(:current_token) { double('current_token', expired?: false) }
      it { is_expected.to receive(:current_token) }
      it { is_expected.to_not receive(:requisition_token) }
    end
  end

  describe "#requisition_token" do
    after do
      subject.requisition_token
    end

    it "gets a token from the identity server" do
      expect(subject.client).to receive_message_chain(:client_credentials, :get_token).with(scope: "tenant")
    end

    it "assigns the token" do
      expect(subject).to receive(:current_token=).with(an_instance_of(OAuth2::AccessToken))
    end
  end
end
