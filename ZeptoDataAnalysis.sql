/* ============================================================
   PROJECT: Zepto Product Data Analysis (SQL)
   DESCRIPTION: Product, Pricing & Inventory Analysis
   SKILLS USED:
   ✔ Data Cleaning
   ✔ Aggregations
   ✔ CASE Statements
   ✔ Business Insights
   ✔ Revenue Estimation
   ✔ Inventory Analysis
   ============================================================ */


/* ===============================
   1️⃣ CREATE TABLE
   =============================== */

DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
    sku_id SERIAL PRIMARY KEY,                 -- Unique product ID
    category VARCHAR(120),                     -- Product category
    name VARCHAR(150) NOT NULL,                -- Product name
    mrp NUMERIC(8,2),                          -- Maximum Retail Price
    discountPercent NUMERIC(5,2),              -- Discount percentage
    availableQuantity INTEGER,                 -- Available stock
    discountedSellingPrice NUMERIC(8,2),       -- Final selling price
    weightInGms INTEGER,                       -- Weight in grams
    outOfStock BOOLEAN,                        -- Stock status
    quantity INTEGER                           -- Pack quantity
);


/* ===============================
   2️⃣ DATA VALIDATION
   =============================== */

-- Check for NULL values
SELECT *
FROM zepto 
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;


/* ===============================
   3️⃣ DATA EXPLORATION
   =============================== */

-- Different Product Categories
SELECT DISTINCT category 
FROM zepto 
ORDER BY category;


-- Products In Stock vs Out of Stock
SELECT outOfStock,
       COUNT(sku_id) AS total_products
FROM zepto
GROUP BY outOfStock;


-- Duplicate Product Names (Multiple SKUs)
SELECT name,
       COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY number_of_skus DESC;


/* ===============================
   4️⃣ DATA CLEANING
   =============================== */

-- Products with zero price
SELECT *
FROM zepto
WHERE mrp = 0 
   OR discountedSellingPrice = 0;


-- Convert Paise to Rupees (if dataset stored in paise)
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;


/* ===============================
   5️⃣ BUSINESS QUESTIONS
   =============================== */


-- Q1: Top 10 Best-Value Products (Highest Discount %)
SELECT name,
       mrp,
       discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


-- Q2: High MRP Products Currently In Stock
SELECT name,
       mrp,
       outOfStock
FROM zepto
WHERE outOfStock = FALSE
ORDER BY mrp DESC;


-- Q3: Estimated Revenue Per Category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) 
       AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;


-- Q4: Premium Products with Low Discount
SELECT name,
       mrp,
       discountPercent
FROM zepto
WHERE mrp > 500 
  AND discountPercent < 10
ORDER BY mrp DESC;


-- Q5: Top 5 Categories with Highest Average Discount
SELECT category,
       ROUND(AVG(discountPercent),2) AS avg_discount_percent
FROM zepto
GROUP BY category
ORDER BY avg_discount_percent DESC
LIMIT 5;


-- Q6: Price Per Gram (Best Value Products >100g)
SELECT name,
       discountedSellingPrice,
       weightInGms,
       ROUND(discountedSellingPrice / weightInGms, 4) 
       AS price_per_gram
FROM zepto
WHERE weightInGms > 100
ORDER BY price_per_gram ASC;


-- Q7: Weight Segmentation (Low / Medium / Bulk)
SELECT name,
       weightInGms,
       CASE
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms BETWEEN 1000 AND 4999 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;


-- Q8: Total Inventory Weight per Category (in KG)
SELECT category,
       ROUND(SUM(weightInGms * availableQuantity) / 1000.0,2) 
       AS total_weight_kg
FROM zepto
GROUP BY category
ORDER BY total_weight_kg DESC;


/* ============================================================
   END OF PROJECT
   This project demonstrates:
   ✔ Retail Pricing Analysis
   ✔ Inventory Optimization
   ✔ Revenue Estimation
   ✔ Product Segmentation
   ✔ Business-Driven SQL Thinking
   ============================================================ */