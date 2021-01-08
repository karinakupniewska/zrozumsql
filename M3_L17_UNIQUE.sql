CREATE TABLE sales (
	id integer NOT NULL,
	description TEXT unique
);

---wstawianie do tabeli z ograniczniem UNIQUE
INSERT INTO sales VALUES (1,'abc');
INSERT INTO sales VALUES (2,NULL);
INSERT INTO sales VALUES (3,NULL);
INSERT INTO sales VALUES (4,'abc'); ---nie można wprowadzić tego rekordu, bo juz jest w tabeli wartość 'abc', a description ma być unikatowe

---inny sposób - kombinacja na 2 kolumnach
CREATE TABLE products (
	id integer NOT NULL,
	product_short_code varchar(10),
	product_no varchar(5),
	UNIQUE(product_short_code, product_no) ---kombinacja tych dwóch atrybutów musi być unikatowa w obrębie tej tabeli
);

---ograniczeni UNIQUE można usunąć tak jak inne ograniczenia przez alter table i drop constraint