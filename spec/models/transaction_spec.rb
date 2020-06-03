# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "#discount_rules" do
    it "is a store accessor" do
      expect(described_class.local_stored_attributes[:details]).to eq([:purchases, :total])
    end
  end

  describe "#total=(value)" do
    it "converts attribute to string" do
      transaction = create(:transaction, total: 1.5)
      expect(transaction.reload.total).to eq("1.5")
    end
  end
end
