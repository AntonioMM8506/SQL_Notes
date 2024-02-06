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
