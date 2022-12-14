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

select 
    playerno,
    name,
    year_of_birth
from players
where mod(year_of_birth, 4)=0 and
mod(year_of_birth, 100)=0 and
mod(year_of_birth, 400)=0;

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