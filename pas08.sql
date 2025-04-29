-- Jordi Fernández Arlegui, Lucía Martínez Gutiérrez, Joan Navío García

-- 1. Creació dels usuaris en localhost per seguretat
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
GRANT SELECT, INSERT, UPDATE, DELETE ON LSFitWell.activitats_raw TO 'lsfit_data_loader'@'localhost';
GRANT FILE ON *.* TO 'lsfit_data_loader'@'localhost'; -- Permet carregar arxius

-- 3. Permisos per a lsfit_user
-- Permet executar estructures (ALTER, INDEX, etc.) però no crear-les (CREATE)
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX, REFERENCES, 
      CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, SHOW VIEW
      ON LSFitWell.* TO 'lsfit_user'@'localhost';
GRANT FILE ON *.* TO 'lsfit_user'@'localhost'; -- Permet generar fitxers

-- 4. Permisos per a lsfit_backup
-- Llegir tot a LSFitWell i tot (menys GRANT) a la BD de backup
GRANT SELECT ON LSFitWell.* TO 'lsfit_backup'@'localhost';
GRANT ALL PRIVILEGES ON lsfitwell_backup.* TO 'lsfit_backup'@'localhost';

-- 5. Permisos per a lsfit_auditor
-- Només lectura a totes les BD
GRANT SELECT ON LSFitWell.* TO 'lsfit_auditor'@'localhost';
GRANT SELECT ON lsfitwell_backup.* TO 'lsfit_auditor'@'localhost';

-- 6. Permisos per a lsfit_admin
-- Tots els permisos a ambdues BD
GRANT ALL PRIVILEGES ON LSFitWell.* TO 'lsfit_admin'@'localhost';
GRANT ALL PRIVILEGES ON lsfitwell_backup.* TO 'lsfit_admin'@'localhost';

-- Actualitzar permisos
FLUSH PRIVILEGES;

-- 7. Proves de validació dels permisos (executar amb cada usuari per verificar)

-- Prova per lsfit_data_loader (hauria de funcionar):
-- SELECT * FROM LSFitWell.activitats_raw LIMIT 5;
-- INSERT INTO LSFitWell.activitats_raw VALUES (...);
-- No hauria de poder: SELECT * FROM LSFitWell.activitats_net;

-- Prova per lsfit_user (hauria de funcionar):
-- CALL LSFitWell.netejar_dades();
-- SELECT * FROM LSFitWell.activitats_net;
-- No hauria de poder: CREATE DATABASE nova_db;

-- Prova per lsfit_backup (hauria de funcionar):
-- SELECT * FROM lsfitwell_backup.activitats_net_20240501;
-- CREATE TABLE lsfitwell_backup.prova (id INT);
-- No hauria de poder: GRANT SELECT ON *.* TO 'algu'@'localhost';

-- Prova per lsfit_auditor (hauria de funcionar):
-- SELECT * FROM LSFitWell.control_carregues;
-- No hauria de poder: INSERT INTO LSFitWell.control_carregues VALUES (...);

-- Prova per lsfit_admin (hauria de funcionar):
-- CREATE TABLE LSFitWell.nova_taula (id INT);
-- DROP TABLE lsfitwell_backup.prova;
-- No hauria de poder: CREATE USER 'nou_usuari'@'localhost'; (a menys que s'afegeixi GRANT OPTION)