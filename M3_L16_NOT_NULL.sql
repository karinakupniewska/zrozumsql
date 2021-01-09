--ograniczenie jest widoczne w zakładce columns jako check box, nie widać ograniczenia not null w zakładce constraints
CREATE TABLE sales (
	id integer NOT NULL,
	sales NUMERIC CHECK (sales > 1000)
);
--usuwanie ogranicznia z powyższej tabeli
ALTER TABLE sales ALTER COLUMN id DROP NOT NULL;


