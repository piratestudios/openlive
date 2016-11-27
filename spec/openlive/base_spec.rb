require 'spec_helper'

describe Openlive::Base do
  describe "instance methods" do
    let(:api_data) { nil }
    subject(:base) { Openlive::Base.new(api_data) }

    it { is_expected.to respond_to(:api_data) }
    it { is_expected.to respond_to(:api_data=) }

    describe "#initialize" do
      let(:api_data) { double('api_data') }
      subject { base.api_data }

      it { is_expected.to eq(api_data) }

      describe "setting the response object" do
        let(:base) { Openlive::Base.new(api_data, response: response) }
        let(:response) { Openlive::Response.new(double('faraday_response')) }
        subject { base.response }

        it { is_expected.to eq(response) }
      end
    end

    describe "#connection" do
      let(:connection) { double('connection') }
      subject { base.connection }

      before { allow(Openlive::Base).to receive(:connection) { connection } }

      it { is_expected.to eq(connection) }
    end

    describe "#oauth" do
      let(:oauth) { double('oauth') }
      subject { base.oauth }

      before { allow(Openlive::Base).to receive(:oauth) { oauth } }

      it { is_expected.to eq(oauth) }
    end

    describe "#refresh" do
      let(:api_data) { { "api_thing": "yes" } }
      let(:response) { double('response') }
      let(:obj) { double('obj', api_data: api_data, response: response) }

      before { allow(Openlive::Base).to receive(:find) { obj } }
      after { base.refresh }

      it "sets the api data" do
        expect(base).to receive(:api_data=).with(api_data)
      end

      it "sets the response" do
        expect(base).to receive(:response=).with(response)
      end
    end
  end

  describe "class methods" do
    describe "#connection" do
      subject { Openlive::Base.connection }

      before do
        allow(Openlive::Base.oauth).to receive(:token) { double('token', token: "Excellent!") }
      end

      it { is_expected.to be_a(Faraday::Connection) }

      it "sets the URL prefix" do
        expect(subject.url_prefix).to eq(URI(Openlive.configuration.base_uri))
      end

      it "sets the Bearer token" do
        expect(subject.headers["Authorization"]).to eq("Bearer Excellent!")
      end

      describe "it always sets the Bearer token to ensure not-expired tokens" do
        let(:faraday) { double('faraday', url_prefix: true, authorization: true) }

        before do
          allow(Faraday).to receive(:new) { faraday }
        end

        it "sets the token every time" do
          3.times do
            expect(faraday).to receive(:authorization).with(:Bearer, anything)
            subject
          end
        end
      end
    end

    describe "#oauth" do
      subject { Openlive::Base.oauth }
      it { is_expected.to be_an(Openlive::OAuth) }
    end

    describe "#handle_response" do
      let(:base) { Openlive::Base }
      let(:response) { double('response', body: "test") }
      let(:error_class) { nil }
      let(:message) { nil }

      context "response is successful" do
        before { allow(response).to receive(:success?) { true } }

        it "calls the given block" do
          expect(
            base.send(:handle_response, response) { "Be excellent to each other" }
          ).to eq("Be excellent to each other")
        end
      end

      context "response is not successful" do
        before do
          allow(response).to receive(:success?) { false }
          allow(response).to receive(:status) { 500 }
        end

        context "message is given" do
          let(:message) { "You ditched Napoleon!" }

          it "raises the given message" do
            expect {
              base.send(:handle_response, response, message: message)
            }.to raise_exception(Openlive::Error, message)
          end
        end

        context "error_class is given" do
          let(:error_class) { StandardError }

          it "raises the given error class" do
            expect {
              base.send(:handle_response, response, error_class: error_class)
            }.to raise_exception(StandardError)
          end

          context "error_class is APIError" do
            let(:error_class) { Openlive::APIError }

            it "raises an APIError" do
              expect {
                base.send(:handle_response, response, error_class: error_class)
              }.to raise_exception(Openlive::APIError, "endpoint returned a #{response.status} status: #{response.body}")
            end
          end
        end
      end
    end
  end
end
