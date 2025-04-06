**SQL query used:**

#1. What is the salary development across different industries?

```sql
SELECT industry_branch_code, payroll_year, 
       ROUND(AVG(value)::numeric, 2) AS avg_salary
FROM czechia_payroll
WHERE value_type_code = 5958
GROUP BY industry_branch_code, payroll_year
ORDER BY industry_branch_code, payroll_year;

Summary of results:
From 2000 to 2021, the average salaries in various industries have shown a steady increase.
The most significant growth was observed in the IT and banking sectors.
On the other hand, the lowest average salaries were consistently recorded in the accommodation and food service industry.

Exported CSV file: salary_by_industry.csv

## 2. How many liters of milk could be bought from the average salary in 2021?

**SQL query used:**
```sql
WITH avg_salary AS (
    SELECT ROUND(AVG(value)::numeric, 2) AS salary
    FROM czechia_payroll
    WHERE value_type_code = 5958
      AND payroll_year = 2021
),
milk_price AS (
    SELECT ROUND(AVG(value)::numeric, 2) AS milk
    FROM czechia_price
    WHERE category_code = '114201'
      AND EXTRACT(YEAR FROM date_from) = 2021
)
SELECT salary, milk, ROUND(salary / milk, 0) AS litres_of_milk
FROM avg_salary, milk_price;

Summary of results: In 2021, the average salary was 36,815.34 CZK.
Unfortunately, the average milk price data appears to be missing (NULL), so the number of liters could not be calculated.

Exported CSV file: milk_purchasing_power_2021.csv

## 3. Which food category has the slowest price increase?

**SQL query used:**

```sql
WITH prices AS (
  SELECT
    category_code,
    ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date_from) = 2006 THEN value END)::numeric, 2) AS price_2006,
    ROUND(AVG(CASE WHEN EXTRACT(YEAR FROM date_from) = 2018 THEN value END)::numeric, 2) AS price_2018
  FROM czechia_price
  GROUP BY category_code
),
price_growth AS (
  SELECT
    category_code,
    price_2006,
    price_2018,
    ROUND(
      CAST(
        (POWER(price_2018 / price_2006, 1.0 / 12) - 1) * 100
        AS NUMERIC
      ),
      2
    ) AS cagr_percentage
  FROM prices
  WHERE price_2006 IS NOT NULL AND price_2018 IS NOT NULL
)
SELECT *
FROM price_growth
ORDER BY cagr_percentage ASC;
```

**Summary of results:**

The food category with the slowest average annual price increase from 2006 to 2018 is the one with the **lowest CAGR (compound annual growth rate)**. This means it had the **least inflation over time**.

Exported CSV file: slowest_price_growth.csv

