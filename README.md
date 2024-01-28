# Walmart Sales Data Analysis Project Documentation

## Overview

This document provides an overview of the Walmart Sales Data Analysis project. The analysis aims to derive valuable insights from sales data, answer business-related questions, and provide a basis for data-driven decision-making.

## Project Objectives

- Analyze and understand the Walmart sales dataset.
- Generate insights regarding product sales, customer behavior, and overall revenue.
- Address specific business questions related to sales, products, customers, and more.
- Enhance the quality and accessibility of the data for future analyses.

## Dataset Information

- **Dataset Name:** Walmart Sales Dataset
- **Data Source:** [https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting]
- This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 row

## Database Structure

- **Database Name:** walmart_sales
- **Table Name:** sales_data
- Columns:
| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product sold        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                     | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total sales                         | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method          | The payment methods                     | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

  
## Feature Engineering

### Time_of_Day Column
- Created a new column, `time_of_day`, to categorize sales into Morning, Afternoon, and Evening.

### Day_of_Week Column
- Added a new column, `day_of_week`, to capture the days of the week on which transactions occurred.

### Month_Name Column
- Introduced a new column, `month_name`, to represent the months in which transactions took place.

## Business Questions

### General Questions

1. **Unique Cities:**
   - Query to find the number of unique cities in the dataset.

2. **Branch Cities:**
   - Identify the city associated with each branch.

### Product Analysis

1. **Unique Product Lines:**
   - Determine the number of unique product lines in the dataset.

2. **Most Common Payment Method:**
   - Identify the most common payment method.

3. **Top-Selling Product Line:**
   - Find the product line with the highest sales volume.

4. **Total Revenue by Month:**
   - Calculate the total revenue for each month.

5. **Largest COGS by Month:**
   - Identify the month with the highest Cost of Goods Sold (COGS).

6. **Largest Revenue by Product Line:**
   - Determine the product line with the highest revenue.

7. **Largest Revenue by City:**
   - Find the city with the highest revenue.

8. **Product Line with Largest VAT:**
   - Identify the product line with the highest Value Added Tax (VAT).

9. **Good/Bad Sales Performance:**
   - Evaluate the sales performance of each product line.

10. **Most Common Product Line by Gender:**
    - Determine the most common product line for each gender.

### Sales Analysis

1. **Sales by Time of Day:**
   - Analyze the number of sales during different times of the day.

2. **Customer Type with Highest Revenue:**
   - Identify the customer type bringing the most revenue.

3. **City with Largest VAT:**
   - Find the city with the highest Value Added Tax (VAT).

4. **Customer Type Paying Most in VAT:**
   - Identify the customer type paying the most in VAT.

5. **Total Revenue by Branch:**
   - Calculate the total revenue for each branch.

6. **Product Line Contribution to Overall Sales:**
   - Identify the product line contributing the most to overall sales.

7. **Consistent High Sales Days/Months:**
   - Identify specific days or months with consistently higher sales.

### Customer Analysis

1. **Unique Customer Types:**
   - Determine the number of unique customer types in the dataset.

2. **Unique Payment Methods:**
   - Identify the number of unique payment methods.

3. **Most Common Customer Type:**
   - Find the most common customer type.

4. **Customer Type with Highest Sales:**
   - Identify the customer type with the highest sales.

5. **Gender Distribution:**
   - Analyze the gender distribution of customers.

6. **Gender Distribution per Branch:**
   - Determine the gender distribution per branch.

7. **Time of Day with Most Ratings:**
   - Identify the time of day when customers give the most ratings.

8. **Branch with Best Average Ratings:**
   - Determine the branch with the best average ratings.

9. **Day of Week with Best Average Ratings:**
   - Identify the day of the week with the best average ratings.
