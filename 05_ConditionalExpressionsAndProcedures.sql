-- CONDITIONAL EXPRESSIONS AND PROCEDURES


-- BASIC use of CASE
-- We can use the CASE statement to only execute SQL code when certain conditions are met. 
-- This is very similar to IF/ELSE statements in other programming languages.
-- There are tow main ways to use a CASE statement, either a general CASE or a CASE expression.
/*
	SELECT a,
	CASE WHEN a=1 THEN 'one'
		WHEN a=2 THEN 'two'
		ELSE 'other'
	END
	FROM test;
*/
-- The CASE expression syntax first evaluates an expression then compares the result with each value in the WHEN clauses sequentially.
SELECT customer_id, 
	CASE
		WHEN (customer_id <= 100) THEN 'Premium Customer' -- Verify this Scenario in first place
		WHEN (customer_id BETWEEN 101 AND 200) THEN 'Plus'
		ELSE 'Normal' -- If none of the Scenarios above are true, then this is the expected/default result
	END AS customer_class
FROM customer;

SELECT customer_id,
	CASE customer_id -- In this way, this is taken as the field to compare against, so there is no need to mention it in the WHEN statements.
		WHEN 2 THEN 'Winner'
		WHEN 5 THEN 'Second Place' 
		ELSE  'Normal'
	END AS raffle_results
FROM customer;

SELECT 
	SUM (CASE rental_rate 
		WHEN 0.99 THEN 1
		ELSE 0
		END) AS bargains,
	SUM( CASE rental_rate 
		WHEN 2.99 THEN 1
		ELSE 0
		END ) AS regular 
	SUM( CASE rental_rate 
		WHEN 4.99 THEN 1
		ELSE 0
		END ) AS premium 
FROM film;


-- ++++ CHALLENGE ++++
-- We want to know and compare the various amounts of films we have per movie rating. 
SELECT 
	SUM( CASE rating
		WHEN 'R' THEN 1
		ELSE 0
		END ) AS r, 
	SUM( CASE rating
		WHEN 'PG' THEN 1
		ELSE 0
		END ) AS pg,
	SUM( CASE rating 
		WHEN 'PG-13' THEN 1
		ELSE 0
		END ) AS pg_13
FROM film;


-- BASIC use of COALESCE
-- The COALESCE funciton accepts an unlimited number of arguments. It returns the first argument that is not null. 
-- If all arguments are null, the COALESCE function will return NULL. 
-- THe COALESCE function becomes useful when queryng a table that contains null values and substituting it with another value. 
-- Looks for the value in the given column, if it's different than null, uses that current value, otherwise it will substitute it,
-- duting the calculation, with the second given parameter. 
	-- SELECT item, (price - COALESCE(discount, 0)) AS final FROM table;
-- Keep the COALESCE function in mind in case you encounter a table with null values that you want to perform operations on.


-- BASIC use of CAST
-- The CAST operator let's you convert from one ata type into another.
-- Keep in mind not every instance of a data type can be CAST to another data type, it must be reasonable to convert data,
-- for example, '5' to an INTEGER will work, 'five' to INTEGER will NOT. 
SELECT CAST('5' AS INTEGER) AS new_int;
SELECT '5'::INTEGER; -- :: => PostgreSQL CAST operator.
-- Keep in mind you can then use this in a SELECT query with a column name instead of a single instance.	
	-- SELECT CAST(date AS TIMESTAMP) FROM table;
SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR)) FROM rental; -- Calculate the length of characters


-- BASIC use of NULLIF
-- The NULLIF function takes in 2 inputs and returns NULL if both are equal, otherwise it returns the first argument passed.
CREATE DATABASE testme;
\c testme;

CREATE TABLE depts(
	first_name VARCHAR(50),
	department VARCHAR(50)
);

INSERT INTO depts(first_name, deparment) VALUES ('Vincent', 'B'), ('Tifa', 'A'), ('Aerith', 'A');

SELECT * FROM depts;

SELECT (SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END) / 
		SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END)
	) AS department_ratio FROM depts;

DELETE FROM depts WHERE department='B';

SELECT (SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END) / 
		SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END)
	) AS department_ratio FROM depts; -- It will fail, because division by 0 is NOT possible.

SELECT (SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END) /
		NUllIF( SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END), 0 ) -- Returns NULL instead of 0, so the division will also return NULL.  
	) AS department_ratio FROM depts;


-- BASIC use of VIEWS
-- Instead of having to perform the query over and over again as a starting point, you can create a VIEW to quickly see this query with a simple call.
-- A view is a database object that is of a stored query.
-- A VIEW can be accessed as a virtual table in PostgreSQL.
-- Notice that a view does not store data physically, it simply stores the query.
-- You can also update and alter existing views.
c\ dvdrental

CREATE VIEW custommer_info AS
SELECT first_name, last_name, address FROM customer INNER JOIN address ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

CREATE OR REPLACE VIEW customer_info AS
SELECT first_name, last_name, address, district FROM customer INNER JOIN address ON customer.address_id = address.address_id;

SELECT * FROM customer_info;

DROP VIEW IF EXISTS customer_info;


-- BASIC us of IMPORT and EXPORT
-- *** NOTE ***
	-- Not every outside data file will work, variations in formatting, macros, data types, etc. may prevent the import
	-- commnd from reading the file, at which point you must edit your file to be compatible with SQL.
	-- You must provide the 100% correct file path to your outside file, otherwise the import command will fail to find
	-- th file. The most common mistake if failing to provide the correct file path, confirm the file's location under
	-- its properties. 
	-- The IMPORT command DOES NOT create a table for you. It assumes a table is already created.
CREATE TABLE simple(
	a INTEGER,
	b INTEGER,
	c INTEGER
);

SELECT * FROM simple;
