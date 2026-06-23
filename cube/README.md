# Cube Semantic Layer Setup

This folder contains the Cube data model for the Northwind Modern Data Stack project.
The model connects to Databricks Unity Catalog and defines all CFO, COO, and HR metrics
as reusable Cube measures consumed by both Tableau and Power BI.

## Model Overview

| File | Cubes Defined | Purpose |
|------|--------------|---------|
| `model/orders.yml` | orders, customers, products, employees, order_date | Revenue, fulfillment, and workforce metrics from fact_order_lines |
| `model/inventory.yml` | inventory, inventory_products | Inventory health metrics from fact_inventory_snapshot |

## Step 1: Create a Cube Cloud Account

1. Go to [app.cube.dev](https://app.cube.dev) and sign up for free (no credit card required).
2. Click **Create Deployment** and choose **Cube Cloud**.
3. Name it `northwind-demo`.

## Step 2: Connect to Databricks

When prompted for a data source, choose **Databricks** and enter:

| Field | Value |
|-------|-------|
| Host | Your Databricks workspace URL (e.g., `adb-1234567890.1.azuredatabricks.net`) |
| HTTP Path | Your SQL Warehouse HTTP path (e.g., `/sql/1.0/warehouses/abc123`) |
| Token | Your Databricks personal access token |
| Catalog | `northwind` |
| Schema | `marts` |

Click **Test Connection** to confirm, then **Next**.

## Step 3: Upload the Data Model

Cube Cloud offers two options:

**Option A — Git Sync (recommended for portfolio):**
1. In Cube Cloud, go to **Settings > Git Integration**.
2. Connect your GitHub account and select the `DirectionalData Northwind Demo Project` repo.
3. Set the **Model path** to `cube/model`.
4. Cube Cloud will pull the YAML files automatically and sync on every push.

**Option B — Manual upload:**
1. In Cube Cloud, open the **Data Model** editor.
2. Create two new files: `orders.yml` and `inventory.yml`.
3. Paste the contents of each file from this repo's `cube/model/` folder.

## Step 4: Validate the Model in Playground

1. Go to **Playground** in the Cube Cloud sidebar.
2. Select the `orders` cube.
3. Add the `net_revenue` measure and `order_date` time dimension. Run the query.
4. Expected: revenue aggregated by month, totaling approximately $1.35 million across 1996-1998.

Run a second query: `inventory` cube, `out_of_stock_count` and `below_reorder_count` measures.
Expected: 2 out-of-stock active products, several below reorder level.

## Step 5: Configure BI Tool Connections

### Tableau
1. In Cube Cloud, go to **Integrations > BI Integrations**.
2. Copy the **Cube SQL API** connection string (host, port, username, password).
3. In Tableau Desktop, connect via **Other Databases (JDBC)** or use the **Cube Tableau connector**.
4. Connect using the SQL API credentials.

### Power BI
1. In Power BI Desktop, go to **Get Data > Other > ODBC**.
2. Use the Cube ODBC connection string from **Integrations > BI Integrations**.
3. Alternatively, use **Get Data > Web** with the Cube REST API endpoint.

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
| Employee Count | `employees.employee_count` |
| Net Revenue by Rep | `orders.net_revenue` grouped by `orders.employee_full_name` |
| Orders by Rep | `orders.order_count` grouped by `orders.employee_full_name` |
| Revenue per Employee | `orders.revenue_per_employee` |
| Territory Count by Rep | `employees.territory_count` |
