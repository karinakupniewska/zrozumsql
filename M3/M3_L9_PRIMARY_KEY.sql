CREATE TABLE products (
	id integer,
	description TEXT,
	PRIMARY KEY (id)
);

CREATE TABLE sales (
	id integer PRIMARY KEY
);

CREATE TABLE customers (
	id integer,
	name TEXT 
);

INSERT INTO customers VALUES (NULL, 'Customer 1'), (1, 'Customer 2');

ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY (id);
ALTER TABLE customers ADD PRIMARY KEY (id);

---usuwanie klucza 
ALTER TABLE customers DROP CONSTRAINT customers_pkey;