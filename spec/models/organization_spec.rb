# frozen_string_literal: true

require "rails_helper"

RSpec.describe Organization, type: :model do
  describe "#has_secure_token" do
    it "generates a 24-character unique auth_token on creating new record" do
      organization = described_class.new(name: "Foo Org")
      organization.save
      expect(organization.reload.auth_token.length).to eq(24)
    end
  end

  describe "#validates" do
    context "without required fields" do
      it "throws errors" do
        organization = described_class.new
        organization.save
        expect(organization.errors).to include(:name)
      end
    end
  end

  describe "#before_create" do
    it "sets slug using auth_token and name" do
      organization = described_class.new(name: "Foo Org")
      organization.save
      expect(organization.reload.slug).to eq("#{organization.auth_token}-#{organization.name}".parameterize)
    end
  end
end
