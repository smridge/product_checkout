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

      @total +=
        if product.gte_3 && count >= 3
          DiscountCalcs.apply_20_percent_off(count: count, price: product.price)
        elsif product.bogo && count >= 2
          DiscountCalcs.apply_bogo(count: count, price: product.price)
        else
          count * product.price
        end
    end
  end
end
