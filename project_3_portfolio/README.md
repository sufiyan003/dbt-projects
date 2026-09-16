# Project 3 — API-Driven Analytics Pipeline (Python + dbt + Snowflake)

A production-style analytics engineering project combining Python-based data ingestion from a live REST API with a full dbt transformation layer on Snowflake. Built as the capstone portfolio project after completing beginner and intermediate dbt projects.

## Overview

This project extracts real e-commerce data (products, users, shopping carts) from the public FakeStore API, loads it into Snowflake using Python, then transforms it into a tested, documented star schema using dbt.

## Architecture

```
FakeStore API (https://fakestoreapi.com)
   /products   /users   /carts
        │
        ▼
   Python (requests + pandas)
   fetch_products.py — extracts, flattens nested JSON,
   explodes cart items, loads via write_pandas
        │
        ▼
   Snowflake — raw layer
   raw_products, raw_users, raw_cart_items
        │
        ▼
   dbt — staging layer
   stg_products, stg_users, stg_cart_items (views)
        │
        ▼
   dbt — marts layer (star schema)
   dim_products (with price tier logic)
   dim_users
   fct_cart_items (joined, calculated line_total)
        │
        ▼
   Tested + Documented
```

## Project Structure

```
project_3_portfolio/
├── python_ingestion/
│   └── fetch_products.py       # API extraction + Snowflake load
├── dbt_transform/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_products.sql
│   │   │   ├── stg_users.sql
│   │   │   ├── stg_cart_items.sql
│   │   │   └── sources.yml
│   │   └── marts/
│   │       ├── dim_products.sql
│   │       ├── dim_users.sql
│   │       ├── fct_cart_items.sql
│   │       └── schema.yml
│   └── dbt_project.yml
└── .env                         # Snowflake credentials (gitignored)
```

## Key Features

- **Real API ingestion**: Live data pulled from FakeStore API using `requests`, not static or pre-downloaded files
- **JSON flattening**: Nested user name objects and multi-product carts parsed and normalized into clean tabular rows before loading
- **Secure credentials**: Snowflake password loaded via `python-dotenv` from a `.env` file, never hardcoded or committed to version control
- **Star schema**: `dim_products`, `dim_users`, and `fct_cart_items` form a standard dimensional model
- **Business logic in SQL**: `dim_products` classifies items into Budget / Mid-range / Premium price tiers using `CASE WHEN`
- **Full test coverage**: `unique`, `not_null`, `accepted_values`, and `relationships` tests across all marts
- **Auto-generated documentation**: `dbt docs generate` produces full lineage and column-level documentation

## Tech Stack

- **Python** — `requests`, `pandas`, `python-dotenv`, `snowflake-connector-python[pandas]`
- **dbt-core** with **dbt-snowflake** adapter
- **Snowflake** (cloud data warehouse)

## How to Run

```bash
# 1. Extract from API and load into Snowflake
python python_ingestion/fetch_products.py

# 2. Build the dbt models
cd dbt_transform
dbt run

# 3. Run data quality tests
dbt test

# 4. Generate documentation
dbt docs generate
dbt docs serve
```

## Data Model

| Model | Type | Description |
|---|---|---|
| `stg_products` / `stg_users` / `stg_cart_items` | view | Cleaned records from raw API data |
| `dim_products` | table | Product dimension with price tier classification |
| `dim_users` | table | User dimension with combined full name |
| `fct_cart_items` | table | Cart line items joined with product pricing, with calculated `line_total` |

## Author

Muhammad Sufiyan Siddiqui