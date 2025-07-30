# HotalManagement

A Java Servlet + JSP project for managing hotel room bookings.

## 📌 Features
- Add and manage hotel rooms
- User registration and login
- Room booking system
- PostgreSQL database integration

## 📂 Project Structure
src/main/java/
└── hotallogin/ → Handles login functionality
└── hotalroombooking/ → Manages room booking logic
└── hotalsignup/ → Handles signup functionality

src/main/webapp/
├── addhotalroombooking.jsp
├── hotalroombooking.jsp
├── userhotalroombookinglist.jsp
├── index.html
├── register.html
└── WEB-INF/lib/postgresql-42.7.3.jar



## 🛠️ Technologies Used
- Java Servlets & JSP
- PostgreSQL
- Apache Tomcat
- Eclipse IDE / STS

## 🚀 How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/MalaiMannan900/HotalManagement.git
   cd HotalManagement

   ## 🗄️ Database Schema (PostgreSQL)

### 🔹 Table: `register`
```sql
CREATE TABLE IF NOT EXISTS public.register
(
    id integer NOT NULL DEFAULT nextval('register_id_seq'::regclass),
    name character varying(100),
    mobileno character varying(1024),
    email character varying(1024),
    password character varying(1024),
    username character varying(100),
    CONSTRAINT register_pkey PRIMARY KEY (id)
);


## 🏨 Room Table Schema (PostgreSQL)

```sql
CREATE TABLE IF NOT EXISTS public.room
(
    roomno character varying(10) NOT NULL,
    type character varying(50),
    price numeric(10,2),
    status character varying(20),
    CONSTRAINT room_pkey PRIMARY KEY (roomno)
);

