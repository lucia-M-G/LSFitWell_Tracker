-- No creem un segon fitxer CSV doncs no hi ha necessitat, doncs ja podem comrpovar el seu
-- correcte funcionament amb el CSV original

-- 1. Creem tres taules per optimitzar l'espaiutilitzat, una per INSERT de activitats_net
-- una altre pels UPDATE de md_activitat i una última pels DELETE d'aquesta última taula

DROP TABLE IF EXISTS registre_INSERT_activitats_net;

CREATE TABLE IF NOT EXISTS registre_INSERT_activitats_net (
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

DROP TABLE IF EXISTS registre_DELETE_md_activitat;

CREATE TABLE IF NOT EXISTS registre_DELETE_md_activitat (
    -- Dades completes de l'activitat
	id INT,
    nom VARCHAR(50),
    descripcio TEXT,
    
    -- Metadades
    usuari_mysql VARCHAR(100),
    data_hora TIMESTAMP,
    
    -- Detalls addicionals
    canvis_realitzats TEXT,
    
	id_registre INT AUTO_INCREMENT PRIMARY KEY
);

DROP TABLE IF EXISTS registre_UPDATE_md_activitat;

CREATE TABLE IF NOT EXISTS registre_UPDATE_md_activitat (
    -- Dades completes de l'activitat
	NEW_id INT,
    NEW_nom VARCHAR(50),
    NEW_descripcio TEXT,
    
    OLD_id INT,
    OLD_nom VARCHAR(50),
    OLD_descripcio TEXT,
    
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
		INSERT INTO registre_INSERT_activitats_net (
			id_usuari, data_activitat, hora_inici,
			durada_minuts, tipus_activitat, calories, dispositiu, es_cap_setmana,
			usuari_mysql, data_hora, canvis_realitzats
		)
		VALUES (
			NEW.id_usuari, NEW.data_activitat, NEW.hora_inici,
			NEW.durada_minuts, NEW.tipus_activitat, NEW.calories, NEW.dispositiu, NEW.es_cap_setmana,
			CURRENT_USER(), NOW(), 'Nova activitat registrada'
		);
	END //
DELIMITER ;


-- 3. Tigger per modificacions

DROP TRIGGER IF EXISTS md_activitat_update;

DELIMITER //
CREATE TRIGGER md_activitat_update
	BEFORE UPDATE ON MD_activitat
	FOR EACH ROW
	BEGIN
		DECLARE cambios TEXT;
		
		-- Detectar cambios específicos
		SET cambios = '';
		IF OLD.nom != NEW.nom THEN
			SET cambios = CONCAT(cambios, 'Antic nom: "', OLD.nom, '"Nou nom: "', NEW.nom, '"\n'); -- Miramos la FK
		END IF;
		
		IF OLD.descripcio != NEW.descripcio THEN
			SET cambios = CONCAT(cambios, 'Descripció modificada\n'); -- Miramos la descipcion
		END IF;
		
		-- Registrar solo si hay cambios reales
		IF cambios != '' THEN
			INSERT INTO registre_UPDATE_md_activitat (
				
			)
			VALUES (
				
			);
		END IF;
	END //
DELIMITER ;



-- 4. Triger d'eliminacion

DROP TRIGGER IF EXISTS md_activitat_delete;

DELIMITER //
CREATE TRIGGER md_activitat_delete
	BEFORE DELETE ON MD_activitat
	FOR EACH ROW
	BEGIN
		INSERT INTO registre_DELETE_md_activitat (
			
		)
		VALUES (
			
		);
	END //
DELIMITER ;


SELECT *
	FROM registre_canvis;