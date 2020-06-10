# frozen_string_literal: true

require "rails_helper"

RSpec.describe Credit, type: :model do
  describe "#associations" do
    it "belongs_to organization" do
      expect(described_class.reflect_on_association(:organization).macro).to eq(:belongs_to)
    end
  end

  describe "#product_type" do
    it "is an enum hash" do
      expect(described_class.product_types).to eq({ "contract" => 0 })
    end
  end
end
