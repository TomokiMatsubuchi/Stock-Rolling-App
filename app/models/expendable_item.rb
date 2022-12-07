class ExpendableItem < ApplicationRecord
  validates :name, presence: true
  validates :amount_of_product, presence:true
  validates :amount_to_use, presence: true
  validates :frequency_of_use, presence: true
  enum auto_buy: {"する": true, "しない": false}
  validates :auto_buy, inclusion: {in: ["する", "しない"]}

  has_one_attached :image
  belongs_to :user

  paginates_per 6
end
