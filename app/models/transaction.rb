# frozen_string_literal: true

class Transaction < ApplicationRecord
  store_accessor :details, :purchases, :total

  attr_accessor :product_codes

  def total=(value)
    super(value.to_s)
  end
end
