# 📊 Netflix TV Shows and Movies Analysis with SQL
## 🔍 Project Overview
This project presents an in-depth analysis of Netflix's collection of movies and TV shows using SQL. The primary objective is to uncover meaningful insights and address key business questions by exploring the dataset. This README outlines the project’s goals, data source, analytical approach, key findings, and overall conclusions.

## 🎯 Project Objectives
- Examine the distribution of content types (Movies vs. TV Shows).

- Identify the most frequent ratings assigned to each type of content.

- Analyze content by release year, country of origin, and duration.

- Discover and classify shows and movies based on specific keywords and criteria.

## 📁 Dataset Information
The dataset used in this project was obtained from Kaggle:
- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Schema

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT DISTINCT type, count(*)
FROM netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
SELECT type,rating
FROM (
SELECT type,rating,count(*) as cnt,
RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) As Rank
FROM netflix
GROUP BY 1,2
) as ranking
WHERE rank=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix
WHERE release_year =2020 AND type = 'Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT country,count(show_id) AS content_count
FROM netflix
WHERE Country IS NOT NULL
GROUP BY 1 ORDER BY 2 DESC LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix
WHERE type ='Movie' AND duration =(SELECT MAX(duration) FROM netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added,'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix
WHERE type='TV Show' AND duration>'5 seasons';
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre, count(show_id) as total_content
FROM netflix
GROUP BY 1 ORDER BY 2 DESC
;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS year, 
	count(*) as total_release,
	ROUND(
	count(*)::numeric/(SELECT count(*) FROM netflix WHERE country LIKE '%India%')::numeric*100
	,2) as avg_release
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1 ORDER BY 3 DESC LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%' AND type = 'Movie';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT *
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT UNNEST(STRING_TO_ARRAY(casts,',')),count(show_id)
FROM netflix
WHERE country LIKE '%India%'
GROUP BY 1 ORDER BY 2 DESC LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
## 📈 Findings & Conclusion
- **Content Distribution:** The dataset showcases a broad mix of movies and TV shows, reflecting a wide variety of genres and content types available on Netflix.

- **Popular Ratings:** Analysis of the most frequent ratings offers insights into the platform’s content positioning and its intended target audiences.

- **Geographical Trends:** The dominance of countries like the United States and India in terms of content volume reveals regional preferences and Netflix’s global content strategy.

- **Content Categorization:** Filtering content based on keywords helps identify trends and patterns in show themes, genres, and formats.

Overall, this analysis offers a data-driven perspective on Netflix’s content library, which can support strategic decisions related to content planning, user targeting, and regional expansion.

## 📌 Author: Aakkash Aswin
This project is a part of my data analytics portfolio and highlights my SQL proficiency relevant to data analyst roles.
### Connect with me on [LinkedIn](http://www.linkedin.com/in/aakkash-aswin)
