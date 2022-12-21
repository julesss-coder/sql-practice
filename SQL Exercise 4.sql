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
