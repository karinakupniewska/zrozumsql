--m3_projekt;

DROP SCHEMA IF EXISTS expense_tracker cascade;
CREATE SCHEMA IF NOT EXISTS expense_tracker;

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_owner (
						id_ba_own integer PRIMARY KEY,
						owner_name varchar (50) NOT NULL,
						owner_desc varchar (250),
						user_login integer NOT NULL,
						active boolean DEFAULT TRUE NOT NULL,
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.bank_account_types (
						id_ba_type integer PRIMARY KEY,
						ba_type varchar(50) NOT NULL,
						ba_desc varchar(250),
						active boolean DEFAULT TRUE NOT NULL,
						is_common_account boolean DEFAULT FALSE NOT NULL,
						id_ba_own integer, 
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.transactions (
						id_transaction integer PRIMARY KEY,
						id_trans_ba integer,
						id_trans_cat integer,
						id_trans_subcat integer,
						id_trans_type integer,
						id_user integer,
						transaction_date date DEFAULT current_date,
						transaction_value numeric (9, 2),
						transaction_description text,
						insert_date timestamp default current_timestamp, 
						update_date timestamp default current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_bank_accounts (
						id_trans_ba integer PRIMARY KEY,
						id_ba_own integer,
						id_ba_typ integer,
						bank_account_name varchar(50) NOT NULL,
						bank_account_desc varchar(250),
						active boolean DEFAULT TRUE NOT NULL,
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_category (
						id_trans_cat integer PRIMARY KEY,
						category_name varchar(50) not NULL,
						category_description varchar(250),
						active boolean DEFAULT TRUE NOT NULL,
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_subcategory (
						id_trans_subcat INTEGER PRIMARY KEY,
						id_trans_cat INTEGER,
						subcategory_name VARCHAR(50) NOT NULL,
						subcategory_description VARCHAR(250),
						active boolean DEFAULT TRUE NOT NULL,
						insert_date TIMESTAMP DEFAULT current_timestamp,
						update_date TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.transaction_type (
						id_trans_type INTEGER PRIMARY KEY,
						transaction_type_name VARCHAR(50) NOT NULL,
						transaction_type_desc VARCHAR(250),
						active boolean DEFAULT TRUE NOT NULL,
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS expense_tracker.users (
						id_user integer PRIMARY KEY,
						user_login varchar (25) NOT NULL,
						user_name varchar(50) NOT NULL,
						user_password varchar(100) NOT NULL,
						password_salt varchar(100) NOT NULL,
						active boolean DEFAULT TRUE NOT NULL,
						insert_date timestamp DEFAULT current_timestamp,
						update_date timestamp DEFAULT current_timestamp
);

