create table emp (
  empno int,
  ename varchar(10),
  job varchar(9),
  mgr int,
  hiredate date,
  sal int,
  comm int,
  deptno int,
  primary key (empno),
  foreign key (deptno) references dept (deptno),
  // foreign key mgrKey (mgr) references emp (empno) // add later
);


// DATE IST IM FALSCHEN FORMAT, KONNTE DAS ERWARTETE FORMAT IN PHPMYADMIN NICHT AENDERN
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,str_to_date('17-12-1980', '%d-%m-%y'),800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,str_to_date('20-02-1981', '%d-%m-%y'),1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,str_to_date('22-02-1981', '%d-%m-%y'),1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,str_to_date('2-04-1981', '%d-%m-%y'),2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,str_to_date('28-09-1981', '%d-%m-%y'),1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,str_to_date('1-05-1981', '%d-%m-%y'),2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,str_to_date('9-06-1981', '%d-%m-%y'),2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,str_to_date('09-12-1982', '%d-%m-%y'),3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,str_to_date('17-11-1981', '%d-%m-%y'),5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,str_to_date('8-08-1981', '%d-%m-%y'),1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,str_to_date('12-01-1983', '%d-%m-%y'),1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,str_to_date('3-12-1981', '%d-%m-%y'),950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,str_to_date('3-12-1981', '%d-%m-%y'),3000,NULL,20);
INSERT INTO EMP VALUES (1111,'MILLER','CLERK',null,str_to_date('23-01-1982', '%d-%m-%y'),1300,NULL,10);

select date_format(hiredate,'%e %M %Y')
as hireDate 
from emp;

// 4. date output 2 - Output of ENAME and the number of days since joining the company (column heading DAYS) for each employee.
SELECT
	ename,
    datediff("2022-12-13", hiredate) as `days`
    from emp;
    
// 5. simple output 2 - Output of jobs (only 1 output per job).
select distinct job from emp;

// 6. minmax output - Output of the minimum, maximum and average salary.
// minimum salary in `emp`:
select ename, min(sal) as `lowest salary`
from emp;
// maximum salaryselect ename, max(sal) as `highest salary`
from emp;
// average salary
select avg(cast(sal as float)) as `average salary` from emp;
// ODER:
select avg(sal) as `average salary` from emp; // ergibt auch eine Dezimalzahl

// 7. count 1 - Statement to determine "How many employees are there?".
SELECT COUNT(ENAME) FROM EMP;


// 8. count 2 - Statement to determine "How many different jobs are there?".
select count(distinct job)
from emp;


=========== KOMPETENZCHECK =================

Create the tables and insert data from the following files [Create Tables] [Insert Data]. If you are working on the Oracle database adjust the insert script dates and number formats.

1. The HR department wants a query to display the last name, job identifier (JOB_ID), hire date and employee number for each employee, with the employee number as the first value. Specify the alias STARTDATE for the HIRE_DATE column.

select  
  employee_id, 
  last_name,
  job_id,
  hire_date as `STARTDATE`
from employees;


2. HR requires a query to display 
all unique job identifiers (JOB_ID) from the EMPLOYEES table. 
Duplicates are to be avoided.

select distinct 
  job_id
from employees;
// Alternative: group by job_id

3. The HR department wants more meaningful column headings for the reports related to employees. Use the statement from output 3.1 (1.1??) and give the columns the headings Emp #, Employee, Job and Hire Date. Run the query again.

select  
  employee_id as `Emp #`, 
  last_name as `Employee`,
  job_id as `Job`,
  hire_date as 'Hire Date'
from employees;

4. For budget purposes, HR needs a report that shows the last name and salary for employees earning more than $12,000. Run the query.

select 
  last_name, 
  salary 
from employees
where salary>12000;

5. Create a report to show the last name and department number for the employee with employee number 176.

select 
  last_name, 
  department_id
from employees
where employee_id=176;

6. Create a report to show the last name, job identifier (JOB_ID) and hire date for all employees. Sort the query in ascending order by hire date.

select 
  last_name, 
  job_id, 
  hire_date
from employees
order by hire_date;

7. View last names and department numbers of all employees in Department 20, sorted alphabetically by last name in ascending order.

select 
  last_name, 
  department_id
from employees
where department_id=20
order by last_name;

8. Create a query that displays last names, salaries and commissions of all employees whose commission is 20%. Give the columns the headings Employee, Monthly Salary and Commission.

select 
  last_name as `Employee`,
  salary as `Monthly salary`, 
  commission_pct as `Commission`
from employees
where commission_pct=0.2;

7. View last names and department numbers of all employees in Department 20, sorted alphabetically by last name in ascending order.

select 
  last_name, 
  department_id
from employees 
where department_id=20
order by last_name;

8. Create a query that displays last names, salaries and commissions of all employees whose commission is 20%. Give the columns the headings Employee, Monthly Salary and Commission.

select 
  last_name as `Employee`, 
  salary as `Monthly Salary`, 
  commission_pct as `Commission`
from employees 
where commission_pct=0.2;
