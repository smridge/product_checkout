# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction, type: :model do
  describe "#discount_rules" do
    it "is a store accessor" do
      expect(described_class.local_stored_attributes[:details]).to eq([:purchases, :total])
    end
  end

  describe "#created_between" do
    let(:transaction) { create(:transaction) }
    let(:start_date) { transaction.created_at.to_date }
    let(:end_date) { Time.zone.today + 2.days }

    it "is an active record relation" do
      expect(described_class.created_between(nil, nil)).to be_a(ActiveRecord::Relation)
    end

    context "with start_date" do
      it "returns array of transactions greater than start_date" do
        expect(described_class.created_between(start_date, nil)).to include(transaction)
      end
    end

    context "with end_date" do
      it "returns array of transactions less than end_date" do
        expect(described_class.created_between(nil, end_date)).to include(transaction)
      end
    end

    context "with start_date and end_date" do
      it "returns array of transactions between date range" do
        expect(described_class.created_between(start_date, end_date)).to include(transaction)
      end
    end
  end

  describe "#total=(value)" do
    it "converts attribute to string" do
      transaction = create(:transaction, total: 1.5)
      expect(transaction.reload.total).to eq("1.5")
    end
  end
end
