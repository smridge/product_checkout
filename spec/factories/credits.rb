# frozen_string_literal: true

FactoryBot.define do
  factory :credit do
    product_type { "contract" }
    units { 10 }
    organization
  end
end
