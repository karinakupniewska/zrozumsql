/* Korzystając ze składni CREATE ROLE, stwórz nowego użytkownika o nazwie user_training z
możliwością zalogowania się do bazy danych i hasłem silnym :) (coś wymyśl). */

DROP ROLE IF EXISTS user_training;
CREATE ROLE user_training WITH LOGIN PASSWORD '!s0kpw8fT5q';

/* 2. Korzystając z atrybutu AUTHORIZATION dla składni CREATE SCHEMA. Utwórz schemat
training, którego właścicielem będzie użytkownik user_training. */

DROP SCHEMA IF EXISTS training;
CREATE SCHEMA training AUTHORIZATION user_training;


/* 3. Będąc zalogowany na super użytkowniku postgres, spróbuj usunąć rolę (użytkownika)
user_training.*/
--można usunąć rolę jeśli przepisze się zależne od niej obiekty

REASSIGN OWNED BY user_training TO postgres; 
DROP OWNED BY user_training; 
DROP ROLE user_training;

/* 4. Przekaż własność nad utworzonym dla / przez użytkownika user_training obiektami na role
postgres. Następnie usuń role user_training.*/

REASSIGN OWNED BY user_training TO postgres;
DROP OWNED BY user_training;
DROP ROLE user_training;

/* 5. Utwórz nową rolę reporting_ro, która będzie grupą dostępów, dla użytkowników warstwy
analitycznej o następujących przywilejach.
? Dostęp do bazy danych postgres
? Dostęp do schematu training
? Dostęp do tworzenia obiektów w schemacie training
? Dostęp do wszystkich uprawnień dla wszystkich tabel w schemacie training */


CREATE ROLE reporting_ro;
GRANT CONNECT ON DATABASE postgres TO reporting_ro;
GRANT USAGE, CREATE ON SCHEMA training TO reporting_ro;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA training TO reporting_ro;

/* 6. Utwórz nowego użytkownika reporting_user z możliwością logowania się do bazy danych i
haśle silnym :) (coś wymyśl). Przypisz temu użytkownikowi role reporting ro; */

DROP ROLE IF EXISTS reporting_user;
CREATE ROLE reporting_user WITH LOGIN PASSWORD 'tA2p087frY$*';
GRANT reporting_ro TO reporting_user;

/* 7. Będąc zalogowany na użytkownika reporting_user, spróbuj utworzyć nową tabele (dowolną)
w schemacie training. */

--ok
DROP TABLE IF EXISTS training.test;
CREATE TABLE training.test (
	id Integer
)
;

/* 8. Zabierz uprawnienia roli reporting_ro do tworzenia obiektów w schemacie training; */

REVOKE CREATE ON SCHEMA training FROM reporting_ro;

/* 9. Zaloguj się ponownie na użytkownika reporting_user, sprawdź czy możesz utworzyć nową
tabelę w schemacie training oraz czy możesz taką tabelę utworzyć w schemacie public.*/

---W poprzednim kroku zostały odebrane uprawnienia w obrębie schematu training, więc nie da się utworzyć tabeli w tym schemacie
CREATE TABLE training.test1 (
	id INTEGER
)
;

--W schemacie public można utworzyć tabelę
CREATE TABLE public.test2 (
	id INTEGER
)
;
