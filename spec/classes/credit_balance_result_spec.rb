# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreditBalanceResult do
  describe "#perform" do
    context "with debits and credits" do
      it "returns hash with slug and balance with organization argument" do
        organization = create(:organization, :with_credits_and_debits)
        credit_units = Credit.by_organization(organization.id).sum(&:units)
        debit_units  = Debit.by_organization(organization.id).sum(&:units)
        result       = described_class.new(organization: organization).perform

        expect(result).to eq(
          {
            org: {
              slug: organization.slug,
              balance: (credit_units - debit_units).to_s
            }
          }
        )
      end
    end

    context "without debits or credits" do
      it "returns a zero balance" do
        organization = create(:organization)
        result       = described_class.new(organization: organization).perform

        expect(result).to eq(
          {
            org: {
              slug: organization.slug,
              balance: 0.to_s
            }
          }
        )
      end
    end
  end
end
