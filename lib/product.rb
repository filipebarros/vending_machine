# frozen_string_literal: true

class Product
  class InvalidPriceError < StandardError; end

  attr_reader :name, :price

  def initialize(name, price)
    raise InvalidPriceError, "#{price}£ is not valid" unless price.positive?

    @name = name
    @price = price
  end
end
