require 'spec_helper'

describe Openlive::Request do
  describe "class methods" do
    subject { Openlive::Request }
    let(:connection) { double('connection', send: response) }
    let(:response) { double('faraday_response') }

    before do
      allow(subject).to receive(:connection) { connection }
    end

    %w(get post).each do |http_method|
      describe "##{http_method}" do
        let(:method_call) { subject.send(http_method, "test/path", { test: "Excellent!" }) }

        before do
          allow(subject).to receive(:default_params) { { test: "Boo", test2: "Woo" } }
        end

        it "calls the method on the connection" do
          expect(connection).to receive(:send).with(http_method, "test/path", { test: "Excellent!", test2: "Woo" })
          method_call
        end
      end
    end
  end
end
