--1.Оконные функции
--    1.1
SELECT 
userId,
 movieId, 
(rating - MIN(rating) OVER (PARTITION BY userId))/( MAX(rating) OVER (PARTITION BY userId) - MIN(rating) OVER (PARTITION BY userId)) as normed_rating,
AVG(rating) OVER (PARTITION BY userId) as average_rating
FROM ratings
LIMIT 30;
