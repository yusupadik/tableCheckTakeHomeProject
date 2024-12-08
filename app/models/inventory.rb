class Inventory
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :orders

  field :name, type: String
  field :category, type: String
  field :default_price, type: Float
  field :price, type: Float
  field :qty, type: Integer

  validates :name, :category, :default_price, :price, :qty, presence: true
  validates :name, uniqueness: true

end
