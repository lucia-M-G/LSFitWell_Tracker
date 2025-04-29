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