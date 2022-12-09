SELECT 
	p.post_no 
	,e.first_name 
	,e.last_name 
    ,e.emp_no
    ,t.team
	,p.created_at 
	,e.gender
    ,p.likes
    ,p.shares
    ,p.comments
    ,p.views
FROM posts p 
	JOIN employees e ON e.emp_no  = p.emp_no 
	JOIN emp_team et ON et.emp_no = e.emp_no 
	JOIN teams t ON t.team_no = et.team_no 	
	
SELECT COUNT(*)
FROM posts p 
WHERE MONTH(p.created_at) = 11 AND YEAR(p.created_at) = 2022

SELECT COUNT(*)
FROM employees e 

-- MySQL press kpi tracking
-- WITH cte_raw AS
-- (SELECT 
-- 	CASE 
-- 		WHEN EXTRACT(DAY FROM p.created_at)%3 =1 THEN p.created_at
-- 		WHEN EXTRACT(DAY FROM p.created_at)%3 =2 THEN p.created_at - INTERVAL 1 DAY
-- 		ELSE p.created_at - INTERVAL 2 DAY
-- 	END date_group
-- 	,EXTRACT(YEAR_MONTH FROM p.created_at) `year_month`
-- 	,t.team
-- 	,e.emp_no
-- 	,CONCAT(e.first_name, ' ',e.last_name) emp_name
-- 	,SUM(p.likes) likes
-- 	,COUNT(p.post_no) post_num
-- 	,SUM(p.comments) comments
-- 	,SUM(p.shares) shares
-- 	,SUM(p.views) views
-- 	
-- FROM posts p 
-- 	JOIN employees e ON e.emp_no  = p.emp_no 
-- 	JOIN emp_team et ON et.emp_no = e.emp_no 
-- 	JOIN teams t ON t.team_no = et.team_no 	
-- GROUP BY 1,2,3,4),
-- cte_cal_kpi AS 
-- (SELECT emp_no
-- 	    ,`year_month`
-- 	    ,SUM(CASE WHEN post_num>=3 THEN 1 ELSE 0 END ) month_kpi_count
-- FROM cte_raw
-- GROUP BY 1,2
-- ),
-- cte_temp AS (
-- SELECT a.*,b.month_kpi_count
-- FROM cte_raw a
-- 	JOIN cte_cal_kpi b ON a.`year_month` = b.`year_month`
-- 	AND a.emp_no = b.emp_no
-- )
-- SELECT COUNT(DISTINCT emp_no)
-- FROM cte_temp
-- WHERE `year_month`=202211
-- AND month_kpi_count>=5
WITH cte_raw AS
(SELECT 
 CASE 
  WHEN EXTRACT(DAY FROM p.created_at)%3 =1 THEN p.created_at
  WHEN EXTRACT(DAY FROM p.created_at)%3 =2 THEN p.created_at - INTERVAL 1 DAY
  ELSE p.created_at - INTERVAL 2 DAY
 END `date`
 ,EXTRACT(YEAR_MONTH FROM p.created_at) `year_month`
 ,t.team
 ,e.emp_no
 ,CONCAT(e.first_name, ' ',e.last_name) emp_name
 ,SUM(p.likes) likes
 ,COUNT(p.post_no) post_num
 ,SUM(p.comments) comments
 ,SUM(p.shares) shares
 ,SUM(p.views) views
 
FROM posts p 
 JOIN employees e ON e.emp_no  = p.emp_no 
 JOIN emp_team et ON et.emp_no = e.emp_no 
 JOIN teams t ON t.team_no = et.team_no  
GROUP BY 1,2,3,4, 5),
cte_cal_kpi AS 
(SELECT emp_no
     ,`year_month`
     ,SUM(CASE WHEN post_num>=3 THEN 1 ELSE 0 END ) month_kpi_count
FROM cte_raw
GROUP BY 1,2
)
SELECT  
 DATE(a.`date`) AS `date`,
 a.`year_month`,
 a.team,
 a.emp_no,
 a.emp_name,
 a.likes,
 a.post_num,
 a.comments,
 a.shares,
 a.views,
 b.month_kpi_count
FROM cte_raw a
 JOIN cte_cal_kpi b ON a.`year_month` = b.`year_month`
 AND a.emp_no = b.emp_no
WHERE a.emp_name LIKE 'Xiping Klerer' AND a.`year_month`=202211
