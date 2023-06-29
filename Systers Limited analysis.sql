use HR_Dataset

SELECT *
FROM HRData

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HRData';

--Viewing each columns' schema 
SELECT column_name, data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'HRData';


/*Question 1 (Is there any relationship between a person's manager and their performance score?)
*/
SELECT 
	ManagerName, 
	PerformanceScore,
	COUNT(*) AS TotalEmployees
FROM HRData
GROUP BY ManagerName, PerformanceScore
ORDER BY PerformanceScore, TotalEmployees DESC;

--Determining the Managers with the highest employee performance score 'Exceed"
SELECT 
	ManagerName,
	count(PerformanceScore) as No_Performancescore
FROM
	HRData
WHERE
	PerformanceScore = 'Exceeds'
GROUP BY
	ManagerName
ORDER BY
	No_Performancescore DESC;

--Who is the highest performing manager?
SELECT TOP 1 ManagerName
FROM HRData
GROUP BY ManagerName
ORDER BY COUNT(*) DESC;



/*Question 2(What is the overall diversity profile of the organization?)
In terms of diversity, we have the following factors to consider (Sex, Marital Status, Citizen status and Race) */
SELECT
	Sex,
	MaritalDesc,
	CitizenDesc,
	RaceDesc,
	Count(*) AS TotalEmployees
FROM HRData
GROUP BY
	Sex,
	MaritalDesc,
	CitizenDesc,
	RaceDesc
ORDER BY TotalEmployees DESC;

--By Sex
SELECT
	Sex,
	Count(*) Frequency
FROM
	HRData
GROUP BY
	Sex
ORDER BY
	Frequency DESC;

--By Marital Status
SELECT
	MaritalDesc,
	Count(*) Frequency
FROM
	HRData
GROUP BY
	MaritalDesc
ORDER BY
	Frequency DESC;

--By Citizen Status
SELECT
	CitizenDesc,
	Count(*) Frequency
FROM
	HRData
GROUP BY
	CitizenDesc
ORDER BY
	Frequency DESC;

--By Race
SELECT
	RaceDesc,
	Count(*) Frequency
FROM
	HRData
GROUP BY
	RaceDesc
ORDER BY
	Frequency DESC;


/*Question 3(What are our best recruiting sources if we want to ensure a diverse organization?)
Gender: Overall, based on the analysis, CareerBuilder and Diversity Job Fair may be considered 
effective recruiting sources for achieving a diverse organization, as they show higher percentages 
of female candidates and a relatively balanced gender distribution respectively. 
*/


--By Gender
SELECT RecruitmentSource, 
       ROUND((COUNT(CASE WHEN Sex = 'F' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Female,
	   ROUND((COUNT(CASE WHEN Sex = 'M' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Male
FROM 
	HRData
GROUP BY 
	RecruitmentSource
ORDER BY 
	RecruitmentSource;


--By Marital Status
SELECT RecruitmentSource, 
       ROUND((COUNT(CASE WHEN MaritalDesc = 'Single' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Single,
	   ROUND((COUNT(CASE WHEN MaritalDesc = 'Married' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Married,
	   ROUND((COUNT(CASE WHEN MaritalDesc = 'Divorced' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Divorced,
	   ROUND((COUNT(CASE WHEN MaritalDesc = 'Separated' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Separated,
	   ROUND((COUNT(CASE WHEN MaritalDesc = 'Widowed' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Widowed
FROM 
	HRData
GROUP BY 
	RecruitmentSource
ORDER BY 
	RecruitmentSource;

--By Citizenship status
SELECT RecruitmentSource, 
       ROUND((COUNT(CASE WHEN CitizenDesc = 'US Citizen' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_UScitizen,
	   ROUND((COUNT(CASE WHEN CitizenDesc = 'Eligible NonCitizen' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_EligibleNoncitizen,
	   ROUND((COUNT(CASE WHEN CitizenDesc = 'Non-Citizen' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Noncitizen
FROM 
	HRData
GROUP BY 
	RecruitmentSource
ORDER BY 
	RecruitmentSource;

--By Racial status
SELECT RecruitmentSource, 
       ROUND((COUNT(CASE WHEN RaceDesc = 'White' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_White,
	   ROUND((COUNT(CASE WHEN RaceDesc = 'Black or African American' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Black,
	   ROUND((COUNT(CASE WHEN RaceDesc = 'Asian' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Asian,
	   ROUND((COUNT(CASE WHEN RaceDesc = 'Two or more races' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_2ormoreraces,
	   ROUND((COUNT(CASE WHEN RaceDesc = 'American Indian or Alaska Native' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_AmericanIndian,
	   ROUND((COUNT(CASE WHEN RaceDesc = 'Hispanic' THEN 1 END) * 100.0 / COUNT(*)), 0) AS Percentage_Hispanic
FROM 
	HRData
GROUP BY 
	RecruitmentSource
ORDER BY 
	RecruitmentSource;


/*Question 4 Determining the top 5 recruitment sources with the highest number of employees
Which recruitment sources have resulted in the highest number of successful hires? */
SELECT
	TOP 5 RecruitmentSource,
	Count(*) AS TotalEmployees
FROM
	HRData 
GROUP BY 
	RecruitmentSource
ORDER BY
	TotalEmployees DESC;

--Which recruitment sources have resulted in the highest number of successful hires who are exceeding at work
SELECT
	TOP 5 RecruitmentSource,
	Count(*) AS TotalEmployees
FROM
	HRData
WHERE
	PerformanceScore = 'Exceeds'
GROUP BY 
	RecruitmentSource
ORDER BY
	TotalEmployees DESC;

--Overall Performance scores of employees
SELECT 
	PerformanceScore,
	Count(*) AS TotalEmployees
FROM HRData
GROUP BY PerformanceScore;

/*Question 5 (What is the distribution of salaries or compensation packages across different job levels or departments?)
*/

--Trying to view the ranges of salaries
SELECT Salary FROM HRData ORDER BY Salary DESC;

--By Department
SELECT 
	Department,
	min(Salary) AS MinSalary,
	max(Salary) AS MaxSalary
FROM 
	HRData
GROUP BY Department
ORDER BY Department;

--By Employee's position
SELECT 
	Position,
	min(Salary) AS MinSalary,
	max(Salary) AS MaxSalary
FROM 
	HRData
GROUP BY Position
ORDER BY Position;

--Question 6 (What are the specific areas or departments with lower satisfaction scores that require attention?)
SELECT
	Department,
	CASE
		WHEN EmpSatisfaction = 1 THEN 'Very dissatisfied'
		WHEN EmpSatisfaction = 2 THEN 'Dissatisfied'
		WHEN EmpSatisfaction = 3 THEN 'Neutral'
		WHEN EmpSatisfaction = 4 THEN 'Satisfied'
		WHEN EmpSatisfaction = 5 THEN 'Very Satisfied'
		ELSE 'Unknown'
		END AS SatisfactionRange,
	Count(*) AS Freq_EmpSatisfaction,
	EmpSatisfaction
FROM 
	HRData
GROUP BY
	Department,
	EmpSatisfaction
ORDER BY 
	Department;

--Relationship between employee's satisfaction and performance
SELECT
	PerformanceScore,
	CASE
		WHEN EmpSatisfaction = 1 THEN 'Very dissatisfied'
		WHEN EmpSatisfaction = 2 THEN 'Dissatisfied'
		WHEN EmpSatisfaction = 3 THEN 'Neutral'
		WHEN EmpSatisfaction = 4 THEN 'Satisfied'
		WHEN EmpSatisfaction = 5 THEN 'Very Satisfied'
		ELSE 'Unknown'
		END AS SatisfactionRange,
	Count(*) AS Frequency,
	EmpSatisfaction
FROM
	HRData
GROUP BY 
	PerformanceScore, 
	EmpSatisfaction
ORDER BY 
	PerformanceScore;

--Reason for Termination
SELECT
	TermReason,
	Count(*) AS Frequency
FROM
	HRData
GROUP BY
	TermReason
ORDER BY
	Frequency DESC;