TRUNCATE TABLE activitats_net;

CREATE TABLE IF NOT EXISTS activitats_net (
    id_usuari INT,
    data_activitat DATE,
    hora_inici TIME,
    durada_minuts INT,
    tipus_activitat VARCHAR(50),
    calories INT,
	dispositiu VARCHAR(20)
);

ALTER TABLE activitats_net
	ADD COLUMN es_cap_setmana BOOLEAN;



DROP PROCEDURE IF EXISTS netejar_dades;

DELIMITER //
CREATE PROCEDURE netejar_dades()
BEGIN
	TRUNCATE TABLE activitats_net;
	
    INSERT INTO activitats_net
		SELECT id_usuari, data_activitat, hora_inici, durada_minuts, 
			tipus_activitat, calories, dispositiu,
			DAYOFWEEK(data_activitat) IN (1,7) AS es_cap_setmana
		FROM activitats_raw
		WHERE data_activitat = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
END //
DELIMITER ;



SET GLOBAL event_scheduler=ON;

DROP EVENT evento_netejar_dades;

DELIMITER //
	CREATE EVENT evento_netejar_dades
	ON SCHEDULE
		EVERY 1 DAY
		STARTS NOW()
	DO
	BEGIN
		TRUNCATE TABLE activitats_net;
		CALL netejar_dades();
	END //
DELIMITER ;



CALL netejar_dades();

SELECT *
	FROM activitats_net;