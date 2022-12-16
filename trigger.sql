DROP TRIGGER IF EXISTS value_insert ON all_series;

-- Перший етап: створення тригерної функції
CREATE OR REPLACE FUNCTION value_adding() RETURNS trigger 
LANGUAGE 'plpgsql'
AS
$$
     BEGIN
          UPDATE all_series
          SET name_series = upper(name_series)
          WHERE all_series.id = NEW.id; 
		  RETURN NULL; -- result is ignored since this is an AFTER trigger
     END;
$$;

--DROP FUNCTION IF EXISTS value_adding();

-- створення тригеру
CREATE TRIGGER value_insert 
AFTER INSERT ON all_series
FOR EACH ROW EXECUTE FUNCTION value_adding();

--перевірка
INSERT INTO all_series(id, name_series, airing_date)
VALUES (2000345, 'yama', Date '1999.12.18');

select * from all_series;

DELETE FROM all_series where id = 2000345;