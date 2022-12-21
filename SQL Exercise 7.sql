------------------------------------------------------

SQL Exercise 7

------------------------------------------------------

1-4 Tennis query
1. output of players names who played for both team 1 and team 2.

-- Intersection using `where` keyword - works
select 
  name,
  initials
from players
where players.playerno in (
  select
    playerno
  from matches
  where teamno=1 and playerno in (
    select
      playerno
    from matches
    where teamno=2
  )  
);

-- Intersection using `intersect` keyword - works
select 
  name,
  initials
from players
where players.playerno in (
  select
    playerno
  from matches
  where teamno=1
  intersect
  select
    playerno
  from matches
  where teamno=2
);

-- Intersection using `where` keyword - works
select
  playerno
from matches
where teamno=1 and playerno in (
  select
    playerno
  from matches
  where teamno=2
);

-- Intersection using `intersect` keyword - works
select
  playerno
from matches
where teamno=1
intersect
select
  playerno
from matches
where teamno=2;


3. output of players who received at least one penalty over $80

select
  playerno
from penalties
where amount > 80
group by playerno;



4. output of players who had all penalties over $80.

-- using Oracle `minus` operator
select
  playerno 
from penalties
where amount > 80
minus
select
  playerno
from penalties
where amount < 80;

-- Using subselect
select
  playerno 
from penalties
where amount > 80 and
playerno not in (
  select
    playerno
  from penalties 
  where amount < 80
);

------------------------------------------------------
5-8 EmpDept query
------------------------------------------------------

5. find all employees whose salary is higher than the average salary of their department

-- Stop 1:
-- Get average salary per department, linked to each employee
select 
  ename,
  sal,
  deptno,
  (select  
    avg(sal)
  from emp
  where deptno = e1.deptno --alias, in order to know which deptno we are referring to currently
  group by deptno) as AVG
from emp e1;

-- Final code:
select 
  ename,
  -- sal and deptno are not required, but make table easier to understand
  sal,
  deptno
from emp e1
where sal > (
  select  
    avg(sal)
  from emp
  where deptno = e1.deptno --alias, in order to know which deptno we are referring to currently
  group by deptno
);


6. identify all departments that have at least one employee

-- works
select  
  deptno,
  count(empno)
from emp
group by deptno
having count(empno)>=1;

7. output of all departments that have at least one employee earning over $1000


select
  distinct deptno
from emp
where sal > 1000;
  


8. output of all departments in which each employee earns at least 1000,-.

select 
  dname, 
  min(sal)
from dept
join emp
on emp.deptno = dept.deptno
group by dname
having min(sal) >= 1000;

