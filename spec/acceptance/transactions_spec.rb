# frozen_string_literal: true

require "rspec_api_documentation/dsl"

RSpec.describe "/transactions", type: :request do
  resource "Transactions" do
    describe "#index" do
      get "/transactions" do
        parameter :start_date, with_example: true
        parameter :end_date, with_example: true

        let(:start_date) { Time.zone.today - 1.week }
        let(:end_date) { Time.zone.today + 1.week }

        before { create(:transaction) }

        example_request "GET Transactions" do
          expect(status).to eq 200
          expect(response_body).to match_json_expression(
            {
              transactions: [{ total: Transaction.last.total, purchases: Transaction.last.purchases, created_at: wildcard_matcher }],
              purchase_totals: Transaction.last.total
            }
          )
        end
      end
    end

    describe "#create" do
      post "/transactions" do
        with_options scope: :transaction, with_example: true do
          parameter :product_codes, "JSON Array of Product Codes, [CC PC WA]", required: true
        end

        let(:product_codes) { %w[CC PC WA].to_json }

        before do
          create(:product, :coca_cola)
          create(:product, :pepsi_cola)
          create(:product, :water)
        end

        example_request "POST Transaction" do
          expect(status).to eq(201)
        end
      end
    end
  end
end
