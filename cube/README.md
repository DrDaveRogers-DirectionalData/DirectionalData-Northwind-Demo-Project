# Cube Semantic Layer Setup

This folder contains the Cube data model for the Northwind Modern Data Stack project.
The model connects to Databricks Unity Catalog and defines all CFO, COO, and HR metrics
as reusable Cube measures consumed by both Tableau and Power BI.

## Model Overview

Both cubes are flat — all dimensional attributes are already denormalized into the
fact tables, so no joins are needed between Cube cubes.

| File | Cube | Source Table | Purpose |
|------|------|-------------|---------|
| `model/orders.yml` | `orders` | `northwind.marts.fact_order_lines` | Revenue, discount, and fulfillment metrics for CFO and COO dashboards |
| `model/inventory.yml` | `inventory` | `northwind.marts.fact_inventory_snapshot` | Inventory health metrics for COO dashboard |

## Step 1: Create a Cube Cloud Account

1. Go to [cubecloud.dev](https://cubecloud.dev/auth/signup) and sign up for free (no credit card required).
2. Click **Create Deployment**, name it `northwind-demo`.
3. Select cloud platform **AWS** and region **US East (Ohio)** to match the Databricks Free Edition workspace region (us-east-2).

## Step 2: Set Up the Cube Project

On the **Set Up Cube Project** screen, choose **Import from a GitHub repository**.

1. Authorize Cube Cloud to access your GitHub account when prompted.
2. Select the `DirectionalData Northwind Demo Project` repository.
3. Under **Project Directory (for monorepos)**, enter `cube`. Do not enter `cube/model` — Cube looks for a `model/` subfolder inside the project directory automatically. Entering `cube/model` returns "Data Model folder not found."
4. Click **Next**. Cube Cloud pulls `orders.yml` and `inventory.yml` and syncs on every future push.

## Step 3: Connect to Databricks

Cube Cloud's Databricks setup form has three fields: **Access Token**, **Databricks JDBC URL**, and **Databricks Catalog**. It does not have separate host and HTTP path fields — those go into the JDBC URL.

| Field | Value |
|-------|-------|
| Access Token | Your Databricks personal access token |
| Databricks JDBC URL | See format below |
| Databricks Catalog | `northwind` |

**JDBC URL format:**
```
jdbc:databricks://<host>:443/default;transportMode=http;ssl=1;httpPath=<http_path>
```

Example:
```
jdbc:databricks://dbc-fac570af-863f.cloud.databricks.com:443/default;transportMode=http;ssl=1;httpPath=/sql/1.0/warehouses/8d7183780783c50d
```

Your host and HTTP path are in `~/.dbt/profiles.yml`. To view: open PowerShell and run `type C:\Users\<username>\.dbt\profiles.yml`.

Click **Test Connection** to confirm, then **Next**.

## Step 4: Validate the Model in Playground

1. Go to **Playground** in the Cube Cloud sidebar.
2. Select the `orders` cube.
3. Add the `net_revenue` measure and `order_date` time dimension. Set granularity to **Month** and run.
4. Expected: $1,265,793.29 total net revenue across 1996-1998. Gross revenue before discounts is approximately $1.35M; the ~$85K difference is total discount amount — a useful built-in sanity check.

Run a second query: `inventory` cube, `out_of_stock_count` and `below_reorder_count` measures.
Expected: 1 out-of-stock active product, 22 products at or below reorder level.

## Step 5: Configure BI Tool Connections

### Tableau
1. In Cube Cloud, go to **Integrations > BI Integrations**.
2. Copy the **Cube SQL API** connection string (host, port, username, password).
3. In Tableau Desktop, connect via **Other Databases (JDBC)** or use the Cube Tableau connector.
4. Connect using the SQL API credentials.

### Power BI
1. In Power BI Desktop, go to **Get Data > Other > ODBC**.
2. Use the Cube ODBC connection string from **Integrations > BI Integrations**.
3. Alternatively, use **Get Data > Web** with the Cube REST API endpoint.

## Troubleshooting

**"Data Model folder not found at this location"**
The Project Directory field expects the parent of the `model/` folder, not the model folder itself.
Set it to `cube`, not `cube/model`.

**"primary key for 'orders' is required when join is defined"**
Cube requires a `primary_key: true` dimension on any cube that defines joins. The orders cube
uses a composite natural key (order_id + product_id), so the primary key is defined as a
concatenated surrogate: `CONCAT(CAST(order_id AS STRING), '-', CAST(product_id AS STRING))`.

**Naming conflict between a join and a dimension**
If a join and a dimension share the same name (e.g., both named `order_date`), Cube throws
compile errors. The solution used here: remove all joins from the orders cube entirely.
`fact_order_lines` already has all dimensional attributes denormalized, so joins to separate
dimension cubes are unnecessary.

**"[TABLE_OR_VIEW_NOT_FOUND] northwind.marts.fact_order_lines"**
dbt's default `generate_schema_name` macro prefixes the custom schema with the target schema
from `profiles.yml`. With target schema `staging` and custom schema `marts`, dbt builds tables
into `northwind.staging_marts`, not `northwind.marts`. Fix: add the macro override at
`northwind_dbt/macros/generate_schema_name.sql` (already committed) and rerun `dbt run`.
This makes dbt use the custom schema name directly regardless of target.

## Metrics Reference

### CFO Dashboard (Tableau)
| Metric | Cube Measure |
|--------|-------------|
| Net Revenue | `orders.net_revenue` |
| Gross Revenue | `orders.gross_revenue` |
| Discount Amount | `orders.discount_amount` |
| Order Count | `orders.order_count` |
| Avg Order Value | `orders.avg_order_value` |
| Discount Rate % | `orders.discount_rate_pct` |
| Freight as % of Revenue | `orders.freight_as_pct_of_revenue` |

### COO Dashboard (Power BI)
| Metric | Cube Measure |
|--------|-------------|
| On-Time Delivery Rate | `orders.on_time_delivery_rate` |
| Avg Days to Ship | `orders.avg_days_to_ship` |
| Avg Days Late | `orders.avg_days_late` |
| Late Order Count | `orders.late_order_count` |
| Out-of-Stock Products | `inventory.out_of_stock_count` |
| Below Reorder Level | `inventory.below_reorder_count` |
| Total Inventory Value | `inventory.total_inventory_value` |
| Out-of-Stock Rate | `inventory.out_of_stock_rate` |

### HR Dashboard (Tableau or Power BI)
| Metric | Cube Measure / Dimension |
|--------|--------------------------|
| Employee Count | `orders.employee_count` |
| Net Revenue by Rep | `orders.net_revenue` grouped by `orders.employee_full_name` |
| Orders by Rep | `orders.order_count` grouped by `orders.employee_full_name` |
| Avg Revenue per Rep | `orders.net_revenue` / `orders.employee_count` |
