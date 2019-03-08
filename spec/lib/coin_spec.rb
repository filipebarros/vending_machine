# frozen_string_literal: true

require 'coin'

RSpec.describe Coin do
  context '#new' do
    subject(:coin) { described_class.new(value) }

    described_class::ACCEPTED_VALUES.each do |value|
      describe 'creates a coin' do
        let(:value) { value }

        it "with #{value}£ value" do
          expect(coin.value).to be(value)
        end
      end
    end

    describe 'when the value is not accepted' do
      let(:value) { 0.03 }

      it 'throws error' do
        expect { coin }.to raise_error(Coin::InvalidValueError)
      end
    end
  end
end
