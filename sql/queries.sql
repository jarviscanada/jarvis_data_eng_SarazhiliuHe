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
SELECT m.memid, COUNT(r.memid) AS count
FROM cd.members m
    JOIN cd.members r ON m.memid = r.recommendedby
GROUP BY m.memid
ORDER BY m.memid;


-- Q18
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

-- Q19
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY total_slots;

-- Q20
SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

-- Q21
SELECT COUNT(DISTINCT memid)
FROM cd.bookings;

-- Q22
SELECT m.surname, m.firstname, m.memid, MIN(b.starttime) AS first_booking
FROM cd.members m
         JOIN cd.bookings b ON m.memid = b.memid
WHERE b.starttime > '2012-09-01'
GROUP BY m.memid, m.firstname, m.surname
ORDER BY m.memid;

-- Q23
SELECT firstname, surname,
       (SELECT COUNT(*) FROM cd.members) AS total_members
FROM cd.members
ORDER BY joindate;

-- Q24
SELECT ROW_NUMBER() OVER (ORDER BY joindate) AS row_number,
        firstname, surname, memid
FROM cd.members;

-- Q25
SELECT facid, total_slots
FROM (
         SELECT facid, SUM(slots) AS total_slots,
                RANK() OVER (ORDER BY SUM(slots) DESC) AS rank
         FROM cd.bookings
         GROUP BY facid
     ) AS ranked
WHERE rank = 1;


-- Q26
SELECT surname || ', ' || firstname AS name
FROM cd.members;

-- Q27
-- use LIKE
SELECT memid, telephone
FROM cd.members
WHERE telephone LIKE '%(%'
   OR telephone LIKE '%)%'
ORDER BY memid;
-- use ~ and regex
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]'
ORDER BY memid;

-- Q28
SELECT SUBSTRING(surname, 1, 1) AS first_letter, COUNT(*) AS count
FROM cd.members
GROUP BY first_letter
ORDER BY first_letter;




