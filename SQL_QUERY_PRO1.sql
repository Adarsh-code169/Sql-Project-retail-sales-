-- sql retail sales analysis
CREATE DATABASE sql_project_p1

-- creating tables for analysis
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
				(
					
					transactions_id	INT PRIMARY KEY,
					sale_date DATE,	
					sale_time TIME,
					customer_id	INT,
					gender VARCHAR(15),
					age	INT,
					category VARCHAR(15),	
					quantiy	INT,
					price_per_unit FLOAT,	
					cogs FLOAT,
					total_sale FLOAT
		
				);

-- Now ...going to see how my data looks like

SELECT * FROM retail_sales

--Now...I have imported the dataset maunally....and now going to see my dataset

SELECT * FROM retail_sales
LIMIT 10

--Now going to check my dataset is correct or not...By checking number of lines in dataset

SELECT COUNT(*) FROM retail_sales

--It is showing 2000...so our dataset which isi imported is correct.









--Now we are going to check if any column have null value in it

--DATA CLEANING

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

--In case of transactions_id there is no null value

SELECT * FROM retail_sales
WHERE sale_date IS NULL

--In case of sale_date there is no null value

SELECT * FROM retail_sales
WHERE sale_time IS NULL

--In case of sale_time there is no null value

SELECT * FROM retail_sales
WHERE customer_id IS NULL


--This is very lengthy...so can check all the columns at once...let's see
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- we get a table in which column have null value in it....so we are going to delete them.

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Hence we have succesfully delete all the columns having null in it.








--DATA EXPLORATION

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales
--1997

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales
--155

--How many categories we have and there names?
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales
--3
SELECT DISTINCT category FROM retail_sales
--Electronics
--Clothing
--Beauty







--DATA ANALYSIS AND KEY PROBLEMS AND THERE ANSWERS.

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)





-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date='2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT category,SUM(quantiy) FROM retail_sales
WHERE category='Clothing'
GROUP BY 1




SELECT * FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND quantiy >=4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
		SUM(total_sale)as net_sale,
		COUNT(*)as total_orders
		FROM retail_sales
		GROUP BY 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) FROM retail_sales
WHERE category='Beauty'



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale>1000



-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


SELECT 
		year,
		month,
		avg_sale
	FROM (
			SELECT
					EXTRACT(YEAR FROM sale_date)AS year,
					EXTRACT(MONTH FROM sale_date)AS month,
					AVG(total_sale)as avg_sale,
					RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
	) as t1
	WHERE rank=1



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 



SELECT 
		customer_id,
		SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.



SELECT 
		category,
		COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
