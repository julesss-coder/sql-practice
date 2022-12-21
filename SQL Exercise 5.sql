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
where not job='PRESIDENT'
group by deptno
having count(empno) >= 2;


19. find the average value for salary and commission of all employees from department 30

select
  round(avg(sal + nvl(comm, 0)), 2) as "Average salary and commission dept. 30"
from emp
where deptno=30;
