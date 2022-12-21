=====================================================

SQL Exercise 6

=====================================================

1-5 Tennis query
1. NAME, INITIALS and number of sets won for each player

select
  name,
  initials, 
  sum(won)
from matches
join players
on matches.playerno = players.playerno
group by name, initials;

2. NAME, PEN_DATE and AMOUNT sorted in descending order by AMOUNT

select 
  name,
  pen_date,
  amount
from penalties
join players
on penalties.playerno = players.playerno
order by amount desc;


3. TEAMNO, NAME (of the captain) per team

select
  teamno,
  name
from teams
join players
on teams.playerno = players.playerno;


4. NAME (player name), WON, LOST of all won matches

// won matches: more `won` points than `lost`

select
  name,
  sum(won),
  sum(lost)
from matches
join players
on matches.playerno = players.playerno
where won > lost
group by name;

5. PLAYERNO, NAME and penalty amount for each team player. If a player has not yet received a penalty, it should still be issued. Sorting should be done in ascending order of penalty amount

select
  players.playerno,
  name,
  amount
from penalties
full join players
on penalties.playerno = players.playerno 
order by amount;

----------------------------------------------------------
6-9 EmptDept query
----------------------------------------------------------

6. in which city does the employee Allen work?

select
  emp.ename,
  dept.loc
from dept
join emp
on dept.deptno = emp.deptno
where emp.ename='ALLEN'; // Use single quotes, it doesnt work with double quotes


7. search for all employees who earn more than their supervisor

select
  A.ename as "employee name", B.ename as "Manager name"
  from emp A, emp B
  where A.ename <> B.ename
  and A.mgr = B.empno
  and A.sal > B.sal;

8. output the number of hires in each year

select
  to_char(hiredate, 'yyyy')  as "Hire date",
  count(to_char(hiredate, 'yyyy')) as "Number of hires / year"
from emp
group by to_char(hiredate, 'yyyy');


9. output all employees who have a job like an employee from CHICAGO.
-----------------
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
