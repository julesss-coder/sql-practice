
-- Use https://livesql.oracle.com/ to do the exercises

-- =====================================================

-- Competence Check
-- URL: https://wiki.streampy.at/index.php?title=SQL_2#SQL_Exercise_7_using_Joins

-- =====================================================

/*Tables Create the following tables like shown in the [Class Diagram]

Table description:

REGIONS contains rows that represent a region (for example, North, South America, Asia). COUNTRIES contains rows for countries. Each row is linked to a region. LOCATIONS contains the addresses of specific offices, warehouses and/or production sites of a company in a specific country. DEPARTMENTS displays department details where employees work. Each department can have a relationship that represents the head of department in the EMPLOYEES table. EMPLOYEES contains details of each employee working for a department. Not all employees must be assigned to a department. JOBS contains the types of positions that each employee can hold. JOB_HISTORY contains the individual positions that the employee has held so far. If an employee changes department or position within a department, a new row is added to this table with information about the employee's old position. JOB_GRADES identifies a salary range per pay grade level. The salary ranges do not overlap.*/

CREATE TABLE students  
( id number(10) NOT NULL,  
  name varchar2(40) NOT NULL,  
  class varchar2(10)  
  PRIMARY KEY(id)
);

create table regions
( region_id number(11) not null, -- int(11) funktioniert nicht, stattdessen number verwendet
  region_name varchar(25),
  constraint region_id primary key (region_id)
);

create table countries (
  country_id char(2),
  country_name varchar(40),
  region_id number(11),
  constraint country_id primary key (country_id),
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

Insert For inserting use the insert script file which is in the repository

Selects and Joins
1) The management would like a list of the different salaries per job. The output should contain the job_id as well as the sum of the salaries per job_id. In addition, the output should be sorted in descending order according to the sum of the salaries.

2) The personnel department wants to have information about the average salary of the employees at the current time.

3) The personnel department would like a list of all employees (first name, last name), on which the department name (department_name) is also displayed.

4) For the new stationery, the secretary's office needs a list of all departments (department_name) as well as their address consisting of the postal code, the city, the province, and the street and house number

5) The secretariat thanks for the list, but would like to have the name of the country in addition.

6) The secretariat thanks for the updated list. Embarrassed, the first and last name as "Manager" of the respective manager of the department is now requested in addition.

7) The personnel department needs a list of the employees with the following contents:

 7.1.) First and last name as "Name
 7.2.) job_title as "job"
 7.3.) The salary
 7.4.) The department name


8) The new General Manager asks you to find out which subordinates each employee has. You could now collect the data manually, but something stirs inside you when you feel the challenge of generating the result via MySQL. Accept it!

==================
