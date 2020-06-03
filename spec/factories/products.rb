# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { "Foo" }
    code { "FO" }
    price { 1.00 }

    trait :coca_cola do
      name { "Coca-Cola" }
      code { "CC" }
      price { 1.50 }
      bogo { true }
    end

    trait :pepsi_cola do
      name { "Pepsi Cola" }
      code { "PC" }
      price { 2.00 }
      gte_3 { true }
    end

    trait :water do
      name { "Water" }
      code { "WA" }
      price { 0.85 }
    end
  end
end
