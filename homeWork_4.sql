-- --+ Lấy dữ liệu từ dataset sakila thực hiện lần lượt các yêu cầu dưới đây:
-- --1. Tính doanh thu tích lũy theo ngày từ việc cho thuê phim (Sử dụng subquery)
SELECT 
	temp.payment_date,
	temp.amount,
	SUM(temp.amount) OVER (ORDER BY temp.payment_date)
FROM
(
SELECT 
	DATE_FORMAT(p.payment_date, '%d-%m-%Y') AS payment_date,
	SUM(p.amount) AS amount
FROM
	sakila.payment p
GROUP BY
	1) temp
ORDER BY temp.payment_date

-- --2. Sử dụng subquery để hiển thị tất cả các diễn viên xuất hiện trong phim Alone Trip.
SELECT
	CONCAT(a.first_name, ' ', a.last_name)
FROM
	sakila.actor a
WHERE
	actor_id IN
(
	SELECT
		fa.actor_id
	FROM
		sakila.film_actor fa
	WHERE
		fa.film_id =
(
		SELECT
			f.film_id
		FROM
			sakila.film f
		WHERE
			LOWER(f.title) LIKE 'alone trip'));
-- --3. Bạn muốn chạy một chiến dịch quảng cáo qua email ở Canada, hãy Sử dụng subquery
-- --lấy thông tin về tên và địa chỉ email của tất cả khách hàng Canada.
SELECT
	c.first_name,
	c.last_name ,
	c.email
FROM
	sakila.customer c
WHERE
	c.address_id IN 
(
	SELECT
		a.address_id
	FROM
		sakila.address a
	WHERE
		a.city_id IN
(
		SELECT
			ci.city_id
		FROM
			sakila.city ci
		WHERE
			ci.country_id IN
(
			SELECT
				c.country_id
			FROM
				sakila.country c
			WHERE
				LOWER(country) LIKE 'canada')))
	
	-- --4. Giả định bạn nhận thấy doanh số cho thuê phim đã giảm dần trong các gia đình trẻ và
-- --bạn muốn nhắm mục tiêu tất cả các phim gia đình để được khuyến mại. Xác định tất
-- --cả các phim thuộc thể loại phim gia đình, có thể khuyến mại cho nhóm khách hàng
-- --này.
SELECT
	f.film_id,
	f.title,
	f.release_year
FROM
	sakila.film f
WHERE
	f.film_id IN
	(
	SELECT
		fc.film_id
	FROM
		sakila.film_category fc
	WHERE
		fc.category_id =
	(
		SELECT
			c.category_id
		FROM
			sakila.category c
		WHERE
			LOWER(c.name) LIKE 'family'))

-- 5.Tìm sản phẩm có giá bán lớn hơn trung bình của tất cả sản phẩm cùng dòng
-- (productline) trong bảng product của dataset ecommerce.
SELECT
	p1.productname,
	p1.buyprice
FROM
	ecommerce.products p1
WHERE
	p1.buyprice > (
	SELECT
		AVG(buyprice)
	FROM
		ecommerce.products)
		
-- 6.Tìm số lượng mặt hàng tối đa , tối thiểu và trung bình trong 1 đơn đặt hàng. (Gợi ý:
-- sử dụng bảng orderdetails của dataset ecommerce)
SELECT 
    MAX(items), 
    MIN(items), 
    FLOOR(AVG(items))
FROM
    (SELECT 
        orderNumber, COUNT(orderNumber) AS items
    FROM
        ecommerce.orderdetails
    GROUP BY 1) AS listitem;
    
 
-- Sử dụng dataset sakila thực hiện lần lượt các yêu cầu dưới đây:
-- 1. Tính doanh thu tích lũy theo ngày từ việc cho thuê phim (Sử dụng cte)
WITH payments AS (
SELECT
	DATE_FORMAT(payment_date, '%Y-%m-%d') AS payment_date,
	SUM(amount) AS amount
FROM
	sakila.payment
GROUP BY
	1
)
SELECT 
	payment_date, 
	amount, 
	SUM(amount) OVER (
	ORDER BY payment_date) AS accumulated_revenue
FROM
	payments
ORDER BY
	payment_date;
   
-- 2. Sử dụng cte để hiển thị tất cả các diễn viên xuất hiện trong phim Alone
-- Trip.
WITH film AS (
	SELECT 
		film_id 
	FROM sakila.film 
	WHERE LOWER(title) = LOWER('Alone Trip')
),
actor AS (
	SELECT 
		actor_id
	FROM sakila.film_actor
	WHERE film_id IN ( SELECT  film_id FROM film)
		
)
SELECT 
	first_name, 
	last_name
FROM
	sakila.actor
WHERE
	actor_id IN (
	SELECT
		actor_id
	FROM
		actor);
-- Sử dụng dataset ecommerce thực hiện lần lượt các yêu cầu dưới đây:
-- 1. Sử dụng subquery lấy thông tin về tên khách hàng, số điện thoại và người
-- đại diện bán hàng của những khách hàng thuộc bang California (CA) của
-- nước USA trong bảng customers.
WITH customers_in_usa AS (
SELECT
	customerName,
	phone,
	salesRepEmployeeNumber,
	state
FROM
	ecommerce.customers
WHERE
	country = 'USA'
)
SELECT
	*
FROM
	customers_in_usa
WHERE
	state = 'CA'
ORDER BY
	customerName;
-- 2. Tính trung bình số tiền lớn nhất, trung bình số tiền nhỏ nhất mà khách
-- hàng đã thanh toán trong bảng payment.
WITH data AS (
SELECT 
		customerNumber,
		MIN(amount) AS min_amount, 
		MAX(amount) AS max_amount
FROM
	ecommerce.payments p
GROUP BY
	1 
)
SELECT 
	AVG(min_amount) AS avg_min_amount,
	AVG(max_amount) AS avg_max_amount
FROM
	data;

-- 3. Tính xem mỗi quý khách hàng sẽ đặt hàng trung bình, nhiều nhất, ít nhất
-- bao nhiêu lần? Có bao nhiêu khách hàng đặt hàng mỗi quý.
WITH data AS (
SELECT 
		EXTRACT(QUARTER FROM orderDate) AS order_quarter, 
		customerNumber, 
		COUNT(DISTINCT orderNumber) AS total_order
FROM
	ecommerce.orders o
WHERE
	EXTRACT(YEAR FROM orderDate) = '2004'
GROUP BY
	1,
	2 
)
SELECT 
	order_quarter,
	AVG(total_order) AS avg_order, 
	MIN(total_order) AS min_order,
	MAX(total_order) AS max_order,
	COUNT( DISTINCT customerNumber) AS total_customer
FROM
	data
GROUP BY
	1
ORDER BY
	1;
-- 4. Tìm số lượng mặt hàng tối đa , tối thiểu và trung bình trong 1 đơn đặt
-- hàng. (Gợi ý: sử dụng bảng orderdetails)

-- WITH cte_quanityOrdered AS (
-- 	SELECT 
-- 		o.orderNumber,
-- 		COUNT(o.orderNumber) as num,
-- 		SUM(o.quantityOrdered) AS sum_quanity, 
-- 		MAX(o.quantityOrdered) AS max_quantity,
-- 		MIN(o.quantityOrdered) AS min_quantity
-- 	FROM ecommerce.orderdetails o
-- 	GROUP BY 1
-- )
-- SELECT 
-- 	orderNumber,
-- 	max_quantity,
-- 	min_quantity,
-- 	sum_quanity/num AS 'avg_quantity'
-- FROM cte_quanityOrdered

WITH lineitems AS (SELECT 
        orderNumber, 
        COUNT(orderNumber) AS items
    FROM
        ecommerce.orderdetails
    GROUP BY orderNumber) 
SELECT 
    MAX(items), 
    MIN(items), 
    FLOOR(AVG(items))
FROM lineitems;