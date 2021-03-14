/* 
1. Utw�rz nowy schemat dml_exercises
*/
CREATE SCHEMA IF NOT EXISTS dml_exercises;

/*
2. Utw�rz now� tabel� sales w schemacie dml_exercises wed�ug opisu:
Tabela: sales;
Kolumny:
? id - typ SERIAL, klucz g��wny,
? sales_date - typ data i czas (data + cz�� godziny, minuty, sekundy), to pole ma nie
zawiera� warto�ci nieokre�lonych NULL,
? sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znak�w, do 2 znak�w po
przecinku)
? sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znak�w, do 2 znak�w po przecinku)
? added_by - typ tekstowy (nielimitowana ilo�� znak�w), z warto�ci� domy�ln� 'admin'
? korzystaj�c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje
ograniczenie o nazwie sales_less_1k na polu sales_amount typu CHECK takie, �e
warto�ci w polu sales_amount musz� by� mniejsze lub r�wne 1000
*/

DROP TABLE IF EXISTS dml_exercises.sales;

CREATE TABLE IF NOT EXISTS dml_exercises.sales (
	id serial PRIMARY KEY,
	sales_date timestamp NOT NULL,
	sales_amount numeric(38, 2),
	sales_qty numeric(10, 2),
	added_by text DEFAULT 'admin',
	CONSTRAINT sales_less_1k CHECK (sales_amount <= 1000)
)
;

/*
3. Dodaj to tabeli kilka wierszy korzystaj�c ze sk�adni INSERT INTO
3.1 Tak, aby id by�o generowane przez sekwencj�
3.2 Tak by pod pole added_by wpisa� warto�� nieokre�lon� NULL
3.3 Tak, aby sprawdzi� zachowanie ograniczenia sales_less_1k, gdy wpiszemy warto�ci wi�ksze
od 1000
*/
	
INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty, added_by)
     VALUES ('11-01-2021', 200, 10, 'user_1'),
     		('13-02-2021', 500, 35, NULL),
     		('05-02-2021', 800, 20, 'user_2')
;
     	

     INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty, added_by)
 	 VALUES ('15-01-2021', 1001, 05, 'user_1') 		-- B��D: nowy rekord dla relacji "sales" narusza ograniczenie sprawdzaj�ce "sales_less_1k"
 													--- Detail: Niepoprawne ograniczenia wiersza (4, 2020-10-30 00:00:00, 1001.00, 10.00, user_1).
; 

/*	
4. Co zostanie wstawione, jako format godzina (HH), minuta (MM), sekunda (SS), w polu
sales_date, jak wstawimy do tabeli nast�puj�cy rekord.
INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('20/11/2019', 101, 50, NULL);
*/

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('20/11/2019', 101, 50, NULL)
;


SELECT sales_date FROM dml_exercises.sales
 WHERE sales_amount = 101 
   AND sales_qty = 50
;
  
--- Odp. 00:00:00


/*
5. Jaka b�dzie warto�� w atrybucie sales_date, po wstawieniu wiersza jak poni�ej. Jak
zintepretujesz miesi�c i dzie�, �eby mie� pewno��, o jaki konkretnie chodzi.
INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('04/04/2020', 101, 50, NULL);
*/

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('04/04/2020', 101, 50, NULL)
;

--sprawdzenie kolejno�ci:
SHOW datestyle;

/*
6. Dodaj do tabeli sales wstaw wiersze korzystaj�c z poni�szego polecenia
INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
 SELECT NOW() + (random() * (interval '90 days')) + '30 days',
 random() * 500 + 1,
 random() * 100 + 1,
 NULL
 FROM generate_series(1, 20000) s(i);
 */

INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty,added_by)
 SELECT NOW() + (random() * (interval '90 days')) + '30 days',
 random() * 500 + 1,
 random() * 100 + 1,
 NULL
 FROM generate_series(1, 20000) s(i);

/*
7. Korzystaj�c ze sk�adni UPDATE, zaktualizuj atrybut added_by, wpisuj�c mu warto��
'sales_over_200', gdy warto�� sprzeda�y (sales_amount jest wi�ksza lub r�wna 200)
*/
   
UPDATE dml_exercises.sales
   SET added_by = 'sales_over_200'
 WHERE sales_amount >= 200
;

SELECT * FROM dml_exercises.sales
;  

/*
8. Korzystaj�c ze sk�adni DELETE, usu� te wiersze z tabeli sales, dla kt�rych warto�� w polu
added_by jest warto�ci� nieokre�lon� NULL. Sprawd� r�nic� mi�dzy zapisemm added_by =
NULL, a added_by IS NULL
*/


DELETE FROM dml_exercises.sales 
      WHERE added_by = NULL; 
-- updated rows: 0
-- NULL nie jest warto�ci�

     
DELETE FROM dml_exercises.sales
      WHERE added_by IS NULL;
--- updated rows: 7867


/*    
9. Wyczy�� wszystkie dane z tabeli sales i zrestartuj sekwencje
*/

TRUNCATE TABLE dml_exercises.sales RESTART IDENTITY;

/*
10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 4.
Utw�rz kopi� zapasow� tabeli do pliku. Nast�pnie usu� tabel� ze schematu dml_exercises i
odtw�rz j� z kopii zapasowej.
*/


