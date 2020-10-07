# frozen_string_literal: true

RSpec.describe Checkout do
  before do
    create(:product, :coca_cola)
    create(:product, :pepsi_cola)
    create(:product, :water)
  end

  describe "#perform" do
    let(:init) { described_class.new(product_codes: %w[CC PC WA]) }

    it "can access 'total' as an attribute" do
      init
      expect(init.total).to be_a(BigDecimal)
    end

    it "can access 'transaction' as an attribute" do
      init
      expect(init.transaction).to be_a(Transaction)
    end

    context "with valid product codes" do
      it "creates transaction" do
        expect { init.perform }.to change(Transaction, :count).by(1)
      end
    end

    context "with no discounts" do
      it "calculates transaction purchases" do
        init.perform
        expect(init.transaction.purchases).to eq({ "CC" => 1, "PC" => 1, "WA" => 1 })
      end

      it "calculates transaction total" do
        init.perform
        expect(init.transaction.total).to eq(4.35.to_s)
      end
    end

    context "with bogo discount applied" do
      let(:product) { create(:product, :coca_cola) }
      let(:init) { described_class.new(product_codes: [product.code, product.code]) }

      it "calculates transaction purchases" do
        init.perform
        expect(init.transaction.purchases).to eq({ product.code => 2 })
      end

      it "calculates transaction total" do
        init.perform
        product_count = init.transaction.purchases[product.code]
        expect(init.transaction.total).to eq((product_count / 2 * product.price).to_s)
      end
    end

    context "with greater than 3 discount applied" do
      let(:product) { create(:product, :pepsi_cola) }
      let(:init) { described_class.new(product_codes: [product.code, product.code, product.code]) }

      it "calculates transaction purchases" do
        init.perform
        expect(init.transaction.purchases).to eq({ product.code => 3 })
      end

      it "calculates transaction total" do
        init.perform
        product_count = init.transaction.purchases[product.code]
        expect(init.transaction.total).to eq((product_count * product.price * 0.8).to_s)
      end
    end

    context "with all discounts applied" do
      let(:init) { described_class.new(product_codes: %w[PC CC PC WA PC CC]) }

      it "calculates transaction purchases" do
        init.perform
        expect(init.transaction.purchases).to eq({ "CC" => 2, "PC" => 3, "WA" => 1 })
      end

      it "calculates transaction total" do
        init.perform
        expect(init.transaction.total).to eq(7.15.to_s)
      end
    end

    context "with invalid and valid product codes" do
      let(:init) { described_class.new(product_codes: %w[CC PC WA FO BA cc]) }

      it "only creates purchases for valid product codes" do
        init.perform
        expect(init.transaction.purchases).to eq({ "CC" => 1, "PC" => 1, "WA" => 1 })
      end
    end
  end
end
