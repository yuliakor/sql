
-- создание БД

CREATE TABLE
department1 (
    id INT PRIMARY KEY, 
    name VARCHAR(355) NOT NULL
	);
	
CREATE TABLE
position1 (
    id  INT PRIMARY KEY,
	position_name VARCHAR(355) NOT NULL,
	salary INT
	);
	
CREATE TABLE
tutor1 (
    id  INT PRIMARY KEY,
	tutor_name VARCHAR(355) NOT NULL,
	department INT,
	position_id INT,
    FOREIGN KEY(department) REFERENCES department1(id),
	FOREIGN KEY(position_id) REFERENCES position1(id)
	);

CREATE TABLE
student1 (
    id  INT PRIMARY KEY,
	student_name VARCHAR(355) NOT NULL,
	gpa INT,
	department_id INT,
	tutor_id INT,
    FOREIGN KEY(department_id) REFERENCES department1(id),
	FOREIGN KEY(tutor_id) REFERENCES tutor1(id)
	);
	
	

	
insert into position1 values
('1', 'преподаватель', 50000),
('2', 'ассистент', 40000),
('3', 'профессор', 80000),
('4', 'старший преподаватель', 70000);

 insert into department1 values
('1','Департамент социологии'),
('2', 'Департамент политической науки'),
('3','Департамент психологии'),
('4','Департамент медиа'),
('5','Департамент прикладной математики');
 
 
 insert into tutor1 values
('1','Коровина Валерия Вячеславовна','5','4'),
('2','Мохаммад Лилия Эсмаеловна','4','3'),
('3', 'Немкина Наталия Евгеньевна', '4','3'),
('4','Дерезовская Варвара Дмитриевна','5','2'),
('5','Кузнецова Полина Павловна','4','1'),
('6','Макуха Всеволод Викторович','4','3'),
('7','Кирмасов Артём Алексеевич','4','3');

 
 insert into student1 values
('1','Покаместова Ольга Ильинична',10.0,'3','7'),
('2','Жукова Дарья Олеговна',8.2,'1','2'),
('3','Симохина Елизавета Викторовна',9.8,'3','7'),
('4','Голик Мария Анатольевна',9.3,'4','2'),
('5','Левен Екатерина Игоревна',6.2,'4','3'),
('6','Дроздик Мария Михайловна',5.5,'1','1'),
('7','Долгова Екатерина Михайловна',6.4,'5','4'),
('8','Самир Ахмад Фаим',7.0,'2','2'),
('9','Солянова Мария Алексеевна',9.9,'5','5'),
('10','Стрижак Ирина Юрьевна',9.6,'4','5'),
('11','Трофимов Максим Николаевич',7.9,'1','4'),
('12','Окорокова Анастасия Евгеньевна',7.7,'4','6'),
('13','Очеретина Александра Константиновна',8.9,'4','5'),
('14','Русанова Анна Юрьевна',5.5,'4','6'),
('15','Патутина Екатерина Алексеевна',6.4,'3','6');

 --Запросы
 
 
 
--- 1 (Подсчет средней зарплаты по департаменту)
SELECT tutor1.department, 
AVG(salary) as avg_salary
FROM tutor1 LEFT JOIN position1
ON tutor1.position_id = position1.id
GROUP BY tutor1.department;

-- 2 (Подсчет максимального балла (gpa)по департаменту)
SELECT student1.department_id, department1.name,
MAX(gpa) as max_gpa
FROM student1 LEFT JOIN department1
ON student1.department_id = department1.id
GROUP BY student1.department_id, department1.name;

-- 3  (Подсчет среднего балла (gpa) студентов у различных научных руководителей)
SELECT tutor1.tutor_name, tutor1.id, 
AVG(gpa) as avg_gpa
FROM tutor1 LEFT JOIN student1
ON tutor1.id = student1.tutor_id
GROUP BY tutor1.tutor_name, tutor1.id;

-- 4 (Подсчет количества студентов, которые курируют научные руководители)

SELECT tutor1.tutor_name, tutor1.id, 
COUNT(student1.id) as count_students
FROM tutor1 LEFT JOIN student1
ON tutor1.id = student1.tutor_id
GROUP BY tutor1.tutor_name, tutor1.id;

-- 5 (Подсчет студентов в каждом департаменте)
 
SELECT department1.name, department_id, 
COUNT(student1.id) as count_students
FROM department1 LEFT JOIN student1
ON department1.id = student1.department_id
GROUP BY department1.name, department_id;

-- 6 ( Вывод 5-ти студентов с наибольшим gpa) 
SELECT *
FROM student1
ORDER BY gpa DESC
LIMIT 5;

-- 7 (Узнать на сколько gpa каждого студента отклоняется от среднего по департаменту)
SELECT id, student_name, gpa, department_id,
    gpa - AVG(gpa) OVER (PARTITION BY id) as diff
FROM student1
ORDER BY department_id, gpa DESC;

--8 (Вывести список студентов с минимальным баллом в каждом из департаментов с их названием)
WITH sample AS (
	SELECT
  		MIN(gpa) AS min_gpa,
  		department_id
	FROM student1
	GROUP BY department_id
)
SELECT student1.student_name, student1.department_id, student1.gpa, department1.name 
FROM sample
FULL OUTER JOIN student1 ON sample.min_gpa = student1.gpa
JOIN department1 ON department1.id = student1.department_id
WHERE department1.id = sample.department_id AND student1.gpa = sample.min_gpa
ORDER BY student1.department_id;


--9 ( Проранжировать каждого студента в департаменте в зависимости от gpa )

SELECT
student1.name, gpa, department1.name,
ROW_NUMBER() OVER (PARTITION BY department1.name) as rating
FROM student1 
LEFT JOIN department1 on student1.department_id = department1.id
ORDER BY department1.name, gpa DESC;

--10 (Вывести, во сколько раз зарплата научного руководителя отличается от средней по департаменту)
 
SELECT position1.id, salary, tutor1.department,
    salary / AVG(salary) OVER (PARTITION BY tutor1.department) as diff
FROM position1 LEFT JOIN tutor1 ON position1.id=tutor1.position_id
ORDER BY tutor1.department, diff DESC;
 



