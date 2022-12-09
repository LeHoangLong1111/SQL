-- Homework 1
-- Lấy thông tin trong bảng payments  của dataset ecommerce thoả mãn đồng thời tất cả các  điều kiện dưới đây:
-- 1.Đếm số khách hàng có giá trị đơn hàng lớn hơn hoặc bằng 5000$
SELECT
	COUNT(DISTINCT customerNumber) AS Total_Cus
FROM
	ecommerce.payments p
WHERE
	p.amount > 5000;
	
-- 2. Đếm số lần thanh toán có trong bảng payments
SELECT COUNT(p.customerNumber) AS Total_Pay FROM ecommerce.payments p;

-- 3. Tính tổng số tiền thu được từ những khách hàng có mã định danh lớn hơn hoặc bằng 200
SELECT
	SUM(p.amount) AS Total_Amount
FROM
	ecommerce.payments p
WHERE
	p.customerNumber >= 200;

	-- 4. Tính tổng số tiền thu được trong quý 1 năm 2004
SELECT
	SUM(p.amount) AS Total_Amount_1quater
FROM
	ecommerce.payments p
WHERE
	p.paymentDate >= '2004-01-01'
	AND p.paymentDate <= '2004-03-31';

	-- 5. Thanh toán có giá trị lớn nhất, nhỏ nhất là bao nhiêu tiền 
SELECT
	MAX(p.amount) AS Max_Amount,
	MIN(p.amount) AS Min_Amount
FROM
	ecommerce.payments p;
	
	-- 6. Tính số tiền trung bình của 1 lần thanh toán
SELECT
	AVG(amount) AS Avg_Amount
FROM
	ecommerce.payments p;


--Homework2
-- Lấy thông tin trong bảng salaries của dataset employees thực hiện lần lượt các yêu cầu dưới đây:
-- 1. Tính tổng số lương mỗi nhân viên nhận được.
SELECT
	s.emp_no ,
	SUM(s.salary) AS Total_Salary
FROM
	employees.salaries s
GROUP BY
	1 ;

-- 2. Tính tổng số lương phải trả nhân viên theo năm. ( biết rằng lương sẽ đc trả vào cuối kì làm việc (to_date))
SELECT
	EXTRACT(YEAR FROM s.to_date) AS Paid_Year,
	SUM(s.salary) AS Total_Salary
FROM
	employees.salaries s
GROUP BY 1
ORDER BY 1;

	-- 3. Tính tổng số năm mỗi nhân viên làm việc, và tổng số lương, số lương nhỏ nhất, số lương lớn nhất  họ nhận được
SELECT
	s.emp_no,
	SUM(DATEDIFF(s.to_date, s.from_date))/365 AS Num_Of_Year,
	SUM(s.salary) AS Total_Salary,
	MAX(s.salary) AS Max_Salary,
	MIN(s.salary) AS Min_Salary
FROM
	employees.salaries s
GROUP BY 1;



SELECT
	T1.emp_no,
	SUM(DATEDIFF(T1.Later, T1.from_date))/ 365 AS Num_Of_Year,
	SUM(T1.salary) AS Total_Salary,
	MAX(T1.salary) AS Max_Salary,
	MIN(T1.salary) AS Min_Salary
FROM
	(
	SELECT
		*,
		CASE
-- 			WHEN T.to_date LIKE '9999%' THEN (REPLACE(T.to_date, '9999', EXTRACT(YEAR FROM (DATE_ADD(T.year_temp, INTERVAL 1 YEAR)))))
			WHEN T.to_date LIKE '9999%' THEN (DATE_ADD(T.year_temp, INTERVAL 1 YEAR))
			ELSE T.to_date
		END AS Later
	FROM
		(
		SELECT
			*,
			LAG(s.to_date) OVER(
		ORDER BY
			s.emp_no) AS year_temp
		FROM
			employees.salaries s ) AS T) AS T1
GROUP BY 1;

-- Homework3
-- Lấy thông tin trong bảng orders của dataset ecommerce thực hiện lần lượt các yêu cầu dưới đây:
-- 1. Tính tổng số đơn hàng theo status.
SELECT
	status,
	COUNT(DISTINCT o.orderNumber) AS total_order
FROM
	ecommerce.orders o
GROUP BY 1;

-- 2. Tính tổng số đơn hàng theo status và năm order. 
SELECT
	status,
	EXTRACT(YEAR FROM o.orderDate) AS Order_year,
	COUNT(DISTINCT o.orderNumber) AS total_order
FROM
	ecommerce.orders o
GROUP BY
	1,
	2
ORDER BY
	1,
	2 ;

-- 3. Tính tổng đơn hàng đã được ship theo năm được ship và tháng được ship, sắp xếp dữ liệu theo chiều tăng dần của năm được ship và tháng được ship.
SELECT
	EXTRACT(YEAR FROM o.shippedDate) AS Shipped_year,
	EXTRACT(MONTH FROM o.shippedDate) AS Shipped_month, 
	COUNT(DISTINCT o.orderNumber) AS total_num
FROM
	ecommerce.orders o 
WHERE LOWER(status) = 'shipped'
GROUP BY 1,2
ORDER BY 1,2;


-- 4. Tính số đơn hàng bị cancel, số khách hàng cancel theo năm order.
SELECT
	EXTRACT(YEAR FROM o.requiredDate) AS year_cancel,
	COUNT(o.status) AS Total_Cancel
FROM
	ecommerce.orders o
WHERE
	LOWER(status) = 'cancelled'
GROUP BY 1
ORDER BY 1;