# Table Check, Home Work, E-commerce Platform

## Overview

This E-commerce platform provides an API to manage products, inventory, and orders. The application supports dynamic pricing based on inventory quantity and customer demand. The platform allows customers to browse products and place orders.

### Key Features:
- **Inventory Management**: Import inventories from CSV file.
- **Order Management**: Place orders, check order status, and manage order history.
- **Dynamic Pricing**: Prices may fluctuate based on available inventory and other business rules.

## Dynamic Pricing

Dynamic pricing is a key feature of this platform, which adjusts the price of products based on Demand, stock levels, and competitor prices. The idea is to offer more attractive prices when inventory levels are high and increase prices when stock runs low, and make sure that the price will always below the competitors.

### Dynamic Pricing Logic:
- **High Inventory**: When the stock quantity is greater than a threshold, the price remains at the default price.
- **Low Inventory**: As stock decreases, the price increases proportionally to encourage sales or balance demand.
- **High Demand**: When the deman high, the price will increases based on the high demand percentage variable.
- **Competitor Prices**:  Adjust prices based on competitor prices. We pull the competitor prices from service API, then give undercut if the current price is higher than the competitor

### Dynamic Pricing Variable:
All the Variable on how many additional, discount percentage, or the demand threshold can change from the `.env` file, see the `env.example`

## API Endpoints

### 1. **Import CSV**
- **URL**: `/api/v1/inventories/import_csv`
- **Method**: `POST`
- **Description**: Import inventory products from a CSV file..

#### Request:
- **file**: A CSV file containing product data. The file should have the following columns: NAME, CATEGORY, DEFAULT_PRICE, QTY.

#### Response:

```json
{
  "message": "Inventories imported successfully",
  "inventories": [
    {
      "_id": "6753cf64fb1e85b65d2e9524",
      "category": "Footwear",
      "created_at": "2024-12-07T04:30:28.457Z",
      "default_price": 3005.0,
      "name": "MC Hammer Pants",
      "price": 3005.0,
      "qty": 285,
      "updated_at": "2024-12-07T07:18:25.067Z"
  },
  {
      "_id": "6753cf64fb1e85b65d2e9525",
      "category": "Accessories",
      "created_at": "2024-12-07T04:30:28.462Z",
      "default_price": 1511.0,
      "name": "Thriller Jacket",
      "price": 1511.0,
      "qty": 241,
      "updated_at": "2024-12-07T07:18:25.074Z"
    },
  ]
}
```

#### Errors:
- **Status**: 422 Unprocessable Content

```json
  {
    "error": "No file uploaded"
  }
```

