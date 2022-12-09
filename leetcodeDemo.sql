--Day 1
--1. A country is big if:
--it has an area of at least three million (i.e., 3000000 km2), or
--it has a population of at least twenty-five million (i.e., 25000000).
--Write an SQL query to report the name, population, and area of the big countries.
--Return the result table in any order.
SELECT name, population,area FROM World WHERE area >= 3000000 OR population >= 25000000

--2.Write an SQL query to find the ids of products that are both low fat and recyclable.
--Return the result table in any order.
--The query result format is in the following example.
SELECT product_id
FROM Products
WHERE low_fats LIKE 'Y' AND recyclable LIKE 'Y'

--3. Write an SQL query to report the names of the customer that are not referred by the customer with id = 2.
--Return the result table in any order.
--The query result format is in the following example.
SELECT name 
FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL

--4. Write an SQL query to report all customers who never order anything.
--Return the result table in any order.
--The query result format is in the following example.
SELECT c.name AS 'Customers'
FROM Customers c
WHERE c.id NOT IN (
    SELECT o.customerId
    FROM Orders o
)

--Day2
--1. Write an SQL query to calculate the bonus of each employee. The bonus of an employee is 100% of their salary if the ID of the employee is an odd number and the employee name does not start with the character 'M'. The bonus of an employee is 0 otherwise.
--Return the result table ordered by employee_id.
--The query result format is in the following example.
SELECT
    employee_id,
    CASE
        WHEN ((employee_id % 2 <> 0 ) AND (name NOT LIKE 'M%')) THEN salary
        ELSE 0
    END AS bonus
FROM Employees
GROUP BY 1
ORDER BY 1 ASC
--2. Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temporary tables.
--Note that you must write a single update statement, do not write any select statement for this problem.
--The query result format is in the following example.
UPDATE Salary
    SET
        sex=CASE sex
            WHEN 'm' THEN 'f'
            ELSE 'm'
        END 
--3. Write an SQL query to delete all the duplicate emails, keeping only one unique email with the smallest id. Note that you are supposed to write a DELETE statement and not a SELECT one.
--After running your script, the answer shown is the Person table. The driver will first compile and run your piece of code and then show the Person table. The final order of the Person table does not matter.
--The query result format is in the following example.
DELETE pe1 FROM Person pe1, Person pe2
WHERE pe1.Email=pe2.Email AND pe1.Id > pe2.Id


--Day3
--Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.
--Return the result table ordered by user_id.
SELECT 
    user_id,
    CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name,2))) AS name 
FROM Users 
GROUP BY 1
ORDER BY 1 ASC
-- Write an SQL query to find for each date the number of different products sold and their names.
--The sold products names for each date should be sorted lexicographically.
--Return the result table ordered by sell_date.
SELECT 
    sell_date,
    COUNT(DISTINCT product) num_sold,
    GROUP_CONCAT( DISTINCT product ORDER BY product ASC) products
FROM Activities
GROUP BY 1
--Write an SQL query to report the patient_id, patient_name all conditions of patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix
--Return the result table in any order.
SELECT 
    *
FROM Patients
WHERE conditions LIKE '% DIAB1%' OR conditions LIKE 'DIAB1%'


--Day4
--Write an SQL query to report the IDs of all the employees with missing information. The information of an employee is missing if:
--The employee's name is missing, or
--The employee's salary is missing.
--Return the result table ordered by employee_id in ascending order.
SELECT employee_id FROM Employees WHERE employee_id NOT IN (SELECT employee_id FROM Salaries)
UNION 
SELECT employee_id FROM Salaries WHERE employee_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY 1 ASC
--Write an SQL query to rearrange the Products table so that each row has (product_id, store, price). If a product is not available in a store, do not include a row with that product_id and store combination in the result table.
--Return the result table in any order.
SELECT product_id, 'store1' AS store, store1 AS price FROM Products WHERE store1 IS NOT NULL
UNION 
SELECT product_id, 'store2' AS store, store2 AS price FROM Products WHERE store2 IS NOT NULL
UNION 
SELECT product_id, 'store3' AS store, store3 AS price FROM Products WHERE store3 IS NOT NULL
ORDER BY 1,2 ASC
--Each node in the tree can be one of three types:
--"Leaf": if the node is a leaf node.
--"Root": if the node is the root of the tree.
--"Inner": If the node is neither a leaf node nor a root node.
--Write an SQL query to report the type of each node in the tree.
--Return the result table ordered by id in ascending order.
SELECT
    id,
    CASE 
        WHEN p_id is null THEN 'Root'
        WHEN id IN (SELECT DISTINCT p_id FROM Tree) THEN 'Inner'
        ELSE 'Leaf'
    END type
FROM Tree
ORDER BY 1 ASC
--Write an SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should report null.
SELECT MAX(salary) AS SecondHighestSalary
FROM employee
WHERE salary NOT IN (
        SELECT MAX(salary)
        FROM employee)
        
--Day5
--Write an SQL query to report the first name, last name, city, and state of each person in the Person table. If the address of a personId is not present in the Address table, report null instead.
--Return the result table in any order.
SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId 

--Write an SQL query to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
--Return the result table sorted in any order.
SELECT
	customer_id,
	COUNT(Visits.visit_id) AS count_no_trans
FROM
	visits
LEFT JOIN Transactions
	ON Visits.visit_id = Transactions.visit_id
WHERE 
	Transactions.visit_id IS NULL
GROUP BY customer_id

--Write an SQL query to find all the authors that viewed at least one of their own articles.
--Return the result table sorted by id in ascending order.
SELECT 
    DISTINCT author_id AS id FROM Views 
WHERE author_id = viewer_id 
ORDER BY id

--DAY 6
-- Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).
-- Return the result table in any order.
SELECT w1.id 'Id'
FROM Weather w1, Weather w2
WHERE w1.temperature > w2.temperature
AND DATEDIFF(w1.Recorddate,w2.Recorddate) = 1

--Write an SQL query to report the names of all the salespersons who did not have any orders related to the company with the name "RED".
--Return the result table in any order.
SELECT name
FROM salesperson
WHERE sales_id NOT IN (
	SELECT o.sales_id
	FROM orders o
	JOIN company c on o.com_id = c.com_id
	WHERE c.name LIKE 'red'
)