# frozen_string_literal: true

require 'coin'
require 'product'
require 'vending_machine'

require 'pry'

RSpec.describe VendingMachine do
  subject(:vending_machine) { described_class.new(products, change) }

  context '#new' do
    describe 'when products and change are not provided' do
      let(:products) { {} }
      let(:change) { {} }

      it 'creates an empty vending machine' do
        expect(vending_machine.products).to eq({})
        expect(vending_machine.change).to eq({})
      end
    end

    describe 'when products and change are provided' do
      let(:chocolate_bar) { Product.new('Chocolate Bar', 0.98) }
      let(:products) { { chocolate_bar => 1 } }

      let(:one_p_coin) { Coin.new(0.01) }
      let(:change) { { one_p_coin => 10 } }

      it 'creates an empty vending machine' do
        expect(vending_machine.products).to eq(products)
        expect(vending_machine.change).to eq(change)
      end
    end
  end

  context '#buy' do
    subject(:buy) { vending_machine.buy(product, introduced_money) }

    describe 'when product does not exist in the machine' do
      let(:product) { Product.new('Chocolate Bar', 0.98) }
      let(:products) { {} }

      let(:one_p_coin) { Coin.new(0.01) }
      let(:change) { { one_p_coin => 10 } }

      let(:introduced_money) { [] }

      it 'throws error' do
        expect { buy }.to raise_error(VendingMachine::ProductUnavailableError)
      end
    end

    describe 'when not enough money is provided' do
      let(:product) { Product.new('Chocolate Bar', 0.98) }
      let(:products) { { product => 1 } }

      let(:one_p_coin) { Coin.new(0.01) }
      let(:change) { { one_p_coin => 10 } }

      let(:introduced_money) { [one_p_coin] }

      it 'throws error' do
        expect { buy }.to raise_error(VendingMachine::InsufficientMoneyError)
      end
    end

    describe 'when enough money is provided but no change available' do
      let(:product) { Product.new('Chocolate Bar', 0.98) }
      let(:products) { { product => 1 } }

      let(:one_pound_coin) { Coin.new(1.00) }
      let(:one_p_coin) { Coin.new(0.01) }
      let(:change) { { one_p_coin => 1 } }

      let(:introduced_money) { [one_pound_coin] }

      it 'throws error' do
        expect { buy }.to raise_error(VendingMachine::InsufficientChangeError)
      end
    end

    describe 'when enough money is provided and one coin of change is available' do
      let(:product) { Product.new('Chocolate bar', 0.98) }
      let(:products) { { product => 1 } }

      let(:one_pound_coin) { Coin.new(1.00) }
      let(:two_p_coin) { Coin.new(0.02) }
      let(:change) { { two_p_coin => 1, one_pound_coin => 1 } }

      let(:introduced_money) { [one_pound_coin] }

      it 'gets product and returns the change' do
        buy

        expect(vending_machine.products).to eq(product => 0)
        expect(vending_machine.change).to eq(two_p_coin => 0, one_pound_coin => 1)
      end
    end

    describe 'when enough money is provided and change is available' do
      let(:product) { Product.new('Chocolate Bar', 0.92) }
      let(:products) { { product => 1 } }

      let(:one_pound_coin) { Coin.new(1.00) }
      let(:one_p_coin) { Coin.new(0.01) }
      let(:two_p_coin) { Coin.new(0.02) }
      let(:five_p_coin) { Coin.new(0.05) }
      let(:change) { { one_p_coin => 1, two_p_coin => 2, five_p_coin => 1, one_pound_coin => 1 } }

      let(:introduced_money) { [one_pound_coin] }

      it 'gets product and returns the change' do
        buy

        expect(vending_machine.products).to eq(product => 0)
        expect(vending_machine.change).to eq(one_p_coin => 0, two_p_coin => 1, five_p_coin => 0, one_pound_coin => 1)
      end
    end
  end

  context '#add_change' do
    subject(:add_change) { vending_machine.add_change(new_change) }

    let(:product) { Product.new('Chocolate bar', 0.98) }
    let(:products) { { product => 1 } }
    let(:one_pound_coin) { Coin.new(1.00) }
    let(:change) { { one_pound_coin => 3 } }

    describe 'when adding a coin that does not exist' do
      let(:one_p_coin) { Coin.new(0.01) }
      let(:new_change) { { one_p_coin => 10 } }

      it 'creates a new coin with the newly added amount of coins' do
        add_change

        expect(vending_machine.change).to eq(one_p_coin => 10, one_pound_coin => 3)
      end
    end

    describe 'when adding a coin that already exists' do
      let(:new_change) { { one_pound_coin => 10 } }

      it 'sums the amount of coins added to the previously existing' do
        add_change

        expect(vending_machine.change).to eq(one_pound_coin => 13)
      end
    end
  end

  context '#add_product' do
    subject(:add_products) { vending_machine.add_products(new_products) }

    let(:chocolate_bar) { Product.new('Chocolate bar', 0.98) }
    let(:products) { { chocolate_bar => 1 } }
    let(:one_pound_coin) { Coin.new(1.00) }
    let(:change) { { one_pound_coin => 3 } }

    describe 'when adding a product that does not exist' do
      let(:diet_coke) { Product.new('Diet Coke', 1.01) }
      let(:new_products) { { diet_coke => 10 } }

      it 'creates a new product' do
        add_products

        expect(vending_machine.products).to eq(chocolate_bar => 1, diet_coke => 10)
      end
    end

    describe 'when adding a product that already exists' do
      let(:new_products) { { chocolate_bar => 10 } }

      it 'sums the amount of products added to the previously existing' do
        add_products

        expect(vending_machine.products).to eq(chocolate_bar => 11)
      end
    end
  end
end
