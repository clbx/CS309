/* Practice 1.1 
Create a table vendor with the following information. */
CREATE TABLE v (
    V_CODE int PRIMARY KEY,
    V_NAME varchar(32),
    V_CONTACT varchar(32),
    V_AREACODE varchar(3),
    V_PHONE varchar(8),
    V_STATE varchar(2),
    V_ORDER varchar(1) 
)

INSERT INTO v(V_CODE, V_NAME, V_CONTACT,V_AREACODE,V_PHONE,V_STATE,V_ORDER)
VALUES(21225,"Bryson, Inc.","Smithson","615","223-3234","TN","Y"),
      (21226,"SuperLoo, Inc.","Flushing","904","215-8995","FL","N")

;

/* Practice 1.2
Create a database called Sale from the script sale_data.sql in my public folder.  */
CREATE DATABASE SALE
USE SALE
SOURCE /path/to/file/sale_data.sql
;

/* Practice 1.3
Find all the products provided by vendor 21344 */
SELECT * 
FROM PRODUCT
WHERE V_CODE = 21344
;

/* Practice 1.4
List all customers who live in 615 area */
SELECT *
FROM CUSTOMER
WHERE CUS_AREACODE = 615
;
/* Practice 1.5
List names, contacts and phones of vendors in Tennessee (TN) */
SELECT V_NAME, V_CONTACT, V_PHONE
FROM VENDOR
WHERE V_STATE = "TN"
;

/* Practice 1.6
List products’ descriptions, units available (QOH) and vendor codes that the prices are under $100. */
SELECT P_DESCRIPT, P_QOH, V_CODE,
FROM PRODUCT
WHERE P_PRICE < 100
;

/* Practice 1.6
Get the total product value from vendor 21225 */
SELECT
    Round(Sum(P_PRICE),2)
FROM PRODUCT
WHERE V_CODE = 21225
;

/* Practice 1.7
Assume the invoice which has been generated over 180 days cannot be used for return. Get a list of such invoices. */
SELECT
    *
FROM INVOICE
WHERE DATE_SUB(CURDATE(), INTERVAL 180 DAY) > INV_DATE
;




/* Practice 2.1 (Practice 1)
List vendors information (name, contact and phone) that are in the area ‘615’ 
and have previous order */
SELECT
    V_NAME,
    V_CONTACT,
    V_PHONE
FROM VENDOR
WHERE V_AREACODE = 615
AND V_ORDER = "Y"
;


/* Practice 2.2 (Practice 1)
List customers name (last name, first name and middle initial) who live in the area 
‘615’ or have zero balance */
SELECT
    CUS_LNAME,
    CUS_FNAME,
    CUS_INITIAL
FROM CUSTOMER
WHERE CUS_AREACODE = 615
OR CUS_BALANCE = 0
;

/* Practice 2.3 (Practice 1)
List products (all attributes) that either have excess inventory (units available (QOH) 
is at least 50 more than minimum units) or have discount and stocking date was before 01/01/2018. */
SELECT *
FROM PRODUCT
WHERE P_QOH > (P_MIN + 50)
OR (
    P_DISCOUNT > 0 
    AND P_INDATE < "2016-01-01"
   )
;

/* Practice 2.4 (Practice 2)
Find customer’s information whose last name beginning with ‘O’ */
SELECT *
FROM CUSTOMER
WHERE CUS_LNAME LIKE "O%"
;

/* Practice 2.5 (Practice 2)
List products that are related to saw */
SELECT *
FROM PRODUCT
WHERE P_DESCRIPT LIKE "%saw%"
;


/* Practice 2.6 (Practice 2)
Suppose that you want to find a vendor’s information, but you cannot remember 
that the contact’s name is spelled ‘Orton’ or ‘Orten’. How can you do it? */
SELECT *
FROM VENDOR
WHERE V_CONTACT LIKE "Ort%n"
;

/* Practice 2.7 (Practice 3)
Find customers who have generated invoices, list their last name, 
first name and middle initial */
SELECT
    CUS_LNAME,
    CUS_FNAME,
    CUS_INITIAL
FROM CUSTOMER
WHERE CUS_CODE IN (
    SELECT CUS_CODE 
    FROM INVOICE
    )
;

/* Practice 2.8 (Practice 4)
List the most recent invoices. */
SELECT *
FROM INVOICE
ORDER BY INV_DATE
;


/* Practice 2.9 (Practice 4)
Find the products (description, vendor code, stocking date, price) which were 
stocked before 2018-01-01 and have prices no more than $50.00. The contents 
should be listed first by vendor code in ascending, and then by price in descending 
within the vendor code. */
SELECT
    P_DESCRIPT,
    P_CODE,
    P_INDATE,
    P_PRICE
FROM PRODUCT
WHERE P_INDATE < "2018-01-01"
AND P_PRICE < 50
ORDER BY V_CODE, P_PRICE DESC
;


/* Practice 3.1 (Practice 5)
Which product has the oldest date? */

SELECT *
FROM PRODUCT
WHERE P_INDATE = (SELECT(Min(P_INDATE)) FROM PRODUCT)
;

/* Practice 3.2 (Practice 5)
What is the most recent product?  */
SELECT *
FROM PRODUCT
WHERE P_INDATE = (SELECT(Max(P_INDATE)) FROM PRODUCT)


/* Practice 3.3 (Practice 5)
What product has the highest inventory value? */
SELECT
    *
FROM PRODUCT
WHERE (P_QOH * P_PRICE) = (SELECT(Max(P_QOH*P_PRICE)) FROM PRODUCT)
;

/* Practice 3.4 (Practice 6)
 How many products in inventory are from vendor 24288? */
SELECT
    Count(*)
FROM PRODUCT
WHERE V_CODE = 24288
;
 /* Practice 3.5 (Practice 6)
 What is the average balance of customers who live in area ‘615’?  */
 SELECT
    Avg(CUS_BALANCE)
FROM CUSTOMER
WHERE CUS_AREACODE = 615;

 /* Practice 3.6 (Practice 6)
 Find the customers who live in area ‘615’ and have the balance lower than their local average. List customers by their balance in descending.
 */
SELECT *
FROM CUSTOMER
WHERE CUS_AREACODE = 615
AND CUS_BALANCE < (
        SELECT
            Avg(CUS_BALANCE)
        FROM CUSTOMER
        WHERE CUS_AREACODE = 615
    )
;


/* Practice 4.1 (Practice 7)
What is the average price of products from each vendor? */

SELECT
    V_CODE,
    Round(Avg(P_QOH * P_PRICE),2)
FROM PRODUCT
GROUP BY V_CODE
;

/* Practice 4.2 (Practice 7)
Find how many invoices each customer have? */
SELECT
    CUS_CODE,
    Count(INV_NUMBER)
FROM INVOICE
GROUP BY CUS_CODE
;

/* Practice 4.3 (Practice 7)
What is the total number of available quantity of products for each vendor? */
SELECT
    V_CODE,
    Sum(P_QOH)
FROM PRODUCT
GROUP BY V_CODE
;

/* Practice 4.4 (Practice 8)
Find the invoices which have total purchase amount over $100. Show 
the invoice number and its total purchase amount. List the contents  
by total purchase amount in ascending. */
SELECT
    INV_NUMBER,
    Round(INVOICE_TOTAL,2)
FROM (
        SELECT
            INV_NUMBER,
            Sum(LINE_PRICE * LINE_UNITS) AS INVOICE_TOTAL
        FROM LINE
        GROUP BY INV_NUMBER
    ) AS SUB
WHERE INVOICE_TOTAL > 100
;

/* Practice 4.5 (Practice 9)
List customers and the date they generated invoices. */
SELECT
    CUSTOMER.CUS_CODE,
    CUSTOMER.CUS_FNAME,
    CUSTOMER.CUS_LNAME,
    INVOICE.INV_DATE
FROM CUSTOMER, INVOICE
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
;



/* Practice 4.6 (Practice 9)
For the customers who live in area ‘615’, find out their information and 
the date they generated invoices. Show same attributes as the above query. 
List the records by their balance in descending. */
SELECT
    CUSTOMER.CUS_CODE,
    CUSTOMER.CUS_FNAME,
    CUSTOMER.CUS_LNAME,
    INVOICE.INV_DATE
FROM CUSTOMER, INVOICE
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
ORDER BY CUSTOMER.CUS_BALANCE;
;

/* Practice 4.7 (Practice 10) 
Find the customers who ordered “saw” after ‘2016-01-15’. List the customer last name, 
customer first name, invoice number, invoice date and product description. */
SELECT
    CUSTOMER.CUS_LNAME,
    CUSTOMER.CUS_FNAME,
    INVOICE.INV_NUMBER,
    INVOICE.INV_DATE,
    PRODUCT.P_DESCRIPT
FROM CUSTOMER, INVOICE, LINE, PRODUCT
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
AND INVOICE.INV_NUMBER = LINE.INV_NUMBER
AND LINE.P_CODE = PRODUCT.P_CODE
AND PRODUCT.P_DESCRIPT LIKE ("%saw%")
AND INVOICE.INV_DATE > "2016-01-15"
;

/* Practice 5.1 (Practice 11)
Find the customers who bought products that have price are over 100. */

SELECT DISTINCT
    CUSTOMER.CUS_LNAME,
    CUSTOMER.CUS_FNAME
FROM CUSTOMER, INVOICE, LINE, PRODUCT
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
AND INVOICE.INV_NUMBER = LINE.INV_NUMBER
AND LINE.P_CODE = PRODUCT.P_CODE
AND PRODUCT.P_PRICE > 100
;

/* Practice 5.2 (Practice 12)
List all vendors (V_CODE) who have more than 2 products. */
SELECT DISTINCT
    VENDOR.V_CODE
FROM VENDOR, PRODUCT
WHERE VENDOR.V_CODE = PRODUCT.V_CODE
GROUP BY VENDOR.V_CODE
HAVING (SELECT Count(PRODUCT.V_CODE) > 2 FROM PRODUCT)
;

/* Practice 5.3 (Practice 12)
For the vendors who have more than 2 products, list its code, name and 
products description order by vendor code in ascending. */
SELECT DISTINCT
    VENDOR.V_CODE,
    PRODUCT.P_DESCRIPT
FROM VENDOR, PRODUCT
WHERE VENDOR.V_CODE = PRODUCT.V_CODE
HAVING (SELECT Count(PRODUCT.V_CODE) > 2 FROM PRODUCT)
ORDER BY VENDOR.V_CODE
;

/* Practice 6.1 (Practice 1)
List the customer code, last name, invoice number, invoice date 
using natural join according to the order of customer code. */
SELECT
    CUSTOMER.CUS_CODE,
    CUSTOMER.CUS_LNAME,
    INVOICE.INV_NUMBER,
    INVOICE.INV_DATE
FROM CUSTOMER, INVOICE
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
ORDER BY CUSTOMER.CUS_CODE
;

/* Practice 6.3 (Practice 1)
List the invoice number, product code, product description, line units, 
line price using natural join. The line price should be greater than 50. */
SELECT
    INVOICE.INV_NUMBER,
    LINE.P_CODE,
    PRODUCT.P_DESCRIPT,
    LINE.LINE_UNITS,
    LINE.LINE_PRICE
FROM INVOICE, LINE, PRODUCT
WHERE INVOICE.INV_NUMBER = LINE.INV_NUMBER
AND LINE.P_CODE = PRODUCT.P_CODE
AND LINE.LINE_PRICE > 50
;

/* Practice 6.4 (Practice 2)
List  invoice number, the customer code, the customer last  and first name, 
the invoice date, and customer balance for all customers with a customer 
balance of $500 or more using join on. */
SELECT
    INVOICE.INV_NUMBER,
    CUSTOMER.CUS_CODE,
    CUSTOMER.CUS_LNAME,
    CUSTOMER.CUS_FNAME,
    INVOICE.INV_DATE,
    CUSTOMER.CUS_BALANCE
FROM CUSTOMER, INVOICE
WHERE CUSTOMER.CUS_CODE = INVOICE.CUS_CODE
AND CUSTOMER.CUS_BALANCE > 50
;

/* Practice 6.5 (Practice 4)
Write a query to get the product code, the total sales by product, 
and the contribution by employee of each product’s sales. */

SELECT
    
