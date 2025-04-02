#1. What is the salary development across different industries?

**SQL query used:**
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

