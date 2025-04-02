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
