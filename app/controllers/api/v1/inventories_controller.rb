class Api::V1::InventoriesController < ApplicationController
  require 'csv'
  before_action :set_inventory, only: [:show]

  def index
    inventories = Inventory.all
    render json: inventories.as_json(only: [:_id, :name, :category, :default_price, :price, :qty])
  end

  def show
    render json: @inventory
  end

  def import_csv
    if params[:file].nil?
      render json: { error: 'No file uploaded' }, status: :unprocessable_entity
      return
    end

    begin
      csv_file = params[:file].path
      inventories = []
      inventories_failed = []

      CSV.foreach(csv_file, headers: true) do |row|

        inventory = Inventory.find_or_initialize_by(name: row['NAME'])

        inventory.assign_attributes(
          name: row['NAME'],
          category: row['CATEGORY'],
          default_price: row['DEFAULT_PRICE'],
          price: row['DEFAULT_PRICE'],
          qty: row['QTY']
        )

        if inventory.valid?
          inventory.save
          inventories << inventory
        else
          inventories_failed << "inventory #{row['NAME']} failed to save: #{inventory.errors.full_messages}"
        end
      end
      if inventories.count > 0
        render json: { message: 'Inventories imported successfully', inventories: inventories, inventories_failed: inventories_failed }, status: :created
      else
        render json: { error: 'No inventory can be saved', inventories_failed: inventories_failed }, status: :unprocessable_entity
      end

    rescue => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def set_inventory
    @inventory = Inventory.where(id: params[:id]).first

    render json: { error: 'Inventory not found' }, status: :not_found unless @inventory
  end
end
