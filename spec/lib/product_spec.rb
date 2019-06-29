# frozen_string_literal: true

require 'product'

RSpec.describe Product do
  describe '#new' do
    subject(:product) { described_class.new(name, price) }

    let(:name) { 'Diet Coke' }

    context 'when a new product is created' do
      let(:price) { 0.98 }

      it 'has a given name' do
        expect(product.name).to be 'Diet Coke'
      end

      it 'has a price' do
        expect(product.price).to be 0.98
      end
    end

    context 'when price is zero' do
      let(:price) { 0.0 }

      it 'throws error' do
        expect { product }.to raise_error(Product::InvalidPriceError)
      end
    end

    context 'when price is negative' do
      let(:price) { -0.98 }

      it 'throws error' do
        expect { product }.to raise_error(Product::InvalidPriceError)
      end
    end
  end
end
