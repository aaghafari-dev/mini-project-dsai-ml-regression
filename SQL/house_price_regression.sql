-- =====================================================
-- Mini-Project week 28 & 28
--House Price Regression – SQL Analysis
-- Database: house_price_regression
-- dataset: regression_data
-- =====================================================

-- 1. Create database and table (run once)
CREATE DATABASE IF NOT EXISTS house_price_regression;
USE house_price_regression;

CREATE TABLE house_price_data (
    id INT PRIMARY KEY,
    date DATE,
    bedrooms INT,
    bathrooms DECIMAL(3,1),
    sqft_living INT,
    sqft_lot INT,
    floors DECIMAL(2,1),
    waterfront INT,
    view INT,
    `condition` INT,
    grade INT,
    sqft_above INT,
    sqft_basement INT,
    yr_built INT,
    yr_renovated INT,
    zipcode INT,
    lat DECIMAL(10,6),
    `long` DECIMAL(10,6),
    sqft_living15 INT,
    sqft_lot15 INT,
    price DECIMAL(10,2)
);

-- 2. Enable local infile and load data
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'path/to/regression_data.csv'
INTO TABLE house_price_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3. Verify data
SELECT * FROM house_price_data LIMIT 10;
SELECT COUNT(*) FROM house_price_data;

-- 4. Drop date column (not used in SQL analysis)
ALTER TABLE house_price_data DROP COLUMN date;

-- 5. Unique values in categorical columns
SELECT DISTINCT bedrooms FROM house_price_data ORDER BY bedrooms;
SELECT DISTINCT bathrooms FROM house_price_data ORDER BY bathrooms;
SELECT DISTINCT floors FROM house_price_data ORDER BY floors;
SELECT DISTINCT `condition` FROM house_price_data ORDER BY `condition`;
SELECT DISTINCT grade FROM house_price_data ORDER BY grade;

-- 6. Top 10 most expensive houses (IDs)
SELECT id FROM house_price_data ORDER BY price DESC LIMIT 10;

-- 7. Average price of all properties
SELECT AVG(price) FROM house_price_data;

-- 8. Group by bedrooms – average price and sqft_living
SELECT bedrooms, AVG(price) AS avg_price FROM house_price_data GROUP BY bedrooms ORDER BY bedrooms;
SELECT bedrooms, AVG(sqft_living) AS avg_sqft_living FROM house_price_data GROUP BY bedrooms ORDER BY bedrooms;

-- 9. Waterfront impact
SELECT waterfront, AVG(price) AS avg_price FROM house_price_data GROUP BY waterfront;

-- 10. Correlation between condition and grade
SELECT `condition`, AVG(grade) AS avg_grade FROM house_price_data GROUP BY `condition` ORDER BY `condition`;

-- 11. Customer filter (3-4 bedrooms, >3 baths, 1 floor, no waterfront, condition>=3, grade>=5, price<300k)
SELECT * FROM house_price_data
WHERE bedrooms IN (3,4)
  AND bathrooms > 3
  AND floors = 1
  AND waterfront = 0
  AND `condition` >= 3
  AND grade >= 5
  AND price < 300000;

-- 12. Properties with price > 2× average (subquery)
SELECT * FROM house_price_data
WHERE price > 2 * (SELECT AVG(price) FROM house_price_data);

-- 13. Create view for high‑value properties
CREATE VIEW high_value_properties AS
SELECT * FROM house_price_data
WHERE price > 2 * (SELECT AVG(price) FROM house_price_data);

-- 14. Difference in average price between 3‑bedroom and 4‑bedroom
SELECT 
    AVG(CASE WHEN bedrooms = 3 THEN price END) AS avg_price_3,
    AVG(CASE WHEN bedrooms = 4 THEN price END) AS avg_price_4,
    AVG(CASE WHEN bedrooms = 4 THEN price END) - AVG(CASE WHEN bedrooms = 3 THEN price END) AS difference
FROM house_price_data
WHERE bedrooms IN (3,4);

-- 15. Distinct zip codes (locations)
SELECT DISTINCT zipcode FROM house_price_data ORDER BY zipcode;

-- 16. Renovated properties
SELECT * FROM house_price_data WHERE yr_renovated > 0;

-- 17. 11th most expensive property
SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;