-- CREATE DATABASE zepto_project;
USE zepto_project;
-- IMPORT THE DATA AND SEE THE FILE  
 SELECT COUNT(*) FROM zepto_v1;

-- NAME OF THE COLUMN IS DIFFERENT SO NEED TO CHANGE THAT IN ORDER TO GET A STANDARD NAME
ALTER TABle zepto_v1 RENAME COLUMN ï»¿Category TO Category;
ALTER TABLE zepto_v1 ADD COLUMN id INT primary key auto_increment FIRST;
SELECT * FROM zepto_v1;

-- WANT THE ID COLUMN AT THE FIRST PLACE
ALTER TABLE zepto_v1
MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT FIRST;
SELECT * FROM zepto_v1;

--  TRACK OUT THE NULL VALUES IN DATA
SELECT * FROM zepto_v1 WHERE 
Category is NULL OR
name is NULL OR
mrp is NULL OR
discountPercent is NULL OR
availableQuantity is NULL OR
discountedSellingPrice is NULL OR
weightInGms is NULL OR
outOfStock is NULL OR
quantity is NULL;

--  TO SEE ALL THE DISTINCT CATEGORY AVAILABLE IN DATASET
SELECT DISTINCT Category from zepto_v1 ORDER BY Category;

-- TO SEE THE DATA WHERE WE GET THE COUNT OF PRODUCT WHICH ARE IN STOCK AND OUT OF STOCK
SELECT COUNT(*) AS QTY, outOfStock FROM zepto_v1 GROUP BY outOfStock;

-- DATA CLEANING
-- SEE TO THE COLUMN WHERE MRP IS ZERO OR NULL
SELECT * FROM zepto_v1 WHERE mrp='0' OR 'NULL';

-- DELETE THE ROW WHERE MRP IS ZERO

-- THIS SAFE MODE NEEDS TO BE DONE AS ON TRUNNING THE DELETE QUERY THE SQL PREVENT THIS BY GIVING THE CAUTION AS DELETING MANY ROW IN A GO 
-- CAN BE VERY IMPACTFUL SO BY DOING THIS IT WILL ALLOW TO DO
SET SQL_SAFE_UPDATES = 0;
DELETE FROM zepto_v1  WHERE mrp='0';

-- AS IN THE DATA THE MRP AND DISCOUNTED SELLING PRICE IS IN PAISE NOT IN RUPEES SO WILL CONVERT THEM AS WELL

-- UPDATE zepto_v1 SET mrp =mrp/100.0 ;
-- UPDATE zepto_v1 SET discountedsellingprice =discountedsellingprice/100.0
 
-- BUSINESS QUESTION
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT * FROM zepto_v1 ORDER BY discountpercent DESC LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT mrp, name , outofstock FROM zepto_v1 WHERE outofstock='TRUE'
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT Category, SUM(Discountedsellingprice * availablequantity) AS Revenue
FROM zepto_v1 GROUP BY Category ORDER BY Revenue 

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%

SELECT name, mrp,discountpercent FROM zepto_v1 
WHERE mrp>500 AND discountpercent<10;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,ROUND(AVG(DiscountPercent),2) as avg_discount  
FROM zepto_v1 GROUP BY Category  ORDER BY avg_discount desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT  name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto_v1
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto_v1;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_v1
GROUP BY category
ORDER BY total_weight;

-- THANKYOU :) 
