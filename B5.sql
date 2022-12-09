SELECT
	o.orderNumber,
	od.productCode ,
	od.priceEach * od.quantityOrdered AS 'GrandTotal'
FROM
	ecommerce.orders o
JOIN ecommerce.orderdetails od ON
	o.orderNumber = od.orderNumber;
	
SELECT
	o.orderNumber,
	SUM(od.priceEach * od.quantityOrdered) AS 'GrandTotal'
FROM
	ecommerce.orders o
JOIN ecommerce.orderdetails od ON
	o.orderNumber = od.orderNumber
GROUP BY
	1;
	
SELECT
	c.customerName , 
	SUM(od.priceEach * od.quantityOrdered) AS 'Total Revenue'
FROM
	ecommerce.orders o
JOIN ecommerce.orderdetails od ON
	o.orderNumber = od.orderNumber
JOIN ecommerce.customers c ON
	c.customerNumber = o.customerNumber
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 5;

SELECT
	c.customerName , 
	COUNT(DISTINCT o.orderNumber) AS 'No.orders',
	SUM(od.priceEach * od.quantityOrdered) AS 'Total Revenue'
FROM
	ecommerce.orders o
JOIN ecommerce.orderdetails od ON
	o.orderNumber = od.orderNumber
JOIN ecommerce.customers c ON
	c.customerNumber = o.customerNumber
GROUP BY
	1
ORDER BY
	1;
	
SELECT
	c.customerName,
	COUNT(DISTINCT o.orderNumber) AS 'No.orders'
FROM
	ecommerce.customers c
LEFT JOIN ecommerce.orders o ON
	o.customerNumber = c.customerNumber
GROUP BY 1;

SELECT
	c.customerName,
	COUNT(DISTINCT o.orderNumber) AS 'No.orders'
FROM
	ecommerce.orders o
LEFT JOIN ecommerce.customers c ON
	o.customerNumber = c.customerNumber
GROUP BY
	1;
	
SELECT
	e1.employeeNumber ,
	CONCAT(e1.firstName, ' ', e1.lastName) AS 'Name',
	CONCAT(e2.firstName, ' ', e2.lastName) AS 'ManagerName'
FROM
	ecommerce.employees e1
LEFT JOIN ecommerce.employees e2 ON
	e1.reportsTo = e2.employeeNumber;	
	
SELECT
	o.orderNumber, o.customerNumber 
FROM
	ecommerce.orders o
WHERE
	o.customerNumber = 181
UNION ALL 
SELECT
	o.orderNumber, o.customerNumber 
FROM
	ecommerce.orders o
WHERE
	o.customerNumber = 181
	
SELECT
	o.orderNumber, o.customerNumber 
FROM
	ecommerce.orders o
WHERE
	o.customerNumber = 181
UNION
SELECT
	o.orderNumber, o.customerNumber 
FROM
	ecommerce.orders o
WHERE
	o.customerNumber = 181

-- Sử dụng Database Ecommerce
-- 1. In ra tên nhân viên và sếp cấp 1, cấp 2 (sếp của sếp) của bạn đó.
SELECT
		CONCAT(e.lastName, ' ', e.firstName) AS 'Employee_Name',
		CONCAT(e2.lastName, ' ', e2.firstName) AS 'Mamager1_Name',
		CONCAT(e3.lastName, ' ', e3.firstName) AS 'Mamager2_Name'
FROM
	ecommerce.employees e
LEFT JOIN ecommerce.employees e2 ON
	e.reportsTo = e2.employeeNumber
LEFT JOIN ecommerce.employees e3 ON
	e2.reportsTo = e3.employeeNumber 
	
-- 2. In ra các nhân viên dưới ngưỡng doanh số trung bình.
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	SUM(od.priceEach * od.quantityOrdered) AS Total
FROM
	ecommerce.employees e
JOIN ecommerce.customers c ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN ecommerce.orders o ON
	c.customerNumber = o.customerNumber
JOIN ecommerce.orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1)

SELECT
	AVG(total) avg_total
FROM
	cte_emp_sum 

-- 3. Cũng yêu cầu trên (yêu cầu số 2) nhưng mình muốn mỗi dòng dữ liệu đều được gắn số AVG nên không có điều kiện join nha các bạn.
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	SUM(od.priceEach * od.quantityOrdered) AS Total
FROM
	ecommerce.employees e
JOIN ecommerce.customers c ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN ecommerce.orders o ON
	c.customerNumber = o.customerNumber
JOIN ecommerce.orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1),
 employees AS 
(
SELECT
	AVG(total) avg_total
FROM
	cte_emp_sum )
SELECT
	a.*,
	b.avg_total
FROM
	cte_emp_sum a
JOIN employees b
WHERE
	a.total <b.avg_total
	
-- 4. In ra các TOP 10 khách hàng có doanh số cao nhất.
WITH cte_emp_sum AS
(
SELECT
	c.customerNumber,
	c.customerName ,
	SUM(od.priceEach * od.quantityOrdered) total
FROM
	ecommerce.customers c
JOIN ecommerce.orders o ON
	o.customerNumber = c.customerNumber
JOIN ecommerce.orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2)

SELECT
	*
FROM
	cte_emp_sum
ORDER BY
	total DESC
LIMIT 10

-- Sử dụng Database Sakila, bạn hãy thực hiện:
-- 1. Đếm số lượt thuê, doanh thu theo category của Film.
SELECT
	c.name ,
	COUNT(r.rental_id) AS Total,
	SUM(p.amount) AS Rental_amout
FROM
	sakila.rental r
JOIN sakila.inventory i ON
	r.inventory_id = i.inventory_id
JOIN sakila.film f ON
	f.film_id = i.film_id
JOIN sakila.film_category fc ON
	fc.film_id = f.film_id
JOIN sakila.category c ON
	c.category_id = fc.category_id
JOIN sakila.payment p ON
	r.rental_id = p.rental_id
GROUP BY
	1
	
-- 2. Lấy ra top 10 Phim được thuê nhiều nhất, và doanh thu.
SELECT
	f.title,
	COUNT(*) AS Rental_count,
	SUM(p.amount) AS Rental_amount
FROM 
	sakila.rental r
JOIN sakila.inventory i ON
	r.inventory_id = i.inventory_id
JOIN sakila.film f ON
	f.film_id = i.film_id
JOIN sakila.payment p ON
	r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 3 DESC 
LIMIT 10

-- 3. Đếm số lượt thuê phim, doanh thu theo Store.
SELECT
	i.store_id ,
	COUNT(*) Rental_count,
	SUM(p.amount) Rental_amount
FROM 
	sakila.rental r
JOIN sakila.inventory i ON
	r.inventory_id = i.inventory_id
JOIN sakila.payment p ON
	r.rental_id = p.rental_id
GROUP BY 1