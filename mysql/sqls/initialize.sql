
DROP DATABASE IF EXISTS myapp;

GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'johnahn' WITH GRANT OPTION;

CREATE DATABASE myapp;
USE myapp;

CREATE TABLE lists(
    id INTEGER AUTO_INCREMENT,
    value TEXT,
    PRIMARY KEY (id)
);

