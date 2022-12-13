FactoryBot.define do
  factory :expendable_item do
    factory :item_1 do
      name { "item_1" }
      amount_of_product { 500 }
      amount_to_use { 5 }
      frequency_of_use { 3 }
      deadline_on {Date.current.since(33.days)}
      image { nil }
      product_url { "http://example.com" }
      auto_buy { "しない" }
      reference_date {Date.current}
    end
    
  end
end
