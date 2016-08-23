require 'spec_helper'

describe Openlive::Response do
  describe "instance methods" do
    subject(:response) { Openlive::Response.new(faraday_response) }
    let(:faraday_response) { double('faraday_response') }

    describe "#initialize" do
      subject { response.response }
      it { is_expected.to eq(faraday_response) }
    end

    describe "#success?" do
      subject { response.success? }
      before { allow(faraday_response).to receive(:success?) { success } }

      context "is successful" do
        let(:success) { true }
        it { is_expected.to be true }
      end

      context "is not successful" do
        let(:success) { false }
        it { is_expected.to be false }
      end
    end

    describe "#body" do
      subject { response.body }
      let(:json) { '{"test": "Excellent!"}' }

      before { allow(faraday_response).to receive(:body) { json } }

      it { is_expected.to eq({ "test" => "Excellent!" }) }
    end
  end
end
