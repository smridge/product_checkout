# frozen_string_literal: true

class Organization < ApplicationRecord
  has_secure_token :auth_token

  validates :name, presence: true

  before_create do
    self.slug = "#{auth_token}-#{name}".parameterize
  end
end
