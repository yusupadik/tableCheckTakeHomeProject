# test/services/dynamic_pricing_service_test.rb
require 'test_helper'

class DynamicPricingServiceTest < ActiveSupport::TestCase
  def setup
    @inventory = Object.new
    @inventory.define_singleton_method(:default_price) { 100.0 }
    @inventory.define_singleton_method(:name) { 'item1' }
    @inventory.define_singleton_method(:qty) { 50 }

    order1 = Object.new
    order1.define_singleton_method(:qty) { 10 }

    order2 = Object.new
    order2.define_singleton_method(:qty) { 15 }

    @inventory.define_singleton_method(:orders) { [order1, order2] }

    @competitor_prices = [
      { "name" => "item1", "price" => 90.0 }
    ]
  end

  test "calculate_dynamic_price applies demand, inventory, and competitor factors correctly" do
    ENV["DEMAND_QTY_TRIGGER"] = "20"
    ENV["PERCENTAGE_DEMAND_ADDITION_PRICE"] = "5"
    ENV["HIGH_QTY_TRIGGER"] = "500"
    ENV["LOW_QTY_TRIGGER"] = "20"
    ENV["PERCENTAGE_HIGH_LEVEL_DISCOUNT_PRICE"] = "10"
    ENV["PERCENTAGE_LOW_LEVEL_ADDITIONAL_PRICE"] = "10"
    ENV["PERCENTAGE_UNDERCUT_COMPETITOR_PRICE"] = "5"

    dynamic_pricing_service = DynamicPricingService.new(@inventory, @competitor_prices)

    dynamic_price = dynamic_pricing_service.calculate_dynamic_price

    expected_price = 85.5
    assert_equal expected_price, dynamic_price
  end

  test "calculate_dynamic_price returns nil if no base price is set" do
    @inventory.define_singleton_method(:default_price) { nil }

    dynamic_pricing_service = DynamicPricingService.new(@inventory, @competitor_prices)
    dynamic_price = dynamic_pricing_service.calculate_dynamic_price

    assert_nil dynamic_price
  end

  test "calculate_dynamic_price applies competitor price undercut" do
    @inventory.define_singleton_method(:default_price) { 120.0 }
    @competitor_prices = [
      { "name" => "item1", "price" => 80.0 }
    ]

    dynamic_pricing_service = DynamicPricingService.new(@inventory, @competitor_prices)
    dynamic_price = dynamic_pricing_service.calculate_dynamic_price

    assert_equal 76.0, dynamic_price
  end
end
