require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    Inventory.delete_all
    Order.delete_all
  end

  # Run after each test to clean up data
  teardown do
    Inventory.delete_all
    Order.delete_all
  end
  test "should save order with inventory_id" do
    inventory = Inventory.new(name: "Test Inventory", price: 100, qty: 10, category: "Test Category", default_price: 90)
    inventory.save
    order = Order.new(inventory: inventory, price: 100, qty: 2)
    assert order.save, "Saved the order"
  end

  test "should not save order without inventory_id" do
    order = Order.new(price: 100, qty: 2)
    assert_not order.save, "Couldn't save the order"
  end
end
