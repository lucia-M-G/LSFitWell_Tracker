-- Jordi Fernández Arlegui, Lucía Martínez Gutiérrez, Joan Navío García

-- 1. Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS lsfitwell;

-- 2. Seleccionar la base de datos
USE lsfitwell;

-- 3. Creació de la taula temporal activitats_raw
DROP TABLE IF EXISTS activitats_raw;

CREATE TABLE activitats_raw (
    id_usuari INT,
    data_activitat DATE,
    hora_inici TIME,
    durada_minuts INT,
    tipus_activitat VARCHAR(50),
    calories INT,
    dispositiu VARCHAR(50)
);

-- 4. Càrrega de dades des del fitxer CSV
LOAD DATA LOCAL INFILE 'C:\Users\Administrador\Desktop\LaSalle\WebDigitalització\Practica CV\LSFitWell_Tracker\activitats.csv'
INTO TABLE activitats_raw
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
-- Ignora la capçalera del CSV
IGNORE 3 ROWS;

-- 5. Verificació de la càrrega
SELECT COUNT(*) AS total_registres FROM activitats_raw;