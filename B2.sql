SELECT
	name
FROM
	sakila.category ;

SELECT
	category_id,
	last_update,
	name
FROM
	sakila.category;

SELECT
	*
FROM
	sakila.category;

SELECT
	film_id,
	title
FROM
	sakila.film
ORDER BY
	film_id;

SELECT
	film_id,
	title
FROM
	sakila.film
ORDER BY
	film_id DESC;

SELECT
	rental_id,
	rental_date,
	inventory_id,
	customer_id,
	return_date,
	staff_id,
	last_update
FROM
	sakila.rental
ORDER BY
	customer_id DESC,
	rental_id ASC,
	return_date ASC;

SELECT
	rental_id,
	rental_date,
	inventory_id,
	customer_id,
	return_date,
	staff_id,
	last_update
FROM
	sakila.rental
ORDER BY
	4 DESC,
	1 ASC,
	5 ASC;

SELECT
	DISTINCT actor_id
FROM
	sakila.film_actor;

SELECT
	DISTINCT customer_id,
	staff_id
FROM
	sakila.payment;

SELECT
	customer_id ,
	store_id ,
	first_name ,
	last_name ,
	email
FROM
	sakila.customer
LIMIT 5;

SELECT
	film_id ,
	title AS film_name,
	release_year AS public_year,
	language_id
FROM
	sakila.film

SELECT
	payment_id AS `payment id`,
	customer_id AS `customer id`,
	staff_id AS `staff_id`,
	rental_id AS `rental id`,
	amount ,
	payment_date AS `payment date`,
	last_update AS `last update `
FROM
	sakila.payment;
	
SELECT
	*
FROM
	sakila.customer
WHERE
	store_id = 2
LIMIT 10;

SELECT
	*
FROM
	sakila.customer c
WHERE
	first_name = 'BARBARA'
LIMIT 10;

SELECT * FROM sakila.customer c WHERE store_id = 2 AND customer_id = 400;
SELECT * FROM sakila.customer c WHERE store_id = 2 AND first_name = 'Jon';

SELECT
	staff_id AS `Staff ID`,
	email AS `Email`,
	username as `User Name`,
	last_update AS `Last Update`
FROM
	sakila.staff
WHERE
	username <> 'Jon';

SELECT
	language_id,
	name,
	last_update
FROM
	sakila.`language`
WHERE
	language_id > 4;
	
SELECT
	film_id,
	title,
	release_year,
	special_features,
	replacement_cost
FROM
	sakila.film f
WHERE
	film_id >= 995;
	
SELECT
	language_id,
	name,
	last_update
FROM
	sakila.`language`
WHERE
	language_id < 4;

SELECT
	language_id,
	name,
	last_update
FROM
	sakila.`language`
WHERE
	language_id <= 4;
	
SELECT
	film_id,
	title,
	release_year
FROM
	sakila.film
WHERE
	film_id >= 995
	AND release_year = 2006;
	
SELECT
	rental_id,
	rental_date ,
	inventory_id ,
	customer_id ,
	return_date ,
	staff_id ,
	last_update
FROM
	sakila.rental r
WHERE
	customer_id = 399
	OR customer_id = 3
ORDER BY
	1 DESC;

SELECT
	rental_id,
	rental_date ,
	inventory_id ,
	customer_id ,
	return_date ,
	staff_id ,
	last_update
FROM
	sakila.rental r
WHERE
	customer_id IN (399,3)
ORDER BY
	rental_date DESC;

SELECT * FROM sakila.customer c WHERE first_name LIKE 'MA%';
SELECT * FROM sakila.customer c WHERE first_name LIKE '%MA%';
SELECT * FROM sakila.customer c WHERE first_name LIKE '%MA';
SELECT * FROM sakila.customer c WHERE first_name LIKE '__MA%';
SELECT * FROM sakila.customer c WHERE first_name LIKE 'm%n';

SELECT
	film_id,
	title,
	release_year
FROM
	sakila.film f
WHERE
	film_id BETWEEN 1 AND 5;
	
SELECT
	*
FROM
	sakila.customer c
WHERE
	first_name LIKE 'm%n'
	AND first_name NOT LIKE '%LYN%';
	
SELECT
	*
FROM
	sakila.customer c
WHERE
	first_name LIKE 'm%n'
	AND first_name NOT IN ('MEGAN', 'MARION');
	
SELECT
	*
FROM
	sakila.customer c 
WHERE
	first_name  LIKE 'm%n'
	AND customer_id NOT BETWEEN 90 AND 550;
	
SELECT
	*
FROM
	sakila.customer c
WHERE
	active = 1
	AND address_id BETWEEN 5 AND 10
	AND (first_name LIKE 'm%n'
		OR first_name NOT LIKE '_a%')
ORDER BY
	create_date DESC
LIMIT 10;

SELECT
	staff_id ,
	first_name ,
	last_name ,
	address_id ,
	picture ,
	email ,
	store_id,
	active ,
	username ,
	password ,
	last_name
FROM
	sakila.staff s
WHERE
	picture IS NULL;
	
SELECT
	staff_id ,
	first_name ,
	last_name ,
	address_id ,
	picture ,
	email ,
	store_id,
	active ,
	username ,
	password ,
	last_name
FROM
	sakila.staff s
WHERE
	picture IS NOT NULL;
	
SELECT
	title,
	release_year,
	rental_rate,
	`length`,
	rating ,
	CASE rating 
		WHEN 'G' THEN 'family'
		WHEN 'PG' THEN 'teens'
		WHEN 'PG-13' THEN 'teens'
		WHEN 'R' THEN 'adults'
		WHEN 'NC-17' THEN 'adults'
	END AS target_audience
FROM sakila.film f
ORDER BY 1;

SELECT
	payment_id,
	customer_id,
	amount,
	CASE
		WHEN amount < 3 THEN 'Low Price'
		WHEN amount >= 3 AND amount <=7 THEN 'Medium Price'
		ELSE 'High Price'
	END AS price_type,
	payment_date
FROM sakila.payment
ORDER BY payment_id;

SELECT
	address_id,
	address ,
	CASE
		WHEN address2 IS NULL THEN 'unknow'
	END AS address2,
	district,
	city_id,
	postal_code,
	phone,
	location
FROM
	sakila.address a;

SELECT
	address_id,
	address ,
	CASE
		WHEN address2 LIKE '' OR address2 IS NULL THEN 'unknow'
	END AS address2,
	district,
	city_id,
	postal_code,
	phone,
	location
FROM
	sakila.address a;
	
SELECT
	film_id,
	title,
	rental_rate,
	rental_duration
FROM
	sakila.film
WHERE rental_duration = CASE rental_rate 
							WHEN 0.99 THEN 3
							WHEN 2.99 THEN 4
							WHEN 4.99 THEN 5
							ELSE 6
						END
ORDER BY title DESC;

SELECT
	*
FROM
	ecommerce.customers c
ORDER BY
	(CASE city
		WHEN 'Las Vegas' THEN 1
		WHEN 'San Francisco' THEN 2
		WHEN 'Singapore' THEN 3
		ELSE 4
	END) ASC,
	city DESC;

SELECT
	address_id,
	address,
	COALESCE (address2,
	'unknow') AS address2,
	district ,
	city_id ,
	postal_code ,
	phone ,
	location
FROM
	sakila.address a;
	
SELECT COALESCE (NULL, 'LONG', 1233, NULL);
SELECT COALESCE (NULL, NULL);
SELECT COALESCE (NULL, NULL, 1233);

SELECT NULLIF (225, 'LONG');
SELECT NULLIF ('HELLO','hello');

SELECT
	address_id,
	address ,
	district ,
	city_id ,
	postal_code ,
	NULLIF (phone, '') AS phone,
	location,
	last_update
FROM
	sakila.address a
WHERE
	phone = '';
	
SELECT
	address_id ,
	address,
	NULLIF(address2, '') AS address2,
	district,
	city_id ,
	postal_code ,
	phone ,
	location ,
	last_update
FROM
	sakila.address a ;
	
SELECT
	address_id ,
	address ,
	IFNULL (address2, 'unknow') AS address2,
	district,
	city_id ,
	postal_code ,
	phone ,
	location
FROM
	sakila.address a ;
	
SELECT
	customerNumber ,
	customerName ,
	IFNULL(salesRepEmployeeNumber, 0) AS salesRepEmployeeNumber,
	creditLimit
FROM
	ecommerce.customers c
WHERE
	customerNumber BETWEEN 120 AND 130
ORDER BY 1;

SELECT
	staff_id,
	UPPER(first_name) AS first_name,
	UPPER(last_name) AS last_name,
	address_id,
	picture,
	email,
	store_id,
	active,
	username,
	`password`,
	last_update 
FROM
	sakila.staff s;
	
SELECT
	staff_id,
	UPPER(first_name) AS first_name,
	UPPER(last_name) AS last_name,
	address_id,
	picture,
	LOWER (email) AS email ,
	store_id,
	active,
	username,
	`password`,
	last_update 
FROM
	sakila.staff s;
	
SELECT
	film_id,
	title,
	LENGTH(title) AS title_length
FROM
	sakila.film f
ORDER BY
	3 DESC;
	
SELECT
	film_id,
	title,
	description,
	LENGTH(title) AS title_length,
	rating 
FROM
	sakila.film f
WHERE LENGTH(description) >= 100;

SELECT
	"My name is Long" AS str,
	LENGTH("My name is Long") AS len_str;
	
SELECT
	TRIM(LEADING 'M' FROM 'My name is Long') AS str,
	LENGTH(TRIM(LEADING 'M' FROM 'My name is Long'));
	
SELECT 
	TRIM(TRAILING 'M' FROM 'My name is Long') AS str,
	LENGTH(TRIM(TRAILING 'M' FROM 'My name is Long')) AS len_str;
	
SELECT
	TRIM(BOTH 'M' FROM 'My name is LongM') AS str,
	LENGTH(TRIM(BOTH 'M' FROM 'My name is LongM')) AS len_str;

SELECT
	TRIM('M' FROM 'My name is LongM') AS str,
	LENGTH(TRIM('M' FROM 'My name is LongM')) AS len_str;

SELECT 
	"    My name is Long     " AS str,
	LENGTH("    My name is Long     ") AS len_str;

SELECT
	LTRIM("    My name is Long    ") AS str,
	LENGTH (LTRIM("    My name is Long    ")) AS len_str;

SELECT
	RTRIM("    My name is Long    ") AS str,
	LENGTH (RTRIM("    My name is Long    ")) AS len_str;

SELECT
	TRIM("    My name is Long    ") AS str,
	LENGTH (TRIM("    My name is Long    ")) AS len_str;

SELECT SUBSTRING('LeHoangLong', 5);
SELECT SUBSTRING('LeHoangLong' FROM 5); 

SELECT SUBSTRING('LeHoangLong',1, 5);
SELECT SUBSTRING('LeHoangLong' FROM 1 FOR 5); 

SELECT SUBSTRING('LeHoangLong',-3, 3);
SELECT SUBSTRING('LeHoangLong' FROM -3 FOR 3); 

SELECT SUBSTRING('LeHoangLong', 40);

SELECT REPLACE ('abcLong456', '456', '123');

SELECT REPLACE ('abcLong456', 'abc', '123');

SELECT REPLACE ('abcLong456', 'KFG', '123');

SELECT REPLACE ('abc ABC', 'c', 'D');

SELECT POSITION('E' IN 'LE HOANG LONG');
SELECT POSITION('e' IN 'LE HOANG LONG');

SELECT POSITION('hoang' IN 'LE HOANG LONG');

SELECT POSITION('m' IN 'LE HOANG LONG');

SELECT
	customer_id,
	first_name,
	last_name,
	POSITION('a' IN last_name) AS a_loc
FROM
	sakila.customer c ;

SELECT
	CONVERT ('2000-11-11',
	DATE);

SELECT
	CONVERT ('2000-11-11 11:11:11',
	DATETIME);

SELECT CONVERT ('11:11:11', TIME);

SELECT CONVERT (111, CHAR);

SELECT
	payment_id ,
	customer_id ,
	staff_id,
	CONVERT (rental_id, CHAR) AS rental_id,
	amount ,
	payment_date ,
	last_update
FROM
	sakila.payment p ;

SELECT DATE_ADD('2000-11-11 11:11:11.000005', INTERVAL 5 MICROSECOND) ;
	
SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL -11 SECOND) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL 50 MINUTE) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL -5 HOuR) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL 30 DAY) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL 11 WEEK) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL -1 MONTH) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL 5 QUARTER) ;

SELECT DATE_ADD('2000-11-11 11:11:11', INTERVAL 2 YEAR) ;

SELECT
	payment_id ,
	rental_id ,
	amount ,
	payment_date ,
	last_update
FROM
	sakila.payment p
WHERE
	payment_date >= DATE_ADD('2006-01-01 00:00:00', INTERVAL -1 MONTH)
	AND amount > 3;
	
SELECT DATE_SUB('2022-8-29 11:15:20.000001', INTERVAL 5 MICROSECOND) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 20 SECOND) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 20 MINUTE) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 12 HOUR) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 20 DAY) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 20 WEEK) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL -1 MONTH) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 8 QUARTER) ;

SELECT DATE_SUB('2022-8-29 11:15:20', INTERVAL 5 YEAR) ;

SELECT DATE_SUB('2022-8-29 11:15:20.000001', INTERVAL '15.000001' SECOND_MICROSECOND) ;

SELECT DATE_SUB('2022-8-29 11:15:20.000001', INTERVAL '10:15.000001' MINUTE_MICROSECOND) ;

SELECT DATE_SUB('2022-8-29 11:15:20.000001', INTERVAL '3:15' MINUTE_SECOND) ;

SELECT
	payment_id,
	rental_id,
	payment_date ,
	last_update
FROM
	sakila.payment p
WHERE
	payment_date >= '2006-01-01 00:00:00'
	AND payment_date <= DATE_SUB('2006-01-01 00:00:00', INTERVAL -2 MONTH)
	AND amount > 3
ORDER BY
	payment_date ASC
	
SELECT
	payment_id,
	rental_id,
	payment_date ,
	last_update
FROM
	sakila.payment p
WHERE
	payment_date >= '2006-01-01 00:00:00'
	AND payment_date <= DATE_SUB('2006-01-01 00:00:00', INTERVAL 2 MONTH)
	AND amount > 3
ORDER BY
	payment_date ASC
	
SELECT CURRENT_DATE() ;

SELECT CURRENT_DATE() + 5;

SELECT DATE_SUB(CURRENT_DATE(), INTERVAL 5 DAY) ;
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY) ;

 SELECT DATEDIFF('2022-04-15', '2022-03-10');

SELECT DATEDIFF(CURRENT_DATE(),'2022-3-10') ;

SELECT
	*,
	DATEDIFF(last_update, rental_date) AS duration
FROM
	sakila.rental r
ORDER BY
	duration DESC;
	
SELECT EXTRACT(MINUTE FROM '2022-10-05 15:12:11');

SELECT DATE_FORMAT('2020-10-15', '%Y'); 

SELECT DATE_FORMAT('2020-10-15', '%M, %d, %Y'); 

SELECT DATE_FORMAT('2000-11-11', '%W, %M %D, %Y'); 

SELECT STR_TO_DATE('August 30 2022', '%M %d %Y');

SELECT STR_TO_DATE('Tuesday,August 30, 2022', '%W, %M %d, %Y');

SELECT STR_TO_DATE('2022,11,10 09', '%Y, %m,%d %h');

SELECT STR_TO_DATE('11,15,15', '%h,%i,%s');

SELECT 20 +30;

SELECT
	store_id,
	manager_staff_id,
	store_id  + manager_staff_id AS test_add
FROM
	sakila.store s;
	
SELECT
	store_id,
	manager_staff_id,
	store_id  - manager_staff_id AS test_sub
FROM
	sakila.store s;
	
SELECT
	store_id,
	manager_staff_id,
	store_id  * manager_staff_id AS test_mul
FROM
	sakila.store s;
	
SELECT
	store_id,
	manager_staff_id,
	store_id  / manager_staff_id AS test_divide
FROM
	sakila.store s;
	
SELECT 10 % 3;
SELECT
	store_id,
	manager_staff_id,
	store_id  % manager_staff_id AS test_modula
FROM
	sakila.store s;

SELECT COUNT(*) FROM sakila.address a ;

SELECT COUNT(address2) FROM sakila.address a ;

SELECT
	COUNT(address2) AS count_not_null
FROM
	sakila.address a
WHERE
	address2 IS NOT NULL;

SELECT
	COUNT(actor_id) actors,
	COUNT(film_id) AS films
FROM
	sakila.film_actor fa
	
SELECT
	COUNT(DISTINCT actor_id) total_actors,
	COUNT(DISTINCT film_id) AS total_films
FROM
	sakila.film_actor fa
	
SELECT
	COUNT(DISTINCT actor_id) total_actors,
	COUNT(DISTINCT film_id) AS total_films
FROM
	sakila.film_actor fa
WHERE
	film_id >= 100

SELECT MIN(amount) AS 'Minimum Amount' FROM sakila.payment p 

SELECT
	MIN(amount) AS 'Minimum Amount'
FROM
	sakila.payment p
WHERE
	payment_date >= '2005-08-01 00:00:00'
	AND payment_date <= '2005-12-31 23:59:59';
	
SELECT MAX(amount) AS 'Maximum Amount' FROM sakila.payment p;
SELECT
	MAX(amount) AS 'Maximum Amount'
FROM
	sakila.payment p
WHERE
	customer_id = 1;
	
SELECT
	AVG(replacement_cost) AS `Average Replacement`
FROM
	sakila.film f
	
SELECT
	AVG(replacement_cost) AS `Average Replacement`
FROM
	sakila.film f
WHERE
	`length` >= 100;
	
SELECT
	SUM(replacement_cost) AS `Total Replacement Cost`
FROM
	sakila.film f
	
SELECT
	SUM(replacement_cost) AS `Total Replacement Cost`
FROM
	sakila.film f
WHERE `length` <= 100;

SELECT SUBSTRING('200lab.io', -3, 3);
SELECT SUBSTR('ABCDEFG',3,1) AS Sub;


SELECT
	*
FROM
	ecommerce.customers c
WHERE
	c.country IN 
	('USA',
	'Italy',
	'Australia', 
	'Hong Kong',
	'Singapore',
	'Philippines')
	AND c.salesRepEmployeeNumber < 2000
	AND addressLine1 IS NOT NULL
	AND addressLine2 IS NOT NULL
	AND (customerName LIKE 'MI%'
		OR customerName LIKE '%Co%'
		OR customerName LIKE '_r%')
ORDER BY
	customerNumber ASC,
	salesRepEmployeeNumber DESC
LIMIT 10;