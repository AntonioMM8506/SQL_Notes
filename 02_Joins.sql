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
