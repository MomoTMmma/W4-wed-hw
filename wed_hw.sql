-- WEEK 5 WEDNESDAY QUESTIONS

-- 1. List all customers who live in Texas (use JOINs)

SELECT * FROM address

SELECT *
FROM address
WHERE district = 'Texas';

-- SELECT *
-- FROM customer
-- WHERE customer.customer_id IN (
--   SELECT address.customer_id
--   FROM address
--   WHERE address.district = 'Texas'
-- );

-- SELECT *
-- FROM customer
-- INNER JOIN address
-- ON customer.last_update = address.last_update
-- WHERE address.district = 'Texas';

-- SELECT district, customer.last_update
-- from address
-- INNER JOIN customer
-- ON customer.last_update = address.last_update;

--^^^ THESE TOP 3 QUERIES WHERE TRIAL AND ERRORS I WAS TRYING TO JOIN THE TABLES USING CUSTOMER_ID 
-- BUT THE REALIZED ITS NOT IT THE ADDRESS TABLE. 
-- I TRIED JOING THE TABLES USING THE LAST_UPDATE BUT THAT DIDNT WORK. 
-- I WAS ABOUT TO GIVE UP WHEN I SAW ADDRESS_ID IN THE CUSTOMERS TABLE

SELECT *
FROM address
INNER JOIN customer
ON address.address_id = customer.address_id
WHERE address.district = 'Texas';

-- THERE ARE 5 CUSTOMERS WHO LIVE IN TEXAS!



-- 2. Get all payments above $6.99 with the Customer's Full Name

SELECT first_name, last_name, payment.amount
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
WHERE payment.amount > 6.99;

-- THERE ARE 25 CUSTOMER WITH PAYMENTS OVER 6.99. 
-- THERE ARE 22 PETER MENARD'S
-- THE OTHERS ARE NAMED MARY SMITH, DOUGLAS GRAF, AND ALVIN DELOACH



-- 3. Show all customers names who have made payments over $175(use subqueries)

-- SELECT customer.first_name, payment.amount
-- FROM customer
-- JOIN payment ON customer.customer_id IN (
--   SELECT payment.customer_id
--   FROM payment
--   WHERE payment.amount > 175
-- );

-- THIS FIRST ONE WORKED BUT IT HAD FLAWS IN IT.
-- IT WAS GIVING ME NEGATIVE NUMBERS WHICH IS NOT WHAT I WANTED

SELECT customer.first_name, payment.amount
FROM customer
JOIN payment 
ON customer.customer_id = payment.customer_id 
WHERE payment.amount > 175 
AND customer.customer_id IN(
    SELECT payment.customer_id
    FROM payment
    WHERE payment.amount > 175
);

-- THERE ARE 2 CUSTOMERS. MARY WHO MADE A PAYMENT AMOUNT OF 578.49
-- AND DOUGLAS WHO MADE A PAYMENT OF 917.67



-- 4. List all customers that live in Nepal (use the city table)
SELECT * FROM city

Select * 
FROM city
WHERE city = 'Nepal';

SELECT first_name, last_name
FROM(
    SELECT city, first_name, last_name
    FROM address
    INNER JOIN customer
    ON address.address_id = customer.address_id
    INNER JOIN city
    ON city.city_id = address.city_id
)AS multijoiner
WHERE city = 'Nepal';

-- I WANTED TO DOUBLE CHECK MY WORK SO I PUT THE BOTTOM QUIERY TO MAKE SURE
-- THERE ARE NO CUSTOMERS THAT LIVE IN NEPAL



-- 5. Which staff member had the most transactions?

SELECT * FROM staff

SELECT * FROM payment

SELECT * FROM rental

SELECT 
    first_name, last_name AS staff_name,
    max_transaction_count AS transaction_count
FROM 
    staff
    JOIN (
        SELECT staff_id, COUNT(*) AS max_transaction_count
        FROM payment
        GROUP BY staff_id
        ORDER BY max_transaction_count DESC
        LIMIT 1
    ) AS max_transactions ON staff.staff_id = max_transactions.staff_id;

-- THE STAFF MEMBER JON STEPHENS HAS THE MOST TRANSACTIONS WITH 7304



-- 6. How many movies of each rating are there?

SELECT * FROM film

SELECT rating, COUNT(*) 
AS movie_count
FROM film
GROUP BY rating;

-- NC-17 HAS 209
-- G HAS 178
-- PG-13 HAS 223
-- PG HAS 194
-- R HAS 196



-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)

SELECT * 
FROM payment
WHERE amount = 6.99;

SELECT first_name, last_name, payment.amount, payment.payment_id
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
WHERE payment.amount > 6.99
AND(
    SELECT COUNT(*)
    FROM payment AS p
    WHERE p.customer_id = payment.customer_id
) = 1;

-- I AM GETTING NO DATA EVEN WHEN I RAN THE TOP QUERY TO DOUBLE CHECK MY ANSWER
-- IT WAS STILL GIVING ME NO DATA



-- 8. How many free rentals did our stores give away?

SELECT * FROM rental

SELECT COUNT(*)
AS total_free_rentals
FROM rental
WHERE rental.inventory_id = 0;

-- THERE ARE 0 FREE RENTALS THAT THE STORE GAVE AWAY