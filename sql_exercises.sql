SQL EXERCISE 3

=======================================================================

1-8 Tennis queries

1. output of PLAYERNO, NAME of players born after 1960.

select 
    playerno,
    name
from players
where year_of_birth>1960;


2. output of PLAYERNO, NAME and TOWN of all female players who do not reside in Strat- ford.

select
    playerno,
    name,
    town
from players
where sex='F' and not town='Stratford';


3. output of player numbers of players who joined the club between 1970 and 1980.

select
    playerno
from players
where year_joined between 1970 and 1980;


4. output of PlayerId, Name, Year of Birth of players born in a leap year.
=== DOES NOT WORK - CHECK FOR LEAP YEAR IS INCORRECT ====
select 
    playerno,
    name,
    year_of_birth
from players
where mod(year_of_birth, 4)=0 and
mod(year_of_birth, 100)!=0 or
mod(year_of_birth, 400)=0;


// Pseudocode for checking for leap year, see URL: https://de.wikipedia.org/wiki/Schaltjahr#Gregorianischer_Kalender 
if year % 4 === 0:
  if year % 100 !== 0:
    leap year
  else if year % 400 === 0:
    leap year

// SQL pseudocode for checking for leapyear
if mod(year_of_birth, 4) = 0 then
  if mod(year_of_birth, 100)!= 0
  or
  if mod(year_of_birth, 100)=0 and if mod(year_of_birth, 400)=0 then
    // leap year

========================    
// um einfach berechnungen ohne bestimmte datenbanken durchzufuehren, verwende `dual`
SELECT MOD(253, 7) FROM dual;

5. output of the penalty numbers of the penalties between 50,- and 100,-.
select
  paymentno
from penalties
where amount between 50 and 100;

6. output of PlayerId, name of players who do not live in Stratford or Douglas.
select
  playerno,
  name
from players
where not town='Stratford' and not town='Douglas';


7. output of playerId and name of players whose name contains 'is'.

select
  playerno,
  name 
from players
where name like '%is%';

8. output of all hobby players.
select
  name
from players
where leagueno is null;


===============================================================

9 - 21 EmpDept queries.
9. output of those employees who receive more commission than salary.

select    
  empno,
  ENAME
from emp
where comm>sal;

10. output of all employees from department 30 whose salary is greater than or equal to 1500.

select
  empno,
  ename
from emp
where deptno=30 and 
sal>=1500;

11. output of all managers who do not belong to department 30.

select
  empno,
  ENAME
from emp
where job='MANAGER'
and deptno!=30;

12. output of all employees from department 10 who are neither managers nor clerical workers (CLERK).

select 
  empno,
  ename
from emp
where deptno=10
and not job='MANAGER' and not job='CLERK';

13. output of all employees who earn between 1200,- and 1300,-.

select 
  empno,
  ENAME
from emp
where sal between 1200 and 1300;

14. output all employees whose name is 5 characters long and begins with ALL.

select
  empno,
  ename
from emp
where length(ename)=5
and ename like 'ALL%';

15. output the total salary (salary + commission) for each employee.


select
  ename,
  sal + nvl(comm, 0) as totalSalary
from emp;

nvl(comm, 0): wenn `comm` gleich `NULL` ist, wird 0 zurueckgegeben, wenn nicht, dann `comm`.

16. output all employees, whose commission is over 25% of the salary.

select 
  empno,
  ename 
from emp
where comm>=0.25*sal;

17. searched is the average salary of all office employees.

select
  round(avg(sal), 2)
from emp;

18. searched is the number of employees who have received a commission.

select
  count(ename)
from emp
where comm is not null and not comm=0;

19. wanted is the number of different jobs in department 30.

select
  count(distinct job)
from emp
where deptno=30;


20. wanted is the number of employees in department 30.

select
  count(empno)
from emp
where deptno=30;

21. output of employees hired between 4/1/81 and 15/4/81.

select 
  empno,
  ename
from emp
where hiredate between '4-01-81' and '15-04-81';

// Datumsformat so eingeben, wie ich es urspruenglich eingegeben habe, nicht wie es Oracle SQL anzeigt, d.h. d-mm-yy (bei einstelligen Tagen nur eine Stelle ohne vorhergehende 0)


===============================================

SQL EXERCISE 4

===============================================

1-6 Tennis query

1. output TEAMNO of the teams in which the player with the number 27 is not captain

select
  teamno 
from teams
where not playerno=27;

2. output of PLAYERNO, NAME and INITIALS of the players who have won at least one match

select distinct 
  players.playerno, name, initials 
from players, matches 
where won >= 1 
and players.playerno = matches.playerno;

// =========== Get number of matches won per player =========

select
    playerno, sum(won)
from matches
group by playerno;

// =========== Get number of matches won per player where won >= 2 =========

select
    playerno, sum(won)
from matches
group by playerno
having sum(won)>2;


3. output of playerNo and name of the players who have received at least one penalty

players:
- playerno 
- name
penalties:
  - playerno
  - amount 

select distinct
  players.playerno,
  Name
from players, penalties
where players.playerno = penalties.playerno
and amount>1;

4. output of playerNo and name of the players, who have received at least one penalty over 50.

select distinct
  players.playerno,
  Name 
from players, penalties
where players.playerNo = penalties.playerNo
and amount>=50;

5. output of PlayerNo and name of players born in the same year as R. Parmenter

select
  playerno,
  name,
  initials
from players
where year_of_birth=
  (select 
    year_of_birth
  from players
  where name='Parmenter'
  and initials='R')
and not (name='Parmenter') and not initials='R';

6. output of playerNo and name of the oldest player from Stratford

select
  playerNo,
  Name
from players
where year_of_birth=
  (select min(year_of_birth) 
  from players
  where town='Stratford');

7-12 EmpDept query
7. search all departments, which have no employees

emp:
- deptno

dept:
- deptno

get the department number (dept.deptno) that is not among emp.deptno

select 
    deptno
from dept
where deptno not in (
select distinct 
    deptno
from emp);

// funzt nicht
select 
    deptno
from dept
where deptno not exists (
select distinct 
    deptno
from emp);

// bekhans version
select * from dept where not exists (select * from emp where emp.deptno = dept.deptno);



8. search all employees who have the same job as JONES

select 
  ename 
from emp
where job=(
  select 
    job
  from emp
  where ename='JONES'
)
and not ename='JONES';

9. show all employees who make more than the average employee from department 30.
avg sal = 1566

select
    empno,
    ename,
    sal
from emp
where sal>(
    select 
        avg(sal)
    from emp
    where deptno=30
);

10. show all employees who earn more than any employee from department 30

select
    ename,
    sal
from emp
where sal>(
select max(sal)
from emp
where deptno=30
);

11. display all employees from department 10 whose job is not held by any employee from department 30
// both work

select  
  empno,
  ename,
  job
from emp
where job not in (
select
    job
from emp
where deptno=30)
and deptno=10;

select  
  empno,
  ename,
  job
from emp
where deptno=10 
and job not in (
select
    job
from emp
where deptno=30);


12. search for the employee data (EMPNO, ENAME, JOB, SAL) of the employee with the highest salary.

select
  empno, 
  ename,
  job, 
  sal
from emp
where sal=(
  select 
    max(sal)
  from emp
);

// If you exclude the president, who is not an employee
select
  empno, 
  ename,
  job, 
  sal
from emp
where sal=(
  select 
    max(sal)
  from emp
  where not job='PRESIDENT'
);

=================================================

SQL EXERCISE 5

=================================================

1-11 Tennis query
1. number of new players per year

select 
  count(playerno)
from players
group by year_joined;

2. number and average amount of penalties per player

select
  count(*)
from penalties
group by playerno;

3. number of penalties for the years before 1983

select
  playerno,
  count(*) as "Number of penalties"
from penalties
where pen_date<'01-01-1983'
group by playerno;

4. in which cities live more than 4 players

select 
  count(*) as "Number of tennis players",
  town
from players
group by town
having count(*) > 4;

5. PLAYERNO of those players whose penalty total is over 150

select
  playerno,
  sum(amount) as "Total penalty"
from penalties 
group by playerno
having sum(amount) > 150;

6. NAME and INITIALS of those players who received more than one penalty

// Fuer die unten angegebene Menge moechten wir Infos zu Namen und Initialen der Spieler
select
  playerno, name, initials
from players
where playerno in (
// Menge der Spieler, die mehr als eine Strafe erhalten haben
  select 
    playerno
  from penalties
  group by playerno
  having count(paymentno) > 1
);

// OPTION 1: JOIN
select
    players.playerno,
    players.name,
    players.initials
from players join penalties on players.playerno = pentalites.playerno
group by players.playerno, players.name, players.initials
having count(penalties.playerno) > 1;

// OPTION 2: SUBSELECT
select
    players.playerno,
    players.name,
    players.initials
from players
where playerno in (
  select 
   playerno
  from penalties
  group by playerno
 having count(penalties.playerno) > 1
);


7. in which years there were exactly 2 penalties

select
  pen_date
from penalties
group by extract(year from pen_date)
having count(extract(year from pen_date));

select 
  extract(year from pen_date),
  count(*)
from penalties
group by extract(year from pen_date)



8. NAME and INITIALS of the players who received 2 or more penalties over $40

// Funktioniert
select
  players.playerno,
  name,
  initials
from players
right join penalties
on players.playerno = penalties.playerno
where amount > 40
group by name, initials, players.playerno
having count(paymentno) >= 2;

multitable select mit where
join
subselect (select in zweiter klammer)



9. NAME and INITIALS of the player with the highest penalty amount
// My understanding of the exercise: get the highest total amount of a player

// Max amount
select
  max(amount)
from penalties;

// funktioniert
select
  players.playerno,
  name,
  initials
from players
right join penalties
on players.playerno = penalties.playerno
group by players.playerno, name, initials
// `>= all` works, `> all` does not, because a sum(amount) cannot be greater than ALL sum(amount) in a table
having sum(amount) >= all (
  select 
    sum(amount) 
  from penalties 
  group by playerno);



10. in which year there were the most penalties and how many were there

Expected table:
Year | Number of penalties

select
  to_char(pen_date, 'yyyy') as Year,
  count(paymentno) as "Number of penalties"
from penalties
group by to_char(pen_date, 'yyyy')
having count(paymentno) >= all (
  select 
    count(paymentno)
  from penalties
  group by playerno
);

11. PLAYERNO, TEAMNO, WON - LOST sorted by the the lost. // `won` minus `lost`, or relation

expected table:
playerno | team | `won` minus `lost`

table `matches`

select 
  playerno,
  teamno,
  sum(won) - sum(lost)
from matches
group by playerno, teamno
order by sum(won) - sum(lost);

----------------------------------------------------
12-19 EmpDept query
----------------------------------------------------

12. output of all employees from department 30 sorted by their salary starting with the highest salary.

select
  ename,
  sal
from emp
where deptno = 30
group by ename, sal
order by sal desc;

13. output of all employees sorted by job and within the job by their salary

select  
  ename,
  job, 
  sal
from emp
order by job, sal;

14. output of all employees sorted by their year of employment in descending order and within the year by their name

select
  ename,
  to_char(hiredate, 'yyyy') as "Year of employment"
from emp
order by to_char(hiredate, 'yyyy') desc, ename;

15. output of all salesmen in descending order regarding the ratio commission to salary

select
  ename,
  comm / sal
from emp
where job='SALESMAN'
order by (comm / sal) desc;

16. output the average salary to each department number

select
  deptno,
  round(avg(sal), 2)
from emp
group by deptno;

17. calculate the average annual salaries of those jobs that are performed by more than 2 employees

select
  avg(sal * 12),
  job
from emp
group by job
where job in  ( // 
  select 
    job
  from emp
  group by job
  having count(job) > 2;  
);

select
  avg(sal * 12),
  job
from emp
where job in  (
  select 
    job // only select one attribute, as you are only comparing to one attribute (comparing `job` with the `job` returned from this subselect)
  from emp
  group by job
  having count(job) > 2  
)
group by job; // order of SQL statements!

// jobs that are performed by more than 2 employees
select 
  job,
  count(job)
from emp
group by job
having count(job) > 2;



18. output all department numbers with at least 2 office workers

// which ones are office workers? 
// Assumption: clerk, manager, analyst, salesman - yes, president - no

select
  deptno,
  count(empno)
from emp
where 

19. find the average value for salary and commission of all employees from department 30


=====================================================

SQL Exercise 6

=====================================================

1-5 Tennis query
1. NAME, INITIALS and number of sets won for each player

2. NAME, PEN_DATE and AMOUNT sorted in descending order by AMOUNT

3. TEAMNO, NAME (of the captain) per team

4. NAME (player name), WON, LOST of all won matches

5. PLAYERNO, NAME and penalty amount for each team player. If a player has not yet received a penalty, it should still be issued. Sorting should be done in ascending order of penalty amount

----------------------------------------------------------
6-9 EmptDept query
----------------------------------------------------------

6. in which city does the employee Allen work?

7. search for all employees who earn more than their supervisor

8. output the number of hires in each year

9. output all employees who have a job like an employee from CHICAGO.


=====================================================

SQL Exercise 7

=====================================================

1-4 Tennis query
1. output of players' names who played for both team 1 and team 2.

2. output the NAME and INITIALS of the players who did not receive a penalty in 1980

3. output of players who received at least one penalty over $80

4. output of players who had all penalties over $80.

------------------------------------------------------
5-8 EmpDept query
------------------------------------------------------

5. find all employees whose salary is higher than the average salary of their department

6. identify all departments that have at least one employee

7. output of all departments that have at least one employee earning over $1000

8. output of all departments in which each employee earns at least 1000,-.


=====================================================
SQL Exercise 8
=====================================================

creating the PARTS table([Parts insert and create tables])
display the whole hierarchy of those parts that make up P3 and P9
at which hierarchy level is P12 used in P1
how many parts to P1 cost more than $20
output of all direct and indirect employees belonging to JONES (without JONES itself, with corresponding indentation per hierarchy)
output of all direct and indirect superiors of SMITH (including SMITH itself)
output of the average salary for each hierarchy level
SQL Exercise 6 using Joins
Solve exercise 6 using Joins.

=====================================================

SQL Exercise 7 using Joins

=====================================================

Solve exercise 7 using Joins.


=====================================================

Competence Check

=====================================================

Tables Create the following tables like shown in the [Class Diagram]

Class Diagram

Table description:

REGIONS contains rows that represent a region (for example, North, South America, Asia). COUNTRIES contains rows for countries. Each row is linked to a region. LOCATIONS contains the addresses of specific offices, warehouses and/or production sites of a company in a specific country. DEPARTMENTS displays department details where employees work. Each department can have a relationship that represents the head of department in the EMPLOYEES table. EMPLOYEES contains details of each employee working for a department. Not all employees must be assigned to a department. JOBS contains the types of positions that each employee can hold. JOB_HISTORY contains the individual positions that the employee has held so far. If an employee changes department or position within a department, a new row is added to this table with information about the employee's old position. JOB_GRADES identifies a salary range per pay grade level. The salary ranges do not overlap.

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

TODO
- [ ] SQL Exercise 3, 15: leap year: How to use if conditions in SQL to check leap year?
