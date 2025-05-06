-- Q1
INSERT INTO cd.facilities (
    facid,
    name,
    membercost,
    guestcost,
    initialoutlay,
    monthlymaintenance
)
VALUES (
           9,
           'Spa',
           20,
           30,
           100000,
           800
       );
-- Q2
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (
           (SELECT MAX(facid) + 1 FROM cd.facilities),
           'Spa',
           20,
           30,
           100000,
           800
       );

-- Q3
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

-- Q4
UPDATE cd.facilities
SET membercost = (
    SELECT membercost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1'
),
    guestcost = (
        SELECT guestcost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1'
    )
WHERE name = 'Tennis Court 2';


-- Q5
DELETE FROM cd.bookings;

-- Q6
DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (
    SELECT memid FROM cd.bookings
);

-- Q7
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < monthlymaintenance / 50;

-- Q8
SELECT *
FROM cd.facilities
WHERE name LIKE '%Tennis%';

-- Q9
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Q10
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate > '2012-09-01';

-- Q11
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities;

-- Q12
SELECT b.starttime
FROM cd.bookings b
         JOIN cd.members m ON b.memid = m.memid
WHERE m.firstname = 'David' AND m.surname = 'Farrell';

-- Q13
SELECT b.starttime, f.name
FROM cd.bookings b
         JOIN cd.facilities f ON b.facid = f.facid
WHERE f.name LIKE '%Tennis Court%'
  AND b.starttime::date = '2012-09-21'
ORDER BY b.starttime;

-- Q14
SELECT m.firstname, m.surname, r.firstname AS rec_firstname, r.surname AS rec_surname
FROM cd.members m
         LEFT JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY m.surname, m.firstname;

-- Q15
SELECT DISTINCT m.firstname, m.surname
FROM cd.members m
         JOIN cd.members r ON m.memid = r.recommendedby
ORDER BY m.surname, m.firstname;

-- Q16
SELECT DISTINCT
    firstname || ' ' || surname AS name,
    (SELECT firstname || ' ' || surname
     FROM cd.members r
     WHERE r.memid = m.recommendedby) AS recommender
FROM cd.members m
ORDER BY name;

-- Q17

-- Q18

-- Q19

-- Q20

-- Q21

-- Q22

-- Q23

-- Q24

-- Q25

-- Q26

-- Q27

-- Q28




