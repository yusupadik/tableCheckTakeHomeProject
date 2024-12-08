class Api::V1::OrdersController < ApplicationController

  def create
    if params[:products].nil?
      render json: { error: 'No Products selected'}, status: :unprocessable_entity
    end

    order_params = params[:products]
    orders = []

    order_params.each do |product|
      inventory = Inventory.find_by(name: product[:name])

      if inventory.nil?
        render json: { error: "Inventory not found for #{product[:name]}" }, status: :not_found and return
      end

      # Check if inventory has enough quantity
      if inventory.qty < product[:qty].to_i
        render json: { error: "Not enough quantity for #{product[:name]}" }, status: :unprocessable_entity and return
      end

      # Decrease the inventory quantity
      inventory.update!(qty: inventory.qty - product[:qty].to_i)

      # Create the order
      order = Order.new(inventory: inventory, price: product[:price], qty: product[:qty])
      if order.save
        orders << order
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity and return
      end
    end

    render json: { message: 'Order created successfully', orders: orders }, status: :created
  rescue => e
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

end
