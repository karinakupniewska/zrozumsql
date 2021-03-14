/* 
1. Utwórz nowy schemat dml_exercises
*/
CREATE SCHEMA IF NOT EXISTS dml_exercises;

/*
2. Utwórz now¹ tabelê sales w schemacie dml_exercises wed³ug opisu:
Tabela: sales;
Kolumny:
? id - typ SERIAL, klucz g³ówny,
? sales_date - typ data i czas (data + czêœæ godziny, minuty, sekundy), to pole ma nie
zawieraæ wartoœci nieokreœlonych NULL,
? sales_amount - typ zmiennoprzecinkowy (NUMERIC 38 znaków, do 2 znaków po
przecinku)
? sales_qty - typ zmiennoprzecinkowy (NUMERIC 10 znaków, do 2 znaków po przecinku)
? added_by - typ tekstowy (nielimitowana iloœæ znaków), z wartoœci¹ domyœln¹ 'admin'
? korzystaj¹c z definiowania przy tworzeniu tabeli, po definicji kolumn, dodaje
ograniczenie o nazwie sales_less_1k na polu sales_amount typu CHECK takie, ¿e
wartoœci w polu sales_amount musz¹ byæ mniejsze lub równe 1000
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
3. Dodaj to tabeli kilka wierszy korzystaj¹c ze sk³adni INSERT INTO
3.1 Tak, aby id by³o generowane przez sekwencjê
3.2 Tak by pod pole added_by wpisaæ wartoœæ nieokreœlon¹ NULL
3.3 Tak, aby sprawdziæ zachowanie ograniczenia sales_less_1k, gdy wpiszemy wartoœci wiêksze
od 1000
*/
	
INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty, added_by)
     VALUES ('11-01-2021', 200, 10, 'user_1'),
     		('13-02-2021', 500, 35, NULL),
     		('05-02-2021', 800, 20, 'user_2')
;
     	

     INSERT INTO dml_exercises.sales (sales_date, sales_amount, sales_qty, added_by)
 	 VALUES ('15-01-2021', 1001, 05, 'user_1') 		-- B£¥D: nowy rekord dla relacji "sales" narusza ograniczenie sprawdzaj¹ce "sales_less_1k"
 													--- Detail: Niepoprawne ograniczenia wiersza (4, 2020-10-30 00:00:00, 1001.00, 10.00, user_1).
; 

/*	
4. Co zostanie wstawione, jako format godzina (HH), minuta (MM), sekunda (SS), w polu
sales_date, jak wstawimy do tabeli nastêpuj¹cy rekord.
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
5. Jaka bêdzie wartoœæ w atrybucie sales_date, po wstawieniu wiersza jak poni¿ej. Jak
zintepretujesz miesi¹c i dzieñ, ¿eby mieæ pewnoœæ, o jaki konkretnie chodzi.
INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('04/04/2020', 101, 50, NULL);
*/

INSERT INTO dml_exercises.sales (sales_date, sales_amount,sales_qty, added_by)
 VALUES ('04/04/2020', 101, 50, NULL)
;

--sprawdzenie kolejnoœci:
SHOW datestyle;

/*
6. Dodaj do tabeli sales wstaw wiersze korzystaj¹c z poni¿szego polecenia
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
7. Korzystaj¹c ze sk³adni UPDATE, zaktualizuj atrybut added_by, wpisuj¹c mu wartoœæ
'sales_over_200', gdy wartoœæ sprzeda¿y (sales_amount jest wiêksza lub równa 200)
*/
   
UPDATE dml_exercises.sales
   SET added_by = 'sales_over_200'
 WHERE sales_amount >= 200
;

SELECT * FROM dml_exercises.sales
;  

/*
8. Korzystaj¹c ze sk³adni DELETE, usuñ te wiersze z tabeli sales, dla których wartoœæ w polu
added_by jest wartoœci¹ nieokreœlon¹ NULL. SprawdŸ ró¿nicê miêdzy zapisemm added_by =
NULL, a added_by IS NULL
*/


DELETE FROM dml_exercises.sales 
      WHERE added_by = NULL; 
-- updated rows: 0
-- NULL nie jest wartoœci¹

     
DELETE FROM dml_exercises.sales
      WHERE added_by IS NULL;
--- updated rows: 7867


/*    
9. Wyczyœæ wszystkie dane z tabeli sales i zrestartuj sekwencje
*/

TRUNCATE TABLE dml_exercises.sales RESTART IDENTITY;

/*
10. DODATKOWE ponownie wstaw do tabeli sales wiersze jak w zadaniu 4.
Utwórz kopiê zapasow¹ tabeli do pliku. Nastêpnie usuñ tabelê ze schematu dml_exercises i
odtwórz j¹ z kopii zapasowej.
*/


