-- 1. Crear taula d'auditoria sense IDs artificials

DROP TABLE registre_canvis;

CREATE TABLE IF NOT EXISTS registre_canvis (
    accio VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    taula_origen VARCHAR(20) NOT NULL, -- 'activitats_net' o 'MD_activitat'
    
    -- Dades completes de l'activitat
    id_usuari INT,
    data_activitat DATE,
    hora_inici TIME,
    durada_minuts INT,
    tipus_activitat VARCHAR(50),
    calories INT,
    dispositiu VARCHAR(20),
    es_cap_setmana BOOLEAN,
    
    -- Metadades
    usuari_mysql VARCHAR(100),
    data_hora TIMESTAMP,
    
    -- Detalls addicionals
    canvis_realitzats TEXT,
    
    id_registre INT AUTO_INCREMENT PRIMARY KEY
);

-- 2. Trigger per insercions

DROP TRIGGER IF EXISTS registre_canvis_insert;

DELIMITER //
CREATE TRIGGER registre_canvis_insert
	AFTER INSERT ON activitats_net
	FOR EACH ROW
	BEGIN
		INSERT INTO registre_canvis (
			accio, taula_origen, id_usuari, data_activitat, hora_inici,
			durada_minuts, tipus_activitat, calories, dispositiu, es_cap_setmana,
			usuari_mysql, data_hora, canvis_realitzats
		)
		VALUES (
			'INSERT', 'activitats_net', NEW.id_usuari, NEW.data_activitat, NEW.hora_inici,
			NEW.durada_minuts, NEW.tipus_activitat, NEW.calories, NEW.dispositiu, NEW.es_cap_setmana,
			CURRENT_USER(), NOW(), 'Nova activitat registrada'
		);
	END //
DELIMITER ;



SELECT *
	FROM registre_canvis;