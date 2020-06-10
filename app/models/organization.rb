# frozen_string_literal: true

class Organization < ApplicationRecord
  has_secure_token :auth_token
  has_many :credits, dependent: :restrict_with_error
  has_many :debits, dependent: :restrict_with_error

  validates :name, presence: true

  before_create do
    self.slug = "#{auth_token}-#{name}".parameterize
  end
end
