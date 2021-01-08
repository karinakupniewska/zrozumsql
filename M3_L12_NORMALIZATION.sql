CREATE TABLE contacts (
    name_surname TEXT,
	gender TEXT,
	city TEXT,
	country TEXT,
	id_company INTEGER,
	company TEXT,
	added_by TEXT,
	verified_by TEXT
);

INSERT INTO contacts 
	  VALUES ('Krzysztof Bury', 'M', 'Kraków', 'Polska', 1, 'Data Craze', 'admin', null),
	  		 ('Katarzyna Kowalska', 'F', 'Ateny', 'Polska', 2, 'ACME', 'admin', null);

DELETE FROM contacts;

-- 1 NF
--Tabela musi być relacją i nie może zawierać żadnych powtarzających się grup.
ALTER TABLE contacts DROP name_surname;
ALTER TABLE contacts ADD name TEXT;
ALTER TABLE contacts ADD surname TEXT PRIMARY KEY;

DELETE FROM contacts;
INSERT INTO contacts 
	  VALUES ('M', 'Kraków', 'Polska', 1, 'Data Craze', 'admin', NULL, 'Krzysztof','Bury'),
	  		 ('F', 'Ateny', 'Polska', 2, 'ACME', 'admin', NULL, 'Katarzyna','Kowalska');
	  		
/*2NF
Tabela jest w 1 postaci normalnej, i posiada dokładnie jeden klucz kandydat
(candidate key, który jest tym samym kluczem głównym - primary key) 
i nie jest on kluczem złożonym (składa się z 1 kolumny).
*/
CREATE TABLE customer_gender (
	cust_surname TEXT, 
    gender TEXT
);

INSERT INTO customer_gender VALUES ('Kowalska','F'), 
								   ('Bury','M');

ALTER TABLE contacts DROP gender;

-- 3 NF
-- Wszystkie atrybuty spoza klucza muszą zależeć od klucza danej tabeli.

CREATE TABLE company (
	id integer,
	company_name TEXT
);

INSERT INTO company VALUES (1, 'Data Craze'), 
						   (2, 'ACME');

ALTER TABLE contacts DROP company;

-- 3.5 Boyce Codd
-- Wszystkie atrybuty również te należące do klucza muszą zależeć od klucza danej tabeli.

CREATE TABLE city_country (
	city TEXT,
	country TEXT
); 

INSERT INTO city_country VALUES ('Kraków', 'Polska'), 
						   		('Ateny', 'Polska');

ALTER TABLE contacts DROP country;

-- 4NF
-- Każda tabela, która w założeniu ma reprezentować 
-- Wiele relacji wiele-do-wielu, narusza reguły czwartej postaci normalnej.
CREATE TABLE contacts_verified_by (
	cust_surname TEXT,
	verified_by TEXT
);

CREATE TABLE contacts_added_by (
	cust_surname TEXT,
	added_by TEXT
);

INSERT INTO contacts_verified_by 
     VALUES ('Kowalska','admin'), 
  			('Bury','admin');

ALTER TABLE contacts DROP added_by;
ALTER TABLE contacts DROP verified_by;

-- 5NF
-- każda tabela, która spełnia kryteria postaci normalnej Boyce'a - Codda 
-- i nie zawiera złożonego klucza głównego, znajduje się w piątej postaci normalnej.

-- 5.5NF
-- każde ograniczenie w tabeli musi być logiczną konsekwencją ograniczeń dziedziny tabeli i ograniczeń kluczy.

-- 6 NF
-- jeżeli oprócz atrybutu, który jest jednocześnie kluczem głównym, 
-- posiada maksymalnie 1 dodatkowy atrybut.