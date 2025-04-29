-- Jordi Fernández Arlegui, Lucía Martínez Gutiérrez, Joan Navío García

-- 1. Creació dels usuaris
DROP USER IF EXISTS 'lsfit_data_loader'@'localhost';
DROP USER IF EXISTS 'lsfit_user'@'localhost';
DROP USER IF EXISTS 'lsfit_backup'@'localhost';
DROP USER IF EXISTS 'lsfit_auditor'@'localhost';
DROP USER IF EXISTS 'lsfit_admin'@'localhost';

CREATE USER 'lsfit_data_loader'@'localhost' IDENTIFIED BY 'LoaderPass123!';
CREATE USER 'lsfit_user'@'localhost' IDENTIFIED BY 'UserPass123!';
CREATE USER 'lsfit_backup'@'localhost' IDENTIFIED BY 'BackupPass123!';
CREATE USER 'lsfit_auditor'@'localhost' IDENTIFIED BY 'AuditorPass123!';
CREATE USER 'lsfit_admin'@'localhost' IDENTIFIED BY 'AdminPass123!';

-- 2. Permisos per a lsfit_data_loader
GRANT SELECT, INSERT, UPDATE, DELETE ON lsfitwell.activitats_raw TO 'lsfit_data_loader'@'localhost';
GRANT FILE ON *.* TO 'lsfit_data_loader'@'localhost';

-- 3. Permisos per a lsfit_user
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX, REFERENCES, 
      CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, SHOW VIEW
      ON lsfitwell.* TO 'lsfit_user'@'localhost';
GRANT FILE ON *.* TO 'lsfit_user'@'localhost';

-- 4. Permisos per a lsfit_backup
GRANT SELECT ON lsfitwell.* TO 'lsfit_backup'@'localhost';
GRANT ALL PRIVILEGES ON lsfitwell_backup.* TO 'lsfit_backup'@'localhost';

-- 5. Permisos per a lsfit_auditor
GRANT SELECT ON lsfitwell.* TO 'lsfit_auditor'@'localhost';
GRANT SELECT ON lsfitwell_backup.* TO 'lsfit_auditor'@'localhost';

-- 6. Permisos per a lsfit_admin
GRANT ALL PRIVILEGES ON lsfitwell.* TO 'lsfit_admin'@'localhost';
GRANT ALL PRIVILEGES ON lsfitwell_backup.* TO 'lsfit_admin'@'localhost';

FLUSH PRIVILEGES;

-- 7. PROVES DE VALIDACIÓ ADAPTADES A L'ESTRUCTURA ACTUAL

-- Comprovar que els permisos s'han aplicat correctament
SELECT user, host FROM mysql.user WHERE user LIKE 'lsfit_%';

-- Mostrar els permisos per a cada usuari
SHOW GRANTS FOR 'lsfit_data_loader'@'localhost';
SHOW GRANTS FOR 'lsfit_user'@'localhost';
SHOW GRANTS FOR 'lsfit_backup'@'localhost';
SHOW GRANTS FOR 'lsfit_auditor'@'localhost';
SHOW GRANTS FOR 'lsfit_admin'@'localhost';

-- Script de proves per executar amb cada usuari:

DELIMITER //
CREATE PROCEDURE test_permissions()
BEGIN
    DECLARE user_count INT;
    
    -- Prova per lsfit_data_loader
    -- Hauria de poder fer:
    SELECT 'TESTING lsfit_data_loader' AS test;
    SELECT COUNT(*) INTO user_count FROM lsfitwell.activitats_raw LIMIT 1;
    SELECT CONCAT('Accés a activitats_raw OK: ', user_count, ' registres') AS result;
    
    -- Hauria de fallar:
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1142 SELECT 'Accés denegat a activitats_net (CORRECTE)' AS result;
        SELECT COUNT(*) FROM lsfitwell.activitats_net;
    END;
    
    -- Prova per lsfit_user
    -- Hauria de poder fer:
    SELECT 'TESTING lsfit_user' AS test;
    SELECT COUNT(*) INTO user_count FROM lsfitwell.activitats_net LIMIT 1;
    SELECT CONCAT('Accés a activitats_net OK: ', user_count, ' registres') AS result;
    
    -- Hauria de fallar:
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1142 SELECT 'No pot crear taules noves (CORRECTE)' AS result;
        CREATE TABLE lsfitwell.nova_taula_test (id INT);
    END;
    
    -- Prova per lsfit_backup
    -- Hauria de poder fer:
    SELECT 'TESTING lsfit_backup' AS test;
    SELECT COUNT(*) INTO user_count FROM lsfitwell.activitats_net LIMIT 1;
    SELECT CONCAT('Lectura a lsfitwell OK: ', user_count, ' registres') AS result;
    
    -- Hauria de fallar:
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1142 SELECT 'No pot modificar dades a lsfitwell (CORRECTE)' AS result;
        UPDATE lsfitwell.activitats_net SET calories = 100 WHERE id_usuari = 1;
    END;
    
    -- Prova per lsfit_auditor
    -- Hauria de poder fer:
    SELECT 'TESTING lsfit_auditor' AS test;
    SELECT COUNT(*) INTO user_count FROM lsfitwell.activitats_net LIMIT 1;
    SELECT CONCAT('Lectura a activitats_net OK: ', user_count, ' registres') AS result;
    
    -- Hauria de fallar:
    BEGIN
        DECLARE CONTINUE HANDLER FOR 1142 SELECT 'No pot inserir dades (CORRECTE)' AS result;
        INSERT INTO lsfitwell.activitats_net (id_usuari) VALUES (99);
    END;
    
    -- Prova per lsfit_admin
    -- Hauria de poder fer:
    SELECT 'TESTING lsfit_admin' AS test;
    
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SELECT 'Error inesperat' AS result;
        CREATE TABLE IF NOT EXISTS lsfitwell.test_admin_permisos (id INT);
        INSERT INTO lsfitwell.test_admin_permisos VALUES (1);
        SELECT 'Admin pot crear/modificar taules (CORRECTE)' AS result;
        DROP TABLE IF EXISTS lsfitwell.test_admin_permisos;
    END;
END //
DELIMITER ;