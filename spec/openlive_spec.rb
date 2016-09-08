require 'spec_helper'

describe Openlive do
  it 'has a version number' do
    expect(Openlive::VERSION).not_to be nil
  end

  describe "configuration" do
    it "has oauth settings" do
      expect(Openlive.configuration.oauth_settings).to be_a(Hash)
    end

    it "has oauth credentials" do
      expect(Openlive.configuration.oauth_credentials).to be_a(Hash)
    end

    it "has default headers" do
      expect(Openlive.configuration.default_headers).to be_a(Hash)
    end

    it "has a base URI" do
      expect(Openlive.configuration.base_uri).to be_a(String)
    end
  end
end
