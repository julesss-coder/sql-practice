
-- Use https://livesql.oracle.com/ to do the exercises

-- =====================================================

-- Competence Check
-- URL: https://wiki.streampy.at/index.php?title=SQL_2#SQL_Exercise_7_using_Joins

-- =====================================================

/*Tables Create the following tables like shown in the [Class Diagram]

Table description:

REGIONS contains rows that represent a region (for example, North, South America, Asia). COUNTRIES contains rows for countries. Each row is linked to a region. LOCATIONS contains the addresses of specific offices, warehouses and/or production sites of a company in a specific country. DEPARTMENTS displays department details where employees work. Each department can have a relationship that represents the head of department in the EMPLOYEES table. EMPLOYEES contains details of each employee working for a department. Not all employees must be assigned to a department. JOBS contains the types of positions that each employee can hold. JOB_HISTORY contains the individual positions that the employee has held so far. If an employee changes department or position within a department, a new row is added to this table with information about the employee's old position. JOB_GRADES identifies a salary range per pay grade level. The salary ranges do not overlap.*/

--======================================================
-- QUESTIONS
-- Which table is the left and right table, respectively, in a JOIN statement?
-- The left table is the one in the select part of the query (after `from`). The right table is the one you are joining on.
-- URL: https://stackoverflow.com/questions/4109704/which-table-exactly-is-the-left-table-and-right-table-in-a-join-statement-s 
-- Does the primary key always need to have the addition `not null`?
-- Why does int(4) (or int with any other number) not work, even though INT is an ANSI-supported data type in Oracle SQL?

  -- Table `employees`: Inserting the data provided in repo throws error:
    -- ORA-01861: literal does not match format string ORA-06512: at "SYS.DBMS_SQL", line 1721
  -- Converting the date string to date format works: to_date('1987-06-17', 'YYYY-MM-DD')
  -- I converted each tuple for `employees` manually to date format. Is there a more efficient solution? 

  -- Same error with table `job_history`-- solved by manually formatting date string with to_date()

-- does creating table and inserting data work?
-- regions OK
-- countries OK
-- locations OK
-- departments OK
-- jobs OK
-- employees create OK, employees insert DOES NOT WORK!! -- solved
-- job_history create OK, job_history insert DOES NOT WORK, throws error: ORA-01861: literal does not match format string ORA-06512: at "SYS.DBMS_SQL", line 1721



create table regions (
  region_id number(11) not null, -- int(11) funktioniert nicht, stattdessen number verwendet
  region_name varchar(25),

  constraint region_pk primary key (region_id)
);

create table countries (
  country_id char(2),
  country_name varchar(40),
  region_id number(11),

  constraint country_pk primary key (country_id),

  constraint region_fk -- constraint names have to be unique
  foreign key (region_id) 
  references regions(region_id)
);

create table locations (
  location_id number(4) not null,
  street_address varchar(40),
  postal_code varchar(12),
  city varchar(30),
  state_province varchar(25),
  country_id char(2),

  constraint location_pk primary key (location_id),

  constraint country_fk 
  foreign key (country_id) 
  references countries(country_id)
);

create table departments (
  department_id number(4) not null,
  department_name varchar(30),
  manager_id number(6),
  location_id number(4),

  constraint department_pk primary key (department_id),

  constraint location_fk
  foreign key (location_id)
  references locations(location_id)
);

create table jobs (
  job_id varchar(20) not null,
  job_title varchar(35),
  min_salary number(6),
  max_salary number(6),
  constraint jobs_pk primary key (job_id)
);

create table employees (
  employee_id number(6) not null,
  first_name varchar(20),
  last_name varchar(20),
  email varchar(25),
  phone_number varchar(20),
  hire_date date,
  job_id varchar(10),
  salary decimal(8,2),
  commission_pct decimal(2,2),
  manager_id number(6),
  department_id number(4),

  constraint employee_pk primary key (employee_id),

  constraint employees_fk
  foreign key (job_id)
  references jobs(job_id),

  --self-reference: Is this how it's done?
  constraint employees_fk2
  foreign key (manager_id)
  references employees(employee_id),

  constraint employees_fk3
  foreign key (department_id)
  references departments(department_id)
);

create table job_history (
  employee_id number(6),
  start_date date,
  end_date date,
  job_id varchar(10),
  department_id number(4),

  -- 
  constraint job_history_fk 
  foreign key (employee_id)
  references employees(employee_id),

  constraint job_history_pk primary key (employee_id, start_date),

  constraint job_history_fk1 
  foreign key (department_id)
  references departments(department_id)
);


Insert For inserting use the insert script file which is in the repository

==================


/*
============================
VALUES FOR TABLE `EMPLOYEES` WITH FORMATTED DATE STRING
----------------------------

INSERT INTO employees VALUES 
       ( 100
       , 'Steven'
       , 'King'
       , 'SKING'
       , '515.123.4567'
       , to_date('1987-06-17', 'YYYY-MM-DD')
       , 'AD_PRES'
       , 24000
       , NULL
       , NULL
       , 90
       );

INSERT INTO employees VALUES 
       ( 101
       , 'Neena'
       , 'Kochhar'
       , 'NKOCHHAR'
       , '515.123.4568'
       , to_date('1989-09-21', 'YYYY-MM-DD')
       , 'AD_VP'
       , 17000
       , NULL
       , 100
       , 90
       );
INSERT INTO employees VALUES 
       ( 102
       , 'Lex'
       , 'De Haan'
       , 'LDEHAAN'
       , '515.123.4569'
       , to_date('1993-01-13', 'YYYY-MM-DD')
       , 'AD_VP'
       , 17000
       , NULL
       , 100
       , 90
       );
INSERT INTO employees VALUES 
       ( 103
       , 'Alexander'
       , 'Hunold'
       , 'AHUNOLD'
       , '590.423.4567'
       , to_date('1990-01-03', 'YYYY-MM-DD')
       , 'IT_PROG'
       , 9000
       , NULL
       , 102
       , 60
       );       
       
INSERT INTO employees VALUES 
       ( 104
       , 'Bruce'
       , 'Ernst'
       , 'BERNST'
       , '590.423.4568'
       , to_date('1991-05-21', 'YYYY-MM-DD')
       , 'IT_PROG'
       , 6000
       , NULL
       , 103
       , 60
       );
INSERT INTO employees VALUES 
       ( 107
       , 'Diana'
       , 'Lorentz'
       , 'DLORENTZ'
       , '590.423.5567'
       , to_date('1999-02-07', 'YYYY-MM-DD')
       , 'IT_PROG'
       , 4200
       , NULL
       , 103
       , 60
       );
INSERT INTO employees VALUES 
       ( 124
       , 'Kevin'
       , 'Mourgos'
       , 'KMOURGOS'
       , '650.123.5234'
       , to_date('1999-11-16', 'YYYY-MM-DD')
       , 'ST_MAN'
       , 5800
       , NULL
       , 100
       , 50
       );
INSERT INTO employees VALUES 
       ( 141
       , 'Trenna'
       , 'Rajs'
       , 'TRAJS'
       , '650.121.8009'
       , to_date('1995-10-17', 'YYYY-MM-DD')
       , 'ST_CLERK'
       , 3500
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 142
       , 'Curtis'
       , 'Davies'
       , 'CDAVIES'
       , '650.121.2994'
       , to_date('1997-01-29', 'YYYY-MM-DD')
       , 'ST_CLERK'
       , 3100
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 143
       , 'Randall'
       , 'Matos'
       , 'RMATOS'
       , '650.121.2874'
       , to_date('1998-03-15', 'YYYY-MM-DD')
       , 'ST_CLERK'
       , 2600
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 144
       , 'Peter'
       , 'Vargas'
       , 'PVARGAS'
       , '650.121.2004'
       , to_date('1998-07-09', 'YYYY-MM-DD')
       , 'ST_CLERK'
       , 2500
       , NULL
       , 124
       , 50
       );
INSERT INTO employees VALUES 
       ( 149
       , 'Eleni'
       , 'Zlotkey'
       , 'EZLOTKEY'
       , '011.44.1344.429018'
       , to_date('2000-01-29', 'YYYY-MM-DD')
       , 'SA_MAN'
       , 10500
       , .2
       , 100
       , 80
       );
INSERT INTO employees VALUES 
       ( 174
       , 'Ellen'
       , 'Abel'
       , 'EABEL'
       , '011.44.1644.429267'
       , to_date('1996-05-11', 'YYYY-MM-DD')
       , 'SA_REP'
       , 11000
       , .30
       , 149
       , 80
       );
INSERT INTO employees VALUES 
       ( 176
       , 'Jonathon'
       , 'Taylor'
       , 'JTAYLOR'
       , '011.44.1644.429265'
       , to_date('1998-03-24', 'YYYY-MM-DD')
       , 'SA_REP'
       , 8600
       , .20
       , 149
       , 80
       );
INSERT INTO employees VALUES 
       ( 178
       , 'Kimberely'
       , 'Grant'
       , 'KGRANT'
       , '011.44.1644.429263'
       , to_date('1999-05-24', 'YYYY-MM-DD')
       , 'SA_REP'
       , 7000
       , .15
       , 149
       , NULL
       );
INSERT INTO employees VALUES 
       ( 200
       , 'Jennifer'
       , 'Whalen'
       , 'JWHALEN'
       , '515.123.4444'
       , to_date('1987-09-17', 'YYYY-MM-DD')
       , 'AD_ASST'
       , 4400
       , NULL
       , 101
       , 10
       );
INSERT INTO employees VALUES 
       ( 201
       , 'Michael'
       , 'Hartstein'
       , 'MHARTSTE'
       , '515.123.5555'
       , to_date('1996-02-17', 'YYYY-MM-DD')
       , 'MK_MAN'
       , 13000
       , NULL
       , 100
       , 20
       );
INSERT INTO employees VALUES 
       ( 202
       , 'Pat'
       , 'Fay'
       , 'PFAY'
       , '603.123.6666'
       , to_date('1997-08-17', 'YYYY-MM-DD')
       , 'MK_REP'
       , 6000
       , NULL
       , 201
       , 20
       );
INSERT INTO employees VALUES 
       ( 205
       , 'Shelley'
       , 'Higgins'
       , 'SHIGGINS'
       , '515.123.8080'
       , to_date('1994-06-07', 'YYYY-MM-DD')
       , 'AC_MGR'
       , 12000
       , NULL
       , 101
       , 110
       );
INSERT INTO employees VALUES 
       ( 206
       , 'William'
       , 'Gietz'
       , 'WGIETZ'
       , '515.123.8181'
       , to_date('1994-06-07', 'YYYY-MM-DD')
       , 'AC_ACCOUNT'
       , 8300
       , NULL
       , 205
       , 110
       );


==========================
VALUES FOR TABLE `JOB_HISTORY` WITH FORMATTED DATE STRING
--------------------------

INSERT INTO job_history
VALUES (102
      , to_date('1993-01-13', 'YYYY-MM-DD')
      , to_date('1998-06-24', 'YYYY-MM-DD')
      , 'IT_PROG'
      , 60);
INSERT INTO job_history
VALUES (101
      , to_date('1989-09-21', 'YYYY-MM-DD')
      , to_date('1993-10-27', 'YYYY-MM-DD')
      , 'AC_ACCOUNT'
      , 110);
INSERT INTO job_history
VALUES (101
      , to_date('1993-10-28', 'YYYY-MM-DD')
      , to_date('1997-03-15', 'YYYY-MM-DD')
      , 'AC_MGR'
      , 110);
INSERT INTO job_history
VALUES (201
      , to_date('1996-02-17', 'YYYY-MM-DD')
      , to_date('1999-12-19', 'YYYY-MM-DD')
      , 'MK_REP'
      , 20);
INSERT INTO job_history
VALUES  (200
       , to_date('1987-09-17', 'YYYY-MM-DD')
       , to_date('1993-06-17', 'YYYY-MM-DD')
       , 'AD_ASST'
       , 90
       );
INSERT INTO job_history
VALUES  (176
       , to_date('1998-03-24', 'YYYY-MM-DD')
       , to_date('1998-12-31', 'YYYY-MM-DD')
       , 'SA_REP'
       , 80
       );
INSERT INTO job_history
VALUES  (176
       , to_date('1999-01-01', 'YYYY-MM-DD')
       , to_date('1999-12-31', 'YYYY-MM-DD')
       , 'SA_MAN'
       , 80
       );
INSERT INTO job_history
VALUES  (200
       , to_date('1994-06-01', 'YYYY-MM-DD')
       , to_date('1998-12-31', 'YYYY-MM-DD')
       , 'AC_ACCOUNT'
       , 90
       );

*/

/*

Selects and Joins
1) The management would like a list of the different salaries per job. The output should contain the job_id as well as the sum of the salaries per job_id. In addition, the output should be sorted in descending order according to the sum of the salaries.

*/
-- works
select 
  job_id,
  min_salary + max_salary as "Sum of min and max salary"
from jobs
order by "Sum of min and max salary" desc;


/*

2) The personnel department wants to have information about the average salary of the employees at the current time.

-- for each employee, get current salary
-- sum them up
-- get average

*/

-- works
select 
  avg(salary) as "Average salary"
from employees;

/*

3) The personnel department would like a list of all employees (first name, last name), on which the department name (department_name) is also displayed.
*/
-- works
select 
  first_name,
  last_name,
  department_name
from employees
-- left join in order to get all employees, whether they have a department or nor
left join departments on employees.department_id = departments.department_id;

/*
4) For the new stationery, the secretary's office needs a list of all departments (department_name) as well as their address consisting of the postal code, the city, the province, and the street and house number
*/

-- works
select
  department_name,
  postal_code,
  city,
  state_province,
  street_address
from departments
-- left join, to get all departments, even those where no address is stored
left join locations on departments.location_id = locations.location_id;

/*
5) The secretariat thanks for the list, but would like to have the name of the country in addition.
*/
-- works
select
  department_name,
  postal_code,
  city,
  state_province,
  street_address,
  country_name
from departments
-- left join, to get all departments, even those where no address is stored
left join locations on departments.location_id = locations.location_id
left join countries on locations.country_id = countries.country_id;

/*
6) The secretariat thanks for the updated list. Embarrassed, the first and last name as "Manager" of the respective manager of the department is now requested in addition.
*/
select
  department_name,
  first_name || ' ' || last_name as "Manager",
  postal_code,
  city,
  state_province,
  street_address,
  country_name
from departments
-- left join, to get all departments, even those where no address is stored
left join locations on departments.location_id = locations.location_id
left join countries on locations.country_id = countries.country_id
-- left join, so that also departments without managers are listed
left join employees on employees.employee_id = departments.manager_id;

/*
7) The personnel department needs a list of the employees with the following contents:

 7.1.) First and last name as "Name
 7.2.) job_title as "job"
 7.3.) The salary
 7.4.) The department name
*/

-- works
select
  first_name || ' ' || last_name as "Name",
  job_title as "Job", -- join jobs on job_id
  salary,
  department_name -- join departments on department_id
from employees
left join jobs on employees.job_id = jobs.job_id
left join departments on employees.department_id = departments.department_id;

/*
8) The new General Manager asks you to find out which subordinates each employee has. You could now collect the data manually, but something stirs inside you when you feel the challenge of generating the result via MySQL. Accept it!
*/

-- works, checked correctness of data with the query below this one
select 
  superiors.employee_id,
  superiors.first_name || ' ' || superiors.last_name as "Employee",
  subordinates.first_name || ' ' || subordinates.last_name as "Subordinate"
from employees superiors
join employees subordinates on superiors.employee_id = subordinates.manager_id
order by superiors.employee_id;

-- Query to check the correctness of above query:
select employee_id, first_name || ' ' || last_name as "Name", manager_id from employees;
-- EMPLOYEE_ID	Name	MANAGER_ID
-- 100	Steven King	 - 
-- 101	Neena Kochhar	100
-- 102	Lex De Haan	100
-- 103	Alexander Hunold	102
-- 104	Bruce Ernst	103
-- 107	Diana Lorentz	103
-- 124	Kevin Mourgos	100
-- 141	Trenna Rajs	124
-- 142	Curtis Davies	124
-- 143	Randall Matos	124
-- 144	Peter Vargas	124
-- 149	Eleni Zlotkey	100
-- 174	Ellen Abel	149
-- 176	Jonathon Taylor	149
-- 178	Kimberely Grant	149
-- 200	Jennifer Whalen	101
-- 201	Michael Hartstein	100
-- 202	Pat Fay	201
-- 205	Shelley Higgins	101
-- 206	William Gietz	205


-- TO-DOS
-- Do I have to do these tasks using `SELECT`s only, as well?
-- Solve exercise 6 using Joins / Selects
-- Solve exercise 7 using Joins / Selects.
