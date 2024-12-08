class DynamicPricingService
  def initialize(inventory, competitor_prices)
    @inventory = inventory
    @competitor_prices = competitor_prices
  end

  # Main function to calculate the dynamic price based on demand and inventory level
  def calculate_dynamic_price
    base_price = @inventory.default_price

    if base_price
      demand_factor = calculate_demand_factor
      price_after_demand = base_price * demand_factor

      # Factor in inventory levels: Adjust price based on quantity
      inventory_factor = calculate_inventory_factor
      price_after_inventory = price_after_demand * inventory_factor

      # Apply competitor price undercutting strategy
      final_price = apply_competitor_undercut(price_after_inventory)

      return final_price.round(2)
    else
      return nil
    end
  end

  private

  # Calculate the demand factor based on how often the product has been ordered
  def calculate_demand_factor
    demand_qty = ENV["DEMAND_QTY_TRIGGER"] || 20
    percentage_demand_qty_additional_price = ENV["PERCENTAGE_DEMAND_ADDITION_PRICE"] || 5

    total_ordered_qty = @inventory.orders.sum(:qty)
    if total_ordered_qty > demand_qty.to_i
      1 + (percentage_demand_qty_additional_price.to_f/100)
    else
      1.00  # No change
    end
  end

  # Calculate the inventory level factor (adjust the price based on quantity)
  def calculate_inventory_factor
    high_qty = ENV["HIGH_QTY_TRIGGER"] || 500
    low_qty = ENV["LOW_QTY_TRIGGER"] || 20
    high_lvl_discount = ENV["PERCENTAGE_HIGH_LEVEL_DISCOUNT_PRICE"] || 10
    low_lvl_additional =  ENV["PERCENTAGE_LOW_LEVEL_ADDITIONAL_PRICE"] || 10

    if @inventory.qty < low_qty.to_i
      1 + (low_lvl_additional.to_f / 100)
    elsif @inventory.qty > high_qty.to_i
      1 - (high_lvl_discount.to_f / 100)
    else
      1.00  # No change for normal stock
    end
  end

  # Apply undercut strategy based on competitor prices
  def apply_competitor_undercut(price_after_inventory)
    competitor_price = find_competitor_price
    undercut_compeitor_price = ENV["PERCENTAGE_UNDERCUT_COMPETITOR_PRICE" || 5]
    price_after_undercut = price_after_inventory

    if competitor_price && competitor_price < price_after_inventory
      price_after_undercut = competitor_price * (1 - (undercut_compeitor_price.to_f/100))
    end

    price_after_undercut
  end

  # Find the competitor price for the current inventory
  def find_competitor_price
    competitor_data = @competitor_prices.find { |item| item["name"] == @inventory.name }
    competitor_data ? competitor_data["price"].to_f : nil
  end
end