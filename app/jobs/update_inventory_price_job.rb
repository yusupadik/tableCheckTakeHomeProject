class UpdateInventoryPriceJob < ApplicationJob
  queue_as :default

  def perform
    competitor_prices = CompetitorPricingService.fetch_prices

    Inventory.all.each do |inventory|
      pricing_service = DynamicPricingService.new(inventory, competitor_prices)
      new_price = pricing_service.calculate_dynamic_price
      if new_price
        inventory.update(price: pricing_service.calculate_dynamic_price)
      end


    end
  end
end
