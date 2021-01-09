
CREATE SCHEMA trainig;

ALTER SCHEMA trainig RENAME TO training;

CREATE TABLE new_table (id integer);

ALTER TABLE new_table RENAME TO newer_table; 

ALTER TABLE newer_table 
	ADD COLUMN description TEXT;

ALTER TABLE newer_table 
	RENAME description TO descr;

ALTER TABLE newer_table 
	DROP descr;

ALTER TABLE newer_table 
	DROP id;