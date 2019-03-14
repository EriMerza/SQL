-- 1
use sakila;

-- 2
SELECT first_name, last_name
FROM actor;

-- 3
select UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 4
select first_name, last_name, actor_id
FROM actor
WHERE first_name = "Joe";

-- 5 
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE '%GEN%';

-- 6
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 7
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 8
ALTER TABLE actor
ADD COLUMN description blob AFTER last_name;

-- 9
ALTER TABLE actor
DROP COLUMN description;

-- 10
SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
HAVING `last_name_frequency` >= 1;

-- 11
SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
Having `last_name_frequency` >= 2;

-- 12
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

-- 13 
UPDATE actor
 SET first_name =
CASE
 WHEN first_name = 'HARPO'
 THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172;

-- 14
SHOW CREATE TABLE address;

-- 15
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON (staff.address_id = address.address_id);

-- 16
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff 
INNER JOIN payment 
ON payment.staff_id = staff.staff_id
WHERE MONTH(payment.payment_date) = 08 AND YEAR(payment.payment_date) = 2005
GROUP BY staff.staff_id;

-- 17 
SELECT film_actor.title, COUNT(film_actor.actor_id) AS 'Actors'
FROM film_actor
INNER JOIN film 
ON film.film_id = film_actor.film_id
GROUP BY film.title
ORDER BY Actors desc;

-- 18
SELECT title, COUNT(inventory_id) AS '# of copies'
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;

-- 19
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 20
SELECT title
FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
 (
 SELECT language_id
 FROM language
 WHERE name = 'English'
 );

-- 21
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
 (
 SELECT actor_id
 FROM film_actor
 WHERE film_id =
 (
  SELECT film_id
  FROM film
  WHERE title = 'Alone Trip'
  )
);

-- 22
SELECT first_name, last_name, email, country
FROM customer
INNER JOIN address
ON (customer.address_id = address.address_id)
INNER JOIN city
ON (address.city_id = city.city_id)
INNER JOIN country ctr
ON (city.country_id = country.country_id)
WHERE country.country = 'canada';

-- 23
SELECT title, category.name
FROM film 
INNER JOIN film_category
ON (film.film_id = film_category.film_id)
INNER JOIN category
ON (category.category_id = film_category.category_id)
WHERE name = 'family';

-- 24
SELECT title, COUNT(title) as 'Rentals'
FROM film
INNER JOIN inventory
ON (film.film_id = inventory.film_id)
INNER JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
GROUP by title
ORDER BY rentals desc;

-- 25
SELECT store.store_id, SUM(amount) AS Gross
FROM payment
INNER JOIN rental
ON (payment.rental_id = rental.rental_id)
INNER JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
INNER JOIN store 
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id;

-- 26
SELECT store_id, city, country
FROM store
INNER JOIN address
ON (store.address_id = address.address_id)
INNER JOIN city
ON (city.city_id = address.city_id)
INNER JOIN country
ON(city.country_id = country.country_id);

-- 27
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment
INNER JOIN rental
ON (payment.rental_id = rental.rental_id)
INNER JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
INNER JOIN film_category
ON (inventory.film_id = film_category.film_id)
INNER JOIN category
ON (film_category.category_id = category.category_id)
GROUP BY category.name
ORDER BY SUM(amount) DESC;

-- 28
CREATE VIEW top_five_genres AS
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment
INNER JOIN rental
ON (payment.rental_id = rental.rental_id)
INNER JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
INNER JOIN film_category
ON (inventory.film_id = film_category.film_id)
INNER JOIN category
ON (film_category.category_id = category.category_id)
GROUP BY category.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 29
SELECT *
FROM top_five_genres;

-- 30
DROP VIEW top_five_genres;
