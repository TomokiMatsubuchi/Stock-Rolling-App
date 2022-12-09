class ExpendableItem < ApplicationRecord
  validates :name, presence: true
  validates :amount_of_product, presence:true, numericality: {greater_than: 0}
  validates :amount_to_use, presence: true, numericality: {greater_than: 0}
  validates :frequency_of_use, presence: true, numericality: {greater_than: 0}
  validates :product_url, format: {with: /\A#{URI::regexp(['http', 'https'])}\z/}, unless: -> { product_url.blank? }
  enum auto_buy: {"する": true, "しない": false}
  validates :auto_buy, inclusion: {in: ["する", "しない"]}

  has_one_attached :image
  belongs_to :user

  paginates_per 6
end
