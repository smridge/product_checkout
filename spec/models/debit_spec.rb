# frozen_string_literal: true

require "rails_helper"

RSpec.describe Debit, type: :model do
  describe "#associations" do
    it "belongs_to organization" do
      expect(described_class.reflect_on_association(:organization).macro).to eq(:belongs_to)
    end
  end

  describe "#set_default_product_type" do
    it "sets default product_type on initialize" do
      expect(described_class.new.product_type).to eq("pentest")
    end

    it "persists attribute on save" do
      expect(create(:debit).product_type).to eq("pentest")
    end
  end

  describe "#by_organization" do
    it "returns debits with organization id argument" do
      debit = create(:debit)
      expect(described_class.by_organization(debit.organization_id)).to include(debit)
    end

    it "is an active record relation" do
      expect(described_class.by_organization(nil)).to be_a(ActiveRecord::Relation)
    end
  end
end
