DROP TABLE control_carregues;

CREATE TABLE control_carregues (
	nom_fitxer VARCHAR(100),
	num_files INT,
	data_hora TIMESTAMP
);



DROP PROCEDURE IF EXISTS netejar_dades;

DELIMITER //
CREATE PROCEDURE netejar_dades()
BEGIN
    DECLARE num_registres INT;

	TRUNCATE TABLE activitats_net;
	
    INSERT INTO activitats_net
		SELECT id_usuari, data_activitat, hora_inici, durada_minuts, 
			tipus_activitat, calories, dispositiu,
			DAYOFWEEK(data_activitat) IN (1,7) AS es_cap_setmana
		FROM activitats_raw
		WHERE data_activitat = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
    
	
    SELECT COUNT(*) INTO num_registres FROM activitats_net;
    
    INSERT INTO control_carregues
		VALUES ('C:/Users/jordi/Documents/GitHub/LSFitWell_Tracker/activitats.csv', 
			num_registres, NOW());
		
END //
DELIMITER ;


-- Event del pas02 sense modificar

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
	FROM control_carregues;