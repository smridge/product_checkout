# frozen_string_literal: true

class CreditBalanceResult
  def initialize(organization:)
    @organization = organization
    @credit_units = organization.credits.sum(&:units)
    @debit_units  = organization.debits.sum(&:units)
  end

  def perform
    {
      org: {
        slug: @organization.slug,
        balance: (@credit_units - @debit_units).to_s
      }
    }
  end
end
