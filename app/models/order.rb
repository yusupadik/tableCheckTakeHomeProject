class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :inventory

  field :price, type: Float
  field :qty, type: Integer
  field :inventory_id, type: BSON::ObjectId

  # Validations
  validates :price, presence: true
  validates :qty, presence: true
  validates :inventory_id, presence: true
end
