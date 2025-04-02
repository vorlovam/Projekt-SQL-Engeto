## 1. Jaký je vývoj mezd v jednotlivých odvětvích?

**Použitý SQL dotaz:**
```sql
SELECT industry_branch_code, payroll_year, 
       ROUND(AVG(value)::numeric, 2) AS avg_salary
FROM czechia_payroll
WHERE value_type_code = 5958
GROUP BY industry_branch_code, payroll_year
ORDER BY industry_branch_code, payroll_year;

Shrnutí výsledků: Od roku 2000 do roku 2021 průměrné mzdy v jednotlivých odvětvích stabilně rostly. Největší nárůst byl zaznamenán v IT a bankovnictví. Nejnižší průměrné mzdy byly dlouhodobě v odvětví ubytování a stravování.

Exportovaný soubor: salary_by_industry.csv
