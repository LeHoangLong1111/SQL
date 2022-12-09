--1.Find the month-over-month percentage change for monthly active users (MAU). 
WITH cte_mau AS (
	SELECT DATE_FORMAT(`date`, "%Y-%m-01") `month`
		,COUNT(*) mau
	FROM login
	GROUP BY 1
)

SELECT cur_mth.`month`
	   ,cur_mth.mau cur_mau
	   ,last_mth.mau last_mau
	   ,ROUND(100.0*(cur_mth.mau - last_mth.mau)/last_mth.mau,2) AS percent_change 
FROM cte_mau cur_mth LEFT JOIN cte_mau last_mth ON cur_mth.`month` = last_mth.`month` + interval 1 MONTH

--2. Write SQL such that we label each node as a “leaf”, “inner” or “Root” node, such that for the nodes above we get:
--Cach 1
SELECT 
    node,
    CASE 
        WHEN node IS NULL THEN 'Root'
        WHEN node NOT IN (SELECT DISTINCT parent FROM tree) THEN 'Leaf'
        ELSE 'Inner'
--        WHEN node IN (SELECT parent FROM tree) AND parent IS NOT NULL THEN 'Inner'
    END AS label 
 FROM 
    tree
    
--Cach 2:
WITH cte_parent_node AS (
	SELECT DISTINCT parent node
	FROM tree
	WHERE parent IS NOT NULL 
),
cte_sum AS (
	SELECT t.*,
		CASE WHEN pr.node IS NULL THEN 'no' ELSE 'yes' END is_parent 
	FROM tree t LEFT JOIN cte_parent_node pr ON t.node = pr.node
)

SELECT s.node,
	CASE WHEN s.parent IS NULL THEN 'Root'
		WHEN s.is_parent ='no' THEN 'Leaf'
		ELSE 'Inner' 
	END label
FROM cte_sum s

--3. Write a query that gets the number of retained users per month. In this case, retention for a given month is defined as the number of users who logged in that month who also logged in the immediately previous month. 
SELECT 
    DATE_FORMAT(`date`, "%Y-%m-01") `month`, 
    COUNT(DISTINCT cur_mth.user_id) retained_users 
 FROM 
    logins cur_mth 
 JOIN 
    logins last_mth ON cur_mth.user_id = last_mth.user_id 
        AND DATE_FORMAT(cur_mth.`date`, "%Y-%m-01") = DATE_FORMAT(last_mth.`date`, "%Y-%m-01") + interval 1 month                                    
 GROUP BY  1
 
 -- 4.Now we’ll take retention and turn it on its head: Write a query to find many users last month *did not* come back this month. i.e. the number of churned users.  
 SELECT DATE_FORMAT(cur_mth.`date`, "%Y-%m-01") + interval 1 month
 	,COUNT(DISTINCT last_mth.user_id ) churn_users
 FROM logins last_mth 
 LEFT JOIN logins cur_month ON cur_mth.user_id = last_mth.user_id 
        AND DATE_FORMAT(cur_mth.`date`, "%Y-%m-01")  = DATE_FORMAT(last_mth.`date`, "%Y-%m-01") + interval 1 month
 WHERE cur_month.user_id IS NULL 
 
 
 -- 6. Write a query to get *cumulative* cash flow for each day such that we end up with a table in the form below: 
 SELECT
    `date`, 
    SUM(cash_flow) OVER (ORDER BY `date` ASC) as cumulative_cf 
FROM
    transactions 
ORDER BY `date` ASC

-- 7. Write a query to get 7-day rolling (preceding) average of daily sign ups. 
SELECT 
  `date`, 
  AVG(sign_ups) OVER(ORDER BY `date`
		RANGE BETWEEN INTERVAL '7' DAY PRECEDING AND
		INTERVAL '1' DAY PRECEDING) rolling_avg_7day
FROM 
  signups
  
-- 8. **Write a query to get the response time per email (`id`) sent to `zach@g.com` . Do not include `id`s that did not receive a response from [zach@g.com](mailto:zach@g.com). Assume each email thread has a unique subject. Keep in mind a thread may have multiple responses back-and-forth between [zach@g.com](mailto:zach@g.com) and another email address. 
WITH cte_reponse AS
( SELECT 
    se.id, 
    MIN(re.timestamp) respond_time
FROM 
    emails se
JOIN
    emails re
        ON 
            se.subject = re.subject 
        AND 
            se.to = re.from
        AND 
            se.from = re.to 
        AND 
            se.timestamp < re.timestamp 
 GROUP BY 1)
 
 SELECT se.*
 		, TIMESTAMPDIFF(MINUTE,se.timestamp,re.respond_time) time_to_response
 FROM emails se JOIN cte_reponse re ON se.id = re.id
 WHERE se.to = 'zach@g.com' 
 
-- 9. Write a query to get the `empno` with the highest salary. Make sure your solution can handle ties!
WITH sal_rank AS 
  (SELECT 
    empno, 
    RANK() OVER(ORDER BY salary DESC) rnk
  FROM 
    salaries)
    
SELECT 
  empno
FROM
  sal_rank
WHERE 
  rnk = 1;

-- 10. Write a query that returns the same table, but with a new column that has average salary per `depname`. We would expect a table in the form: 
SELECT 
    *, 
    ROUND(AVG(salary),0) OVER (PARTITION BY depname) avg_salary
FROM
    salaries
    
-- 11. Write a query that adds a column with the rank of each employee based on their salary within their department, where the employee with the highest salary gets the rank of `1`. We would expect a table in the form:
SELECT 
    *, 
    DENSE_RANK() OVER(PARTITION BY depname ORDER BY salary DESC) salary_rank
 FROM  
    salaries 
    
-- 12. Write a query to count the number of sessions that fall into bands of size 5, i.e. for the above snippet, produce something akin to: 
WITH bin_label AS 
(SELECT 
    session_id, 
    FLOOR(length_seconds/5) as bin_label 
 FROM
    sessions 
 )
 
 SELECT 
    CONCAT(CAST(bin_label*5 AS CHAR), '-', CAST(bin_label*5+5 AS CHAR)) bucket, 
    COUNT(DISTINCT session_id) count 
 GROUP BY 
    bin_label
 ORDER BY 
    bin_label ASC