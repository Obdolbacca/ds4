SELECT 'Олег Бобок' as student;

-- 4.0
SELECT nspname || '.' || relname                         AS "relation",
       pg_size_pretty(pg_total_relation_size(klass.oid)) AS "size"
FROM pg_catalog.pg_class klass
       LEFT JOIN pg_catalog.pg_namespace namespace ON (namespace.oid = klass.relnamespace)
WHERE nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
  AND klass.relkind = 'r'
ORDER BY pg_relation_size(klass.oid) DESC
LIMIT 5;

-- 4.1
SELECT userid, array_agg(movieId) as user_views
FROM ratings
WHERE userid = 1
GROUP BY userid;

-- 4.2
SELECT userid, array_agg(movieId) as user_views INTO TABLE user_movies_agg
FROM ratings
GROUP BY userid;

-- 4.3
CREATE OR REPLACE FUNCTION cross_arr(bigint[], bigint[])
  RETURNS bigint[]
  language sql as
$$
SELECT array_agg(rec)::bigint[]
FROM (SELECT unnest($1) intersect SELECT unnest($2)) arr(rec);
$$;

WITH user_pairs as (SELECT userid, user_views AS movie_array FROM user_movies_agg)
SELECT a.userid AS u1, b.userid AS u2, cross_arr(a.movie_array, b.movie_array) AS crossed_array
INTO TABLE common_user_views
FROM user_pairs a
       LEFT JOIN user_pairs b ON a.userid != b.userid;

SELECT u1, u2, cross_arr(ar1, ar2) AS crossed_arr
FROM common_user_views
GROUP BY (u1, u2)
ORDER BY (array_length(cross_arr(ar1, ar2), 1));

SELECT * FROM common_user_views
WHERE crossed_array IS NOT NULL
ORDER BY array_length(crossed_array, 1) DESC
LIMIT 10;

CREATE OR REPLACE FUNCTION diff_arr(bigint[], bigint[])
  RETURNS bigint[]
  language sql as
$$
SELECT array_agg(rec)::bigint[]
FROM (SELECT unnest($1) EXCEPT SELECT unnest($2)) arr(rec);
$$;

SELECT uma.userid AS userid, cuv.u2 as recommendation_source, diff_arr(uma.user_views, cuv.crossed_array) as recommended_arr
FROM common_user_views cuv
LEFT JOIN user_movies_agg uma
ON cuv.u1 = uma.userid;
