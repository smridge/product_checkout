# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    purchases { { "CC" => 1, "PC" => 1, "WA" => 1 } }
    total { 4.35 }
  end
end
