# frozen_string_literal: true

class Debit < ApplicationRecord
  include ProductType
  belongs_to :organization

  after_initialize :set_default_product_type, if: :new_record?

  scope :by_organization, ->(org_id) { where(organization_id: org_id) }

  private

  def set_default_product_type
    self.product_type ||= :pentest
  end
end
