/*
Creating tables
The following code creates the Employees table in the dbo schema, which in turn is located inside the TSQL2012 database.
*/

CREATE DATABASE TSQL2012;

USE TSQL2012;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
  DROP TABLE dbo.Employees;
CREATE TABLE dbo.Employees
(
  empid     INT NOT     NULL,
  firstname VARCHAR(30) NOT NULL,
  lastname  VARCHAR(30) NOT NULL,
  hiredate  DATE        NOT NULL,
  mgrid     INT         NULL,
  ssn       VARCHAR(20) NOT NULL,
  salary    MONEY       NOT NULL
);

/* 
Primary Key Constraints
A primary key constraint (PRIMARY KEY) ensures the uniqueness of rows and prohibits storing NULL values in the corresponding columns. Each unique set of values in the attributes that make up the constraint can appear in the table only once — in no more than one row. The DBMS prevents any attempt to define primary key constraints for columns that are capable of containing NULL values.
In the example presented below, this constraint is defined for the attribute empid from the Employees table.
*/

ALTER TABLE dbo.Employees
  ADD CONSTRAINT PK_Employees
  PRIMARY KEY(empid);
/* 
  UNIQUE Constraint  
A UNIQUE constraint ensures the uniqueness of rows and implements the relational model concept of alternate keys. Unlike primary keys, a single table can contain multiple UNIQUE constraints. Moreover, uniqueness applies to all columns, including those that may contain NULL values. According to the SQL specification, columns with a UNIQUE constraint support different NULL markers (as if they are distinct). However, the T‑SQL language implemented in SQL Server prohibits duplicating these markers (any two NULL values cannot be considered equal).

The following code defines a UNIQUE constraint for the ssn column in the Employees table.
*/

ALTER TABLE dbo.Employees
  ADD CONSTRAINT UNQ_Employees_ssn
  UNIQUE(ssn);
  
/*
  Foreign Key Constraints  
A foreign key is responsible for referential integrity. This constraint is defined for one or more attributes in the so‑called referencing table and points to the attributes of a potential key (PRIMARY KEY or UNIQUE constraint) in the referenced table (also called the parent table). It is worth noting that this can even be the same table. A foreign key ensures that its attributes can only take values that exist in the referenced columns.

The following code creates a table called Orders. It contains the column orderid with a primary key.
*/

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
  DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders
(
  orderid INT         NOT NULL,
  empid   INT         NOT NULL,
  custid  VARCHAR(10) NOT NULL,
  orderts DATETIME2   NOT NULL,
  qty     INT         NOT NULL,
  CONSTRAINT PK_Orders
    PRIMARY KEY(orderid)
);

/*Foreign Key Constraint Example  
Suppose you want to introduce a constraint according to which the empid column of the Orders table must support only those values that exist in the empid column of the Employees table. To achieve this, you need to define a foreign key constraint for the empid column of the Orders table, which will reference the column of the same name in the Employees table. The example below shows how this can be done.
*/

ALTER TABLE dbo.Orders
  ADD CONSTRAINT FK_Orders_Employees
  FOREIGN KEY(empid)
  REFERENCES dbo.Employees(empid);

  /* Referencing a Column in the Same Table  
In a similar way, you can reference a column within the same table. Using the following code, we restrict the contents of the mgrid column to values that are stored in the empid column (all within the Employees table).*/

ALTER TABLE dbo.Employees
  ADD CONSTRAINT FK_Employees_Employees
  FOREIGN KEY(mgrid)
  REFERENCES dbo.Employees(empid);

  /*
  CHECK Constraint  
A CHECK constraint allows you to define a predicate stating that before a row is modified or added to the table, it must pass a validation test. Thanks to the following constraint, the salary column in the Employees table supports only positive values.
  */

  ALTER TABLE dbo.Employees
  ADD CONSTRAINT CHK_Employees_salary
  CHECK(salary > 0.00);

  /*
  DEFAULT Constraint  
A DEFAULT constraint is associated with a specific attribute. The expression is used as the default value for empty attributes of a row being added to the table. In the following example, the DEFAULT constraint is defined for the orders column (it stores the time the order was created).
  */

  ALTER TABLE dbo.Orders
  ADD CONSTRAINT DFT_Orders_orderts
  DEFAULT(SYSDATETIME()) FOR orderts;

  /*
  At the end, run the code provided to clear the database
  */

  DROP TABLE dbo.Orders, dbo.Employees;