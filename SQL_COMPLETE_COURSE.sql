-- Udemy Course 
-- The Complete SQL Bootcamp: Go from Zero to Hero

SELECT * FROM film;
SELECT * FROM actor;
SELECT last_name, first_name FROM actor;

-- *** NOTE ***
-- ProsgreSQL only accepts single quotes ''. 


-- *** NOTE ***
-- SHOW TABLES; command does not exist in PostgreSQL, this is another approach.
SELECT tablename FROM pg_tables WHERE schemaname='public';


-- *** NOTE ***
-- DESCRIBE command does not exist in PostgreSQL, this is another approach.
SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_NAME='customer';


-- ++++ CHALLENGE ++++
-- Write a Query to show the customer first name, last name and email.
SELECT first_name, last_name, email FROM customer;


-- Returns the unique values of a column
SELECT DISTINCT(release_year) FROM film;
SELECT DISTINCT(rental_rate) FROM film;


-- ++++ CHALLENGE ++++ 
-- What ratings do we have available? 
SELECT DISTINCT(rating) FROM film;
-- How many different rates exist?
SELECT COUNT(DISTINCT(rating)) FROM film;
-- How many elements of a given rate exist?
SELECT rating, COUNT(rating) FROM film GROUP BY rating;


-- Basic use of WHERE
SELECT * FROM customer WHERE first_name = 'Jared';
SELECT * FROM film WHERE rental_rate > 4 AND rental_rate <= 6;
SELECT * FROM film WHERE rating != 'R' OR rating='PG';


-- ++++ CHALLENGE ++++
-- What is the email from the customer with the name Nancy Thomas?
SELECT email FROM customer WHERE first_name='Nancy' AND last_name='Thomas';
-- Could you give the description for the movie "Outlaw Hanky"?
SELECT description FROM film WHERE title='Outlaw Hanky';


-- Basic use of ORDER BY ... ASC/DESC; and LIMIT
SELECT * FROM customer ORDER BY first_name DESC;
SELECT * FROM customer ORDER BY last_name ASC;
SELECT store_id, first_name, last_name FROM customer ORDER BY store_id, first_name;
SELECT * FROM payment ORDER BY payment_date DESC LIMIT 10;
SELECT * FROM payment WHERE amount!=0.00 ORDER BY amount DESC LIMIT 5;


-- ++++ CHALLENGE ++++
-- What are the customer ids of the first 10 customers who created a payment?
SELECT customer_id FROM payment ORDER BY payment_date ASC LIMIT 10;
-- What are the titles of the 5 shortest (in length of tuntime) movies?
SELECT title, length FROM film ORDER BY length ASC LIMIT 5;
-- how many movies or less than 50 minutes do we have?
SELECT COUNT(title) FROM film WHERE length <= 50;


-- BASIC use of BETWEEN
-- Note: The first parameter has to be lower/lesser tnan the second one
SELECT * FROM payment WHERE amount BETWEEN 5 AND 10 LIMIT 10;
SELECT COUNT(*) FROM payment WHERE amount NOT BETWEEN 8 AND 9;
SELECT * FROM payment WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15';


-- BASIC use of IN
-- Note: Looks into a bunch of given options
SELECT * FROM film WHERE rating IN('PG', 'R');
SELECT * FROM payment WHERE amount IN (0.99, 1.98, 1.99);
SELECT COUNT(*) FROM payment WHERE amount IN (0.99, 1.98, 1.99);
SELECT COUNT(*) FROM payment WHERE amount NOT IN (0.99, 1.98, 1.99);
SELECT * FROM customer WHERE first_name IN ('John', 'Jake', 'Julie');


-- BASIC use of LIKE
-- % as a wildcard, indicating that anything before or after it, depending of the placing, 
-- can be whatever value that matches together with the given subvalue. Also, to take on mind
-- that when its placed at then, the match does not require to have something at the end. for
-- example, something like '%er%', could retrive something like 'Jennifer'. 
-- _, same as the %, but only counts as 1 character. 
SELECT * FROM customer WHERE first_name LIKE 'Ja%';
SELECT * FROM customer WHERE last_name LIKE '_ic%';
SELECT * FROM customer WHERE first_name LIKE 'J%' AND last_name LIKE 'J%';
SELECT * FROM customer WHERE first_name LIKE '%er%';
SELECT * FROM customer WHERE first_name LIKE 'A%' ORDER BY last_name;


-- ++++ CHALLENGE ++++
-- How many payment transactions were greater than $5.00;
SELECT COUNT(*) FROM payment WHERE amount > 5.00;
-- How many actors have a first name that starts with the letter P?
SELECT * FROM actor;
SELECT COUNT(*) FROM actor WHERE first_name LIKE 'P%';
-- How many unique districts are our customers from?
SELECT * FROM address;
SELECT COUNT(DISTINCT(district)) FROM address;
-- Retrive the list of names for those districts from the previous question
SELECT DISTINCT(district) FROM address ORDER BY district ASC;
-- How many films have a rating of R and a replacement cost between $5 and $15?
SELECT COUNT(*) FROM film WHERE rating='R' AND replacement_cost BETWEEN 5 AND 15;
-- How many films have the word Truman somewhere in the title?
SELECT COUNT(*) FROM film WHERE title LIKE '%Truman%';


-- BASIC use of Aggregation functions
-- *** NOTE ***
-- AVG() => retuns avarage value as a floating number. You can use ROUND() to specify precission after decimal
-- COUNT() => returns number of values. This juss simply returns the number of rows, which means by convention you can use COUNT(*)
-- MAX() => returns maximm value
-- MIN() => returns minimum value
-- SUM() => returns the sum of all values
-- Aggregation functions are NOT allowed after a WHERE
SELECT MIN (replacement_cost) FROM film;
SELECT MAX(replacement_cost), MIN(replacement_cost) FROM film;
SELECT ROUND(AVG(replacement_cost), 2) FROM film;
SELECT SUM (replacement_cost) FROM film;


-- BASIC use of GROUP BY
-- GROUP By allows you to aggregate columns per some category
SELECT title, MIN(replacement_cost) FROM film GROUP BY title ORDER BY MIN(replacement_cost);
	-- Get the total amount, and the number of transactions each customer have performed
SELECT customer_id, SUM(amount), COUNT(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount);
SELECT customer_id, staff_id, SUM(amount) FROM payment GROUP BY staff_id, customer_id ORDER BY staff_id;
-- *** NOTE ***
-- DATE() removes the time stamp
SELECT DATE(payment_date) FROM payment; 
SELECT DATE(payment_date), SUM(amount) FROM payment GROUP BY DATE(payment_date) ORDER BY DATE(payment_date);


-- ++++ CHALLENGE ++++
-- We have Staff IDs 1 and 2. How many payments did each staff member handle and who gets the bonus?
SELECT * FROM staff;
SELECT staff_id, COUNT(amount) FROM payment GROUP BY staff_id;
-- What is the average replacement cost per MPAA rating?
SELECT rating, ROUND(AVG(replacement_cost), 4) FROM film GROUP BY rating;
-- What are the customer ids of the top 5 customers by total spend?
SELECT * FROM payment;
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 5;


-- BASIC use of HAVING
-- *** NOTE ***
-- The HAVING clause allows you to filter after an aggregation has already taken place.
-- HAVING allows you to use the aggregate result as a filter along with a GROUP BY.
-- You cannot user WHERE to filter based off of aggregate reults, because those happen after a WHERE is executed. 
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id HAVING SUM(amount) > 100;
SELECT store_id, COUNT(customer_id) FROM customer GROUP BY store_id HAVING COUNT(customer_id) > 300;


-- ++++ CHALLENGE ++++
-- We will assign platinum status to customers that have had 40 or more transaction payments. 
-- What customer_ids are eligible for platinum status?
SELECT customer_id, COUNT(amount) FROM payment GROUP BY customer_id HAVING COUNT(amount) >= 40;
-- What are the customer ids of customers who have spent more than $100 in payment transactions
-- with our staff_id member 2?
SELECT customer_id, SUM(amount) FROM payment WHERE staff_id=2 GROUP BY customer_id HAVING SUM(amount)>100;


-- !!!!! ASSESSMENT TEST !!!!!
-- Return the customer IDs of customers who have spent at least $110 with the staff member who has and ID of 2
SELECT customer_id, SUM(amount) FROM payment WHERE staff_id=2 GROUP BY customer_id HAVING SUM(amount) > 110;
-- How many films begin with the letter J?
SELECT COUNT(*) FROM film WHERE title LIKE 'J%';


-- ...................................................................................................................................................................
-- JOINS
-- *** NOTE ***
-- JOINS allow you to combine multiple tables
-- The main reason for the different JOIN types is to decide how to deal with information only present in one of the joined tables.


-- BASIC use of AS
-- *** NOTE ***
-- AS is only used for indicating a new name, or aliases for a given parameter
-- The AS operator gets executed at the very end of a query, meaning that we cannot use the ALIAS inside a WHERE or HAVING operator. 
SELECT customer_id, SUM(amount) AS total_amount FROM payment GROUP BY customer_id;
SELECT COUNT(amount) AS num_transactions FROM payment;
-- SELECT customer_id, SUM(amount) AS total_spent FROM payment GROUP BY customer_id HAVING total_spent > 100 => It will return an Error


-- BASIC use of INNER JOINS
-- *** NOTE ***
-- An INNE JOIN will result with the set of records that match in both tables.
-- In a Venn Diagram it will be Intersection between Table A and Table B.
-- Table order won't matter in an INNER JOIN
-- For PostgreSQL, JOIN without the explicit INNER, is treated as INNER JOIN
SELECT * FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id;
SELECT payment_id, payment.customer_id, first_name FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id;


-- BASIC use of OUTER JOINS
-- *** NOTE ***
-- OUTER JOINS will allow you to specify how to deal with values only present in one of the tables being joined. 
-- FULL OUTER JOIN grabs everything whether is present in both tables or just in one. On a Venn Diagram it will be like 
-- taking everything that its in both circles. 
-- When using WHERE, it gets rows unique to either table.
-- The following command will be the equivalent of taking everything outside the intersection in a Venn Diagram. 
	-- SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.col = TableB.col WHERE TableA.id IS null OR Table.id IS null
SELECT * FROM customer FULL OUTER JOIN payment ON customer.customer_id = payment.customer_id;
SELECT * FROM customer FULL OUTER JOIN payment ON customer.customer_id = payment.customer_id WHERE customer.customer_id IS null OR payment.payment_id IS null;


-- BASIC use of LEFT OUTER JOIN
-- *** NOTE ***
-- A LEFT OUTER JOIN results in the set of records that are in the left table, if there is no match with the right table,
-- the results are null.
-- On the Venn dagram it will be like taking everything from TableA and the intersection with TableB, but leaving outside
-- all the exclusive element from TableB.
-- In a FULL OUTER JOIN, the order does not matter, but with a LEFT JOIN it does, meaning that the first mentioned table
-- will dictate the default order. 
-- Take the following example:
	-- SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.col = TableB.col;
	-- In this case, the JOIN indicates that we are gonna take all the values from TableA, including the intersection, however
	-- we will exclude the exclusive values from TableB.
-- In the case you want to ignore completely all the values from TableB including the intersection:
	-- SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.col = TableB.col WHERE TableB.id IS null;
SELECT film.film_id, film.title, inventory_id FROM film LEFT JOIN inventory ON inventory.film_id = film.film_id;
SELECT film.film_id, title, inventory_id, store_id FROM film LEFT JOIN inventory ON inventory.film_id = film.film_id WHERE inventory.film_id IS null;
-- A RIGHT JOIN is essentially the same as a LEFT JOIN, except the tables are switched.
-- This would be the same as switching the table order in a LEFT OUTER JOIN. 


-- BASIC use of UNIONS
-- THe UNION operator is used to combine the result-set of two or more SELECT statements.
-- It basically serves to directly concatenate 2 results together, essentially "pasting" them together.
-- Example:
	-- SELECT * FROM TableA UNION SELECT * FROM TableB;
	
	
-- ++++ CHALLENGE ++++
-- What are the emails of the customer who live in California?
SELECT * FROM customer;
SELECT * FROM address;
SELECT email FROM customer LEFT JOIN address ON customer.address_id = address.address_id WHERE address.district='California';
	-- Another approach:
SELECT district, email FROM address INNER JOIN customer ON address.address_id = customer.address_id WHERE district='California';
-- Get a list of all the movies "Nick Wahlberg" has been in.
SELECT * FROM film; --film_id
SELECT * FROM actor; --actor_id, first_name, last_name
SELECT * FROM film_actor; --actor_id, film_id
	-- concatenate Inner Joins
SELECT film.title, actor.first_name, actor.last_name FROM film INNER JOIN film_actor ON film_actor.film_id = film.film_id 
INNER JOIN actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name='Nick' AND actor.last_name='Wahlberg';


-- ...................................................................................................................................................................
-- ADVANCED COMMANDS


-- BASIC use of TIMESTAMPS 
-- *** NOTE ***
-- TIME => Contains only time HH:MM:SS
-- DATE => Contains only date YYYY-MM-DD
-- TIMESTAMP => Contains date and TIME YYYY-MM-DD HH:MM:SS
-- TIMESTAMPTZ => Contains date, time and time zone DD-MM-YYYY HH:MM:SS+HH:MM
-- Careful considerations should be made when designing a table and database and choosing a time data type.
-- Remember, you can always remove historical information, but you can't add it.
SHOW TIMEZONE; -- To know your exact time zone
SELECT NOW(); -- TimeStamp with time zone
SELECT CURRENT_DATE; -- Get current date
SELECT CURRENT_TIME; -- Get current time with time zone
-- EXTRACT()
	-- Allows you to "extract" or obtain. asub-component of a date value
	-- YEAR, MONTH, DAY, WEEK, QUARTER
SELECT EXTRACT(YEAR FROM payment_date) AS payment_year FROM payment;
-- AGE()
	-- Calcultaes and returns the current age given a timestamp
SELECT AGE(payment_date) FROM payment;
-- TO_CHAR()
	-- General function to convert data types to text
	-- Useful for timestamp formating
SELECT TO_CHAR(payment_date, 'MONTH-YYYY') FROM payment;
SELECT TO_CHAR(payment_date, 'MM    YYYY') FROM payment;
SELECT TO_CHAR(payment_date, 'mon/dd/YYYY') FROM payment;
SELECT TO_CHAR(payment_date, 'dd-MM-YYYY') FROM payment;


-- ++++ CHALLENGE ++++
-- During which months did payments occur? Format your answer to return back the full month name
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH')) FROM payment;
-- How many payments occurred on a Monday?
SELECT COUNT(TO_CHAR(payment_date, 'FMDay')) FROM payment GROUP BY TO_CHAR(payment_date, 'FMDay');
	-- DOW, PostgreSQL considers Sunday as the start of the week (indexed as 0)
SELECT COUNT(TO_CHAR(payment_date, 'FMDay')) FROM payment WHERE EXTRACT(DOW FROM payment_date)=1 GROUP BY TO_CHAR(payment_date, 'FMDay');


-- BASIC use of MATHEMATICAL FUNCTIONS
-- SQL accepts a variery of mathematical operations, such as arithmetical operations to even trigonometry
SELECT ROUND(rental_rate/replacement_cost, 4) * 100 AS percent_cost FROM film;


-- BASIC user of STRING FUNCTIONS AND OPERATIONS
-- PostgreSQL also provides a variey of string functions and operators that allow you to edit, combine, 
-- and alter text data COLUMNS
SELECT LENGTH(first_name) FROM customer; 
-- || => concatenates a string
SELECT first_name || ' ' || last_name AS full_name FROM customer;
SELECT UPPER(first_name) FROM customer;
-- LEFT( string, number) => takes the number of indicated characters from left to right.
SELECT LOWER(LEFT(first_name, 3)) || LOWER(LEFT(last_name, 3)) || '@gmail.com' FROM customer;


-- BASIC use of SUBQUERY
-- A subquery allows you to construct complex queries, essentially performing a query on the results of another query.
-- The syntax is straight forward and involves 2 SELECT statements.
SELECT title, rental_rate FROM film WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);
-- Example of using a more complex subQuery, using a Join query as a Subquery;
SELECT * FROM inventory; -- invetory_id
SELECT * FROM rental; -- inentory_id, film_id
SELECT film_id, title FROM film WHERE film_id IN 
	(SELECT inventory.film_id FROM rental INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id 
	WHERE rental.return_date BETWEEN '2005-05-29' AND '2005-05-30');
-- The EXISTS operator is used to test for existence of rows in a subquery.
-- Typically a subquery is passed in the EXISTS() function to check if any rows are returned with the subquery. 
SELECT first_name, last_name FROM customer WHERE EXISTS (SELECT * FROM payment WHERE payment.customer_id = customer.customer_id AND amount > 11); 


-- BASIC us of SELF JOIN
-- A Self Join is a SubQuery in which a table is joined to itself. dvdrental
-- Self-joins are useful for comparing values of row within the same table. 
-- The sSelf Join can be viewed as a Join of two copies of the same table.
-- The table is not actually copied, but SQL performs the command as though it were. 
-- There is no special keyword for a Self Join, its simply standard JOIN syntax with the same table in both parts.
-- However, when using a Self Join it is necessary to use an alias for the table, otherwise the table names would be ambigous.
-- For example:
	-- SELECT emp.name, report.name FROM employees AS emp JOIN employees AS report ON emp.emp_id = report.report_id;
SELECT f1.title, f2.title, f1.length  FROM film AS f1 INNER JOIN film AS f2 ON f1.film_id != f2.film_id;



-- ...................................................................................................................................................................
-- CREATING DATA BASES AND TABLES


-- DATA TYPES
	-- Boolean => True or False
	-- Character => char, varchar, and text
	-- Numeric => Integer and Floating-point number
	-- Temporal => Date, Time, TimeStamp and Interval
	-- UUID => Universaly Unique Identifiers
	-- Array => Stores an array of Strings, Numbers, etc. 
	-- JSON
	-- Hstore key-value pair
	-- Special types such as network address and geometric data
-- When creating a database and table, take your time to plan for long term storage. 
-- Remember you can always remove historical information you've decided you aren't using, but you can't go  back
-- in time to add information. 


-- PRIMARY and FOREIGN KEYS
-- A PRIMARY KEY is a column or a group of columns to identify a row uniquely in a table.
-- Primary Keys are also important since they allow ypu to easily discern what columns should be used 
-- for joining tables together. 
-- A FOREIGN KEY is a field or group of fields in a table that uniquely identifies a row in another table. 
-- A foreign key is defined in a table that references to the primary key of the other table.
-- The table that contains the FOREIGN KEY is called referencing table or child table.
-- The table to which the FOREIGN KEY referenes is called referenced table or parent table.
-- A table can have multiple FOREIGN KEYS depending on its relationship with other tables.
-- When creating tables and defining columns you can use constraints to define columns as being a primary key, or 
-- attaching a foreign key relationship to another table.

-- CONSTRAINTS
-- Constraints are the rules enforced on data columns on table.
-- These are used to prevent invalid data from being entered into the database.
-- This ensures the accuracy and reliability of the data in the database.
-- Constraints can be divided into two main categories.
	-- Column Constraints: Constrains the data in a column to adhere to certain conditions. 
	-- Table Constraints: Applied to the entire table rather than to an individual column.
-- The most common constraints used: 
	-- NOT NULL => Ensures that a column cannot have NULL value
	-- UNIQUE => Ensures that all values in a column are different
	-- PRIMARY KEY => Uniquely identifies each row/record in a database table
	-- FOREIGN KEY => Constrains data based on columns in other tables
	-- CHECK => Ensures that all values in a column satisfy certain conditions
	-- EXCLUSION => Ensures that if any two rows are compared on the specified colum or expression using
		-- the specified operator, not all of these comparisons will return TRUE.
	-- CHECK (condition) => To check a condition when inserting or updating data
	-- REFERENCES => to constrain the value stored in the column that must exist in a column in another table. 
	-- UNIQUE (column_list) => Forces the values stored in the columns listed inside the parentheses to be unique
	-- PRIMARY KEY (column_list) => Allows you to defines the primary key that consists of multiple columns. 


-- CREATE TABLE
-- SERIAL
	-- In PostgreSQL, a Sequence is a special kind of database object that generates a sequence of integers.
	-- A sequence is often used as the primary key column in a table. 
	-- It will create a sequence object and set the next value generated by the sequence as the default value for the column.
	-- This is perfect for a primary key, because it logs unique integer entries for you automatically upon insertion 
	-- If a row is later removed, the column with the SERIAL data type will NOT adjust, marking the fact that a row was removed from the sequene. 
CREATE DATABASE learning;
ALTER DATABASE learning OWNER TO postgres; 
\connect learning;
--USE learning;
CREATE TABLE players(player_id SERIAL PRIMARY KEY, age SMALLINT NOT NULL);	
CREATE TABLE account (
	user_id SERIAL PRIMARY KEY,  -- ERIAL is only used when declaring a PRIMARY KEY
	username VARCHAR(50) UNIQUE NOT NULL, 
	password VARCHAR(50) NOT NULL, 
	email VARCHAR(250) UNIQUE NOT NULL, 
	created_on TIMESTAMP NOT NULL, 
	last_login TIMESTAMP
);

CREATE TABLE job( 
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP
);


-- BASIC use of INSERT
-- Inserting from another table
	-- INSER INTO table1 (col1, col2) SELECT col3, col4 FROM table2;
-- SERIAL columns do not need to be provided a value.
INSERT INTO account (username, password, email, create_on) VALUES ('Antonio', 'password', 'Antonio@gmail.com', CURRENT_TIMESTAMP);
SELECT * FROM account; 

INSERT INTO job (job_name) VALUES ('Software Engineer');
SELECT * FROM job;

INSERT INTO acount_job(user_id, job_id, hire_date) VALUES (1, 1, CURRENT_TIMESTAMP); 


-- BASIC use of UPDATE
-- The UPDATE keyword allows for the changing of values of the columns in a table. 
UPDATE account SET last_login = CURRENT_TIMESTAMP WHERE last_login IS NULL;
-- Set based on another column
UPDATE account SET last_login = created_on;
-- "UPDATE JOIN" Using another table information to update the current table.
	-- UPDATE tableA SET col1 = tableB.col2 FROM tableB WHERE tableA.id = tableB.id;
-- Return affected rows. So you can see what are the rows affected. Otherwise you will only receive a success/error message;
UPDATE account SET last_login = created_on RETURNING account_id, last_login;
UPDATE account_job SET hire_date =  account.created_on FROM account WHERE account_job.user_id = account.user_id;
UPDATE account SET last_login = CURRENT_TIMESTAMP RETURNING email, created_on, last_login;


-- BASIC use of DELETE
-- You can delete rows based on their presence in other tables. 
	-- DELET FROM tableA USING tableB WHERE tableA.id = tableB.id
-- Deleter Evrything from a Table
	-- DELETE FROM tableA
-- Similar to UPDATE, you can aso add in a RETURNING call to return rows that were removed.
INSERT INTO job(job_name) VALUES 'QA';
DELETE FROM job WHERE job_name = 'QA' RETURNING job_id, job_name;


-- BASIC use of ALTER 
-- The ALTER clause allows for changes to an existing table structure, such as:
	-- Adding, dropping, or renaming columns.
	-- Chaning a column's data type. 
	-- Set DEFAULT values for a column.
	-- Add CHECK constraints. 
	-- Rename table.
-- ALTER constraints
	-- ALTER tableA ALTER COLUMN col1 SET TO NULL/ DROP DEFAULT/ ADD CONSTRAINT const_name;
CREATE TABLE information(
	info_id SERIAL PRIMARY KEY, 
	title VARCHAR(500) NOT NULL, 
	person VARCHAR(50) NOT NULL UNIQUE
);
SELECT * FROM information;
-- Rename Table 
ALTER TABLE information RENAME TO new_info;
SELECT * FROM new_info;
-- Rename Column
ALTER TABLE new_info RENAME COLUMN person TO people;
SELECT * FROM new_info;
-- Change the column constraints
-- SET to add a constraint
-- DROP to remove a constraint
INSERT INTO new_info(title) VALUES ('some new title'); -- Error
ALTER TABLE new_info ALTER COLUMN people DROP NOT NULL; 
INSERT INTO new_info(title) VALUES ('some new title'); -- Success


-- BASIC use of DROP
-- DROP allows for the complete removal of a column in a table. 
-- In PostgreSQL this will also automatically remove all of its indexes and constraints involving the column. 
-- However, it will mot remove columns used in views, triggers, or stored procedures without the additional CASCADE clause.
-- DROP a column. Check for existence to avoid error.
	-- ALTER TABLE tableA DROP COLUMN IF EXISTS col1;
ALTER TABLE new_info DROP COLUMN people;
ALTER TABLE new_info DROP IF EXISTS COLUMN people;


-- BASIC use of CHECK
-- The CHECK constraint allows you to create more customized constraints that adhere to a certain condition.
-- Such as making sure all inserted integer values fall below a certain threshold.
CREATE TABLE employees (
	employe_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK (birthdate > '1900-01-01'),
	hire_date DATE CHECK (hire_date > birthdate),
	salary INTEGER CHECK (salary > 0)
);

INSERT INTO employees(first_name, last_name, birthdate, hire_date, salary) 
VALUES('Bruce', 'Wayne', '1899-11-03', '2010-01-01', -100); -- ERROR

INSERT INTO employees(first_name, last_name, birthdate, hire_date, salary) 
VALUES('Bruce', 'Wayne', '2000-11-03', '2024-01-01', 500); -- SUCCESS

SELECT * FROM employees;


-- !!!! ASSESSMENT !!!!
/*
Create a new database called "School" this database should have two tables: teachers and students.
The students table should have columns for student_id, first_name,last_name, homeroom_number, phone,email, and graduation year.
The teachers table should have columns for teacher_id, first_name, last_name,
homeroom_number, department, email, and phone.
The constraints are mostly up to you, but your table constraints do have to consider the following:
You must have a phone number to contact students in case of an emergency.
You must have ids as the primary key of the tables
Phone numbers and emails must be unique to the individual.
Once you've made the tables, insert a student named Mark Watney (student_id=1) who has a phone number of 777-555-1234 and doesn't have an email. He graduates in 2035 and has 5 as a homeroom number.
Then insert a teacher names Jonas Salk (teacher_id = 1) who as a homeroom number of 5 and is from the Biology department. His contact info is: jsalk@school.org and a phone number of 777-555-4321.
*/
CREATE TABLE students(
student_id serial PRIMARY KEY,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL, 
homeroom_number integer,
phone VARCHAR(20) UNIQUE NOT NULL,
email VARCHAR(115) UNIQUE,
grad_year integer);

CREATE TABLE teachers(
teacher_id serial PRIMARY KEY,
first_name VARCHAR(45) NOT NULL,
last_name VARCHAR(45) NOT NULL, 
homeroom_number integer,
department VARCHAR(45),
email VARCHAR(20) UNIQUE,
phone VARCHAR(20) UNIQUE);

INSERT INTO students(first_name,last_name, homeroom_number,phone,grad_year)VALUES ('Mark','Watney',5,'7755551234',2035);

INSERT INTO teachers(first_name,last_name, homeroom_number,department,email,phone)VALUES ('Jonas','Salk',5,'Biology','jsalk@school.org','7755554321');



-- ...................................................................................................................................................................
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












