Easy
====
-- Show first name, last name, and gender of patients whose gender is 'M'
select 
	first_name, last_name, gender
from patients
where 1 = 1
and gender = 'M';

-- Show first name and last name of patients who does not have allergies. (null)
select 
	first_name, last_name
from patients
where 1 = 1
and allergies is NULL;


--Show first name of patients that start with the letter 'C'
select 
	first_name
from patients
where 1 = 1
and upper(first_name) like 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select 
	first_name, last_name
from patients
where 1 = 1
and weight between 100 and 120;


-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients
set allergies='NKA'
where 1 = 1
and allergies is NULL;


-- Show first name and last name concatinated into one column to show their full name.
select
	concat(first_name, ' ', last_name) full_name
from patients;


-- Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON'
select
	first_name, last_name, province_name
from patients p join province_names o
on p.province_id = o.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.
select
	count(*) total_patients

from patients
where 1 = 1
and year(birth_date) = 2010;


-- Show the first_name, last_name, and height of the patient with the greatest height.
select
	first_name, last_name, height
from patients
where 1 = 1
and height = (select max(height) from patients);


-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select
	*
from patients
where 1 = 1
and patient_id in (1,45,534,879,1000);


-- Show the total number of admissions
select
	count(*) total_admissions
from admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
select
	*
from admissions
where 1 = 1
and admission_date = discharge_date;


-- Show the patient id and the total number of admissions for patient_id 579.
select
	patient_id, count(admission_date) total_admissions
from admissions
where 1 = 1
and patient_id = 579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
select
	distinct city as  unique_cities
from patients
where 1 = 1
and province_id='NS';


-- Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
select
	first_name, last_name, birth_date
from patients
where 1 = 1
and height>160 and weight>70;


-- Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
select
	first_name, last_name, allergies
from patients
where 1 = 1
and allergies is NOT NULL
and city='Hamilton';


Medium
======
-- Show unique birth years from patients and order them by ascending.
select
	distinct year(birth_date) birth_year
from patients
order by 1;

select 
	first_name
from patients
group by first_name
having count(first_name) = 1;


select
	patient_id, first_name
from patients
where 1 = 1
and lower(first_name) like 's%s'
and len(first_name)>=6;

select
	p.patient_id, p.first_name, p.last_name
from patients p join admissions a
where 1 = 1
and p.patient_id = a.patient_id
and a.diagnosis='Dementia';

select 
	first_name
from patients
order by len(first_name), first_name;

select
(select count(gender) from patients where gender='M') as male_count, 
(select count(gender) from patients where gender='F') as female_count;


select 
	first_name, last_name, allergies
from patients 
where 1 = 1
and allergies in ('Penicillin', 'Morphine')
order by allergies, first_name, last_name;


select
	p.patient_id, a.diagnosis
from patients p join admissions a
on p.patient_id = a.patient_id
group by p.patient_id, a.diagnosis
having count(a.diagnosis)>1;


select 
	city, count(patient_id) num_patients
from patients
group by city
order by 2 desc, city;



select
	p.first_name, p.last_name, 'Patient' role
from patients p 
union all
select
	d.first_name, d.last_name, 'Doctor' role
from doctors d;


select 
	allergies, count(allergies) total_diagnosis
from patients
where allergies is not NULL
group by allergies
order by 2 desc;



select
	first_name, last_name, birth_date
from patients
where 1 = 1
and year(birth_date) between 1970 and 1979
order by birth_date;

select
	concat(upper(last_name),',',lower(first_name))
from patients
order by first_name desc;


select
	province_id, sum(height) sum_height
from patients
group by province_id
having sum(height) > 7000;

select
	max(weight) - min(weight) as weight_delta
from patients
where 1 = 1
and last_name='Maroni';


select
	day(admission_date) as day_number,
    count(patient_id) number_of_admissions
from admissions
group by day(admission_date)
order by 2 desc;


select 
	patient_id, admission_date, discharge_date, diagnosis, attending_doctor_id
from admissions
where 1 = 1
and patient_id=542
and admission_date = (select max(admission_date) from admissions where patient_id=542);


select
  patient_id, attending_doctor_id, diagnosis
from admissions
where 1 = 1
AND (patient_id%2 != 0 and attending_doctor_id in (1,5,19))
OR (cast(attending_doctor_id as STRING) like '%2%' AND length(cast(patient_id as STRING))=3);


select 
	d.first_name, d.last_name,
    count(a.patient_id) admissions_total
from doctors d join admissions a
on d.doctor_id = a.attending_doctor_id
group by d.first_name, d.last_name;


select 
	d.doctor_id, concat(d.first_name, ' ', d.last_name) full_name,
 	min(a.admission_date) first_admission_date,
    max(a.admission_date) last_admission_date
from doctors d join admissions a
on d.doctor_id = a.attending_doctor_id
group by d.doctor_id, d.first_name, d.last_name;


select 
	o.province_name,
    count(patient_id) as patient_count
from patients p left join province_names o
on p.province_id = o.province_id
group by o.province_name
order by 2 desc;


select 
	concat(p.first_name, ' ' , p.last_name) as patient_name,
    a.diagnosis,
    concat(d.first_name, ' ', d.last_name) doctor_name
from patients p join admissions a
on p.patient_id = a.patient_id
join doctors d
on a.attending_doctor_id = d.doctor_id;


select
	first_name, last_name, count(patient_id) num_of_duplicates
from patients
group by first_name, last_name
having count(patient_id)>1;


select
	concat(p.first_name, ' ' , p.last_name) as patient_name,
    round((p.height/30.48), 1) as [height "Feet"],
    round((p.weight*2.205), 0) as [weight "Pounds"],
    p.birth_date,
    case
    	when p.gender='M' then 'MALE'
        ELSE 'FEMALE'
    END as gender_type
from patients p;


select 
	p.patient_id, p.first_name, p.last_name
from patients p LEFT outer join admissions a
on p.patient_id = a.patient_id
where 1 = 1
and a.patient_id is NULL;


with
hospital_visits as(
select
	admission_date,
    count(*) total_visits
from admissions
group by admission_date
)
select 
	max(total_visits) as max_visits, 
    min(total_visits) as min_visits,
    round(avg(total_visits),2) as average_visits
from hospital_visits;


-- Display every patient that has at least one admission and show their most recent admission along with the patient and doctor's full name.
select
    concat(p.first_name, ' ', p.last_name) as patient_name,
    max(a.admission_date) admission_date,
    concat(d.first_name, ' ', d.last_name) as doctor_name
from admissions a join doctors d
on a.attending_doctor_id = d.doctor_id
join patients p
on a.patient_id = p.patient_id
group by a.patient_id
having count(*) >= 1;


Hard
====
-- Show all of the patients grouped into weight groups.
-- Show the total amount of patients in each weight group.
-- Order the list by the weight group decending.

-- For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

select 
	patient_id, 
    weight,
    floor(weight/10)*10 as weight_group
from patients;

with 
weight_group as(
select 
	patient_id, 
    weight,
    floor(weight/10)*10 as weight_group
from patients)
select 
	count(patient_id) as patients_in_group, 
    weight_group
from weight_group
group by weight_group
order by 2 desc;

-- Show patient_id, weight, height, isObese from the patients table.
-- Display isObese as a boolean 0 or 1.
-- Obese is defined as weight(kg)/(height(m)2) >= 30.
-- weight is in units kg.
-- height is in units cm.

select
	patient_id,
    weight,
    height,
    case
    	when (weight/power(height/100.0,2)) >= 30 then 1
        ELSE 0
    end as isObese
from patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty.
-- Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
-- Check patients, admissions, and doctors tables for required information.

select
	p.patient_id, p.first_name, p.last_name,
    d.specialty
from patients p join admissions a
on p.patient_id = a.patient_id
join doctors d
on d.doctor_id = a.attending_doctor_id
where 1 = 1
and a.diagnosis='Epilepsy'
and d.first_name='Lisa';


-- All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
-- The password must be the following, in order:
-- 1. patient_id
-- 2. the numerical length of patient's last_name
-- 3. year of patient's birth_date

select
	distinct p.patient_id,
    concat(a.patient_id, '', length(p.last_name), '', year(p.birth_date)) as temp_password
from patients p join admissions a
on p.patient_id = a.patient_id;

-- Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
-- Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

with 
patient_insurance as(
select
	case
    	when (patient_id%2.0) = 0 then 'Yes'
    	ELSE 'No'
    END as has_insurance,
  	case
    	when (patient_id%2.0) = 0 then 10
    	ELSE 50
    END as cost_after_insurance
from admissions)
select 
	has_insurance, 
    sum(cost_after_insurance) as cost_after_insurance
from patient_insurance
group by has_insurance;

select
	case
    	when (patient_id%2.0) = 0 then 'Yes'
    	ELSE 'No'
    END as has_insurance,
  	sum(case
    	when (patient_id%2.0) = 0 then 10
    	ELSE 50
    END) as cost_after_insurance
from admissions
group by has_insurance;

-- Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

with 
male_count as(
select
	o.province_name,
    count(p.gender) as male
from patients p join province_names o
on p.province_id = o.province_id
where 1 = 1
and p.gender='M'
group by o.province_name
),
female_count as(
select
	o.province_name,
    count(p.gender) as female
from patients p join province_names o
on p.province_id = o.province_id
where 1 = 1
and p.gender='F'
group by o.province_name)
select 
	m.province_name
from male_count m join female_count f
on m.province_name = f.province_name
where 1 = 1
and m.male > f.female;

SELECT
 	o.province_name
FROM patients p JOIN province_names o
ON p.province_id = o.province_id
GROUP BY o.province_name
having SUM(p.gender = 'M') > SUM(p.gender = 'F');

-- We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
-- - First_name contains an 'r' after the first two letters.
-- - Identifies their gender as 'F'
-- - Born in February, May, or December
-- - Their weight would be between 60kg and 80kg
-- - Their patient_id is an odd number
-- - They are from the city 'Kingston'

 SELECT
	p.*
FROM patients p
where 1 = 1
and first_name like '__r%'
and p.gender = 'F'
and month(p.birth_date) in (2,5,12)
and p.weight between 60 and 80
and p.city = 'Kingston'
and p.patient_id%2.0 = 1;

-- Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT
	round((count(*)*1.0 / (select count(*) from patients p)) * 100,2) || '%' as percent_of_male_patients
FROM patients p
where 1 = 1
and p.gender = 'M';

-- For each day display the total amount of admissions on that day. Display the amount changed from the previous date.

select 
	admission_date,
    count(patient_id) as admission_day,
	count(patient_id)-LAG(count(patient_id),1) OVER (ORDER BY admission_date) AS admission_count_change
from admissions
group by admission_date;


-- Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
select 
	substr(province_name,2) from
(
select 
	case 
    	when province_name = 'Ontario' then '1'||province_name
        ELSE '2'||province_name
     END province_name
from province_names
order by province_name asc);

select province_name
from province_names
order by
  (case when province_name = 'Ontario' then 0 else 1 end),
  province_name


-- We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
select 
	d.doctor_id, 
    concat(d.first_name, ' ',d.last_name) doctor_name,
    d.specialty,
    year(a.admission_date) selected_year,
    count(*) total_admissions
from admissions a join doctors d
on a.attending_doctor_id = d.doctor_id
group by 
	d.doctor_id, 
    doctor_name,
    d.specialty,
    selected_year;

