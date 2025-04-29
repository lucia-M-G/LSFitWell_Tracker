-- Jordi Fernández Arlegui, Lucía Martínez Gutiérrez, Joan Navío García

DROP PROCEDURE IF EXISTS omplir_cataleg_activitats;

DELIMITER //
CREATE PROCEDURE omplir_cataleg_activitats()
BEGIN
    -- Insertar nuevas actividades que no existan en el catálogo
	INSERT INTO MD_activitat (nom, descripcio)
    SELECT DISTINCT 
        LOWER(TRIM(tipus_activitat)),
        CONCAT('Activitat de tipus: ', tipus_activitat)
    FROM activitats_net
    WHERE 
        tipus_activitat IS NOT NULL 
        AND TRIM(tipus_activitat) != ''
        AND LOWER(TRIM(tipus_activitat)) NOT IN (
            SELECT LOWER(TRIM(nom)) FROM MD_activitat
        );
		
	-- Valor per defecte en cas de NULL
    INSERT INTO MD_activitat (nom, descripcio)
    SELECT 
        'activitat_desconeguda',
        'Activitat no especificada'
    FROM activitats_net
    WHERE 
        (tipus_activitat IS NULL OR TRIM(tipus_activitat) = '')
        AND 'activitat_desconeguda' NOT IN (
            SELECT nom FROM MD_activitat
        )
    LIMIT 1;
    
END //
DELIMITER ;