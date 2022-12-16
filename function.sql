--визначає вік акторів на момент виходу серіалу
DROP FUNCTION IF EXISTS age_actor(id_serie integer);
CREATE OR REPLACE FUNCTION age_actor(id_serie integer)
    RETURNS TABLE (actor_id integer, series_id integer, age integer)
    LANGUAGE 'plpgsql'
AS $$
BEGIN 
    RETURN QUERY
        SELECT cast_series.actor_id::integer, cast_series.series_id::integer,
        extract(year from AGE(airing_date::DATE, birthday::DATE))::integer AS age
        FROM all_series INNER JOIN cast_series ON all_series.id=cast_series.series_id
        INNER JOIN people ON cast_series.actor_id=people.id
		WHERE cast_series.series_id = id_serie;
END;
$$; 

SELECT * FROM age_actor(112888);