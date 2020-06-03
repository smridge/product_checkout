# frozen_string_literal: true

require "rails_helper"

RSpec.describe Product, type: :model do
  describe "#category" do
    it "is an enum hash" do
      expect(described_class.categories).to eq({ "drink" => 0 })
    end
  end

  describe "#discount_rules" do
    it "is a store accessor" do
      expect(described_class.local_stored_attributes[:discount_rules]).to eq([:gte_3, :bogo])
    end
  end

  describe "#set_default_category" do
    it "sets default category on initialize" do
      expect(described_class.new.category).to eq("drink")
    end

    it "persists attribute on save" do
      expect(create(:product).category).to eq("drink")
    end
  end

  describe "#set_discount_rules" do
    it "sets default discount rules on initialize" do
      expect(described_class.new.discount_rules).to eq({ "gte_3" => false, "bogo" => false })
    end

    it "persists attributes on save" do
      expect(create(:product).discount_rules).to eq({ "gte_3" => false, "bogo" => false })
    end
  end

  describe "#gte_3=(string)" do
    it "casts attribute to boolean" do
      product = create(:product, gte_3: "false")
      expect(product.reload.gte_3).to eq(false)
    end
  end

  describe "#bogo=(string)" do
    it "casts attribute to boolean" do
      product = create(:product, bogo: "0")
      expect(product.reload.gte_3).to eq(false)
    end
  end
end
