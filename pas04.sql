DROP TABLE IF EXISTS MD_activitat;

CREATE TABLE MD_activitat (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(50) UNIQUE,
	descripcio TEXT
);

DROP PROCEDURE IF EXISTS omplir_cataleg_activitats;

DELIMITER //
CREATE PROCEDURE omplir_cataleg_activitats()
BEGIN
    -- Insertar nuevas actividades que no existan en el catálogo
	INSERT INTO MD_activitat (nom, descripcio)
    SELECT DISTINCT tipus_activitat, 
           CONCAT('Activitat de tipus: ', tipus_activitat)
    FROM activitats_net
    WHERE tipus_activitat NOT IN (SELECT nom FROM MD_activitat)
		AND tipus_activitat IS NOT NULL
		AND tipus_activitat != '';
    
END //
DELIMITER ;

DROP EVENT IF EXISTS evento_netejar_dades;

DELIMITER //
	CREATE EVENT evento_netejar_dades
	ON SCHEDULE
		EVERY 1 DAY
		STARTS NOW()
	DO
	BEGIN
		TRUNCATE TABLE activitats_net;
		CALL netejar_dades();
        CALL omplir_cataleg_activitats();
	END //
DELIMITER ;

SELECT *
	FROM MD_activitat;