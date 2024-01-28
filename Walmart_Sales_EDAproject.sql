-- Creating the Database

CREATE DATABASE IF NOT EXISTS walmart_sales;
USE walmart_sales;

-- Creating the table and Import the Data

CREATE TABLE IF NOT EXISTS sales_data (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY ,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_percentage FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2, 1)
);

-- Retrieving all Records from Walmart Sales Data Table

SELECT
	*
FROM
	sales_data;

-- Wrangling Data --

-- Identify duplicate rows
SELECT invoice_id, COUNT(*) as duplicates
FROM sales_data
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- Delete rows with NULL values in a specific column
DELETE FROM sales_data WHERE invoice_id IS NULL;

-- Feature Engineering --

-- 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening.

SELECT
	time,
    (
    CASE
		WHEN `time` BETWEEN "00:00:00"  AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
		ELSE 'Evening'
	END
    ) AS time_of_day
FROM
	sales_data;
    
ALTER TABLE sales_data
ADD COLUMN time_of_day VARCHAR(20) NOT NULL;

UPDATE sales_data
SET time_of_day =(
    CASE
		WHEN `time` BETWEEN "00:00:00"  AND "12:00:00" THEN 'Morning'
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
		ELSE 'Evening'
	END
    );

--  2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place

SELECT
	date,
    dayname(date) AS day_of_week
FROM
	sales_data;

ALTER TABLE sales_data
ADD COLUMN day_of_week VARCHAR(20) NOT NULL;

UPDATE sales_data
SET day_of_week = (
	dayname(date)
);

-- 3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place

SELECT
	date,
    monthname(date) AS month_name
FROM
	sales_data;

ALTER TABLE sales_data
ADD COLUMN month_name VARCHAR(20) NOT NULL;

UPDATE sales_data
SET month_name = (
	monthname(date)
);



-- ---------------------------------------------------------------------------------------

							-- Answers to some Business Questions --

-- --------------------------------------------------------------------------------------
								-- General Questions -- 
-- ---------------------------------------------------------------------------------------

-- 1. How many unique cities does the data have?

SELECT DISTINCT
	city
FROM
	sales_data;

-- 2. In which city is each branch?

SELECT
	branch,
    city
FROM
	sales_data
GROUP BY branch,
		 city
ORDER BY branch;

-- ---------------------------------------------------------------------------------------
                          -- Product Analysis --
-- ---------------------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?

SELECT DISTINCT
	product_line
FROM
	sales_data;

-- 2. What is the most common payment method?

SELECT payment_method, COUNT(*) AS frequency
FROM sales_data
GROUP BY payment_method
ORDER BY frequency DESC
LIMIT 1;

-- 3. What is the most selling product line?

SELECT
	product_line,
    SUM(quantity) AS sales_volume
FROM
	sales_data
GROUP BY product_line
ORDER BY sales_volume
LIMIT 1;

-- 4. What is the total revenue by month?

SELECT
	month_name AS Month,
    ROUND(SUM(total),2) AS Total_revenue
FROM
	sales_data
GROUP BY month_name
ORDER BY Total_revenue DESC;

-- 5. Which month had the largest COGS?

SELECT
	month_name AS Month,
    SUM(cogs) as COGS
FROM
	sales_data
GROUP BY month_name
ORDER BY COGS DESC
LIMIT 1 ;

-- 6. Which product line had the largest revenue?

SELECT
	product_line AS Product_line,
    SUM(unit_price * quantity) AS Total_revenue
FROM 
	sales_data
GROUP BY product_line
ORDER BY Total_revenue DESC
LIMIT 1;

-- 7. What is the city with the largest revenue?

SELECT
	city AS City,
    SUM(total) AS Total_revenue
FROM 
	sales_data
GROUP BY city
ORDER BY Total_revenue DESC
LIMIT 1;

-- 8. What product line had the largest VAT?

SELECT
	product_line,
    MAX(VAT) AS Max_VAT
FROM
	sales_data
GROUP BY product_line
ORDER BY Max_VAT DESC
LIMIT 1;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	product_line AS Product_line,
	ROUND(AVG(quantity),2) AS AVG_units_sold
FROM sales_data
GROUP BY product_line;

SELECT
	product_line AS Product_line,
    (
    CASE
		WHEN AVG(quantity) > 5  THEN 'Good'
        ELSE 'Bad'
	END
	) AS Sales_performance
FROM sales_data
GROUP BY product_line;

SELECT 
	branch AS Branch,
	SUM(quantity) Total_units_sold
FROM sales_data
GROUP BY branch
HAVING SUM(quantity) > 
			( SELECT AVG(quantity) FROM sales_data);
              
-- 11. What is the most common product line by gender?

SELECT
	gender AS Gender,
	product_line AS Product_line,
    COUNT(*) AS Counts
FROM
	sales_data
GROUP BY 1,2
ORDER BY Counts DESC;
    
-- 12. What is the average rating of each product line?

SELECT
	product_line,
    ROUND(AVG(rating),2) AS AVG_rating
FROM
	sales_data
GROUP BY product_line
ORDER BY AVG_rating DESC;

-- 13- What are the top-selling products in each branch?

WITH Top_product_line AS (
    SELECT
        branch,
        product_line,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY SUM(total) DESC) AS Product_line_rank
    FROM
        sales_data
    GROUP BY branch, product_line
)
SELECT 
    branch,
    product_line
FROM Top_product_line
WHERE Product_line_rank = 1;

-- 14- Which products have the highest gross income?

SELECT
	product_line,
    ROUND(SUM(gross_income),2) AS Total_gross_income
FROM
	sales_data
GROUP BY product_line
ORDER BY Total_gross_income DESC;    

WITH RankedProducts AS (
    SELECT
        product_line,
        ROUND(SUM(gross_income),2) AS Total_gross_income,
        ROW_NUMBER() OVER (ORDER BY SUM(gross_income) DESC) AS Product_rank
    FROM sales_data
    GROUP BY
        product_line
)
SELECT
    product_line,
    Total_gross_income
FROM
    RankedProducts
WHERE
    Product_rank = 1;

-- -----------------------------------------------------------------------------------------
								-- Sales Analysis -- 
-- -----------------------------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday

-- Parts of Day Sales

SELECT 
	time_of_day AS Day_parts,
    SUM(quantity) AS Total_units_sold
FROM
	sales_data
GROUP BY time_of_day
ORDER BY Total_units_sold DESC;

-- Daily Sales

SELECT
	day_of_week AS Day,
    SUM(quantity) AS Total_units_sold
FROM
	sales_data
GROUP BY Day
ORDER BY Total_units_sold DESC;

-- 2. Which of the customer types brings the most revenue?

SELECT DISTINCT
	customer_type
FROM
	sales_data;

SELECT
	customer_type AS Customer_type,
	ROUND(SUM(total),2) As Revenue
FROM
	sales_data
GROUP BY customer_type
ORDER BY Revenue DESC
LIMIT 1;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

SELECT
	city AS City,
    ROUND(MAX(VAT),2) AS Max_VAT
FROM
	sales_data
GROUP BY City
ORDER BY Max_VAT DESC
LIMIT 1;

-- 4. Which customer type pays the most in VAT?

SELECT
	customer_type AS Customer_type,
	ROUND(MAX(VAT),2) AS Max_VAT
FROM
	sales_data
GROUP BY Customer_type
ORDER BY Max_VAT DESC
LIMIT 1;
    
    
-- 5- What is the total revenue for each branch?

SELECT
	branch AS Branch,
    ROUND(SUM(total),2) AS Revenue
FROM
	sales_data
GROUP BY Branch
ORDER BY Revenue DESC;

-- 6- Which product line contributes the most to overall sales?

SELECT
	product_line,
    ROUND(SUM(total),2) AS Total_sales
FROM
	sales_data
GROUP BY product_line
ORDER BY Total_sales DESC
LIMIT 1;

-- 7- Are there specific months or days that consistently show higher sales?

-- Per Day
SELECT
	day_of_week,
    ROUND(SUM(total),2) AS Total_sales
FROM
	sales_data
GROUP BY day_of_week
ORDER BY Total_sales DESC;

-- Per Month
SELECT
	month_name AS Month,
    ROUND(SUM(total),2) AS Total_sales
FROM
	sales_data
GROUP BY Month
ORDER BY Total_sales DESC;

-- ---------------------------------------------------------------------------------------
                                -- Customer Analysis
-- ---------------------------------------------------------------------------------------

-- 1. How many unique customer types does the data have?

SELECT DISTINCT
	customer_type
FROM
	sales_data;

-- 2. How many unique payment methods does the data have?

SELECT DISTINCT
	payment_method
FROM
	sales_data;

-- 3. What is the most common customer type?

SELECT
	customer_type,
    COUNT(*) AS Total_number
FROM
	sales_data
GROUP BY customer_type
ORDER BY Total_number DESC;

-- 4. Which customer type buys the most?

SELECT
	customer_type,
	SUM(quantity) AS Quantity
FROM 
	sales_data
GROUP BY customer_type
ORDER BY Quantity DESC;

SELECT
	customer_type,
    ROUND(SUM(total),2) AS Total_sales
FROM
	sales_data
GROUP BY customer_type
ORDER BY Total_sales DESC;

-- 5. What is the gender of most of the customers?

SELECT
	gender AS Gender,
    COUNT(*) AS Total_count
FROM
	sales_data
GROUP BY gender
ORDER BY Total_count DESC;

-- 6. What is the gender distribution per branch?

SELECT
	branch AS Branch,
    gender AS Gender,
    COUNT(*) AS Distribution
FROM
	sales_data
GROUP BY branch, gender
ORDER BY branch;

-- 7. Which time of the day do customers give most ratings?

SELECT
	time_of_day AS Day_part,
    COUNT(*) AS Rating_count
FROM
	sales_data
GROUP BY Day_part
ORDER BY Rating_count DESC
LIMIT 1;

-- 8. Which time of the day do customers give most ratings per branch?

WITH Ratings_per_branch AS (
	SELECT
		time_of_day AS Day_part,
		branch AS Branch,
        COUNT(*) AS Rating_count,
		ROW_NUMBER() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS Ranking
	FROM
		sales_data
	GROUP BY Day_part, Branch
)
SELECT
    Branch,
    Day_part,
    Rating_count
FROM
	Ratings_per_branch
WHERE Ranking = 1;

-- 9. Which day of the week has the best avg ratings?

SELECT
	day_of_week,
    ROUND(AVG(rating),2) AS Avg_rating
FROM
	sales_data
GROUP BY day_of_week
ORDER BY Avg_rating DESC
LIMIT 1;

-- 10. Which day of the week has the best average ratings per branch?

WITH Avg_branch_rating AS (
	SELECT
		branch AS Branch,
        day_of_week,
        ROW_NUMBER() OVER ( PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranking
	FROM
		sales_data
	GROUP BY branch, day_of_week
	)
SELECT
	Branch,
    day_of_week
FROM
	Avg_branch_rating
WHERE ranking = 1;
-- ---------------------------------------------------------------------------------------