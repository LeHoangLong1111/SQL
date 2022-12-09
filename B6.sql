/*
 * Tìm phần trăm đóno góp doanh thu của mỗi nhân viên và sắp xếp giảm dần
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2)

SELECT *, 
	SUM(total) OVER() total_revenue,
	total/(SUM(total) OVER()) contribution
FROM cte_emp_sum

/*
 * Tìm ra phân trăm đóng góp của nhân viên theo mã văn phòng (officeCode).
 * Sắp xếp giảm dần
 * Gợi ý: phần trăm tất cả nhân viên trong 1 phòng cộng lại bằng 100%
 */

WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName ,
	   e.officeCode ,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2)
SELECT
	*,
	SUM(total) OVER(PARTITION BY officeCode) total_revenue,
	total /(SUM(total) OVER(PARTITION BY officeCode)) contribution
FROM
	cte_emp_sum
ORDER BY
	officeCode
	
/*
 * Đánh số thứ tự các nhân viên theo doanh thu họ có được sắp xếp giảm dần
 */

WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2)
 
SELECT
	*,
	ROW_NUMBER() OVER(
	ORDER BY total DESC) row_num
FROM
	cte_emp_sum

/*
 * Lấy top 5 nhân viên xuất sắc nhất mỗi năm theo ROW_NUMBER()
 */
WITH cte_emp_sum AS
(SELECT e.employeeNumber,
	   CONCAT(e.firstName,' ',e.lastName) employeeName , 
	   YEAR(o.orderDate) year,
	   SUM(od.priceEach*od.quantityOrdered) total
 FROM employees e JOIN customers c
	ON e.employeeNumber = c.salesRepEmployeeNumber 
	JOIN orders o ON o.customerNumber = c.customerNumber 
	JOIN orderdetails od ON od.orderNumber = o.orderNumber
 GROUP BY 1,2,3),
cte_emp_rn AS
(SELECT *, ROW_NUMBER() OVER( PARTITION BY year
		ORDER BY total DESC) row_num 
FROM cte_emp_sum)

SELECT
	*
FROM
	cte_emp_rn
WHERE
	row_num <= 5
	
/*
 * Lấy top 5 nhân viên xuất sắc nhất mỗi năm theo RANK()
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   YEAR(o.orderDate) year,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3),
cte_emp_rn AS
(
SELECT
	*,
	RANK() OVER( PARTITION BY year
ORDER BY
	total DESC) rank_num
FROM
	cte_emp_sum)
SELECT
	*
FROM
	cte_emp_rn
WHERE
	row_num <= 5
	
 /*
 * Thống kê doanh thu năm nay của mỗi productline và so sánh với năm ngoái
 * Tính tăng trưởng theo doanh thu và tỉ lệ 
 */
WITH cte_prodline_sum AS
(
SELECT
	p.productLine,
	   YEAR(o.orderDate) order_year,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	orders o
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
JOIN products p ON
	p.productCode = od.productCode
GROUP BY
	1,
	2),
cte_prodline_sum2 AS
(
SELECT
	*,
	LAG(total) OVER (PARTITION BY productLine
ORDER BY
	order_year) last_year_total
FROM
	cte_prodline_sum
ORDER BY
	productLine,
	order_year)

SELECT
	*,
	(total-last_year_total) growth,
	(total-last_year_total)/ last_year_total growth_rate
FROM
	cte_prodline_sum2
	
-- USE LEFT JOIN INSTEAD

WITH cte_prodline_sum AS
(
SELECT
	p.productLine,
	   YEAR(o.orderDate) order_year,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	orders o
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
JOIN products p ON
	p.productCode = od.productCode
GROUP BY
	1,
	2),
cte_prodline_sum2 AS
(
SELECT
	ps1.*,
	ps2.total last_year_total
FROM
	cte_prodline_sum ps1
LEFT JOIN cte_prodline_sum ps2 
	ON
	ps1.productLine = ps2.productLine
	and ps1.order_year = ps2.order_year+1 
ORDER BY
	productLine,
	order_year)

SELECT
	*,
	(total-last_year_total) growth,
	(total-last_year_total)/ last_year_total growth_rate
FROM
	cte_prodline_sum2
ORDER BY
	1,
	2
	
/*
 * Tính running total doanh thu của mỗi nhân viên qua từng tháng
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   EXTRACT( YEAR_MONTH FROM o.orderDate) date,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3)

SELECT
	*,
	SUM(total) OVER(PARTITION BY employeeNumber
ORDER BY
	date
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total
FROM
	cte_emp_sum
	
/*
 * Tính  moving avg 3 ngày doanh thu của mỗi nhân viên theo ngày
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   o.orderDate date,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3)

SELECT
	*,
	AVG(total) OVER(PARTITION BY employeeNumber
ORDER BY
	date
		ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) moving_avg_3day
FROM
	cte_emp_sum
	
/*
 * ROWS vs RANGE
 */

WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   o.orderDate date,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3)

SELECT
	*,
	AVG(total) OVER(PARTITION BY employeeNumber
ORDER BY
	date
		RANGE BETWEEN INTERVAL '3' DAY PRECEDING AND
		INTERVAL '1' DAY PRECEDING) moving_avg_3day
FROM
	cte_emp_sum
	
SELECT COUNT(e.employeeNumber)
FROM  ecommerce.customers c  LEFT JOIN ecommerce.employees e  
ON c.salesRepEmployeeNumber =e.employeeNumber 

SELECT COUNT(DISTINCT e.employeeNumber)
FROM  ecommerce.customers c  LEFT JOIN ecommerce.employees e  
ON c.salesRepEmployeeNumber =e.employeeNumber 

/*
 * Tính running total của mỗi nhân viên theo tháng 
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   EXTRACT( YEAR_MONTH FROM o.orderDate) date,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3)

SELECT
	*,
	SUM(total) OVER(PARTITION BY employeeNumber
ORDER BY
	date
		RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total
FROM
	cte_emp_sum

/*
  * Lấy doanh thu cao thứ 2 của nhân viên
 */
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   CONCAT(e.firstName, ' ', e.lastName) employeeName , 
	   YEAR(o.orderDate) year,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3)

 SELECT
	*,
	NTH_VALUE (total,
	2) OVER( PARTITION BY year
ORDER BY
	total DESC) second_highest
FROM
	cte_emp_sum
/*
 * Lấy ra nhân viên có doanh thu cao nhất và thấp nhất của 1 văn phòng theo năm
 * tính gap giữa họ
 */

WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	   e.officeCode,
	   YEAR(o.orderDate) year,
	   SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c
	ON
	e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1,
	2,
	3),
 cte_emp_sum2 AS 
 (
SELECT
	*,
	FIRST_VALUE(total) OVER 
 		(PARTITION BY year
ORDER BY
	total ) lowest,
	LAST_VALUE(total) OVER 
 		(PARTITION BY year
ORDER BY
	total RANGE BETWEEN
				UNBOUNDED PRECEDING AND
				UNBOUNDED FOLLOWING) highest
FROM
	cte_emp_sum)
-- SELECT year,total,highest,lowest, ABS(total-lowest), ABS(total-highest)
-- FROM cte_emp_sum2
SELECT
	*
FROM
	cte_emp_sum2
	
-- Sử dụng Database Ecommerce, bạn hãy thực hiện:
-- 1. In ra các nhân viên dưới ngưỡng doanh số trung bình.
WITH cte_emp_sum AS
(
SELECT
	e.employeeNumber,
	SUM(od.priceEach * od.quantityOrdered) total
FROM
	employees e
JOIN customers c ON
	c.salesRepEmployeeNumber = e.employeeNumber
JOIN orders o ON
	o.customerNumber = c.customerNumber
JOIN orderdetails od ON
	od.orderNumber = o.orderNumber
GROUP BY
	1)
,
cte_emp_avg AS 
(
SELECT
	*,
	AVG(total) OVER () avg_total
FROM
	cte_emp_sum )
-- 2. Mình muốn mỗi dòng dữ liệu đều được gắn số AVG nên không có điều kiện join nha các bạn.
SELECT
	*
FROM
	cte_emp_avg
WHERE
	total <avg_total
	
-- Sử dụng Database Sakila, bạn hãy thực hiện:
-- 1. In ra danh thu theo category film và contribution theo năm.
WITH cte_film_sum AS 
(
SELECT
	c.name ,
	YEAR(r.rental_date) rental_year,
	COUNT(DISTINCT r.rental_id) rental_count,
	SUM(p.amount) rental_amount
FROM
	sakila.rental r
JOIN sakila.inventory i ON
	i.inventory_id = r.inventory_id
JOIN sakila.film f ON
	i.film_id = f.film_id
JOIN sakila.film_category fc ON
	fc.film_id = f.film_id
JOIN sakila.category c ON
	c.category_id = fc.category_id
JOIN sakila.payment p ON
	p.rental_id = r.rental_id
GROUP BY
	1,
	2),
cte_film_sum_year AS
(
SELECT
	*,
	SUM(rental_amount) OVER(PARTITION BY rental_year ) year_total
FROM
	cte_film_sum)

SELECT
	*,
	rental_amount / year_total contribution
FROM
	cte_film_sum_year
ORDER BY
	rental_year,
	contribution DESC
	
-- 2. In ra TOP 3 film đóng góp doanh thu nhiều nhất mỗi năm theo category.
WITH cte_film_sum AS 
(
SELECT
	c.name ,
	YEAR(r.rental_date) rental_year,
	f.title,
	COUNT(DISTINCT r.rental_id) rental_count,
	SUM(p.amount) rental_amount
FROM
	sakila.rental r
JOIN sakila.inventory i ON
	i.inventory_id = r.inventory_id
JOIN sakila.film f ON
	i.film_id = f.film_id
JOIN sakila.film_category fc ON
	fc.film_id = f.film_id
JOIN sakila.category c ON
	c.category_id = fc.category_id
JOIN sakila.payment p ON
	p.rental_id = r.rental_id
GROUP BY
	1,
	2,
	3),
cte_film_sum_rk AS
(
SELECT
	*,
	RANK() OVER(PARTITION BY rental_year,
	name
ORDER BY
	rental_amount DESC ) rk
FROM
	cte_film_sum)

SELECT
	*
FROM
	cte_film_sum_rk
WHERE
	rk <= 3

-- 3. In ra số tháng nằm trong top 10 (theo doanh số) của các film theo năm nhằm kiểm tra xem có phim nào cứ nằm top trending mãi không.
WITH cte_film_sum AS 
(
SELECT
	c.name ,
	EXTRACT(YEAR_MONTH FROM r.rental_date) yearmonth,
	YEAR(r.rental_date) rental_year,
	f.title,
	COUNT(DISTINCT r.rental_id) rental_count,
	SUM(p.amount) rental_amount
FROM
	sakila.rental r
JOIN sakila.inventory i ON
	i.inventory_id = r.inventory_id
JOIN sakila.film f ON
	i.film_id = f.film_id
JOIN sakila.film_category fc ON
	fc.film_id = f.film_id
JOIN sakila.category c ON
	c.category_id = fc.category_id
JOIN sakila.payment p ON
	p.rental_id = r.rental_id
GROUP BY
	1,
	2,
	3,
	4),
cte_film_sum_rk AS
(
SELECT
	*,
	RANK() OVER(PARTITION BY yearmonth
ORDER BY
	rental_amount DESC ) rk
FROM
	cte_film_sum),
cte_film_top AS 
(
SELECT
	*
FROM
	cte_film_sum_rk
WHERE
	rk <= 10)

SELECT
	rental_year,
	title,
	COUNT(*) no_top
FROM
	cte_film_top
GROUP BY
	1,
	2

-- 4. Kiểm tra xem 20% số lượng phim mang lại bao nhiêu phần trăm doanh thu (nâng cao).
WITH cte_film_sum AS 
(
SELECT
	f.title ,
	COUNT(DISTINCT r.rental_id) rental_count,
	SUM(p.amount) rental_amount
FROM
	sakila.rental r
JOIN sakila.inventory i ON
	i.inventory_id = r.inventory_id
JOIN sakila.film f ON
	i.film_id = f.film_id
JOIN sakila.payment p ON
	p.rental_id = r.rental_id
GROUP BY
	1),
cte_film_pct AS
(
SELECT
	*,
	PERCENT_RANK() OVER (
ORDER BY
	rental_amount DESC ) AS pct
FROM
	cte_film_sum)

SELECT
	SUM(CASE WHEN pct <= 0.2 THEN rental_amount ELSE 0 END)/ SUM(rental_amount)
FROM
	cte_film_pct
-- 20% film đứng đầu về doanh thu chỉ đóng góp 40% doanh thu, không đến nổi quá dominant.
