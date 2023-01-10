------------------------------------------------------

SQL Exercise 7

------------------------------------------------------

1-4 Tennis query
1. output of players names who played for both team 1 and team 2.

-- using `intersect`
-- all playerno who played in team 1
-- all playerno who played in team 2
-- intersection of those playerno

-- Step 1: get playerno only - works
select 
  distinct playerno
from matches
where teamno = 1
intersect
select 
  distinct playerno
from matches
where teamno = 2;


-- Step 2: Get name of the player(s) returned - works
select  
  playerno,
  name,
  initials
from players 
where players.playerno in (
  select 
    distinct playerno
  from matches
  where teamno = 1
  intersect
  select 
    distinct playerno
  from matches
  where teamno = 2
);

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

-- Join
-- Can this be solved using only join, without where or intersect keywords?
select
  distinct matches.playerno
from matches
join players on players.playerno = matches.playerno
where teamno = 1 and 
matches.playerno in (
  select 
    playerno 
  from matches
  where teamno = 2
);



3. output of players who received at least one penalty over $80

select 
  distinct playerno, 
  amount 
from penalties
where amount > 80;

-- Using join to return player names instead of numbers
select 
  name, 
  initials, 
  amount 
from penalties
join players on penalties.playerno = players.playerno
where amount > 80;


4. output of players who had all penalties over $80.

-- Using all operator and join
select 
  p1.playerno, 
  amount 
from penalties p1
join players on players.playerno = p1.playerno
where 80 < all (
  select  
  amount
  from penalties p2
  where p1.playerno = p2.playerno
);


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

-- join ? 


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
  deptno--,
  -- count(empno)
from emp
group by deptno
having count(empno)>=1;


7. output of all departments that have at least one employee earning over $1000

select
  distinct deptno
from emp
where sal > 1000;
  

8. output of all departments in which each employee earns at least 1000,-.

-- outputting deptno only
select
  deptno,
  count(empno)
from emp
group by deptno
having (min(sal) > 1000);


-- outputting dname, using join
select
  dname--,
  --count(emp.empno)
from emp
join dept on emp.deptno = dept.deptno
group by dname
having (min(sal) > 1000);




