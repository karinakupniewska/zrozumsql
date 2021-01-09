--ograniczenia CHECK
CREATE TABLE sales (
	id integer,
	sales NUMERIC CHECK (sales > 1000)
);

---to samo co wyżej, tylko bardziej rozbudowane i działa wszędzie (standard ISO), skrócona wersja nie
CREATE TABLE sales2 (
	id integer,
	sales NUMERIC CONSTRAINT sales_over_1k CHECK (sales > 1000)
);
---kolejny sposób to dodanie ograniczenia po przecinku
CREATE TABLE sales3 (
	id integer,
	sales NUMERIC,
	CONSTRAINT sales_over_1k CHECK (sales > 1000)
);

---inny sposób to dodanie ograniczenia juz na stworzonej tabeli - za pomocą alter
CREATE TABLE sales4 (
	id integer,
	sales NUMERIC
);

ALTER TABLE sales4 ADD CONSTRAINT sales_over_1k CHECK (sales > 1000);

---ograniczenie, gdzie jedna tabela zależy od drugiej
CREATE TABLE sales5 (
	id integer,	
	discount NUMERIC,
	sales NUMERIC CHECK (discount < sales)
);
---w związku z powyższym ograniczeniem nie będzie można wprowadzić takiego rekordu:
INSERT INTO sales5 VALUES (1, 100, 10);
---ten tak, bo spełnia warunek CHECK
INSERT INTO sales5 VALUES (1, 10, 100);


----aby usunąć ograniczenie:
ALTER TABLE sales2 DROP CONSTRAINT sales_over_1k; -- musi być podana nazwa ograniczenia