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

## Practice SQL Queries

### Modifying Data

Question 1: Add a new facility - a spa - into the facilities table:
```sql
-- solution:
INSERT INTO cd.facilities (...) VALUES (...);
-- test: check DBeaver output
SELECT * FROM cd.facilities WHERE name = 'Spa';
```
Question 2:

```sql
SELECT *
FROM cd.members
```
Question 3:

```sql
SELECT *
FROM cd.members
```
Question 4:

```sql
SELECT *
FROM cd.members
```
Question 5:

```sql
SELECT *
FROM cd.members
```
Question 6:

```sql
SELECT *
FROM cd.members
```
### Basics
Question 1:
```sql
SELECT *
FROM cd.members
```
### Join
Question 1:
```sql
SELECT *
FROM cd.members
```
### Aggregation
Question 1:
```sql
SELECT *
FROM cd.members
```
### String
Question 1:
```sql
SELECT *
FROM cd.members
```