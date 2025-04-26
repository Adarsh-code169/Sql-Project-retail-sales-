# Retail Sales Analysis Project

### Project Overview

**Project Title:** Retail Sales Analysis  
**Level:** Beginner  
**Database:** `p1_retail_db`

This project demonstrates SQL skills typically used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

---

## Objectives

- Set up a retail sales database.
- Perform data cleaning to remove missing records.
- Conduct exploratory data analysis (EDA).
- Answer business questions using SQL queries.

---

## Project Structure

### 1. Database Setup

**Database Creation:**
```sql
CREATE DATABASE p1_retail_db;
```

**Table Creation:**
```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

### 2. Data Exploration & Cleaning

**Record Count:**
```sql
SELECT COUNT(*) FROM retail_sales;
```

**Customer Count (Unique Customers):**
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
```

**Category Count (Unique Categories):**
```sql
SELECT DISTINCT category FROM retail_sales;
```

**Null Value Check:**
```sql
SELECT * FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
OR gender IS NULL OR age IS NULL OR category IS NULL
OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

**Delete Records with Nulls:**
```sql
DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL
OR gender IS NULL OR age IS NULL OR category IS NULL
OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

---

### 3. Data Analysis & Findings

**1. Sales made on '2022-11-05':**
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

**2. Clothing category sales (quantity > 4) in November 2022:**
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;
```

**3. Total Sales by Category:**
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

**4. Average Age of Customers (Beauty category):**
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

**5. Transactions with Total Sale > 1000:**
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

**6. Transactions by Gender and Category:**
```sql
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

**7. Best-Selling Month Each Year (by Average Sale):**
```sql
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE rank = 1;
```

**8. Top 5 Customers by Total Sales:**
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

**9. Unique Customers per Category:**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY category;
```

**10. Number of Orders by Shift (Morning, Afternoon, Evening):**
```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## Findings

- **Customer Demographics:** Wide range of age groups across product categories like Clothing and Beauty.
- **High-Value Transactions:** Several transactions have total sale amounts exceeding 1000.
- **Sales Trends:** Monthly analysis identifies peak sales seasons.
- **Customer Insights:** Top customers and most popular categories are highlighted.

---

## Reports

- **Sales Summary:** Total sales, category-wise performance, customer demographics.
- **Trend Analysis:** Sales trends across months and shifts (Morning, Afternoon, Evening).
- **Customer Insights:** Top customers and unique customer purchases per category.

---

## Conclusion

This project acts as a beginner-friendly introduction to SQL for data analysts. It covers database creation, data cleaning, exploratory data analysis, and writing SQL queries to solve business problems. The findings can help businesses better understand sales patterns, customer behavior, and product performance.
