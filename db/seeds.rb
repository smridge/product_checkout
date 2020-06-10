# frozen_string_literal: true

Product.create(name: "Coca-Cola", code: "CC", price: 1.50, bogo: true)
Product.create(name: "Pepsi Cola", code: "PC", price: 2.00, gte_3: true)
Product.create(name: "Water", code: "WA", price: 0.85)

10.times do
  Transaction.create(purchases: { "CC" => 1, "PC" => 1, "WA" => 1 }, total: 4.35, created_at: 2.months.ago)
end

5.times do
  Transaction.create(purchases: { "CC" => 1, "PC" => 1, "WA" => 1 }, total: 4.35, created_at: 1.month.ago)
end

Transaction.create(purchases: { "CC" => 1, "PC" => 1, "WA" => 1 }, total: 4.35)
Transaction.create(purchases: { "CC" => 3, "PC" => 1 }, total: 5.0)
Transaction.create(purchases: { "CC" => 2, "PC" => 3, "WA" => 1 }, total: 7.15)

Organization.create(name: "Foo Org")
Organization.create(name: "Bar Org")
