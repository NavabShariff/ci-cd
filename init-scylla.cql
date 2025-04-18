CREATE KEYSPACE IF NOT EXISTS employee_db
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE employee_db;

DROP TABLE IF EXISTS employee_salary;

CREATE TABLE employee_salary (
    id text PRIMARY KEY,
    name text,
    salary float,
    process_date text,
    status text
);