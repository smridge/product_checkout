# frozen_string_literal: true

class Checkout
  attr_accessor :transaction, :total

  def initialize(product_codes:)
    @transaction   = Transaction.new
    @products      = Product.all
    @product_codes = product_codes
    @valid_product_codes = @product_codes.select { |code| @products.map(&:code).include?(code) }
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
      product = @products.find { |rule| rule.code == code }

      if product.gte_3 && count >= 3
        apply_gte_3_discount(count, product.price)
      elsif product.bogo && count >= 2
        apply_bogo_discount(count, product.price)
      else
        @total += count * product.price
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
