# frozen_string_literal: true

module ProductType
  extend ActiveSupport::Concern

  included do
    enum product_type: {
      contract: 0,
      pentest: 1
    }
  end
end
