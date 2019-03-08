# frozen_string_literal: true

class Coin
  class InvalidValueError < StandardError; end

  ACCEPTED_VALUES = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2].freeze

  attr_reader :value

  def initialize(value)
    raise InvalidValueError, "Value #{value}£ is invalid" unless ACCEPTED_VALUES.include?(value)

    @value = value
  end
end
