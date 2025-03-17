CREATE TABLE t_marketa_vorlova_project_SQL_primary_final AS 
WITH gdp_growth AS (
    SELECT 
        year, 
        gdp, 
        LAG(gdp) OVER (ORDER BY year) AS prev_year_gdp,
        ROUND(((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year) * 100)::numeric, 2) AS gdp_growth_pct
    FROM economies 
    WHERE country = 'Czech Republic'
    AND year >= 2000
), salary_growth AS (
    SELECT 
        year, 
        avg_salary_in_kc, 
        LAG(avg_salary_in_kc) OVER (ORDER BY year) AS prev_year_salary,
        ROUND(((avg_salary_in_kc - LAG(avg_salary_in_kc) OVER (ORDER BY year)) / LAG(avg_salary_in_kc) OVER (ORDER BY year) * 100)::numeric, 2) AS salary_increase_pct
    FROM (
        SELECT 
            payroll_year AS year, 
            ROUND(AVG(value)::numeric, 2) AS avg_salary_in_kc
        FROM czechia_payroll
        WHERE value_type_code = 5958  
        GROUP BY payroll_year
    ) subquery
), avg_food_prices AS (
    SELECT 
        EXTRACT(YEAR FROM p.date_from) AS year, 
        ROUND(AVG(p.value)::numeric, 2) AS avg_food_price
    FROM czechia_price p
    GROUP BY year
), food_price_growth AS (
    SELECT 
        year, 
        avg_food_price, 
        LAG(avg_food_price) OVER (ORDER BY year) AS prev_year_price,
        ROUND(((avg_food_price - LAG(avg_food_price) OVER (ORDER BY year)) / LAG(avg_food_price) OVER (ORDER BY year) * 100)::numeric, 2) AS food_price_increase_pct
    FROM avg_food_prices
)
SELECT 
    g.year, 
    g.gdp_growth_pct, 
    s.salary_increase_pct, 
    f.food_price_increase_pct
FROM gdp_growth g
JOIN salary_growth s ON g.year = s.year
JOIN food_price_growth f ON g.year = f.year;
