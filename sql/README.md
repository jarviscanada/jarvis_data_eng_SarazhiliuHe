# SQL Query Practice
This project is built for SQL learning and SQL queries practice.

## Table Setup (DDL)

The database is designed for a country club, with a set of members,
facilities, and booking history for the facilities. 

### 1. members table

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
### 2. facilities table

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
### 3. bookings table

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
## Practice SQL Queries

###### Question 1: Show all members

```sql
SELECT *
FROM cd.members
```

###### Question 2: