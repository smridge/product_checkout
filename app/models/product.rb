# frozen_string_literal: true

class Product < ApplicationRecord
  enum category: { drink: 0 }
  store_accessor :discount_rules, :gte_3, :bogo

  after_initialize :set_default_category, if: :new_record?
  after_initialize :set_discount_rules, if: :new_record?

  def gte_3=(string)
    super(ActiveModel::Type::Boolean.new.cast(string))
  end

  def bogo=(string)
    super(ActiveModel::Type::Boolean.new.cast(string))
  end

  def set_default_category
    self.category ||= :drink
  end

  def set_discount_rules
    self.gte_3 ||= false
    self.bogo ||= false
  end
end
