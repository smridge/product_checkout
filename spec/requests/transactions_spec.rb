# frozen_string_literal: true

RSpec.describe "/transactions", type: :request do
  let(:valid_headers) do
    {
      "X-Frame-Options" => "SAMEORIGIN",
      "X-XSS-Protection" => "1; mode=block",
      "X-Content-Type-Options" => "nosniff",
      "X-Download-Options" => "noopen",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "Referrer-Policy" => "strict-origin-when-cross-origin"
    }
  end

  describe "#index" do
    it "returns response" do
      get(transactions_url, headers: valid_headers, as: :json)
      expect(response).to be_successful
    end

    it "returns response body" do
      transaction = create(:transaction)
      get(transactions_url, headers: valid_headers, as: :json)

      expect(response.body).to match_json_expression(
        {
          transactions: [{ total: transaction.total, purchases: transaction.purchases, created_at: wildcard_matcher }],
          purchase_totals: transaction.total
        }
      )
    end
  end

  describe "#create" do
    before do
      create(:product, :coca_cola)
      create(:product, :pepsi_cola)
      create(:product, :water)
    end

    context "with valid parameters" do
      let(:valid_attributes) { { product_codes: %w[CC PC WA].to_json } }

      it "creates transaction" do
        expect do
          post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
        end.to change(Transaction, :count).by(1)
      end

      it "returns response" do
        post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:created)
      end

      it "returns response body" do
        post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
        transaction = Transaction.last

        expect(response.body).to match_json_expression(
          { id: transaction.id, details: transaction.details, created_at: wildcard_matcher, updated_at: wildcard_matcher }
        )
      end
    end

    context "with invalid data type" do
      let(:invalid_attributes) { { product_codes: "anything".to_json } }

      it "does not create a new Transaction" do
        expect do
          post(transactions_url, params: { transaction: invalid_attributes }, as: :json)
        end.to change(Transaction, :count).by(0)
      end

      it "returns response" do
        post(transactions_url, params: { transaction: invalid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns response body" do
        post(transactions_url, params: { transaction: invalid_attributes }, headers: valid_headers, as: :json)
        expect(response.body).to match_json_expression({ error: "Ensure Array of Strings are Passed in" })
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { anything: nil } }

      it "does not create a new Transaction" do
        expect do
          post(transactions_url, params: { transaction: invalid_attributes }, as: :json)
        end.to change(Transaction, :count).by(0)
      end

      it "returns response" do
        post(transactions_url, params: { transaction: invalid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
