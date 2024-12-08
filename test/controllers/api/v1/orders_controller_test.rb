require "test_helper"
require 'minitest/mock'
class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create sample inventory items
    @inventory_1 = Inventory.create(
      name: 'Product 1',
      category: 'Category 1',
      default_price: 100,
      price: 100,
      qty: 2
      )
    @inventory_2 = Inventory.create(
      name: 'Product 2',
      category: 'Category 1',
      default_price: 50,
      price: 50,
      qty: 3
    )
  end

  teardown do
    # Clean up the test data
    Inventory.delete_all
    Order.delete_all
  end

  test "should not create order if no products selected" do
    post api_v1_orders_url, params: { products: nil }
    assert_response :unprocessable_entity
    assert_includes response.body, "No Products selected"
  end

  test "should not create order if inventory not found" do
    post api_v1_orders_url, params: { products: [{ name: 'Nonexistent Product', qty: 2, price: 100 }] }
    assert_response :unprocessable_entity
    assert_includes response.body, "Inventory not found for Nonexistent Product"
  end

  test "should not create order if not enough quantity" do
    post api_v1_orders_url, params: { products: [{ name: 'Product 1', qty: 15, price: 100 }] }
    assert_response :unprocessable_entity
    assert_includes response.body, "Not enough quantity for Product 1"
  end

  test "should create order successfully" do
    post api_v1_orders_url, params: { products: [
      { name: 'Product 1', qty: 2, price: 100 },
      { name: 'Product 2', qty: 3, price: 50 }
    ] }

    assert_response :created
    assert_includes response.body, "Order created successfully"
    assert_includes response.body, "orders"

    @inventory_1.reload
    @inventory_2.reload
    assert_equal 0, @inventory_1.qty
    assert_equal 0, @inventory_2.qty
  end

end
