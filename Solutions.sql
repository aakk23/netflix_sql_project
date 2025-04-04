-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
SELECT DISTINCT type, count(*)
FROM netflix
GROUP BY type
;

-- 2. Find the most common rating for movies and TV shows
SELECT type,rating
FROM (
SELECT type,rating,count(*) as cnt,
RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) As Rank
FROM netflix
GROUP BY 1,2
) as ranking
WHERE rank=1
;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE release_year =2020 AND type = 'Movie'
;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT country,count(show_id) AS content_count
FROM netflix
WHERE Country IS NOT NULL
GROUP BY 1 ORDER BY 2 DESC LIMIT 5
;

-- 5. Identify the longest movie
SELECT *
FROM netflix
WHERE type ='Movie' AND duration =(SELECT MAX(duration) FROM netflix)
;

-- 6. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'
;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'
;

-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type='TV Show' AND duration>'5 seasons';

-- 9. Count the number of content items in each genre
SELECT
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre, count(show_id) as total_content
FROM netflix
GROUP BY 1 ORDER BY 2 DESC
;

-- 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year, 
	count(*) as total_release,
	ROUND(
	count(*)::numeric/(SELECT count(*) FROM netflix WHERE country LIKE '%India%')::numeric*100
	,2) as avg_release
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1 ORDER BY 3 DESC LIMIT 5;


-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%' AND type = 'Movie'
;

-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL
;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts,',')),count(show_id)
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;

-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
WITH label AS(
SELECT show_id,title, 
	CASE
		WHEN
		description ILIKE '% kill %' OR 
		description ILIKE '% violence %' THEN 'Bad_Content'
		ELSE 'Good_Content'
	END AS content_label
FROM netflix
)

SELECT content_label, Count(*) as total_content
FROM label
GROUP BY 1;