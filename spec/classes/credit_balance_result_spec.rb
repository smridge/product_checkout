# frozen_string_literal: true

RSpec.describe CreditBalanceResult do
  describe "#perform" do
    context "with debits and credits" do
      let(:organization) { create(:organization, :with_credits_and_debits) }
      let(:credit_units) { organization.credits.sum(&:units) }
      let(:debit_units) { organization.debits.sum(&:units) }

      it "returns hash with slug and balance with organization argument" do
        result = described_class.new(organization: organization).perform
        expect(result).to eq({ org: { slug: organization.slug, balance: (credit_units - debit_units).to_s } })
      end
    end

    context "without debits or credits" do
      let(:organization) { create(:organization) }

      it "returns a zero balance" do
        result = described_class.new(organization: organization).perform
        expect(result).to eq({ org: { slug: organization.slug, balance: 0.to_s } })
      end
    end
  end
end
