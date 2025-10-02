CREATE OR REPLACE VIEW vw_active_loans AS
SELECT 
    l.loan_id,
    m.name AS member_name,
    b.title AS book_title,
    l.loan_date,
    l.return_date
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;


 
 CREATE OR REPLACE VIEW vw_member_loan_history AS
SELECT 
    m.member_id,
    m.name,
    COUNT(l.loan_id) AS total_loans,
    MAX(l.loan_date) AS last_loan_date
FROM Member m
LEFT JOIN Loan l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name;


 
CREATE OR REPLACE VIEW vw_overdue_loans AS
SELECT 
    l.loan_id,
    m.name AS member_name,
    b.title AS book_title,
    l.loan_date,
    DATEDIFF(CURRENT_DATE, l.loan_date) AS days_overdue
FROM Loan l
JOIN Member m ON l.member_id = m.member_id
JOIN Book b ON l.book_id = b.book_id
WHERE l.return_date IS NULL
  AND DATEDIFF(CURRENT_DATE, l.loan_date) > 14;


 
 CREATE OR REPLACE VIEW vw_members_missing_email AS
SELECT member_id, name, email, join_date
FROM Member
WHERE email IS NULL;


 
 CREATE OR REPLACE VIEW vw_books_never_borrowed AS
SELECT b.book_id, b.title, a.name AS author_name
FROM Book b
JOIN Author a ON b.book_id = a.author_id
WHERE b.book_id NOT IN (SELECT DISTINCT book_id FROM Loan);


 CREATE OR REPLACE VIEW vw_most_borrowed_books AS
SELECT b.title, COUNT(l.loan_id) AS times_borrowed
FROM Loan l
JOIN Book b ON l.book_id = b.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC
LIMIT 5;

 
 
 CREATE OR REPLACE VIEW vw_member_current_books AS
SELECT m.member_id, m.name, b.title AS borrowed_book, l.loan_date
FROM Member m
JOIN Loan l ON m.member_id = l.member_id
JOIN Book b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;



CREATE OR REPLACE VIEW vw_loan_statistics AS
SELECT 
    COUNT(CASE WHEN return_date IS NULL THEN 1 END) AS currently_borrowed,
    COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS returned_books,
    COUNT(*) AS total_loans
FROM Loan;


