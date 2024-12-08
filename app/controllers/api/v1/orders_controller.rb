class Api::V1::OrdersController < ApplicationController
  def create
    if params[:products].nil?
      render json: { error: 'No Products selected' }, status: :unprocessable_entity
      return
    end

    order_params = params[:products]
    orders = []
    errors = []

    order_params.each do |product|
      inventory = Inventory.where(name: product[:name]).first

      if inventory.nil?
        errors << "Inventory not found for #{product[:name]}"
      elsif inventory.qty < product[:qty].to_i
        errors << "Not enough quantity for #{product[:name]}"
      end
    end

    if errors.any?
      render json: { error: errors }, status: :unprocessable_entity
      return
    end

    order_params.each do |product|
      inventory = Inventory.find_by(name: product[:name])
      inventory.update!(qty: inventory.qty - product[:qty].to_i)

      order = Order.new(inventory: inventory, price: product[:price], qty: product[:qty])
      if order.save
        orders << order
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end

    render json: { message: 'Order created successfully', orders: orders }, status: :created
  end
end
