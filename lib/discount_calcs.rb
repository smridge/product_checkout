# frozen_string_literal: true

module DiscountCalcs
  module_function

  def apply_20_percent_off(count:, price:)
    count * price * 0.8
  end

  def apply_bogo(count:, price:)
    count.even? ? (count / 2 * price) : (count / 2 * price) + price
  end
end
