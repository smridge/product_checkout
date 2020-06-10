# frozen_string_literal: true

require "rails_helper"

RSpec.describe Credit, type: :model do
  describe "#associations" do
    it "belongs_to organization" do
      expect(described_class.reflect_on_association(:organization).macro).to eq(:belongs_to)
    end
  end

  describe "#set_default_product_type" do
    it "sets default product_type on initialize" do
      expect(described_class.new.product_type).to eq("contract")
    end

    it "persists attribute on save" do
      expect(create(:credit).product_type).to eq("contract")
    end
  end
end
