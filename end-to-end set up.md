# Ghana Farm Analytics Pipeline

> An end-to-end data engineering and analytics project — from structured data entry in Microsoft Access, through MySQL storage via ODBC, to interactive Power BI dashboards.

---

## Project Overview

This project builds a complete farm data pipeline for tracking agricultural production and revenue across Ghana's 16 regions. It models real-world data flows used by agribusinesses, NGOs, and government agriculture departments.

**Pipeline:** `Microsoft Access → MySQL (ODBC) → Power BI`

---

## Dataset

| Table | Rows | Description |
|---|---|---|
| `farmers` | 200 | Farmer profiles across 16 regions |
| `produce` | 200 | Crop catalogue with 6 produce types |
| `farm_records` | 200 | Yield and revenue records (2022–2025) |

### Farmers
Covers 16 Ghanaian regions: Ashanti, Eastern, Northern, Volta, Central, Western, Upper East, Upper West, Brong-Ahafo, Greater Accra, Savannah, Bono East, Ahafo, North East, Oti, and Western North.

Fields: `farmer_id`, `farmer_name`, `region`, `farm_size_acres`, `contact`, `email`

### Produce
200 crop entries spanning 6 types:
- **Grain** — Maize, Rice, Sorghum, Millet, Wheat + varieties
- **Vegetable** — Tomato, Pepper, Onion, Okra, Garden Egg + varieties
- **Legume** — Soybean, Groundnut, Cowpea, Bambara Bean + varieties
- **Root Crop** — Cassava, Yam, Cocoyam, Sweet Potato + varieties
- **Cash Crop** — Cocoa, Coffee, Cotton, Shea, Palm Oil + varieties
- **Fruit** — Plantain, Banana, Mango, Pineapple, Pawpaw + varieties

Fields: `produce_id`, `produce_name`, `produce_type`

### Farm Records
Unique farmer/produce/year combinations. Revenue is calculated using realistic GHS/kg rates per produce type:

| Produce Type | Rate Range (GHS/kg) |
|---|---|
| Cash Crop | 20.00 – 55.00 |
| Vegetable | 3.00 – 8.00 |
| Legume | 3.50 – 6.00 |
| Fruit | 2.50 – 7.00 |
| Grain | 2.00 – 4.50 |
| Root Crop | 1.50 – 3.50 |

Fields: `record_id`, `farmer_id`, `produce_id`, `year`, `total_produce_kg`, `total_revenue_ghs`

---

## Project Structure

```
farm-analytics-ghana/
├── README.md
├── data/
│   ├── farmers.csv
│   ├── produce.csv
│   └── farm_records.csv
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_create_views.sql
└── docs/
    └── pipeline_overview.md
```

---

## Pipeline Setup

### Step 1 — Microsoft Access (Data Entry Layer)

1. Open Microsoft Access and create a new blank database.
2. Create 3 tables using the schema below:

**farmers table**
```
farmer_id   AutoNumber (PK)
farmer_name Short Text
region      Short Text
farm_size_acres Number
contact     Short Text
email       Short Text
```

**produce table**
```
produce_id   AutoNumber (PK)
produce_name Short Text
produce_type Short Text
```

**farm_records table**
```
record_id        AutoNumber (PK)
farmer_id        Number (FK → farmers)
produce_id       Number (FK → produce)
year             Number
total_produce_kg Number
total_revenue_ghs Currency
```

3. Go to **Database Tools → Relationships** and link:
   - `farmers.farmer_id` → `farm_records.farmer_id`
   - `produce.produce_id` → `farm_records.produce_id`

4. Import the CSV files from the `/data` folder using **External Data → Text File**.

---

### Step 2 — MySQL Setup

Run the scripts in the `/sql` folder in order:

```bash
mysql -u root -p < sql/01_create_database.sql
mysql -u root -p farm_db < sql/02_create_tables.sql
mysql -u root -p farm_db < sql/03_create_views.sql
```

---

### Step 3 — Connect Access → MySQL via ODBC

1. Download and install [MySQL Connector/ODBC](https://dev.mysql.com/downloads/connector/odbc/)
2. Open **ODBC Data Sources (64-bit)** on Windows
3. Add a new **System DSN**:
   - Driver: MySQL ODBC 8.x Driver
   - Server: `localhost`
   - Database: `farm_db`
   - Username / Password: your MySQL credentials
4. In Access: **External Data → ODBC Database → Export**
5. Select each table (`farmers`, `produce`, `farm_records`) and export to the DSN

---

### Step 4 — Connect MySQL → Power BI

1. Open **Power BI Desktop**
2. Click **Get Data → MySQL Database**
3. Enter:
   - Server: `localhost`
   - Database: `farm_db`
4. Select tables: `farmers`, `produce`, `farm_records`, `farm_summary`
5. Click **Load**
6. Confirm relationships in the **Model view**

---

## Power BI Dashboard

Recommended visuals:

| Visual | Type | Fields |
|---|---|---|
| Revenue by Region | Bar Chart | Region vs SUM(total_revenue_ghs) |
| Produce by Crop Type | Pie Chart | produce_type vs total_produce_kg |
| Farm Size vs Revenue | Scatter Plot | farm_size_acres vs total_revenue_ghs |
| Yearly Revenue Trend | Line Chart | year vs SUM(total_revenue_ghs) |
| Top 10 Farmers by Revenue | Table | farmer_name, region, revenue |
| Revenue by Produce Type | Clustered Bar | produce_type vs revenue by year |

---

## SQL Reference

### Create Database
```sql
CREATE DATABASE farm_db;
USE farm_db;
```

### Create Tables
```sql
CREATE TABLE farmers (
    farmer_id INT PRIMARY KEY,
    farmer_name VARCHAR(100),
    region VARCHAR(50),
    farm_size_acres INT,
    contact VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE produce (
    produce_id INT PRIMARY KEY,
    produce_name VARCHAR(100),
    produce_type VARCHAR(50)
);

CREATE TABLE farm_records (
    record_id INT PRIMARY KEY,
    farmer_id INT,
    produce_id INT,
    year INT,
    total_produce_kg INT,
    total_revenue_ghs DECIMAL(10,2),
    FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id),
    FOREIGN KEY (produce_id) REFERENCES produce(produce_id)
);
```

### Summary View (for Power BI)
```sql
CREATE VIEW farm_summary AS
SELECT
    f.farmer_name,
    f.region,
    f.farm_size_acres,
    p.produce_name,
    p.produce_type,
    r.year,
    r.total_produce_kg,
    r.total_revenue_ghs
FROM farm_records r
JOIN farmers f ON r.farmer_id = f.farmer_id
JOIN produce p ON r.produce_id = p.produce_id;
```

---

## Skills Demonstrated

- Relational database design and normalization
- Data migration via ODBC (Access → MySQL)
- SQL: CREATE, JOIN, VIEW, foreign key constraints
- Power BI: data modelling, relationships, DAX measures
- ETL pipeline design
- Synthetic dataset generation (Python)
- Agricultural data context for Ghana

---

## Tools & Technologies

| Tool | Role |
|---|---|
| Microsoft Access | Data entry and front-end form layer |
| MySQL 8.x | Relational database storage |
| MySQL ODBC Connector | Bridge between Access and MySQL |
| Power BI Desktop | Visualization and dashboard |
| Python 3 | Synthetic data generation |

---

## Author

Built as a portfolio data engineering project focused on Ghana's agricultural sector.

---

## License

MIT License — free to use, adapt, and build upon.
