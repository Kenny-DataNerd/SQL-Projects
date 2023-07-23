use XYZ_Analytics

select * from XYZ_hr

---DATA CLEANING

---We need to be able to tell the age of each employees so i'll create a new column for that
ALTER TABLE XYZ_hr
ADD age int

---Fill the column with the ages of the employees
UPDATE XYZ_hr
SET age = DATEDIFF(YEAR, birthdate, GETDATE())

---Getting the count figures for active, inactive and total employees
select count(*) as Inactive_Emp
from XYZ_hr
where termination_date is null

select count(*) as Active_Emp
from XYZ_hr
where termination_date is not null or termination_date = ' '

select count(*) as Total_Employees
from XYZ_hr

---DATA MANIPULATION

---What is the gender breakdown of active employees in the company?
SELECT gender, count(*) as count
FROM XYZ_hr
WHERE termination_date IS NOT NULL
GROUP BY gender
ORDER BY count DESC;

---What is the race/ethnicity breakdown of active employees in the company?
SELECT race, count(*) as count
FROM XYZ_hr
WHERE termination_date IS NOT NULL
GROUP BY race
ORDER BY count DESC;

---What is the age distribution of active employees in the company?
SELECT CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END AS Age_group,
    COUNT(*) AS count
FROM XYZ_hr
WHERE termination_date IS NOT NULL
GROUP BY CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END
ORDER BY CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END;

---What is the age and gender distribution of active employees in the company?
SELECT CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END AS Age_group,
	gender,
    COUNT(*) AS count
FROM XYZ_hr
WHERE termination_date IS NOT NULL
GROUP BY CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END,
	gender
ORDER BY CASE
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
    END;

---How many active employees work at headquarters verses remote locations?
SELECT 
	location, 
	count(*) as count
FROM 
	XYZ_hr
WHERE 
	termination_date IS NOT NULL
GROUP BY 
	location;

---How does the gender distriution vary across departments and job titles?
SELECT department, gender, count(*) Count
FROM XYZ_hr
WHERE termination_date IS NOT NULL 
GROUP BY gender, department
ORDER BY department;

---What is the distribution of job titles across the company?
SELECT job_title, count(*) as count
FROM XYZ_hr
GROUP BY job_title
ORDER BY job_title;

---Which department has the highest turnover rate?
SELECT 
	department,
	total_count,
	terminated_count,
	ROUND(CAST(terminated_count AS decimal) / CAST(total_count AS decimal), 3) AS termination_rate
FROM (
	SELECT department, count(*) as total_count,
	SUM(CASE WHEN termination_date is not null and termination_date <= GETDATE() THEN 1 ELSE 0 END) AS terminated_count
	FROM XYZ_hr
	GROUP BY department
	) AS subquery
ORDER BY termination_rate DESC;

---What is the distribution of employees across locations by city and state?

SELECT location_state, count(*) as Count
FROM XYZ_hr
WHERE termination_date IS NOT NULL
GROUP BY location_state
ORDER BY Count DESC;