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

    describe "#handle_response" do
      let(:response) { double('response') }
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
            }.to raise_exception(Openlive::Base::OpenliveError, message)
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
            let(:error_class) { Openlive::Base::APIError }

            it "raises an APIError" do
              expect {
                base.send(:handle_response, response, error_class: error_class)
              }.to raise_exception(Openlive::Base::APIError, "endpoint returned a #{response.status} status")
            end
          end
        end
      end
    end
  end
end
