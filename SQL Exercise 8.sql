=====================================================
SQL Exercise 8
=====================================================

creating the PARTS table([Parts insert and create tables])
display the whole hierarchy of those parts that make up P3 and P9
-- no recursion

select super, sub 
from parts
start with super is null
connect by prior sub =  super;

-- Get whole table
select super, sub
from parts
start with super is null
connect by prior sub = super;

-- Traverse tree upward from super
select super, sub
from parts
start with super is null
connect by sub = prior super;

-- display the whole hierarchy of those parts that make up P3 and P9
select lpad(sub, length(sub)+ level * 10 - 10, '-') tree
from parts
start with super is null
connect by prior sub = super
and sub != 'P2' and sub != 'P4';


-- at which hierarchy level is P12 used in P1

-- Counting the number of levels from P12 to P1 (both inclusive)
select count(level)
from parts
start with sub='P12'
connect by prior super = sub;

-- Showing the hierarchy from P12 to P1 in a table
select level, super, sub
from parts
start with sub='P12'
connect by prior super = sub;

-- how many parts to P1 cost more than $20
-- a) List all parts with prices abouve 20
select level, super, sub, price
from parts
where price > 20
start with super is null
connect by prior sub = super;

-- b) Count number of parts with price > 20
select count(price) as "Parts over 20$"
from parts
where price > 20
start with super is null
connect by prior sub = super;


-----------------------------------------------------------------------------------------
-- output of all direct and indirect employees belonging to JONES (without JONES itself, with corresponding indentation per hierarchy) (from `emp` table)
-----------------------------------------------------------------------------------------

------------ tree of all employees, querying by empno 7566 instead of ename Jones ------------
select lpad(empno, length(empno)+ level * 10 - 10, '-') tree
from emp
start with mgr=7566
-- "The condition CONNECT BY PRIOR child_entity= parent_entity, will cause the child entity values to become parent till the whole branch is traversed." 
-- from URL: https://towardsdatascience.com/understanding-hierarchies-in-oracle-43f85561f3d9 
-- `connect by prior empno = mgr` means that the employee number becomes the manager number until the whole tree is traversed.
connect by prior empno = mgr;

/* Ausgabe - stimmt:
7788
----------7876
7902
----------7369
*/


------------ tree of all employees, querying by ename Jones (without JONES himself)?-----------
-- Ist eine Ausgabe moeglich, bei der ich sehe, wer wessen Mgr ist? Oder sehe ich das an der Reihenfolge der Ausgabe, da depth-first search verwendet wird?
-- Antwort: An der Reihenfolge.

-- Antwort mit JONES
select lpad(ename, length(ename)+ level * 10 - 10, '-') tree
from emp e
start with ename='JONES'
connect by prior ename=(
  -- suche name wo nummer gleich mgr
  -- search for ename where mgr === Jones' empno
  select ename from emp e2
  where e2.empno=e.mgr
);


--===============================
-- Antwort ohne JONES: funktioniert!
-- Loesung: `start with ename in (select statement)` - inspiriert von URL: https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:9538760300346411614
select lpad(ename, length(ename) + level * 10 - 10, '-') tree
from emp e1
-- start where employee number of Jones is manager number
start with ename in (
  select ename from emp e3 
  where mgr = (
    select empno from emp e4 where ename='JONES'
  )
)
-- "The condition CONNECT BY PRIOR child_entity= parent_entity, will cause the child entity values to become parent till the whole branch is traversed." 
-- from URL: https://towardsdatascience.com/understanding-hierarchies-in-oracle-43f85561f3d9 
-- `e2.empno = e1.mgr` means that number of ename JONES will become number of manager until the whole tree is traversed.
connect by prior ename=(
    select ename from emp e2
    where e2.empno = e1.mgr
);


--===========================
-- Alternative Antwort ohne Jones: Ich habe den Namen Jones herausgekuerzt, indem ich Anzeige abgekuerzt habe, aber ich glaube, diese Loesung ist nicht gemeint
select lpad(ename, length(ename)+ level * 10 - 20, '-') tree
from emp e
start with ename='JONES'
connect by prior ename=(
  -- suche name wo nummer gleich mgr
  -- search for ename where mgr === Jones' empno
  select ename from emp e2
  where e2.empno=e.mgr
);
--===============================

-- output of all direct and indirect superiors of SMITH (including SMITH itself)

-- Using empno - works
select level, empno
from emp
-- Start with Smith's empno
start with empno=7369
-- In next step, manager becomes employee (to another manager)
connect by prior mgr=empno;

---- Using ename - works--------------
select ename
from emp
-- Start with Smith's empno
start with ename='SMITH'
-- In next step, manager becomes employee (to another manager)
connect by prior mgr=empno;
-- FRAGE: Warum funktioniert das? Wieso wird `mgr` automatisch auf `mgr` von SMITH bezogen? Wieso geht das so einfach??
-------------------

-- As a tree - works--------------
select lpad(ename, length(ename)+ level * 10 - 10, '-') tree
from emp
-- Start with Smith's empno
start with ename='SMITH'
-- In next step, manager becomes employee (to another manager)
connect by prior mgr=empno;
------------------------------------

-- output of the average salary for each hierarchy level

  -- works, checked avg. salaries - correct
select 
  level, 
  round(avg(sal), 2) as "Avg. salary per level"
from emp e1
start with empno=7839
connect by prior empno=mgr
group by level;



SQL Exercise 6 using Joins
Solve exercise 6 using Joins.

=====================================================

SQL Exercise 7 using Joins

=====================================================

Solve exercise 7 using Joins.

