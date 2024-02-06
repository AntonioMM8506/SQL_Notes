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