--визначає актора з найбільшою кількість серіалів за період дат, отриманих в аргументах.
DROP PROCEDURE IF EXISTS best_actor(DATE, DATE);

CREATE OR REPLACE PROCEDURE best_actor(d1 DATE, d2 DATE)
LANGUAGE plpgsql
AS $$
DECLARE actor_series record;
  BEGIN
    FOR actor_series IN SELECT name_actor, COUNT(series_id) as amount
                        FROM people INNER JOIN cast_series ON people.id = cast_series.actor_id
                        INNER JOIN all_series ON cast_series.series_id = all_series.id
                        WHERE d1 <= airing_date AND airing_date <= d2
                        GROUP BY name_actor
                        HAVING COUNT(series_id) = (SELECT COUNT(series_id) 
												   FROM cast_series INNER JOIN all_series ON cast_series.series_id = all_series.id
												   WHERE d1 <= airing_date AND airing_date <= d2
												   GROUP BY cast_series.actor_id
												   ORDER BY COUNT(series_id) DESC
												   LIMIT 1)
    LOOP
      raise notice 'name_actor: %,  count_series: %', actor_series.name_actor,  actor_series.amount;
    END LOOP;
  END;
$$;

CALL best_actor(DATE '2018-12-8', DATE '2022-12-8');