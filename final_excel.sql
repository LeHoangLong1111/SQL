-- 1.What is the total distance from 'Completed' orders, 'Nguyễn An Hòa' ride?
SELECT
	distance
FROM
	data_order
WHERE
	LOWER(status) = LOWER('completed')
	AND supplier_name = 'Nguyễn An Hòa';

-- 2.What are the top 4 reasons for why an order is cancelled by user?
WITH cte_comment_extract AS
(
SELECT
	REPLACE(REPLACE(REPLACE(cancel_comment,LOWER('cancel by uer'),''),'(',''),')') AS comment
FROM
	data_order
WHERE
	LOWER(status)= LOWER('cancelled')
	AND LOWER(cancel_comment) LIKE LOWER('%cancel by user%'))

SELECT comment, COUNT(*) comment_count
FROM cte_comment_extract
LIMIT 4

-- 3.Which district has the second highest number of completed orders on Monday (district in high demand)?
WITH cte_dis_sum AS(
SELECT
	from_district,
	COUNT(*) no_orders
FROM
	data_order
WHERE
	week_day = 2
	AND LOWER(status) = LOWER('completed')
GROUP BY
	1)
SELECT from_district
FROM
	(
	SELECT
		from_district,
		DENSE_RANK() OVER(ORDER BY no_orders DESC) rk
	FROM
		cte_dis_sum) tmp
WHERE rk=2

-- 4.What is the median net income of suppliers (76.4% of total_fee)?
SELECT supplier_id, PERCENT_RANK() OVER(ORDER BY (total_fee*76.4)/100) pr
FROM data_order

-- 5.Which hour of the day has order's the longest acceptance duration (accept_time - create_time)?
SELECT EXTRACT(HOUR FROM creat_time),
		AVG(TIMESTAMPDIFF(MINUTE,creat_time, accep_time) m_diff)
FROM data_order
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- 6.Who wins (Name + Score)?
SELECT supplier_name, 
	AVG(rating_by_user)*0.9 + COUNT(*)*0.1 score
FROM data_order
WHERE LOWER(status) = LOWER('completed')
GROUP BY 1
ORDER BY 2 DESC

-- 7.Write query to extract data from table in "data_order" sheet to return the result as in "table_result" sheet with following conditions:
--- Data from '2019-02-01' to '2019-05-31'
--- Include data of successful orders only (base on "status" field)
--- Revenue = total_fee
--* The query should return exact dimensions' name and logic behind only, not their value.
SELECT DATE_FORMAT(create_time, "%Y-%m-01") month_,
	service_id,
	EXTRACT(HOUR FROM create_time) create_hour,
	SUM(total_fee) revenue,
	COUNT(*) total_order
FROM data_order
WHERE DATE(create_time) BETWEEN '2019-02-01' AND '2019-05-31'
AND LOWER(status) = LOWER('completed')
GROUP 1,2,3
