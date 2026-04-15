-- Ghana Farm Analytics Pipeline
-- Script 3: Create reporting view for Power BI

USE farm_db;

CREATE OR REPLACE VIEW farm_summary AS
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

-- Revenue by region view
CREATE OR REPLACE VIEW revenue_by_region AS
SELECT
    f.region,
    COUNT(DISTINCT f.farmer_id) AS total_farmers,
    SUM(r.total_produce_kg) AS total_kg,
    ROUND(SUM(r.total_revenue_ghs), 2) AS total_revenue_ghs
FROM farm_records r
JOIN farmers f ON r.farmer_id = f.farmer_id
GROUP BY f.region
ORDER BY total_revenue_ghs DESC;

-- Revenue by produce type view
CREATE OR REPLACE VIEW revenue_by_type AS
SELECT
    p.produce_type,
    COUNT(DISTINCT p.produce_id) AS crop_varieties,
    SUM(r.total_produce_kg) AS total_kg,
    ROUND(SUM(r.total_revenue_ghs), 2) AS total_revenue_ghs,
    ROUND(AVG(r.total_revenue_ghs), 2) AS avg_revenue_ghs
FROM farm_records r
JOIN produce p ON r.produce_id = p.produce_id
GROUP BY p.produce_type
ORDER BY total_revenue_ghs DESC;

-- Yearly trend view
CREATE OR REPLACE VIEW yearly_trend AS
SELECT
    r.year,
    COUNT(r.record_id) AS total_records,
    SUM(r.total_produce_kg) AS total_kg,
    ROUND(SUM(r.total_revenue_ghs), 2) AS total_revenue_ghs
FROM farm_records r
GROUP BY r.year
ORDER BY r.year;
