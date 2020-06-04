# frozen_string_literal: true

class TransactionResults
  def initialize(start_date: nil, end_date: nil)
    @transactions = Transaction.created_between(start_date, end_date)
  end

  def perform
    base =
      {
        transactions:
          @transactions.map do |txn|
            {
              total: txn.total,
              purchases: txn.purchases,
              created_at: txn.created_at.to_s
            }
          end
      }

    base.merge!(purchase_totals: base[:transactions].map { |purchase| purchase[:total] }.compact.map(&:to_d).sum.to_s)
  end
end
