CREATE database FP20_Analytics

USE FP20_Analytics

SELECT *
FROM HR_Data;

---Age segments by generations
SELECT
	Age,
	CASE 
		WHEN Age between 11 and 26 then 'Gen Z'
		WHEN Age between 27 and 42 then 'Millennials'
		WHEN Age between 43 and 58 then 'Generation X'
		WHEN Age between 59 and 77 then 'Baby Bloomers'
	END AS Generations
FROM
	HR_Data;


---Gender frequency
SELECT Gender, Count(*) AS Frequency
FROM HR_Data
GROUP BY Gender;


---Hire year by Gender
SELECT 
	Gender,
	YEAR(Hire_Date) AS Hire_Year,
	COUNT(*) AS Total_Emp
FROM
	HR_Data
GROUP BY
	Gender,
	YEAR(Hire_Date);


---Hire year by Marital Status
SELECT 
	YEAR(Hire_Date) AS Hire_Year,
	Marital_Status,
	COUNT(*) AS Total_Emp
FROM
	HR_Data
GROUP BY
	Marital_Status,
	YEAR(Hire_Date)
ORDER BY
	Hire_Year;








