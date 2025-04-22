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
	TRUNCATE TABLE activitats_net;
	
    INSERT INTO activitats_net
		SELECT id_usuari, data_activitat, hora_inici, durada_minuts, 
			tipus_activitat, calories, dispositiu,
			DAYOFWEEK(data_activitat) IN (1,7) AS es_cap_setmana
		FROM activitats_raw
		WHERE data_activitat = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
    
    INSERT INTO control_carregues
		VALUES ('C:/Users/jordi/Documents/GitHub/LSFitWell_Tracker/activitats.csv', 100, NOW());
		
    
    
END //
DELIMITER ;

CALL netejar_dades();

SELECT *
	FROM control_carregues;