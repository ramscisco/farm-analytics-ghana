-- Ghana Farm Analytics Pipeline
-- Script 2: Create tables with constraints

USE farm_db;

CREATE TABLE IF NOT EXISTS farmers (
    farmer_id INT PRIMARY KEY,
    farmer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    farm_size_acres INT,
    contact VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS produce (
    produce_id INT PRIMARY KEY,
    produce_name VARCHAR(100) NOT NULL,
    produce_type VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS farm_records (
    record_id INT PRIMARY KEY,
    farmer_id INT NOT NULL,
    produce_id INT NOT NULL,
    year INT NOT NULL,
    total_produce_kg INT,
    total_revenue_ghs DECIMAL(10,2),
    FOREIGN KEY (farmer_id) REFERENCES farmers(farmer_id),
    FOREIGN KEY (produce_id) REFERENCES produce(produce_id)
);
