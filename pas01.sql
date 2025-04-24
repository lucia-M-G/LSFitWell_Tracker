CREATE DATABASE IF NOT EXISTS LSFitWell;

TRUNCATE TABLE activitats_raw;

CREATE TABLE IF NOT EXISTS activitats_raw (
	id_usuari INT,
	data_activitat DATE,
	hora_inici TIME,
	durada_minuts INT,
	tipus_activitat VARCHAR(50),
	calories INT,
	dispositiu VARCHAR(20)
);

LOAD DATA INFILE 'C:/Users/jordi/Documents/GitHub/LSFitWell_Tracker/activitats.csv'
	INTO TABLE activitats_raw
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 2 ROWS;

SELECT COUNT(*)
	FROM activitats_raw;

SELECT *
	FROM activitats_raw;