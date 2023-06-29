USE Netflix_Data;

SELECT *
FROM netflix_dirty;

---Sort dataset by show_id
SELECT *
FROM netflix_dirty
ORDER BY show_id;

---Check for null values across columns
SELECT
	COUNT(CASE WHEN show_id IS NULL THEN 1 END) AS show_id_null,
	COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_null,
	COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null,
	COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_null,
	COUNT(CASE WHEN cast IS NULL THEN 1 END) AS cast_null,
	COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null,
	COUNT(CASE WHEN date_added IS NULL THEN 1 END) AS date_null,
	COUNT(CASE WHEN release_year IS NULL THEN 1 END) AS year_null,
	COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating_null,
	COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
	COUNT(CASE WHEN listed_in IS NULL THEN 1 END) AS listed_in_null,
	COUNT(CASE WHEN description IS NULL THEN 1 END) AS description_null
FROM 
	netflix_dirty;

/* From the above query, we discovered the columns with null values
director_null = 2,634
cast_null = 825
country_null = 831
date_null = 98
rating_null = 4
duration_null = 3
*/

---Next we determine if there is any relationship between director and casts to populate the director field nulls
WITH cte AS
(
SELECT title, CONCAT(director, ' + ', cast) AS director_casts
FROM netflix_dirty
)

SELECT director_casts, count(*) AS Count
FROM cte
GROUP BY director_casts
HAVING count(*) > 1
ORDER BY count(*) DESC;

---Checking which cells are null
select cast, director, count(*) as count_null
from netflix_dirty
where director is null or cast is null
group by director, cast
having count(*) > 1
order by count_null DESC;

---Next, I started populating the directors based on the relationship between the director and cast fields
SELECT cast, director
FROM netflix_dirty
WHERE cast IS NULL OR director IS  NULL
GROUP BY cast, director
HAVING COUNT(*) > 1;

---Updating director with David Attenborough cast
SELECT cast, director
from netflix_dirty
where cast = 'David Attenborough';
UPDATE netflix_dirty
SET director = 'Alastair Fothergill'
WHERE cast = 'David Attenborough' AND director IS NULL;

---Updating director with Alison Klayman cast
SELECT cast, director
from netflix_dirty
where director = 'Alison Klayman'
UPDATE netflix_dirty
SET cast = 'Ai Weiwei, Lao Ai'
WHERE director = 'Alison Klayman' and cast is null;

---Updating director Alessandro Angola cast
SELECT cast, director
from netflix_dirty
where director = 'Alessandro Angulo'
UPDATE netflix_dirty
SET cast = 'Wade Davis, Martin von Hildebrand'
WHERE director = 'Alessandro Angulo' AND cast is null;

---Updating director Rajiv Chilaka cast
SELECT cast, director
from netflix_dirty
where director = 'Rajiv Chilaka';
UPDATE netflix_dirty
SET cast = 'Vatsal Dubey, Julie Tejwani, Rupa Bhimani, Jigna Bhardwaj, Rajesh Kava, Mousam, Swapnil'
WHERE director = 'Rajiv Chilaka' AND cast is null;

---Updating director Mark Thornton, Todd Kauffman cast
SELECT cast, director
FROM netflix_dirty
WHERE cast = 'Michela Luci, Jamie Watson, Eric Peterson, Anna Claire Bartlam, Nicolas Aqui, Cory Doran, Julie Lemieux, Derek McGrath';
UPDATE netflix_dirty
SET director = 'Mark Thornton, Todd Kauffman'
WHERE cast = 'Michela Luci, Jamie Watson, Eric Peterson, Anna Claire Bartlam, Nicolas Aqui, Cory Doran, Julie Lemieux, Derek McGrath'
AND director IS NULL;

---Updating director Suhas Kadav cast
select cast, director
from netflix_dirty
where director = 'Suhas Kadav';
UPDATE netflix_dirty
SET cast = 'Saurav Chakraborty'
WHERE director = 'Suhas Kadav' and CAST is null;

---Updating director Prakash Satam cast
select cast, director
from netflix_dirty
where director = 'Prakash Satam';
UPDATE netflix_dirty
SET cast = 'Anamaya Verma, Sonal Kaushal, Ganesh Divekar'
WHERE director = 'Prakash Satam' and CAST is null;

---Updating director Prakash Satam cast
select cast, director
from netflix_dirty
where director = 'Prakash Satam';
UPDATE netflix_dirty
SET cast = 'Anamaya Verma, Sonal Kaushal, Ganesh Divekar'
WHERE director = 'Prakash Satam' and CAST is null;

---Updating director Barak Goodman cast
select cast, director
from netflix_dirty
where director = 'Barak Goodman';
UPDATE netflix_dirty
SET cast = 'Dave Hunt, Bo Gritz, Sara Weaver'
WHERE director = 'Barak Goodman' and CAST is null;

---Updating director Barak Goodman cast
select cast, director
from netflix_dirty
where director = 'Barak Goodman';
UPDATE netflix_dirty
SET cast = 'Dave Hunt, Bo Gritz, Sara Weaver'
WHERE director = 'Barak Goodman' and CAST is null;

---Populating the rest of the cells with null values as 'Not Given'
UPDATE netflix_dirty
SET director = 'Not Given'
WHERE director IS NULL;

SELECT *
FROM netflix_dirty


---Populate the country using the director column 

--Selecting the cells to be updated

SELECT COALESCE(nt.country,nt2.country)
FROM netflix_dirty  AS nt
JOIN netflix_dirty AS nt2 
ON nt.director = nt2.director 
AND nt.show_id <> nt2.show_id
WHERE nt.country IS NULL;

---Since the directors column is related to the country column, i updated the country column by checking for similarities
UPDATE netflix_dirty
SET country = (
    SELECT TOP 1 nt2.country
    FROM netflix_dirty AS nt2
    WHERE nt2.director = netflix_dirty.director
      AND nt2.show_id <> netflix_dirty.show_id
      AND nt2.country IS NOT NULL
)
WHERE country IS NULL;

--Populating the remaining cells with no information as "Not Given"

UPDATE netflix_dirty
SET country = 'Not Given'
WHERE country IS NULL;

---Populating the remaining cast with no information as "Not Given"

UPDATE netflix_dirty
SET cast = 'Not Given'
WHERE cast IS NULL;

SELECT *
FROM netflix_dirty;


---Checking the date_added column for null cells 

SELECT COUNT(*)
FROM netflix_dirty
WHERE date_added IS NULL; ---(The column has a total of 98 null cells, i'll leave the cells that way since i don't really need the data)


---Checking for nulls in the rating column

SELECT * 
FROM netflix_dirty
WHERE rating IS NULL; ---We have only 4 records of this, so i'll delete those records

DELETE FROM netflix_dirty
WHERE show_id IN (SELECT show_id FROM netflix_dirty WHERE rating IS NULL);

SELECT *
FROM netflix_dirty
where rating IS NULL; ---Checking to confirm if the records with null are gone, Yes they are!


---Checking for nulls in the duration column
SELECT * 
FROM netflix_dirty
WHERE duration IS NULL; ---We have only 3 records of this, so i'll delete the data

DELETE FROM netflix_dirty
WHERE show_id IN (SELECT show_id FROM netflix_dirty WHERE duration IS NULL);

SELECT *
FROM netflix_dirty
WHERE duration IS NULL; ---Checking to confirm if the records with null are gone, Yes they are!


/* Presently, the only column with null cells that we have is the date column, every other column have been cleaned
But to confirm that, i'll run a query again to check */

SELECT 
	COUNT(CASE WHEN show_id IS NULL THEN 1 END) as show_id_null,
	COUNT(CASE WHEN type IS NULL THEN 1 END) as type_null,
	COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null,
	COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_null,
	COUNT(CASE WHEN cast IS NULL THEN 1 END) AS cast_null,
	COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null,
	COUNT(CASE WHEN date_added IS NULL THEN 1 END) AS date_null,
	COUNT(CASE WHEN release_year IS NULL THEN 1 END) AS year_null,
	COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating_null,
	COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
	COUNT(CASE WHEN listed_in IS NULL THEN 1 END) AS listed_in_null,
	COUNT(CASE WHEN description IS NULL THEN 1 END) AS description_null
FROM 
	netflix_dirty;

/* Now, i'll be dropping the cast, date_added and description columns because i don't need them for my analysis */

ALTER TABLE netflix_dirty
DROP COLUMN cast;

ALTER TABLE netflix_dirty
DROP COLUMN date_added;

ALTER TABLE netflix_dirty
DROP COLUMN description;

--Checking to see if the change has been effected
SELECT *
FROM netflix_dirty ---Yes, it did!

--checking the nulls again
SELECT 
	COUNT(CASE WHEN show_id IS NULL THEN 1 END) as show_id_null,
	COUNT(CASE WHEN type IS NULL THEN 1 END) as type_null,
	COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_null,
	COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_null,
	COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_null,
	COUNT(CASE WHEN release_year IS NULL THEN 1 END) AS year_null,
	COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating_null,
	COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_null,
	COUNT(CASE WHEN listed_in IS NULL THEN 1 END) AS listed_in_null
FROM 
	netflix_dirty;

/* Some movies have different countries and I'll need the origin country(which i presume is the first country in each row)
so i'll have to split the rows so i can access the first country and create a table to that effect */

SELECT *,
       LEFT(country, CHARINDEX(',', country + ',') - 1) AS country1
FROM netflix_dirty

---Finally, i'll be adding a new column to the table to store the origin country data which will be used in my data visualization
ALTER TABLE netflix_dirty
ADD origin_country nvarchar(MAX);

UPDATE netflix_dirty
SET origin_country = LEFT(country, CHARINDEX(',', country + ',') - 1);

SELECT * FROM netflix_dirty



