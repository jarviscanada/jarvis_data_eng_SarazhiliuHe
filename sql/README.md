# SQL Query Practice
This project is built for SQL learning and SQL queries practice.

## Table Setup (DDL)

The database is designed for a country club, with a set of members,
facilities, and booking history for the facilities. 

##### 1. members table

Each member has an ID, basic address information, a reference to the member that recommended them (if any), 
and a timestamp for when they joined.

```sql
CREATE TABLE members (
    memid integer NOT NULL,
    surname character varying(200) NOT NULL,
    firstname character varying(200) NOT NULL,
    address character varying(300) NOT NULL,
    zipcode integer NOT NULL,
    telephone character varying(20) NOT NULL,
    recommendedby integer,
    joindate timestamp NOT NULL,
    CONSTRAINT members_pk PRIMARY KEY (memid),
    CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
                     REFERENCES members(memid) ON DELETE SET NULL
);
```
##### 2. facilities table

This table lists all the bookable facilities that the country club possesses. 
The club stores id and name information, the cost to book for both members and guests, 
the initial cost to build the facility, and estimated monthly upkeep costs.

```sql
    CREATE TABLE facilities
    (
       facid integer NOT NULL, 
       name character varying(100) NOT NULL, 
       membercost numeric NOT NULL, 
       guestcost numeric NOT NULL, 
       initialoutlay numeric NOT NULL, 
       monthlymaintenance numeric NOT NULL, 
       CONSTRAINT facilities_pk PRIMARY KEY (facid)
    );
```
##### 3. bookings table

This table tracks bookings of facilities. 
It stores the facility id, the member who made the booking, the start of the booking, 
and how many half-hour 'slots' the booking was made for.

```sql
    CREATE TABLE bookings
    (
       bookid integer NOT NULL, 
       facid integer NOT NULL, 
       memid integer NOT NULL, 
       starttime timestamp NOT NULL,
       slots integer NOT NULL,
       CONSTRAINT bookings_pk PRIMARY KEY (bookid),
       CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES facilities(facid),
       CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES members(memid)
    );
```

##### 4. Implementation
- Start a PostgreSQL instance using docker.
```bash
./linux_sql/scripts/psql_docker.sh start
```

- Use `clubdata.sql` file to initialize a database `exercises` - create tables,
load sample data and set index.
```bash
# 1. copy clubdata.sql into the Docker container jrvs-psql
docker cp ./clubdata.sql jrvs-psql:/tmp/clubdata.sql

# 2. execute the psql CLI inside the Docker container
docker exec -it jrvs-psql psql -U postgres

# 3. psql internal command: import and execute clubdata.sql
\i /tmp/clubdata.sql

```

## SQL Queries Practice

### Modifying Data

Question 1:
Insert some data into a table:
Add a new facility - a spa - into the facilities table:
```sql
-- solution:
INSERT INTO cd.facilities (...) VALUES (...);
-- test: check DBeaver output
SELECT * FROM cd.facilities WHERE name = 'Spa';
```
Question 2:
Insert calculated data into a table:
Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant.

```sql
INSERT INTO cd.facilities (...)
VALUES (
               (SELECT MAX(facid) + 1 FROM cd.facilities),
                ...
       );
```

Question 3:
Update some existing data:
We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000.
```sql
UPDATE <table>
SET <column> = <value>
WHERE <condition>;

```
Question 4:
Update a row based on the contents of another row.

```sql
UPDATE <table>
SET <column> = (
    SELECT <column> * factor FROM <table> WHERE <condition>
    )
WHERE <condition>;
```
Question 5:
Delete all bookings: As part of a clearout of our database, we want to delete all bookings from the cd.bookings table.

```sql
DELETE FROM <table>;

```
Question 6:
Delete a member from the cd.members table:
We want to remove member 37, who has never made a booking, from our database.
```sql
DELETE FROM <table>
WHERE <condition>
  AND <id_column> NOT IN (
    SELECT <id_column> FROM <related_table>
    );

```
### Basics
Question 7:
Control which rows are retrieved:
produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities.
```sql
SELECT <columns>
FROM <table>
WHERE <condition1>
  AND <condition2>;

```
Question 8:
Basic string searches
How can you produce a list of all facilities with the word 'Tennis' in their name?
```sql
SELECT <columns>
FROM <table>
WHERE <column> LIKE '%word%';
```
Question 9:
Matching against multiple possible values
How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
```sql
SELECT <columns>
FROM <table>
WHERE <column> IN (<value1>, <value2>);

```

Question 10:
Working with dates
How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.
```sql
SELECT <columns>
FROM <table>
WHERE <date_column> > '<YYYY-MM-DD>';

```

Question 11:
Combining results from multiple queries: a combined list of all surnames and all facility names.
```sql
SELECT <column> FROM <table1>
UNION
SELECT <column> FROM <table2>;

```
### Join
Question 12:
Retrieve the start times of members' bookings
How can you produce a list of the start times for bookings by members named 'David Farrell'?
```sql
SELECT <column>
FROM <table1>
    JOIN <table2> ON <join_condition>
WHERE <condition>;

```
Question 13:
Work out the start times of bookings for tennis courts
How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
```sql
SELECT <columns>
FROM <table1>
JOIN <table2> ON <join_condition>
WHERE <column> LIKE '%keyword%'
  AND <date_column>::date = '<YYYY-MM-DD>'
ORDER BY <date_column>;

```
Question 14:
Produce a list of all members, along with their recommender
How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
```sql
SELECT <columns>
FROM <table1> AS a
LEFT JOIN <table1> AS b ON a.<ref_column> = b.<id_column>
ORDER BY a.<sort_column1>, a.<sort_column2>;

```
Question 15:
Produce a list of all members who have recommended another member (JOIN = INNER JOIN)
How can you output a list of all members who have recommended another member? 
Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
```sql
SELECT DISTINCT <columns>
FROM <table1>
JOIN <table2> ON <table1.id> = <table2.ref_column>
ORDER BY <sort_column1>, <sort_column2>;

```
Question 16:
Produce a list of all members, along with their recommender, using no joins
How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
```sql
SELECT DISTINCT firstname || ' ' || surname AS name,
       (SELECT firstname || ' ' || surname
        FROM cd.members r
        WHERE r.memid = m.recommendedby) AS recommender
FROM cd.members m
ORDER BY name;

```

### Aggregation
Question 17:
Count the number of recommendations each member makes
Produce a count of the number of recommendations each member has made. Order by member ID.
```sql
SELECT <member_id>, COUNT(*) AS <count_alias>
FROM <table>
    JOIN <table> ON <join_condition>
GROUP BY <member_id>
ORDER BY <member_id>;

```
Question 18:
List the total slots booked per facility
Produce a list of the total number of slots booked per facility.
```sql
SELECT <group_column>, SUM(<column>) AS <alias>
FROM <table>
GROUP BY <group_column>
ORDER BY <group_column>;

```
Question 19:
List the total slots booked per facility in a given month
Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
```sql
SELECT <group_column>, SUM(<column>) AS <alias>
FROM <table>
WHERE <date_column> BETWEEN '<start_date>' AND '<end_date>'
GROUP BY <group_column>
ORDER BY <alias>;

```

Question 20:
List the total slots booked per facility per month
Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
```sql
-- EXTRACT function
SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

```
Question 21:
Find the count of members who have made at least one booking
Find the total number of members (including guests) who have made at least one booking.
```sql
SELECT COUNT(DISTINCT <member_id>)
FROM <table>;

```
Question 22:
List each member's first booking after September 1st 2012
Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
```sql
SELECT <name_columns>, <member_id>, MIN(<date_column>) AS <alias>
FROM <table1>
JOIN <table2> ON <join_condition>
WHERE <date_column> > '<YYYY-MM-DD>'
GROUP BY <member_id>, <name_columns>
ORDER BY <member_id>;

```
Question 23:
Produce a list of member names, with each row containing the total member count. Order by join date, and include guest members.
```sql
SELECT <name_columns>, <subquery_or_window> AS total_members
FROM <table>
ORDER BY <date_column>;

```
Question 24:
Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
```sql
SELECT ROW_NUMBER() OVER (ORDER BY <date_column>) AS row_number, <columns>
FROM <table>;

```
Question 25:
Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.
```sql
SELECT <group_column>, total_slots
FROM (
    SELECT <group_column>, SUM(<column>) AS total_slots,
    RANK() OVER (ORDER BY SUM(<column>) DESC) AS rank
    FROM <table>
    GROUP BY <group_column>
    ) AS ranked
WHERE rank = 1;

```

### String

Question 26:
Format the names of members
Output the names of all members, formatted as 'Surname, Firstname'.
```sql
SELECT <column1> || ', ' || <column2> AS <alias>
FROM <table>;

```
Question 27:
Find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.
```sql
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


```
Question 28:
Count the number of members whose surname starts with each letter of the alphabet
```sql
SELECT SUBSTRING(surname, 1, 1) AS first_letter, COUNT(*) AS count
FROM cd.members
GROUP BY first_letter
ORDER BY first_letter;

```

