# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    render json: TransactionResults.new(start_date: filtering_params[:start_date], end_date: filtering_params[:end_date]).perform
  end

  def create
    product_codes = transaction_params[:product_codes]
    return head :bad_request if product_codes.blank?

    product_codes = JSON.parse(product_codes)
    checkout = Checkout.new(product_codes: product_codes)
    checkout.perform

    render json: checkout.transaction, status: :created
  rescue NoMethodError => _e
    render json: { error: "Ensure Array of Strings are Passed in" }, status: :unprocessable_entity
  end

  private

  def filtering_params
    params.slice(:start_date, :end_date)
  end

  def transaction_params
    params.require(:transaction).permit(:product_codes)
  end
end
