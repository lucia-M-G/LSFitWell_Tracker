-- Jordi Fernández Arlegui, Lucía Martínez Gutiérrez, Joan Navío García

-- 1. Crear la base de dades de backup
CREATE DATABASE IF NOT EXISTS lsfitwell_backup;

-- 2. Procediment amb bucle per copiar totes les taules automàticament
DROP PROCEDURE IF EXISTS fer_copia_seguretat;

DELIMITER //
CREATE PROCEDURE fer_copia_seguretat()
BEGIN
    -- Declaració de variables
    DECLARE nom_taula VARCHAR(100);          -- Emmagatzema el nom de cada taula
    DECLARE done BOOLEAN DEFAULT FALSE;      -- Controla el final del cursor
    
    -- Cursor per obtenir noms de taules
    DECLARE cur CURSOR FOR 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = DATABASE();     -- Obtenir totes les taules de la BD actual
    
    -- Handler per detectar final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Configuració inicial
    SET @sufix_data = DATE_FORMAT(NOW(), '%Y%m%d');  -- Data actual com a sufix
    OPEN cur;  -- Obrim el cursor
    
    -- Bucle per processar cada taula
    bucle_lectura: WHILE 1=1 DO
        FETCH cur INTO nom_taula;  -- Obtenim el nom de la taula
        
        IF done THEN  -- Si hem arribat al final
            LEAVE bucle_lectura;  -- Sortim del bucle
        END IF;
        
        -- Creem la consulta SQL dinàmica per copiar la taula
        SET @consulta = CONCAT('CREATE TABLE lsfitwell_backup.', nom_taula, '_', @sufix_data,
                              ' SELECT * FROM ', nom_taula);
        
        -- Executem la consulta
        PREPARE stmt FROM @consulta;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;  -- Alliberem recursos
    END WHILE bucle_lectura;
    
    CLOSE cur;  -- Tanquem el cursor
END //
DELIMITER ;

-- 3. Esdeveniment programat (diumenges a les 23:00 durant 2025)

DROP EVENT IF EXISTS esdeveniment_copia_setmanal;

DELIMITER //
CREATE EVENT esdeveniment_copia_setmanal
ON SCHEDULE
    EVERY 1 WEEK
    STARTS NOW()  
    ENDS '2025-12-31 23:00:00'    
DO
BEGIN
    CALL fer_copia_seguretat();
END //
DELIMITER ;


-- --
SET GLOBAL event_scheduler = ON;

-- Test
SELECT *
	FROM activitats_raw_20250426;