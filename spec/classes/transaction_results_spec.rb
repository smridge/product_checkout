# frozen_string_literal: true

RSpec.describe TransactionResults do
  describe "#perform" do
    before { create(:transaction) }

    it "returns all transactions as a Hash" do
      expect(described_class.new.perform).to be_a(Hash)
    end

    it "returns hash of transactions and purchase_totals" do
      expect(described_class.new.perform.keys).to match_array([:transactions, :purchase_totals])
    end

    it "returns all transactions as an array" do
      expect(described_class.new.perform[:transactions]).to be_a(Array)
    end

    it "returns all transactions as an array of hashes" do
      expect(described_class.new.perform[:transactions].first).to be_a(Hash)
    end

    it "includes totals, purchases and created_at keys for each transaction" do
      expect(described_class.new.perform[:transactions].first.keys).to match_array([:total, :purchases, :created_at])
    end

    it "includes total transaction amount as a string" do
      expect(described_class.new.perform[:transactions].first[:total]).to eq("4.35")
    end

    it "includes purchases tally for transaction as a hash" do
      expect(described_class.new.perform[:transactions].first[:purchases]).to eq({ "CC" => 1, "PC" => 1, "WA" => 1 })
    end

    it "includes created at for transaction as a string" do
      transaction = create(:transaction)
      expect(described_class.new.perform[:transactions].first[:created_at]).to eq(transaction.created_at.to_s)
    end

    it "returns purchase totals as stringified decimal" do
      purchase_totals = described_class.new.perform[:purchase_totals]
      expect(purchase_totals).to eq(4.35.to_s)
    end
  end
end
