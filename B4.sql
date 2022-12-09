SELECT
	*
FROM
	(
	SELECT
		customer_id,
		email
	FROM
		sakila.customer c
	WHERE
		c.store_id = 1) cus_sub;
		
SELECT
	*
FROM
	ecommerce.customers c
WHERE
	customerNumber IN (
	SELECT
		DISTINCT customerNumber
	FROM
		ecommerce.orders o);
		
-- In ra những khách (kèm số lượng phim) hàng có số lượng phim thuê >= TB phim thuê của một người
SELECT
	r.customer_id,
	COUNT(*) no_rental
FROM
	sakila.rental r
GROUP BY
	1
HAVING
	no_rental >= (
	SELECT
		AVG(no_rental)
	FROM
		(
		SELECT
			r.customer_id,
			COUNT(*) no_rental
		FROM
			sakila.rental r
		GROUP BY
			1) cus_rental);

SELECT
	c.name ,
	f.title ,
	f.replacement_cost
FROM
	film f
JOIN sakila.film_category fc ON
	fc.film_id = f.film_id
JOIN category c ON
	c.category_id = fc.category_id
WHERE
	f.replacement_cost =
(
	SELECT
		MIN(replacement_cost)
	FROM
		sakila.film f2
	JOIN film_category fc2
 ON
		fc2.film_id = f2.film_id
	WHERE
		fc2.category_id = fc.category_id )
ORDER BY
	1;
	
SELECT
	emp_no ,
	d.dept_name
FROM
	employees.dept_emp de
JOIN
employees.departments d ON
	d.dept_no =
de.dept_no
WHERE
	d.dept_name IN
('Production', 'Quality Management')
ORDER BY
	1;
	
SELECT
	emp_no ,
	d.dept_name
FROM
	employees.dept_emp de
JOIN
employees.departments d ON
	d.dept_no =
de.dept_no
WHERE
	emp_no = 10003;
	
SELECT
	emp_no ,
	d.dept_name
FROM
	employees.dept_emp de
JOIN employees.departments d ON
	d.dept_no = de.dept_no
WHERE
	d.dept_name = 'Production'
	AND d.dept_name = 'Quality Management';

SELECT
	emp_no ,
	d.dept_name
FROM
	employees.dept_emp de
JOIN employees.departments d ON
	d.dept_no = de.dept_no
WHERE
	d.dept_name = 'Production'
	AND EXISTS (
	SELECT
		1
	FROM
		employees.dept_emp de1
	JOIN employees.departments d1 ON
		d1.dept_no = de1.dept_no
	WHERE
		de1.emp_no = de.emp_no
		AND d1.dept_name = 'Quality Management')
ORDER BY
	1;
	
SELECT
	emp_no ,
	d.dept_name
FROM
	employees.dept_emp de
JOIN
employees.departments d ON
	d.dept_no =
de.dept_no
WHERE
	emp_no = 10010;
	
SELECT
	COUNT(DISTINCT de.emp_no)
FROM
	employees.dept_emp de
JOIN employees.departments d ON
	d.dept_no
= de.dept_no
WHERE
	d.dept_name = 'Production'
	AND  (
	SELECT
		1
	FROM
		employees.dept_emp de1
	JOIN employees.departments
d1 ON
		d1.dept_no = de1.dept_no
	WHERE
		de1.emp_no = de.emp_no
		AND d1.dept_name = 'Quality Management');

SELECT
	*
FROM
	employees.employees e
WHERE
	e.emp_no IN (
	SELECT
		emp_no 
	FROM
		employees.dept_emp de
	JOIN employees.departments d ON
		d.dept_no = de.dept_no
	WHERE
		d.dept_name = 'Production'
		AND EXISTS(
		SELECT
			1
		FROM
			employees.dept_emp de1
		JOIN employees.departments d1 ON
			d1.dept_no = de1.dept_no
		WHERE
			de1.emp_no = de.emp_no
			AND d1.dept_name = 'Quality Management'));
		
WITH cte_rental_sum AS
(
SELECT
	r.customer_id,
	COUNT(*) no_rental
FROM
	sakila.rental r
GROUP BY
	1)
SELECT
	*
FROM
	cte_rental_sum
WHERE
	no_rental >= (
	SELECT
		AVG(no_rental)
	FROM
		cte_rental_sum );
	
		
WITH cte_emp_production AS 
(
SELECT
		emp_no
FROM
		employees.dept_emp de
JOIN employees.departments d ON
		d.dept_no = de.dept_no
WHERE
		d.dept_name = 'Production')
SELECT
-- 	COUNT(DISTINCT de1.emp_no)
	de1.emp_no 
FROM
	employees.dept_emp de1
JOIN employees.departments d2 ON
	de1.dept_no = d2.dept_no
JOIN cte_emp_production ON
	cte_emp_production.emp_no = de1.emp_no
WHERE
	cte_emp_production.emp_no = de1.emp_no
	AND d2.dept_name = 'Quality Management'