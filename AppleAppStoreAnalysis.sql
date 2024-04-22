CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1
UNION ALL

SELECT * FROM appleStore_description2
UNION ALL

SELECT * FROM appleStore_description3
UNION ALL

SELECT * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

--Check number of unique apps in table

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc is NULL 

--Find out the number of apps per genre
SELECT prime_genre, COUNT(*) as NumApps
from AppleStore
group BY prime_genre
ORDER by NumApps DESC

--Get an overview of app ratings
select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore       

**Data Analysis**

--Determine whether paid apps have higher rating than free apps

SELECT CASE
			when price > 0 then 'Paid'
            ELSE 'Free'
         END as App_type,
         avg(user_rating) as AvgRating
from AppleStore
group by App_type
            
--Check if apps that support more languages have higher ratingAppleStore

SELECT CASE
			when lang_num < 10 then '10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            ELSE '>30 languages'
         END as Language_bucket,
         avg(user_rating) as AvgRating
from AppleStore
group by Language_bucket
ORder by AvgRating DESC

--Check genres with low ratings

select prime_genre,
	   avg(user_rating) as AvgRating
from AppleStore
group by prime_genre
order by AvgRating Asc
limit 10

--Check the correlation between app descritption length and user ratings

SELECT CASE
			when length(b.app_desc) < 500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
       End as description_length_bucket,
       avg(a.user_rating) as AvgRating
       
from 
	 AppleStore as a
JOIN
	 applestore_description_combined as b
on 
	 a.id = b.id
    
group by description_length_bucket
order by AvgRating DESC

--Check the top rated apps by each genre

SELECT
	prime_genre,
    track_name,
    user_rating
    
from(
  	  SELECT
  	  prime_genre,
  	  track_name,
  	  user_rating,
	  RANK() OVER(PARTITION BY prime_genre order by user_rating DESC, rating_count_tot desc) as RANK
  	  from 
  	  AppleStore
    ) as a
WHERE
a.rank = 1
  
  