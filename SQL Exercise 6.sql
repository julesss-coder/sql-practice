=====================================================

SQL Exercise 6

=====================================================

1-5 Tennis query
1. NAME, INITIALS and number of sets won for each player

-- join
select
  name,
  initials, 
  sum(won)
from matches
join players
on matches.playerno = players.playerno
group by name, initials;

-- multitable select
select
  name,
  initials, 
  sum(won)
from matches, players
where matches.playerno = players.playerno
group by name, initials;

-- subselect
select playerno, name, initials, (select sum(won) from matches group by playerno having playerno = p.playerno) from players p;

-- subselect (either in select statement, where clause, etc. must only return ONE value)

2. NAME, PEN_DATE and AMOUNT sorted in descending order by AMOUNT

-- multitable select
select
  name,
  pen_date,
  amount
from players, penalties
where players.playerno = penalties.playerno
order by amount desc;

-- subquery - works!!!
-- outer select statement references table from which we need the most data
select 
  -- inner select statement gets additional needed data from other table,
  -- specifiying on which column these tables overlap
  (
    select 
      name 
    from players 
    where players.playerno = penalties.playerno -- you can compare inner to outer table here, because outer table is referenced below
  ),
  playerno,
  pen_date,
  amount
from penalties
order by amount desc;

-- join
select 
  name,
  pen_date,
  amount
from penalties
join players
on penalties.playerno = players.playerno
order by amount desc;


3. TEAMNO, NAME (of the captain) per team

-- subquery
select
  (
    select
      name 
    from players
    where players.playerno = teams.playerno
  )
  teamno
from teams;

-- join
select
  teamno,
  name
from teams
join players
on teams.playerno = players.playerno;

-- multi-table select
select
  teamno,
  name
from teams, players
where teams.playerno = players.playerno;


4. NAME (player name), WON, LOST of all won matches

// won matches: more `won` points than `lost`
-- join
select
  name,
  sum(won),
  sum(lost)
from matches
join players
on matches.playerno = players.playerno
where won > lost
group by name;

-- subquery
-- Cannot select by name via alias, nor via subquery
select
  playerno,
  (
    select
      name 
    from players
    where players.playerno = matches.playerno
  ) as "name",
  sum(won),
  sum(lost)
from matches
where won > lost
group by playerno;


5. PLAYERNO, NAME and penalty amount for each team player. If a player has not yet received a penalty, it should still be issued. Sorting should be done in ascending order of penalty amount

-- subquery
select 
  playerno,
  (
    select 
      sum(amount)
    from penalties
    where players.playerno = penalties.playerno -- damit nur ein Wert zurueckgegeben wird
    group by playerno
  ) as "amount"
from players;

-- join
select
  players.playerno,
  name,
  amount
from penalties
right join players
on penalties.playerno = players.playerno 
order by amount;

-- left table `players`, using left join makes more sense
select
  players.playerno,
  name,
  amount
from players
left join penalties
on penalties.playerno = players.playerno 
order by amount;
----------------------------------------------------------
6-9 EmptDept query
----------------------------------------------------------

6. in which city does the employee Allen work?

-- join
select
  emp.ename,
  dept.loc
from dept
join emp
on dept.deptno = emp.deptno
where emp.ename='ALLEN'; -- Use single quotes, it doesnt work with double quotes

-- subquery
select 
  loc
from dept
where deptno = (
  select deptno from emp
  where ename = 'ALLEN'
);


7. search for all employees who earn more than their supervisor

-- subquery
select
  A.ename as "employee name", 
  B.ename as "Manager name"
from emp A, emp B
where A.ename <> B.ename
and A.mgr = B.empno
and A.sal > B.sal;

-- subquery, different option
select  
  ename
from emp employees
where employees.sal > (
  select
    sal 
  from emp supervisors
  where employees.mgr = supervisors.empno
);

-- self-join
select
  employees.ename
from emp employees
join emp supervisors
on employees.mgr = supervisors.empno
where employees.sal > supervisors.sal;

8. output the number of hires in each year

select
  to_char(hiredate, 'yyyy')  as "Hire date",
  count(to_char(hiredate, 'yyyy')) as "Number of hires / year"
from emp
group by to_char(hiredate, 'yyyy');


9. output all employees who have a job like an employee from CHICAGO.
-----------------
-- subqueries
select
  ename
from emp
where job in (
  select 
    job
  from emp
  where deptno = (
    select deptno from dept
    where loc = 'CHICAGO'
  )
);

-- double join
-- seems to work
select
  distinct ename
from emp e1
join (
  -- jobs like employees in Chicago
  select 
    job
  from emp
  join dept 
  on emp.deptno = dept.deptno
  where loc = 'CHICAGO'
) e2
on e1.job = e2.job;

----
-- Step 1: Menge 1: Welche Jobs haben die Leute, die in Chicago arbeiten (in Department 30)?
--         -> Salesman, clerk, manager

select
  distinct job,
  emp.deptno,
  loc
from emp
join dept
on dept.deptno = emp.deptno
where loc='CHICAGO'
group by job, emp.deptno, loc;

------------------
-- Step 2: Menge 2: Alle Angestellten, die als salesman, clerk oder manager arbeiten und nicht in Chicago arbeiten
------------------
-- works
select
  ename,
  job,
  emp.deptno,
  dept.loc
from emp
join dept
on dept.deptno = emp.deptno
where job in (
  select
    distinct job
  from emp
  -- Muss ich hier wieder `JOIN` durchfuehren?
  join dept
  on dept.deptno = emp.deptno
  where dept.loc='CHICAGO' 
) and dept.loc<>'CHICAGO';

-- Alternative: `minus` Menge der Jobs, die in Chicago sind?

--- Great article on subqueries: https://learnsql.com/blog/sql-subquery-examples/ 

---
-- get exercise 6, 9 checcked; look up joining custom tables
