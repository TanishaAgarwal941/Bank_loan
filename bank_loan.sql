create database bank_loan;
use bank_loan;

show tables;
select * from bank_loan_data;



#query 1

select count(id) as total_loan_applications from bank_loan_data;

select count(id) as mtd_total_loan_applications from bank_loan_data
where month(issue_date)=12 ;

select count(id) as pmtd_total_loan_applications from bank_loan_data
where month(issue_date)=11;

SELECT 
    ROUND( 
        ( 
            (SELECT COUNT(id) FROM bank_loan_data 
             WHERE MONTH(issue_date) = 12) 
            - 
            (SELECT COUNT(id) FROM bank_loan_data 
             WHERE MONTH(issue_date) = 11)
        ) 
        / (SELECT COUNT(id) FROM bank_loan_data 
           WHERE MONTH(issue_date) = 11) * 100, 1
    ) 
    AS Month_over_month;



#query 2

select sum(loan_amount) as total_funded_amount from bank_loan_data;

select sum(loan_amount) as mtd_total_funded_amount from bank_loan_data
where month(issue_date) = (select max(month(issue_date)) from bank_loan_data);

select sum(loan_amount) as pmtd_total_funded_amount from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data);

SELECT 
    ROUND(
        (
            (SELECT SUM(loan_amount) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM bank_loan_data))
            - 
            (SELECT SUM(loan_amount) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) - 1 FROM bank_loan_data)))
           / 
        (SELECT SUM(loan_amount) 
         FROM bank_loan_data 
         WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) - 1 FROM bank_loan_data))
        * 100, 1
    ) AS Month_over_month;





#query 3
select sum(total_payment) as total_amount_received from bank_loan_data;

select sum(total_payment) as mtd_total_amount_received from bank_loan_data
where month(issue_date) = (select max(month(issue_date)) from bank_loan_data);

select sum(total_payment) as pmtd_total_amount_received  from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data);

SELECT 
    ROUND(
        (
            (SELECT SUM(total_payment) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) FROM bank_loan_data)) 
            - 
            (SELECT SUM(total_payment) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) - 1 FROM bank_loan_data)))
          / 
        (SELECT SUM(total_payment) 
         FROM bank_loan_data 
         WHERE MONTH(issue_date) = (SELECT MAX(MONTH(issue_date)) - 1 FROM bank_loan_data)) * 100, 1
    ) AS Month_over_month;




#query 4

select AVG(int_rate)* 100 as average_interest_rate from bank_loan_data;

select AVG(int_rate)* 100 as mtd_average_interest_rate from bank_loan_data
where month(issue_date) = (select max(month(issue_date)) from bank_loan_data);

select AVG(int_rate)* 100 as Pmtd_average_interest_rate from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data);

SELECT 
    ROUND(
        (
            (select AVG(int_rate)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)) from bank_loan_data)) 
            - 
            (select AVG(int_rate)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data)))
          / 
        (select AVG(int_rate)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data))
        * 100, 1
    ) AS Month_over_month;



#query 5

SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan_data;

SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 12;

SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 11;

SELECT 
    ROUND(
        (
            (select AVG(dti)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)) from bank_loan_data)) 
            - 
            (select AVG(dti)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data)))
          / 
        (select AVG(dti)* 100 from bank_loan_data
where month(issue_date) = (select max(month(issue_date)-1) from bank_loan_data))
        * 100, 1
    ) AS Month_over_month;




# GOOD LOAN KPI'S

SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;


SELECT COUNT(id) AS Good_Loan_Count
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';


SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';



SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';




# BAD LOAN KPI'S

SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;

SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off';

SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off';

SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off';



# Loan Status Grid View

SELECT
        loan_status,
        COUNT(id) AS Total_Loan_Applications,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        round(AVG(int_rate * 100),1) AS Interest_Rate,
        round(AVG(dti * 100),1) AS DTI
    FROM
        bank_loan_data
    GROUP BY
        loan_status;

        
 SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;




# DASHBOARD 2

# Monthly Trends

SELECT 
	MONTH(issue_date) AS Month_Munber, 
	MONTHNAME(ISSUE_DATE) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(ISSUE_DATE)
ORDER BY MONTH(issue_date);



# Regional Analysis by State 

SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;



# Loan Term Analysis 

SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;



# Employee Length Analysis 

SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;




# Loan Purpose Breakdown 

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;



# Home Ownership Analysis 

SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;

















