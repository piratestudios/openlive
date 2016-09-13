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

    describe "#status" do
      subject { response.status }
      before { allow(faraday_response).to receive(:status) { status } }

      context "is successful" do
        let(:status) { 200 }
        it { is_expected.to eq 200 }
      end

      context "is not successful" do
        let(:status) { 404 }
        it { is_expected.to eq 404 }
      end
    end

    describe "#body" do
      subject { response.body }
      let(:json) { '{"test": "Excellent!"}' }

      before { allow(faraday_response).to receive(:body) { json } }

      it { is_expected.to eq({ "test" => "Excellent!" }) }
    end

    describe "#error_message" do
      subject { response.error_message }
      before do
        allow(faraday_response).to receive(:body) { body }
        allow(faraday_response).to receive(:success?) { success }
      end

      context "success" do
        let(:success) { true }
        it { is_expected.to be nil }
      end

      context "failure" do
        let(:success) { false }

        context "JSON is valid" do
          let(:body) { '{"test": "yes"}' }
          it { is_expected.to eq(response.body) }
        end

        context "JSON is invalid" do
          let(:body) { '{"test: "yes"}' }
          it { is_expected.to match(/unexpected token/) }
        end
      end
    end

    describe "#method_missing" do
      let(:body) { '{"test": "Example value!"}' }
      subject { response.test }
      before { allow(faraday_response).to receive(:body) { body } }

      it { is_expected.to eq("Example value!") }
    end
  end
end
