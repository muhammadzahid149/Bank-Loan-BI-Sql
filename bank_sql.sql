select * from financial_loan;

-- 1 TOTAL LOAN APPLICATION

SELECT COUNT(ID) AS Total_loan_application
FROM financial_loan;

-- 2 MTD Loan Applications

SELECT COUNT(ID) AS MTD_Total_loan_application
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;
  
-- 3 month over month % changes

SELECT
  (DATE_TRUNC('month', issue_date) + INTERVAL '1 month - 1 day')::DATE AS month,
  SUM(loan_amount) AS total_loan,
  LAG(SUM(loan_amount)) OVER (
    ORDER BY DATE_TRUNC('month', issue_date)
  ) AS prev_month_loan,
  ROUND(
    (
      SUM(loan_amount)::NUMERIC -
      LAG(SUM(loan_amount)) OVER (ORDER BY DATE_TRUNC('month', issue_date))::NUMERIC
    ) / NULLIF(
      LAG(SUM(loan_amount)) OVER (ORDER BY DATE_TRUNC('month', issue_date))::NUMERIC,
      0
    ) * 100, 2
  ) AS mom_change_percent
FROM financial_loan
GROUP BY DATE_TRUNC('month', issue_date)
ORDER BY month ;

-- 4 TOTAL LOAN Funded Amount

SELECT sum(loan_amount) AS Total_Funded_Amount
FROM financial_loan;

-- 5 MTD Funded Amount

SELECT sum(loan_amount) AS MTD_Total_Funed_Amount
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

-- 6 previous month to date
SELECT sum(loan_amount) AS PMTD_Total_Funed_Amount
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

-- 7 total payment received by bank
select sum(total_payment) as Total_amount_Received
	from financial_loan;

-- 8 MTD Total amount  Received by bank
SELECT sum(total_payment) AS MTD_Total_Amount_Received
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

 --9 find avg interest rate 
 select round(avg(int_rate) *100,2) as avg_interest_rate
 from  financial_loan;

 --10 calacute month to date(MTD) avg interst rate

SELECT round(avg(int_rate)*100,2) AS MTD_avg_interest_rate
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

-- 11 previous month to date(MTD)avg_interst rate
SELECT round(avg(int_rate)*100,2) AS PMTD_avg_interest_rate
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

 --12  calaculate avg MTD debt to ratio(DTI)
 SELECT round(avg(dti)*100,2) AS MTD_avg_DTI
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

 --13 calaculate  previous avg MTD debt to ratio(DTI)
 SELECT round(avg(dti)*100,2) AS PMTD_avg_DTI
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--14 Good Loan Application Percentage
select  (count(case when loan_status = 'Fully Paid' OR loan_status = 'Current' then id end) *100)/
count(id) as good_loan_percentage
from financial_loan;

--15 calculate good loan application

select count(id) as good_loan_application
from financial_loan
where loan_status ='Fully Paid' or loan_status = 'Current'

--16 Good Loan FUnded
select sum(loan_amount) as good_loan_funded
from financial_loan
where loan_status ='Fully Paid' or loan_status = 'Current'

--17 calacuate Good Loan Total Received Amount
select sum(total_payment) as good_loan_Received
from financial_loan
where loan_status ='Fully Paid' or loan_status = 'Current'

--18 calcaulate bad loan % by bank
select  (count(case when loan_status = 'Charged Off' then id end) *100.0)/
count(id) as bad_loan_Percentage
from financial_loan;

--19 Calcualte bad Loan Application
select count(id) as bad_loan_Application
from financial_loan
where loan_status = 'Charged Off'

--20 Calculate bad Loan Funded Amount
select sum(loan_amount) as bad_loan_funded_amount
from financial_loan
where loan_status= 'Charged Off'

--21 Calculate Bad Amount Received
select sum(total_payment) as Bad_Loan_Amount_Received
from financial_loan
where loan_status= 'Charged Off'

--22 Calculate loan status
select loan_status,count(id)as loan_Application,sum(total_payment) as Total_Amount_Received,
sum(loan_amount) as Total_Funded_Amount,
round(avg(int_rate *100),2) as Interest_Rate,
round(avg(dti *100),2)as DTI
from financial_loan
group by 1
order by loan_status desc

--23 calcualte MTD loan status
select loan_status,
sum(total_payment) as MTD_Total_Amount_Received,
sum(loan_amount) as MTD_Total_Funded_Amount
from financial_loan
where extract(month from issue_date) = 12
group by 1;

--24 monthly trend by issue date
select

	date_part('month',issue_date)::int as month_number,
	to_char(issue_date,'Month')as  month_name,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by date_part('month',issue_date)::int,
		to_char(issue_date,'Month')
order by 1;

--25 Reginol Analyis by State

select address_state,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by 1
order by count(id)desc;

-- calculate loan term analysis
select term,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by 1
order by 1

-- calculate employee length analysis
select emp_length,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by 1
order by count(id)desc

-- calculate loan purpose breakdown

select purpose,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by 1
order by count(id)desc

-- Calculate home ownership anaysis based on total application,total funded amount and received amount

select home_ownership,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment)as Total_Received_amount
from financial_loan
group by 1
order by count(id)desc
