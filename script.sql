CREATE DATABASE IF NOT EXISTS LSFitWell;

CREATE TABLE activitats_raw (
  id_usuari INT,
  data_activitat DATE,
  hora_inici TIME,
  durada_minuts INT,
  tipus_activitat VARCHAR(50),
  calories INT,
  dispositiu VARCHAR(20)
);