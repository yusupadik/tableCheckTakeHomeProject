require "test_helper"

class InventoryTest < ActiveSupport::TestCase
   # Run before each test
  setup do
    # Clear the database (optional if you have a better approach for MongoDB)
    Inventory.delete_all
  end

  # Run after each test to clean up data
  teardown do
    # Ensure no data is left behind
    Inventory.delete_all
  end
  test "should not save inventory without name" do
    inventory = Inventory.new(price: 100, qty: 10)
    assert_not inventory.save, "Saved the inventory without a name"
  end

  test "should save valid inventory" do
    inventory = Inventory.new(name: "Test Inventory", price: 100, qty: 10, category: "Test Category", default_price: 90)
    assert inventory.save, "Couldn't save the inventory"
  end

  test "should not save valid inventory name unique" do
    inventory = Inventory.new(name: "Test Inventory", price: 100, qty: 10, category: "Test Category", default_price: 90)
    inventory.save
    inventory2 = Inventory.new(name: "Test Inventory", price: 100, qty: 10, category: "Test Category", default_price: 90)
    assert_not inventory2.save, "Couldn't save the inventory"
  end
end
