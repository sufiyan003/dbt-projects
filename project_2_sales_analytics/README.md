# Project 2 — Sales Analytics Data Warehouse

An intermediate dbt project building a full sales analytics data warehouse on Snowflake, covering multi-source star schema modeling, incremental merge strategies, slowly changing dimensions, and BI integration with Power BI.

## Overview

This project transforms raw customer, product, and order data into a business-ready star schema, with correct handling of both new records and updates, plus full historical tracking of customer changes over time.

## Architecture

```
Raw Sources (Snowflake)
   raw_customers, raw_products, raw_orders
        │
        ▼
   Staging Layer
   stg_customers, stg_products, stg_orders (views)
        │
        ▼
   Marts Layer (Star Schema)
   dim_customers, dim_products (tables)
   fct_orders (incremental, merge strategy)
        │
        ▼
   Power BI Dashboard

   Snapshots (parallel, from raw_customers)
   snap_customers → full SCD Type 2 history of customer changes
```

## Project Structure

```
models/
├── staging/
│   ├── stg_customers.sql
│   ├── stg_products.sql
│   ├── stg_orders.sql
│   └── sources.yml
└── marts/
    ├── dim_customers.sql
    ├── dim_products.sql
    └── fct_orders.sql          # incremental, merge strategy

snapshots/
└── snap_customers.sql          # SCD Type 2 history tracking
```

## Key Features

- **Multi-source star schema**: customers, products, and orders combined into a clean dimensional model
- **Incremental loading with `merge` strategy**: `fct_orders` correctly handles both new orders and updates to existing orders, using an `updated_at` timestamp rather than `order_date` (which only catches new rows)
- **Snapshots (SCD Type 2)**: `snap_customers` preserves full history of customer attribute changes (e.g. country changes) with `dbt_valid_from` / `dbt_valid_to` tracking
- **Calculated business metrics**: `total_amount` computed in `fct_orders` by joining order quantity with product price
- **Power BI integration**: connected directly to Snowflake, with dimension and fact tables automatically forming a correct star schema relationship model

## Tech Stack

- **dbt-core** 1.12.3 with **dbt-snowflake** adapter
- **Snowflake** (cloud data warehouse)
- **Power BI Desktop** (Import mode connection)

## How to Run

```bash
# Build all models
dbt run

# Full rebuild (needed after schema changes to incremental models)
dbt run --full-refresh

# Capture a snapshot of current source state
dbt snapshot

# Run data quality tests
dbt test
```

## Data Model

| Model | Type | Description |
|---|---|---|
| `stg_customers` | view | Cleaned customer records |
| `stg_products` | view | Cleaned product records |
| `stg_orders` | view | Cleaned order records |
| `dim_customers` | table | Customer dimension |
| `dim_products` | table | Product dimension |
| `fct_orders` | incremental (merge) | Order fact table with calculated total_amount |
| `snap_customers` | snapshot | Full history of customer changes (SCD Type 2) |

## Key Learning: Incremental Filter Design

An early version of `fct_orders` filtered incrementally on `order_date`, which meant updates to existing orders (same date, changed quantity) were silently missed by the `merge` strategy since the row never entered the incremental `SELECT`. Switching the filter to an `updated_at` timestamp column, refreshed on every change, fixed this and was verified by updating an existing order and confirming the change propagated without a full refresh.

## Author

Muhammad Sufiyan Siddiqui