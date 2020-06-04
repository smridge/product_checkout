# frozen_string_literal: true

require "rails_helper"

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

  describe "#create" do
    before do
      create(:product, :coca_cola)
      create(:product, :pepsi_cola)
      create(:product, :water)
    end

    context "with valid parameters" do
      let(:valid_attributes) { { product_codes: %w[CC PC WA].to_json } }

      it "initializes Checkout class" do
        expect(Checkout).to receive(:new).with(product_codes: JSON.parse(valid_attributes[:product_codes])).and_call_original
        post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
      end

      it "creates transaction" do
        expect do
          post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
        end.to change(Transaction, :count).by(1)
      end

      it "renders a JSON response with the new transaction" do
        post(transactions_url, params: { transaction: valid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid data type" do
      let(:invalid_attributes) { { product_codes: "anything".to_json } }

      it "does not create a new Transaction" do
        expect do
          post(transactions_url, params: { transaction: invalid_attributes }, as: :json)
        end.to change(Transaction, :count).by(0)
      end

      it "renders a JSON response with errors for the new transaction" do
        post(transactions_url, params: { transaction: invalid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { anything: nil } }

      it "does not create a new Transaction" do
        expect do
          post(transactions_url, params: { transaction: invalid_attributes }, as: :json)
        end.to change(Transaction, :count).by(0)
      end

      it "renders a JSON response with errors for the new transaction" do
        post(transactions_url, params: { transaction: invalid_attributes }, headers: valid_headers, as: :json)
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq("application/json")
      end
    end
  end
end
