# frozen_string_literal: true

class Transaction < ApplicationRecord
  store_accessor :details, :purchases, :total

  def total=(value)
    super(value.to_s)
  end
end
