SELECT
	last_name ,
	COUNT(*)
FROM
	sakila.actor a
GROUP BY
	last_name;
	
SELECT
	customer_id,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
ORDER BY
	3 DESC;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
ORDER BY
	SUM(amount) DESC;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
HAVING
	`Total Amount` >= 100;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
HAVING
	staff_id = 1;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
HAVING
	`Total Amount` >= 100
	AND customer_id >= 300;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
HAVING
	`Total Amount` >= 100 OR `Maximum Amount` >=10;
	
SELECT
	customer_id,
	staff_id ,
	SUM(amount) AS `Total Amount`,
	MIN(amount) AS `Minimum Amount`,
	MAX(amount) AS `Maximum Amount`,
	AVG(amount) AS `Average Amount`,
	COUNT(DISTINCT payment_id) AS `Payment Frequency`
FROM
	sakila.payment p
GROUP BY
	1,
	2
HAVING
	NOT
	`Total Amount` >= 100
	AND `Maximum Amount` >= 10
ORDER BY
	`Total Amount` DESC,
	`Payment Frequency` ASC;
	

SELECT '' IS NULL
SELECT NULL IS NULL
SELECT COALESCE ('', 'Unknow')
SELECT COALESCE (NULL, 'Unknow')

SELECt DATE_FORMAT('2022-10-00','%M, %e, %Y'); 

SELECT DATE(0)