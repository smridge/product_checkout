# frozen_string_literal: true

class Credit < ApplicationRecord
  belongs_to :organization

  enum product_type: { contract: 0 }
end
