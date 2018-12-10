SELECT 'Олег Бобок';

-- Create window function
SELECT ratings.userid, ratings.movieid, ((normed.rating - normed.min_rating)/(normed.max_rating - normed.min_rating)::numeric) AS normed_rating, avg(ratings.rating) OVER (PARTITION BY ratings.userid) AS avg_rating
FROM ratings LEFT JOIN (
  SELECT userid, movieid, rating, min(rating) OVER (PARTITION BY userid) AS min_rating, max(rating) OVER (PARTITION BY userid) AS max_rating
  FROM ratings
  ) AS normed ON normed.userid = ratings.userid AND normed.movieid = ratings.movieid
LIMIT 30;

-- Create table
CREATE TABLE keywords (movieid bigint, tags text);

-- Fill table
-- External. See 3.sh
--

-- 3
WITH top_rated AS (
  SELECT movieid, avg(rating) AS avg_rating
  FROM ratings
  GROUP BY movieid HAVING count(rating) > 50
  ORDER BY avg_rating DESC, movieid ASC
  LIMIT 150
)
SELECT top_rated.*, keywords.tags AS top_rated_tags INTO top_rated_tags FROM top_rated LEFT JOIN keywords ON keywords.movieid = top_rated.movieid;

-- Export to file
-- External. See 3_1.sh