CREATE TABLE
Department (
    id  INT PRIMARY KEY,
    name VARCHAR(355) NOT NULL);
	
CREATE TABLE
Employee (
    id INT, 
    department_id INT NOT NULL, 
	chief_doc_id  INT NOT NULL,
	name VARCHAR(355) NOT NULL,
	num_public INT NOT NULL,
	PRIMARY KEY(id),
    FOREIGN KEY(department_id) REFERENCES Department(id)
	);
	
	
	insert into Department values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');
 
insert into Employee values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);


--- a
SELECT Department.name, 
COUNT(chief_doc_id) as count_chief_docs
FROM Department LEFT JOIN Employee 
ON Department.id = employee.department_id
GROUP BY Department.name, Department_id;

--b
SELECT Department.name, 
COUNT(Employee.id) as count_employees
FROM Department LEFT JOIN Employee 
ON Department.id = employee.department_id
GROUP BY Department.name, Department_id
HAVING COUNT(Employee.id) > 3;

--c

SELECT Department.name, 
Department_id,
SUM(num_public) as max_count_public
FROM Department LEFT JOIN Employee 
ON Department.id = employee.department_id
GROUP BY Department.name, Department_id
ORDER BY max_count_public DESC
LIMIT 2;


--d
