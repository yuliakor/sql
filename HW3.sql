
SELECT 'ФИО: Корнеева Юлия';

--1.Простые выборки
--    1.1
SELECT *
FROM public.ratings LIMIT 10;
--    1.2
 SELECT *
 FROM public.links
 WHERE
 imdbId like '%42' AND
 movieid >=100 AND movieid <= 1000;
 
 
 -- 2.Сложные выборки: JOIN
  --    2.1
 SELECT imdbId
 FROM public.links
 INNER JOIN  public.ratings
    ON links.movieid=ratings.movieid
 WHERE ratings.rating= 5
 LIMIT 10;
  

 -- 3. Аггрегация данных 
   -- 3.1

SELECT  COUNT(*)
FROM public.links
LEFT JOIN public.ratings
ON links.movieid=ratings.movieid
WHERE ratings.movieid IS NULL;
   -- 3.2
SELECT
    userId,
    AVG(rating) as avg_rating
FROM public.ratings
GROUP BY userId
HAVING AVG(rating) > 3.5
ORDER BY avg_rating DESC
LIMIT 10;

 
 --  4. Иерархические запросы
   -- 4.1
 SELECT imdbId
 FROM links JOIN ratings ON links.movieid=ratings.movieid
 GROUP BY movieid
 HAVING AVG(rating) > 3.5
 limit 10;


  --4.2
WITH tab1 AS (
   SELECT userid,
   AVG(rating) as average
   FROM public.ratings
   GROUP BY userid
    HAVING COUNT(userid) > 10
)
  SELECT 
  AVG(average)
  FROM tab1;
