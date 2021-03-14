--Skopoiowany plik projekt M4 - zmienione klucze wed³ug polecenia M5_Z_1_projekt:
/*
1. Dla tabel posi¹daj¹cych klucz g³ówny (PRIMARY KEY) zmieñ typ danych dla identyfikatorów
(PRIMARY KEY) na typ SERIAL. Zmieniaj¹c definicjê struktury i zapytania CREATE TABLE.
Klucze obce w tabelach (z ograniczeniem REFERENCES) powinny zostaæ, jako typ ca³kowity.
*/





/* 1. Korzystaj¹c ze sk³adni CREATE ROLE, stwórz nowego u¿ytkownika o nazwie
expense_tracker_user z mo¿liwoœci¹ zalogowania siê do bazy danych i has³em silnym :) (coœ
wymyœl)*/

DROP ROLE IF EXISTS expense_tracker_user;
CREATE ROLE expense_tracker_user WITH LOGIN PASSWORD 'gN5#p0skpaLG';

/* 2. Korzystaj¹c ze sk³adni REVOKE, odbierz uprawnienia tworzenia obiektów w schemacie
public roli PUBLIC */

REVOKE CREATE ON SCHEMA public FROM PUBLIC;

/* 3. Je¿eli w Twoim œrodowisku istnieje ju¿ schemat expense_tracker (z obiektami tabel) usuñ
go korzystaj¹c z polecenie DROP CASCADE. */

DROP SCHEMA IF EXISTS expense_tracker CASCADE;

/* 4. Utwórz now¹ rolê expense_tracker_group. */

--przepisanie zale¿nych obiektów na postgres, aby mo¿na odtworzyæ skrypt po raz kolejny
REASSIGN OWNED BY expense_tracker_group TO postgres;
DROP OWNED BY expense_tracker_group;

DROP ROLE IF EXISTS expense_tracker_group;
CREATE ROLE expense_tracker_group;

/* 5. Utwórz schemat expense_tracker, korzystaj¹c z atrybutu AUTHORIZATION, ustalaj¹c
w³asnoœæna rolê expense_tracker_group. */

DROP SCHEMA IF EXISTS expense_tracker CASCADE;
CREATE SCHEMA expense_tracker AUTHORIZATION expense_tracker_group;

/*
6. Dla roli expense_tracker_group, dodaj nastêpuj¹ce przywileje:
? Dodaj przywilej ³¹czenia do bazy danych postgres (lub innej, je¿eli korzystasz z
innej nazwy)
? Dodaj wszystkie przywileje do schematu expense_tracker */

GRANT CONNECT ON DATABASE postgres TO expense_tracker_group;
GRANT ALL PRIVILEGES ON SCHEMA expense_tracker TO expense_tracker_group;

/*
7. Dodaj rolê expense_tracker_group u¿ytkownikowi expense_tracker_user. */


GRANT expense_tracker_group TO expense_tracker_user;


/* 8. Otwórz skrypt z zdaniami projektowymi z Modu³y 3. Usuñ fragment skryptu zwi¹zany z
tworzeniem schematu expense_tracker, teraz ten fragment bêdzie w tej czêœci skryptu.
9. Dla definicja tabel w skrypcie z zdaniami do Modu³u 3 dodaj relacjê kluczy obcych
pomiêdzy tabelami. Zmieñ definicjê CREATE TABLE, nie dodawaj tego za poœrednictwem
ALTER TABLE (bêdzie przejrzyœciej).
? BANK_ACCOUNT_TYPES: Atrybut ID_BA_OWN ma byæ referencj¹ do
BANK_ACCOUNT_OWNER (ID_BA_OWN)
? TRANSACTIONS: Atrybut ID_TRANS_BA ma byæ referencj¹ do
TRANSACTION_BANK_ACCOUNTS (ID_TRANS_BA)
? TRANSACTIONS: Atrybut ID_TRANS_CAT ma byæ referencj¹ do
TRANSACTION_CATEGORY (ID_TRANS_CAT)
? TRANSACTIONS: Atrybut ID_TRANS_SUBCAT ma byæ referencj¹ do
TRANSACTION_SUBCATEGORY (ID_TRANS_SUBCAT)
? TRANSACTIONS: Atrybut ID_TRANS_TYPE ma byæ referencj¹ do
TRANSACTION_TYPE (ID_TRANS_TYPE)
? TRANSACTIONS: Atrybut ID_USER ma byæ referencj¹ do USERS (ID_USER)
? TRANSACTION_BANK_ACCOUNTS: Atrybut ID_BA_OWN ma byæ referencj¹ do
BANK_ACCOUNT_OWNER (ID_BA_OWN)
? TRANSACTION_BANK_ACCOUNTS: Atrybut ID_BA_TYP ma byæ referencj¹ do
BANK_ACCOUNT_TYPES (ID_BA_TYPE)
? TRANSACTION_SUBCATEGORY: Atrybut ID_TRANS_CAT ma byæ referencj¹ do
TRANSACTION_CATEGORY (ID_TRANS_CAT)
10. Uszereguj tak wykonanie tabel w skrypcie, aby w momencie uruchomienia skryptu, nie by³
zwracany b³¹d, ¿e dana relacja nie mo¿e zostaæ utworzona, bo tabela jeszcze nie istnieje.*/




---tworzenie tabel z 3 modu³u + klucze obce

DROP TABLE IF EXISTS expense_tracker.bank_account_owner CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_owner(
	 id_ba_own SERIAL PRIMARY KEY,
	 owner_name varchar(50) NOT NULL ,
	 owner_desc varchar(250),
	 user_login integer NOT NULL,
	 active boolean DEFAULT TRUE NOT NULL  ,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp
 );

DROP TABLE IF EXISTS expense_tracker.bank_account_types CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types(
	 id_ba_type  SERIAL PRIMARY KEY,
	 ba_type varchar(50) NOT NULL ,
	 ba_desc varchar(250),
	 active boolean DEFAULT TRUE NOT NULL  ,
	 is_common_account boolean DEFAULT FALSE NOT NULL  ,
	 id_ba_own integer,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp,
	 CONSTRAINT bank_account_owner_fk FOREIGN KEY (id_ba_own) REFERENCES expense_tracker.bank_account_owner(id_ba_own)
 );

DROP TABLE IF EXISTS expense_tracker.transaction_bank_accounts CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts(
	 id_trans_ba  SERIAL PRIMARY KEY ,
	 id_ba_own integer ,
	 id_ba_typ integer,
	 bank_account_name varchar(50) NOT NULL ,
	 bank_account_desc varchar(250),
	 active boolean DEFAULT TRUE NOT NULL  ,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp,
	 CONSTRAINT bank_account_owner_fk FOREIGN KEY (id_ba_own) REFERENCES  expense_tracker.bank_account_owner(id_ba_own),
	 CONSTRAINT bank_account_types_fk FOREIGN KEY (id_ba_typ) REFERENCES  expense_tracker.bank_account_types(id_ba_type)
 );

DROP TABLE IF EXISTS expense_tracker.transaction_category CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category(
	 id_trans_cat  SERIAL PRIMARY KEY ,
	 category_name varchar(50) NOT NULL,
	 category_description varchar(250),
	 active boolean DEFAULT TRUE NOT NULL  ,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp
  );
 
DROP TABLE IF EXISTS expense_tracker.transaction_subcategory CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory(
	 id_trans_subcat SERIAL PRIMARY KEY ,
	 id_trans_cat integer,
	 subcategory_name varchar(50) NOT NULL,
	 subcategory_description varchar(250),
	 active boolean DEFAULT TRUE NOT NULL  ,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp,
	 CONSTRAINT transaction_category_fk FOREIGN KEY (id_trans_cat) REFERENCES  expense_tracker.transaction_category(id_trans_cat)
 );

 DROP TABLE IF EXISTS expense_tracker.transaction_type CASCADE;
 CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type(
 	id_trans_type SERIAL PRIMARY KEY,
 	transaction_type varchar(50) NOT NULL ,
 	transaction_type_desc varchar(250),
 	active boolean DEFAULT TRUE NOT NULL  ,
 	insert_date timestamp DEFAULT current_timestamp,
 	update_date timestamp DEFAULT current_timestamp
 );

DROP TABLE IF EXISTS expense_tracker.users CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.users(
	 id_user SERIAL PRIMARY KEY ,
	 user_login varchar(25) NOT NULL ,
	 user_name varchar(50) NOT NULL ,
	 user_password varchar(100) NOT NULL ,
	 password_salt varchar(100) NOT NULL ,
	 active boolean DEFAULT TRUE NOT NULL  ,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp
 );

DROP TABLE IF EXISTS expense_tracker.transactions CASCADE;
CREATE TABLE IF NOT EXISTS expense_tracker.transactions(
	 id_transaction SERIAL PRIMARY KEY,
	 id_trans_ba integer ,
	 id_trans_cat integer ,
	 id_trans_subcat integer,
	 id_trans_type integer ,
	 id_user integer,
	 transaction_date date DEFAULT current_date,
	 transaction_value numeric(9,2),
	 transaction_description text,
	 insert_date timestamp DEFAULT current_timestamp,
	 update_date timestamp DEFAULT current_timestamp,
	 CONSTRAINT transaction_bank_accounts_fk FOREIGN KEY (id_trans_ba) REFERENCES expense_tracker.transaction_bank_accounts (id_trans_ba),
	 CONSTRAINT transaction_category_fk FOREIGN KEY (id_trans_cat) REFERENCES expense_tracker.transaction_category(id_trans_cat),
	 CONSTRAINT transaction_subcategory_fk FOREIGN KEY (id_trans_subcat) REFERENCES expense_tracker.transaction_subcategory(id_trans_subcat),
	 CONSTRAINT transaction_type_fk FOREIGN KEY (id_trans_type) REFERENCES expense_tracker.transaction_type(id_trans_type),
	 CONSTRAINT users_fk FOREIGN KEY (id_user) REFERENCES expense_tracker.users(id_user)
 );
 



---ZADANIE 2 - M5_projekt
-- INSERTY
-- 2. Dla ka¿dej z tabel projektowych wstaw przynajmniej 1 rzeczywisty rekord spe³niaj¹cy kryteria tabeli i kluczy obcych.


-- insert do tabeli expense_tracker.users

INSERT INTO expense_tracker.users (user_login, user_name, user_password, password_salt, active)
     VALUES ('kkupniewska', 'Karina Kupniewska', 'o2P9$5!kpo04#', concat(md5(random()::TEXT)), true);
    
-- insert do tabeli expense_tracker.bank_account_owner
     
INSERT INTO expense_tracker.bank_account_owner (owner_name, owner_desc, user_login, active)
	 VALUES ('Karina Kupniewska', 'description', 143202, TRUE);
	
-- insert do tabeli expense_tracker.bank_account_types

INSERT INTO expense_tracker.bank_account_types (ba_type, ba_desc, active, is_common_account, id_ba_own)
     VALUES ('checking', 'Konto Osobiste', TRUE, FALSE, 1);
	
    
-- insert do tabeli expense_tracker.transaction_bank_accounts

INSERT INTO expense_tracker.transaction_bank_accounts (id_ba_own, id_ba_typ, bank_account_name, bank_account_desc, active)
	 VALUES (1, 1, 'Konto Direct', 'Konto Osobiste mbank', TRUE);
    
	
-- insert do tabeli expense_tracker.transaction_category

INSERT INTO expense_tracker.transaction_category (category_name, category_description, active)
	 VALUES ('Zakupy', 'codzienne', TRUE),
			('Op³aty', 'telefon', TRUE);
		
-- insert do tabeli expense_tracker.transaction_subcategory

INSERT INTO expense_tracker.transaction_subcategory (id_trans_cat, subcategory_name, subcategory_description, active)
     VALUES (1, 'Warzywniak', 'Warzywa i owoce', TRUE),
        	(1, 'Piekarnia', 'Pieczywo', TRUE),
       		(1, 'Drogeria', 'Chemia', TRUE),
       		(2, 'Telefon', 'Faktura', TRUE),
       		(2, 'Internet', 'Faktura', TRUE);
       	
-- insert do tabeli expense_tracker.transaction_type

INSERT INTO expense_tracker.transaction_type (transaction_type, transaction_type_desc, active)
	 VALUES ('Przelew przychodz¹cy', 'Wp³yw na konto', TRUE),
	 		('Przelew wychodz¹cy', 'Wyp³yw œrodków z konta', TRUE),
	 		('Karta debetowa', 'P³atnoœæ kart¹ debetow¹', TRUE),
	 		('Karta kredytowa', 'P³atnoœæ kart¹ kredytow¹', TRUE);
       	
	 	
-- insert do tabeli expense_tracker.transactions 

INSERT INTO expense_tracker.transactions (id_trans_cat, id_trans_subcat, id_trans_type, id_user, transaction_date, transaction_value, transaction_description)
     VALUES (1, 1, 3, 1, '01-02-2021', 50.89, 'zakupy w warzywniaku');

    

--ZADANIE 3 M5_PROJEKT
-- kopia zapasowa bazy danych
/*
3. Wykonaj pe³n¹ kopiê zapasow¹ bazy danych z opcj¹ --clean (do formatu plain tak ¿eby
widzieæ, co siê zrzuci³o) korzystaj¹c z narzêdzia pg_dump. Nastêpnie odtwórz kopiê z
zapisanego skryptu korzystaj¹c z narzedzia DBeaver lub psql. */

    
pg_dump --host localhost ^
		--port 5432 ^
		--username postgres ^
		--format plain ^
		--clean ^
		--file "C:\PostgreSQL_dump\expense_tracker_bp.sql" ^
		postgres
		
-- przywrócenie kopii zapasowej
		
psql -U postgres -p 5432 -h localhost -d postgres -f "C:\PostgreSQL_dump\expense_tracker_bp.sql"