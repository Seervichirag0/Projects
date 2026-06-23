-- Q1. What percentage of applications are approved?

SELECT
    COUNT(*) AS total_applications,
    SUM(CASE WHEN loan_approval = 'Y' THEN 1 ELSE 0 END) AS approved_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_approval = 'Y' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS approval_rate
FROM loan;

-- Q2. Are higher-income applicants more likely to be approved?

SELECT
    CASE
        WHEN applicant_income < 2000 THEN 'Low Income'
        WHEN applicant_income BETWEEN 2000 AND 6500 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_group,
    
    COUNT(*) AS applications,
    
    ROUND(
        100.0 * SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY income_group
ORDER BY approval_rate DESC;

-- Q3. How important is credit history in loan approvals?

SELECT
    credit_history,
    COUNT(*) AS applications,

    SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END) AS approved,

    ROUND(
        100.0 * SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY credit_history;

-- Q4. Do larger loan amounts have lower approval rates?

SELECT
    CASE
        WHEN loan_amount < 150 THEN 'Small Loan'
        WHEN loan_amount BETWEEN 150 AND 400 THEN 'Medium Loan'
        ELSE 'Large Loan'
    END AS loan_category,

    COUNT(*) AS applications,

    ROUND(
        100.0 * SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY loan_category
ORDER BY approval_rate DESC;

-- Q5. Does education influence approvals?

SELECT
    education,
    COUNT(*) AS applications,

    SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END) AS approved,

    ROUND(
        100.0 * SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY education;

-- Q6. Do applicants with more dependents have lower approval rates?

SELECT
    dependents,
    COUNT(*) AS applications,

    ROUND(
        100.0 * SUM(CASE WHEN loan_approval ='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY dependents
ORDER BY approval_rate DESC;

-- Q7. Are self-employed applicants treated differently?

SELECT
    self_Employed,

    COUNT(*) AS applications,

    SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END) AS approved,

    ROUND(
        100.0 * SUM(CASE WHEN loan_approval='Y' THEN 1 ELSE 0 END)/COUNT(*),
        2
    ) AS approval_rate

FROM loan
GROUP BY self_Employed;

-- Q8. Who are the highest-risk customers?

SELECT
    loan_id,
    applicant_income,
    loan_amount,
    credit_history,
    dependents

FROM loan

WHERE credit_history = 0
AND loan_amount > 150
AND applicant_income < 5400;

-- Q9 . Which customers have high loan burden relative to income?

SELECT
    loan_id,
    applicant_income,
    loan_amount,

    ROUND(
        loan_amount / applicant_income,
        2
    ) AS loan_income_ratio

FROM loan
WHERE loan_amount / applicant_income > 0.20
ORDER BY loan_income_ratio DESC;

-- Q10. How can applicants be categorized into risk levels?

SELECT
loan_id,

    CASE
        WHEN credit_history = 0 THEN 'High Risk'
        WHEN applicant_income < 3000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment

FROM loan;