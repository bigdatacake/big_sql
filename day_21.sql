DROP
	TABLE IF EXISTS billings;
DROP
	TABLE IF EXISTS HoursWorked; CREATE TABLE billings (
		emp_name varchar(10),
		bill_date date,
		bill_rate int
	);
DELETE FROM
	billings; INSERT INTO billings
VALUES
	('Sachin', '01-JAN-1990', 25),
	('Sehwag', '01-JAN-1989', 15),
	('Dhoni', '01-JAN-1989', 20),
	('Sachin', '05-Feb-1991', 30); CREATE TABLE HoursWorked (
		emp_name varchar(20),
		work_date date,
		bill_hrs int
	);
DELETE FROM
	HoursWorked; INSERT INTO HoursWorked
VALUES
	('Sachin', '01-JUL-1990', 3),
	('Sachin', '01-AUG-1990', 5),
	('Sehwag', '01-JUL-1990', 2),
	('Sachin', '01-JUL-1991', 4);


SELECT
	*
FROM
	hoursworked;

SELECT
	*
FROM
	billings;
	

WITH
billing_range AS(
SELECT 
	b.emp_name,
	b.bill_date bill_start_date,
	b.bill_rate,
	LEAD((b.bill_date-1), 1, NOW()::date) over(partition BY b.emp_name ORDER BY b.bill_date ASC) AS bill_end_date
FROM billings b
)
SELECT 
	b.emp_name,
	b.bill_rate,
	w.bill_hrs
FROM billing_range b JOIN hoursworked w
ON b.emp_name = w.emp_name AND w.work_date BETWEEN b.bill_start_date AND b.bill_end_date;


WITH
billing_range AS(
SELECT 
	b.emp_name,
	b.bill_date bill_start_date,
	b.bill_rate,
	LEAD((b.bill_date-1), 1, NOW()::date) over(partition BY b.emp_name ORDER BY b.bill_date ASC) AS bill_end_date
FROM billings b
)
SELECT 
	b.emp_name,
	SUM(b.bill_rate * w.bill_hrs) payable
FROM billing_range b JOIN hoursworked w
ON b.emp_name = w.emp_name AND w.work_date BETWEEN b.bill_start_date AND b.bill_end_date
GROUP BY b.emp_name;


