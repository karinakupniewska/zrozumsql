---CASCADE pozwala na usunięcie elementów zależnych od danego obiektu, który usuwamy/wprowadzamy zmianę
CREATE SCHEMA training;

CREATE TABLE training.sales (id integer);

---poniższe zapytanie się nie wykona, ponieważ w schemacie training jest tabela
DROP SCHEMA training;

---

---można usunąć schemat training przy pomocy CASCADE, ale usuniemy wszystkie obiekty powiązane z tym schematem czyli usunie się też tabela
DROP SCHEMA training CASCADE;

CREATE TABLE products (id integer PRIMARY KEY);
CREATE TABLE sales (id integer PRIMARY KEY, 
				    product_id integer REFERENCES products);

INSERT INTO products VALUES (1);
INSERT INTO sales VALUES (1,1), (2,1);

--nie da się wykonać poniżego query, bo jest na tej tabeli klucz obcy i są z tą tabelą powiązane elementy (czyli te elementy to rekordy z tabeli sales) 
DROP TABLE products;

---
---używając poniższego query usuniemy tebelę products, ale tabela sales zostanie -znika nam klucz obcy z tabeli products, która zostaje usunięta

DROP TABLE products CASCADE;