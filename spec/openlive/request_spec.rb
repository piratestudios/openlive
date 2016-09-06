require 'spec_helper'

describe Openlive::Request do
  describe "class methods" do
    subject { Openlive::Request }
    let(:connection) { double('connection', send: response) }
    let(:response) { double('faraday_response') }

    before do
      allow(subject).to receive(:connection) { connection }
    end

    describe "#get" do
      let(:method_call) { subject.send(:get, "test/path", { test: "Excellent!" }) }

      before do
        allow(subject).to receive(:default_params) { { test: "Boo", test2: "Woo" } }
        allow(subject).to receive(:default_headers) { { "Content-Type" => "application/json" } }
      end

      it "calls the method on the connection" do
        expect(connection).to receive(:send).with(
          :get,
          "test/path",
          { test: "Excellent!", test2: "Woo" },
          { "Content-Type" => "application/json" }
        )
        method_call
      end

      it "returns a response object" do
        expect(method_call).to be_an(Openlive::Response)
      end
    end

    describe "#post" do
      let(:method_call) { subject.send(:post, "test/path", { test: "Excellent!" }) }

      before do
        allow(subject).to receive(:default_params) { { test: "Boo", test2: "Woo" } }
        allow(subject).to receive(:default_headers) { { "Content-Type" => "application/json" } }
      end

      it "calls the method on the connection" do
        expect(connection).to receive(:send).with(
          :post,
          "test/path",
          JSON.generate({ test: "Excellent!", test2: "Woo" }),
          { "Content-Type" => "application/json" }
        )
        method_call
      end

      it "returns a response object" do
        expect(method_call).to be_an(Openlive::Response)
      end
    end
  end
end
