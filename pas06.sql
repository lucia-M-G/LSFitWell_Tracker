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
    
    PRIMARY KEY (data_hora, usuari_mysql, taula_origen)
);

-- 2. Trigger per insercions

DROP TRIGGER audit_activitats_simple_insert;

DELIMITER //
CREATE TRIGGER audit_activitats_simple_insert
AFTER INSERT ON activitats_net
FOR EACH ROW
BEGIN
    INSERT INTO audit_activitats_simplificada (
        accio, taula_origen, id_usuari, data_activitat, hora_inici,
        durada_minuts, tipus_activitat, calories, dispositiu, es_cap_setmana,
        usuari_mysql, data_hora, canvis_realitzats
    )
    VALUES (
        'INSERT', 'activitats_net', activitats_net.id_usuari, activitats_net.data_activitat, activitats_net.hora_inici,
        activitats_net.durada_minuts, activitats_net.tipus_activitat, activitats_net.calories, activitats_net.dispositiu, activitats_net.es_cap_setmana,
        CURRENT_USER(), NOW(), 'Nova activitat registrada'
    );
END //
DELIMITER ;
