# frozen_string_literal: true

class Transaction < ApplicationRecord
  store_accessor :details, :purchases, :total

  attr_accessor :product_codes

  scope :created_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  def total=(value)
    super(value.to_s)
  end
end
