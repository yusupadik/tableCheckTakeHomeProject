# Table Check, Home Work, E-commerce Platform

## Overview

This is platform provides an API to manage inventory and orders. The application supports dynamic pricing based on inventory quantity and customer demand. The platform allows customers to browse products and place orders.

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
- **Status**: 201 Created
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

### 2. **Inventory List**
- **URL**: `/api/v1/inventories`
- **Method**: `GET`
- **Description**: Retrieve all Inventories on the platform

#### Response:
- **Status**: 200 Ok
```json
[
  {
    "_id": "xxxxxxxxxxxxxxxxxxxx1",
    "category": "Footwear",
    "default_price": 3005.0,
    "name": "Product 1",
    "price": 2704.5,
    "qty": 285
  },
  {
    "_id": "xxxxxxxxxxxxxxxxxxxxxxxx2",
    "category": "Accessories",
    "default_price": 1511.0,
    "name": "Product 2",
    "price": 660.25,
    "qty": 231
  },
  {
    "_id": "xxxxxxxxxxxxxxxxxxxxxxxx3",
    "category": "Clothing",
    "default_price": 1800.0,
    "name": "Product 3",
    "price": 786.6,
    "qty": 4
  }
]
```

### 3. **Inventory Detail**
- **URL**: `/api/v1/inventories/:id`
- **Method**: `GET`
- **Description**: Retrieve a single product by its ID.

#### Response:
- **Status**: 200 Ok
```json
{
    "_id": "xxxxxxxxxxxxxxxxxxxx1",
    "category": "Clothing",
    "created_at": "2024-12-07T04:30:28.467Z",
    "default_price": 1800.0,
    "name": "Product 1",
    "price": 1600.0,
    "qty": 4,
    "updated_at": "2024-12-08T08:05:43.199Z"
}
```

#### Errors:
- **Status**: 404 Not found
```json
{
  "error": [
    "Inventory not found"
  ]
}
```

### 4. **Create an Order**
- **URL**: `/api/v1/orders`
- **Method**: `POST`
- **Description**: Creates a new order for the products selected by the customer.

#### Request:
```json
{
  "products": [
    {
      "name": "Product 1",
      "qty": 2,
      "price": 100
    },
    {
      "name": "Product 2",
      "qty": 1,
      "price": 50
    }
  ]
}
```

#### Response:
- **Status**: 201 Created
```json
{
  "message": "Order created successfully",
  "orders": [
    {
      "_id": "xxxxxxxxxxxxxx1",
      "created_at": "2024-12-08T08:32:46.176Z",
      "inventory_id": "yyyyyyyyyyyyyyyyyproduct1",
      "price": 2205.9,
      "qty": 2,
      "updated_at": "2024-12-08T08:32:46.176Z"
    },
    {
      "_id": "xxxxxxxxxxxxxxxxx2",
      "created_at": "2024-12-08T08:32:46.184Z",
      "inventory_id": "yyyyyyyyyyyyyyyyyyproduct2",
      "price": 5492.7,
      "qty": 3,
      "updated_at": "2024-12-08T08:32:46.184Z"
    }
  ]
}
```

#### Errors:
- **Status**: 422 Unprocessable Content (product params blank)
```json
{
  "error": "No Products selected"
}
```

- **Status**: 422 Unprocessable Content (Inventory not found)
```json
{
  "error": [
    "Inventory not found for xxxx"
  ]
}
```

## Setting Up and Running the Application Locally

To set up and run this application locally, follow these steps:

### Prerequisites:
- Ruby (version 3 or above)
- Rails (version 7 or above)
- Docker ( version 27.3.1 or above)
- Redis (version 6 or above)

### Steps:
1. **Clone the repository:**
```bash
  git clone git@github.com:yusupadik/tableCheckTakeHomeProject.git
  cd tableCheckTakeHomeProject
```

2. **Run Docker Compose:** to create mongodb via docker
```bash
  docker compose up
```

3. **Install Ruby dependencies:**
```bash
  bundle install
```

4. **Setup the .env file**

5. **Set up the database:**
```bash
  rails db:create
```

6. **Start the server:**
```bash
  rails s
```

7. **Run Sidekiq:**
```bash
  bundle exec sidekiq
```

8. **Access the API:** Open your browser or use a tool like Postman to make requests to the API at
`http://localhost:3000/ping`
The result will be:
```json
{
  "message": "pong"
}
```



