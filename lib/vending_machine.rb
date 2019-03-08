# frozen_string_literal: true

class VendingMachine
  class InsufficientChangeError < StandardError; end
  class InsufficientMoneyError < StandardError; end
  class ProductUnavailableError < StandardError; end

  attr_reader :products, :change

  def initialize(products = {}, change = {})
    @products = products
    @change = change
  end

  def buy(product, inserted_coins)
    raise ProductUnavailableError, "Product #{product.name} is currently unavailable" if product_unavailable?(product)

    total_inserted_money = inserted_coins.inject(0) { |sum, coin| sum + coin.value }
    if product.price > total_inserted_money
      raise InsufficientMoneyError, "The product you want to buy costs #{product.price}£ \
      but you only introduced #{total_inserted_money}£"
    end

    calculate_change(total_inserted_money, product.price)

    products[product] -= 1
  end

  def add_change(new_change)
    new_change.each do |k, v|
      if change[k]
        change[k] += v
      else
        change[k] = v
      end
    end
  end

  def add_products(new_products)
    new_products.each do |k, v|
      if products[k]
        products[k] += v
      else
        products[k] = v
      end
    end
  end

  private

  def product_unavailable?(product)
    product_quantity = products[product]
    product_quantity.nil? || product_quantity.zero?
  end

  def calculate_change(inserted, product_price)
    # 0.020000000000000018 for a specific test
    change_due = (inserted - product_price).round(2)

    total_change = change.map { |k, v| k.value * v }.inject(:+)
    raise InsufficientChangeError, "There's not enough change on the machine" if change_due > total_change

    if change.keys.map(&:value).include?(change_due)
      take_coin(change_due)
    else
      while change_due.positive?
        change_available = change.transform_keys(&:value).select { |_k, v| v.positive? }
        coins_available = (Coin::ACCEPTED_VALUES & change_available.keys).sort.reverse!
        value = coins_available.find { |v| v <= change_due }
        take_coin(value)

        change_due = (change_due - value).round(2)
      end
    end
  end

  def take_coin(value)
    coin = change.select { |k, _v| k.value.eql?(value) }
    change[coin.keys.first] -= 1
  end
end
