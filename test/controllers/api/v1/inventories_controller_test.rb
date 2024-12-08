require "test_helper"

class Api::V1::InventoriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    Inventory.delete_all
  end

  teardown do
    Inventory.delete_all
  end
  test 'should get index' do
    Inventory.create!(
      name: 'Item 1',
      category: 'Category 1',
      default_price: 10.5,
      price: 10.5,
      qty: 100
    )

    get api_v1_inventories_url

    assert_response :success
    response_json = JSON.parse(@response.body)

    assert_equal 1, response_json.size
    assert_equal 'Item 1', response_json.first['name']
    assert_equal 'Category 1', response_json.first['category']
  end

  test 'should show inventory' do
    inventory = Inventory.create!(
      name: 'Item 1',
      category: 'Category 1',
      default_price: 10.5,
      price: 10.5,
      qty: 100
    )

    get api_v1_inventory_url(inventory)

    assert_response :success
    response_json = JSON.parse(@response.body)

    assert_equal inventory.name, response_json['name']
    assert_equal inventory.category, response_json['category']
    assert_equal inventory.qty, response_json['qty']
  end

  test 'should import csv successfully' do
    csv_file = fixture_file_upload('test/fixtures/files/inventories.csv', 'text/csv')

    post import_csv_api_v1_inventories_url, params: { file: csv_file }

    assert_response :created
    response_json = JSON.parse(@response.body)

    assert_equal 'Inventories imported successfully', response_json['message']
    assert_equal 2, response_json['inventories'].size
    assert_equal 'Item 1', response_json['inventories'].first['name']
  end
end
