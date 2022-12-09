-- + Lấy dư liệu từ dataset sakila thực hiện lần lượt các yêu cầu dưới đây:
--  1.Viết câu truy vấn tìm xem khách hàng nào có họ trùng với tên của kháng hàng khác.
SELECT
	c.customer_id AS customer1_id,
	c.first_name AS customer1_first_name,
	c.last_name AS customer1_last_name,
	c2.customer_id AS customer2_id,
	c2.first_name AS customer2_first_name,
	c2.last_name AS customer2_last_name
FROM
	sakila.customer c
JOIN sakila.customer c2 
ON
	c.first_name = c2.last_name
ORDER BY
	c.customer_id
	
	-- 2.Lấy danh sách các tiêu đề phim, thể loại, năm phát hành và giá thuê của chúng
SELECT
	f.title,
	c3.name AS category_film,
	f.release_year,
	fl.price
FROM
	sakila.film f
JOIN sakila.film_list fl ON
	f.film_id = fl.FID
JOIN sakila.film_category fc ON
	f.film_id = fc.film_id
JOIN sakila.category c3 ON
	c3.category_id = fc.category_id

SELECT 
	f.title,
	c.name AS category_film,
	f.release_year,
	fl.price 
FROM sakila.film f 
INNER JOIN sakila.film_list fl ON f.film_id = fl.FID
LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id 
LEFT JOIN sakila.category c ON fc.category_id = c.category_id; 

SELECT *
FROM sakila.film f 
LEFT JOIN sakila.film_list fl ON f.film_id = fl.FID
-- 3.Lấy danh sách các tiêu đề phim, thể loại,  năm phát hành và giá thuê của chúng,  chia giá phim theo 3 loại sau:
-- 0 < price < 2.99: discount 
-- 2.99 <= price < 4.99:regular 
-- price >= 4.99: premium
SELECT 
	f.title,
	c.name AS category_film,
	f.release_year,
	fl.price,
	CASE
		WHEN (0 < fl.price
		AND fl.price < 2.99 ) THEN 'discount'
		WHEN (2.99 <= fl.price
		AND fl.price < 4.99 ) THEN 'regular'
		ELSE 'premium'
	END AS price_category 
FROM sakila.film f 
JOIN sakila.film_list fl ON f.film_id = fl.FID
LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id 
LEFT JOIN sakila.category c ON fc.category_id = c.category_id; 

-- 4.Lấy danh sách các tiêu đề phim, thể loại, năm phát hành và giá thuê của chúng, phân chia đối tượng thuê phim theo rating dùng case when với biểu thức (expression) biết rằng: 
-- rating = G: family 
-- rating = PG, PG-13: teens 
-- rating = R, NC-17: aldults
SELECT 
	f.title,
	c.name AS category_film,
	f.release_year,
	fl.price,
	f.rating,
	CASE f.rating
		WHEN 'G' THEN 'Family'
		WHEN 'PG' THEN 'Teens'
		WHEN 'PG-13' THEN 'Teens'
		WHEN 'R' THEN 'Aldults'
		ELSE 'Aldults'
	END AS target_audience
FROM sakila.film f 
JOIN sakila.film_list fl ON f.film_id = fl.FID
LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id 
LEFT JOIN sakila.category c ON fc.category_id = c.category_id; 

-- 5.Có bao nhiêu bản phim Hunchback Impossible tồn kho.
SELECT
	f.title,
	COUNT(*) AS number_in_inventory
FROM
	sakila.film f
JOIN sakila.inventory i ON
	f.film_id = i.film_id 
WHERE
	LOWER(f.title) LIKE 'hunchback impossible'
GROUP BY
	1;
	
-- 6.Liệt kê năm thể loại hàng đầu về tổng doanh thu theo thứ tự giảm dần. gợi ý bạn có thể sử dụng các bảng sau: category, film_category, inventory, payment, rental
SELECT
	cat.NAME AS category_name,
	SUM(
	IFNULL( pay.amount, 0 )) AS revenue
FROM
	sakila.category cat
LEFT JOIN sakila.film_category flm_cat ON
	cat.category_id = flm_cat.category_id
LEFT JOIN sakila.film fil ON
	flm_cat.film_id = fil.film_id
LEFT JOIN sakila.inventory inv ON
	fil.film_id = inv.film_id
LEFT JOIN sakila.rental ren ON
	inv.inventory_id = ren.inventory_id
LEFT JOIN sakila.payment pay ON
	ren.rental_id = pay.rental_id
GROUP BY
	cat.NAME
ORDER BY
	revenue DESC
LIMIT 5;

--  Sử dụng dataset employees thực hiện lần lượt các yêu cầu dưới đây:
-- 1.Tính mức lương tối thiểu trung bình, số nhân viên được thuê
-- theo tháng và năm nhân viên được thuê 
SELECT 
	t.hire_year,
	t.hire_month,
	COUNT(t.emp_no) AS 'Number of Hire',
	AVG(t.sal) AS 'Average Starting Salary'
FROM
	(
	SELECT
		e.emp_no,
		EXTRACT(YEAR FROM e.hire_date) AS hire_year,
		EXTRACT(MONTH FROM e.hire_date) AS hire_month,
		MIN(s.salary) AS sal
	FROM
		employees.employees e
	JOIN employees.salaries s ON
		e.emp_no = s.emp_no
	GROUP BY
		1) AS t
GROUP BY
	hire_year,
	hire_month
ORDER BY
	hire_year,
	hire_month;
	-- 2.Tính Mức lương trung bình của những người không phải là người quản lý theo bộ phận và vị trí.
SELECT 
	d.dept_name, 
	t.title,
	AVG(s.salary) AS avg_salary
FROM
	employees.salaries AS s
JOIN employees.dept_emp AS de ON
	s.emp_no = de.emp_no
JOIN employees.departments AS d ON
	de.dept_no = d.dept_no
JOIN employees.titles AS t ON
	s.emp_no = t.emp_no
WHERE
	t.title <> 'Manager'
GROUP BY
	d.dept_name,
	title
ORDER BY
	avg_salary DESC ;
-- 3.Tìm  nhân viên trẻ nhất và già nhất được thuê
(
SELECT 
	'Youngest Hire' AS Description, 
	first_name, 
	last_name,
	hire_date, 
	birth_date, 
	DATEDIFF(hire_date, birth_date) / 365.25 AS hire_age
FROM
	employees.employees
ORDER BY
	hire_age
LIMIT 1)
UNION 
(
SELECT 
	'Oldest Hire' AS Description, 
 	first_name, 
	last_name,
	hire_date, 
	birth_date, 
	DATEDIFF(hire_date, birth_date) / 365.25 AS hire_age
FROM
employees.employees
ORDER BY
hire_age DESC
LIMIT 1);

-- 4.Những người đạt được vị trí quản lý là do được thuê (Hired) về làm quản lý hay trong quá trình làm được thăng chức (Promoted)?
SELECT 
	dept_name, 
	first_name, 
	last_name,
	CASE
		WHEN dm.from_date = e.hire_date THEN 'Hired'
		ELSE 'Promoted'
	END AS how_attained
FROM
	employees.dept_manager dm
LEFT JOIN employees.employees AS e ON
	dm.emp_no = e.emp_no
LEFT JOIN employees.departments AS d ON
	dm.dept_no = d.dept_no
ORDER BY
	dept_name,
	last_name,
	how_attained;

-- 5.Một quản lý sẽ thuê bao nhiêu nhân viên cấp dưới? 
WITH count_staff AS (
SELECT 
		dm.emp_no, 
		(COUNT(de.emp_no) -1) as num_subordinates
FROM
	employees.dept_manager AS dm
RIGHT JOIN employees.dept_emp AS de ON
	de.dept_no = dm.dept_no
WHERE
	1 = 1
	AND (dm.from_date <= de.from_date
		AND dm.to_date >= de.from_date
		OR dm.from_date BETWEEN de.from_date AND de.to_date)
GROUP BY
	dm.emp_no
)
SELECT
	e.emp_no, 
	e.first_name, 
	e.last_name,
	e.hire_date, 
	ct.num_subordinates
FROM
	employees.employees AS e
INNER JOIN count_staff ct ON
	e.emp_no = ct.emp_no
ORDER BY
	num_subordinates DESC ;
     
 # 6. Tìm số khách hàng mua ít nhất 1 đơn hàng >= 60000 
 # (sử dụng ecommerce dataset)
     
SELECT
	customerNumber,
	customerName
FROM
	ecommerce.customers
WHERE
	EXISTS(
	SELECT
		orderNumber,
		SUM(priceEach * quantityOrdered)
	FROM
		ecommerce.orderdetails
	JOIN
            ecommerce.orders
			USING (orderNumber)
	WHERE
		customerNumber = customers.customerNumber
	GROUP BY
		orderNumber
	HAVING
		SUM(priceEach * quantityOrdered) > 60000);
		
-- Thể loại phim nào phổ biến nhất ở mỗi nước (sử dụng data Sakila):
WITH t1 AS (
SELECT
	cnt.country,
	cat.name AS category,
	COUNT(*) AS num_of_rentals
FROM
	sakila.rental r
JOIN sakila.customer cstm
ON
	r.customer_id = cstm.customer_id
JOIN sakila.address adr
ON
	cstm.address_id = adr.address_id
JOIN sakila.city ct
ON
	adr.city_id = ct.city_id
JOIN sakila.country cnt
ON
	ct.country_id = cnt.country_id
JOIN sakila.inventory i
ON
	i.inventory_id = r.inventory_id
JOIN sakila.film f
ON
	f.film_id = i.film_id
JOIN sakila.film_category fc
ON
	fc.film_id = f.film_id
JOIN sakila.category cat
ON
	cat.category_id = fc.category_id
GROUP BY
	country,
	category
ORDER BY
	num_of_rentals DESC),
	
t2 AS (
SELECT
	t1.country,
	MAX(t1.num_of_rentals) AS num_of_rentals
FROM
	t1
GROUP BY
	t1.country
ORDER BY
	num_of_rentals DESC)
	
SELECT
	t2.country,
	t1.category,
	t2.num_of_rentals
FROM
	t1
JOIN t2
ON
	t1.country = t2.country
	AND t1.num_of_rentals = t2.num_of_rentals
ORDER BY
	t2.num_of_rentals DESC
LIMIT 10;

