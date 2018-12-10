SELECT 'Бобок Олег';
-- 1.1
SELECT * FROM ratings LIMIT 10;
-- 1.2
SELECT * FROM links WHERE imdbid LIKE '%42' AND movieid BETWEEN 1000 AND 10000 LIMIT 10;

-- 2.1
SELECT imdbid AS IMDB_ID FROM links LEFT JOIN ratings ON links.movieid = ratings.movieid WHERE rating = 5 LIMIT 10;

-- 3.1
SELECT count(*) AS films_without_rating FROM links LEFT JOIN ratings ON links.movieid = ratings.movieid WHERE rating IS NULL;
-- 3.2
SELECT userid FROM ratings GROUP BY userid HAVING avg(rating) > 3.5 ORDER BY avg(rating) LIMIT 10;

-- 4.1
SELECT imdbid AS IMDB_ID FROM (SELECT avg(rating) as rating, movieid FROM ratings GROUP BY movieid HAVING avg(rating) > 3.5) avg_ratings LEFT JOIN links ON links.movieid = avg_ratings.movieid LIMIT 10;
-- 4.2
WITH user_ratings AS (
  SELECT userid FROM ratings GROUP BY userid HAVING count(rating) > 10
  )
SELECT avg(rating) FROM ratings WHERE userid in (SELECT userid FROM user_ratings);