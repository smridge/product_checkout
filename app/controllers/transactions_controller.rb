# frozen_string_literal: true

class TransactionsController < ApplicationController
  def create
    product_codes = transaction_params[:product_codes]
    return head :bad_request if product_codes.blank?

    product_codes = JSON.parse(product_codes)
    @checkout = Checkout.new(product_codes: product_codes)
    @checkout.perform

    render json: @checkout.transaction, status: :created
  rescue NoMethodError => _e
    render json: { error: "Ensure Array of Strings are Passed in" }, status: :unprocessable_entity
  end

  private

  def transaction_params
    params.require(:transaction).permit(:product_codes)
  end
end
