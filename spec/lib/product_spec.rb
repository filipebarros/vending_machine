# frozen_string_literal: true

require 'product'

RSpec.describe Product do
  context '#new' do
    let(:name) { 'Diet Coke' }
    subject(:product) { described_class.new(name, price) }

    describe 'it creates a new product' do
      let(:price) { 0.98 }

      it 'the given name and a price' do
        expect(product.name).to be 'Diet Coke'
        expect(product.price).to be 0.98
      end
    end

    describe 'when price is zero' do
      let(:price) { 0.0 }

      it 'throws error' do
        expect { product }.to raise_error(Product::InvalidPriceError)
      end
    end

    describe 'when price is negative' do
      let(:price) { -0.98 }

      it 'throws error' do
        expect { product }.to raise_error(Product::InvalidPriceError)
      end
    end
  end
end
