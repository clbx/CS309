USE SALE

/* Practice 1.1 */
SELECT V_NAME FROM vendor WHERE V_AREACODE = 615 AND V_ORDER = "Y";
/* Practice 1.2 */
SELECT CUS_LNAME, CUS_FNAME, CUS_INITIAL FROM customer WHERE CUS_BALANCE = 0 AND CUS_AREACODE = 615;
/* Practice 1.3 */
SELECT * FROM product WHERE (P_QOH - 50) >= P_MIN OR P_DISCOUNT > 0 OR P_INDATE < "2018-1-1";


/* Practice 2.1 */
SELECT * FROM customer WHERE CUS_LNAME LIKE 'O%';
/* Practice 2.2 */
SELECT * FROM product WHERE P_DESCRIPT LIKE '%saw%';
/* Practice 2.3 */
SELECT * FROM vendor WHERE V_CONTACT LIKE 'Orton' OR 'Orten';

/* Practice 3 */
SELECT CUS_LNAME,CUS_FNAME,CUS_INITIAL FROM customer WHERE CUS_CODE IN (SELECT CUS_CODE FROM invoice);

/* Practice 4.1 */
SELECT * FROM invoice ORDER BY INV_DATE DESC;
/* Practice 4.2 */
SELECT P_DESCRIPT,P_CODE,P_INDATE,P_PRICE FROM product WHERE (P_INDATE < "2018-1-1") AND (P_PRICE < 50) ORDER BY V_CODE, P_PRICE DESC;

/* Practice 5.1 */
SELECT MIN(P_INDATE) FROM PRODUCT;  
/* Practice 5.2 */
SELECT MAX(P_INDATE) FROM PRODUCT;
/* Practice 5.3 */
SELECT p_descript, (p_qoh * p_price) as "Inventory Value" 
FROM product 
WHERE (p_qoh * p_price = (SELECT max(p_qoh * p_price) from product ));