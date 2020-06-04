# frozen_string_literal: true

class Checkout
  attr_accessor :transaction, :total

  def initialize(product_codes:)
    @transaction    = Transaction.new
    @product_fields = Product.all.pluck(:code, :discount_rules, :price)
    @product_codes  = product_codes
    @valid_product_codes = @product_codes.select { |code| @product_fields.map(&:first).include?(code) }
    @products_tally      = @valid_product_codes.tally
    @total = 0.to_d
  end

  def perform
    calculate_total
    return if @total.zero?

    @transaction.purchases = @products_tally
    @transaction.total = @total
    @transaction.save
  end

  private

  def calculate_total
    @products_tally.each do |code, count|
      product_field = @product_fields.find { |rule| rule[0] == code }

      if product_field[1]["gte_3"] && count >= 3
        apply_gte_3_discount(count, product_field[2])
      elsif product_field[1]["bogo"] && count >= 2
        apply_bogo_discount(count, product_field[2])
      else
        @total += count * product_field[2]
      end
    end
  end

  def apply_gte_3_discount(count, price)
    @total += count * price * 0.8
  end

  def apply_bogo_discount(count, price)
    @total +=
      if count.even?
        count / 2 * price
      else
        (count / 2 * price) + price
      end
  end
end
