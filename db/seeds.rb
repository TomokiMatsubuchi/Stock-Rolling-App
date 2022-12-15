5.times do |i|
  User.create!(name: "user_#{i}", email: "sample_#{i}@example.com", password: "password", encrypted_password: "password", admin: false, line_alert: true)
  ExpendableItem.create!(name: "item_#{i}", amount_of_product: 500, amount_to_use: 5, frequency_of_use: 3, deadline_on: Date.current.since(33.days), image: nil, product_url: "http://example.com", auto_buy: "しない", reference_date: Date.current, user_id: i+1)
end