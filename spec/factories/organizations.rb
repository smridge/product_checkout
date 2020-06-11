# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { "Foo Company" }

    trait :with_credits_and_debits do
      after(:create) do |instance|
        create_list(:credit, 1, organization: instance)
        create_list(:debit, 1, organization: instance)
      end
    end
  end
end
