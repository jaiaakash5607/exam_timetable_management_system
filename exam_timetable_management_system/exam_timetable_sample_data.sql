-- ============================================================
-- Exam Time Table Management System: EXTRA SAMPLE DATA (MySQL 8+)
-- Run AFTER exam_timetable.sql (it needs the tables, triggers
-- and the first batch of sample data).
-- Adds: 2 departments, 7 faculty, 4 rooms, 30 students,
--       9 courses, 9 exams, invigilation and seat allocation.
-- ============================================================

USE exam_timetable;

-- ---------- Departments (IDs 4-5) ----------
INSERT INTO department VALUES
 (4,'IT'),
 (5,'EEE');

-- ---------- Faculty (IDs 6-12) ----------
INSERT INTO faculty VALUES
 (6, 'Dr. Lakshmi', 1),
 (7, 'Prof. Venkat',4),
 (8, 'Dr. Anand',   5),
 (9, 'Prof. Nisha', 1),
 (10,'Dr. Prakash', 3),
 (11,'Prof. Geetha',2),
 (12,'Dr. Ramesh',  3);

-- ---------- Rooms (IDs 5-8) ----------
INSERT INTO room VALUES
 (5,'Room B202',   'Block B',     2, 60),
 (6,'Room C101',   'Block C',     1, 90),
 (7,'Room C201',   'Block C',     2, 70),
 (8,'Seminar Hall','Admin Block', 1,150);

-- ---------- Students ----------
-- Format: RA + 13 digits (2411 = 2024 batch, 2511 = 2025 batch;
-- 003 CSE, 004 ECE, 005 IT, 006 EEE, 007 MECH)

-- CSE semester 5
INSERT INTO student VALUES
 ('RA2411003010005','Ishaan', 5,1),
 ('RA2411003010006','Janani', 5,1),
 ('RA2411003010007','Karthik',5,1),
 ('RA2411003010008','Lakshmi',5,1),
 ('RA2411003010009','Manoj',  5,1),
 ('RA2411003010010','Nithya', 5,1);

-- ECE semester 5
INSERT INTO student VALUES
 ('RA2411004010003','Omkar',  5,2),
 ('RA2411004010004','Priya',  5,2),
 ('RA2411004010005','Qadir',  5,2),
 ('RA2411004010006','Revathi',5,2);

-- MECH semester 5
INSERT INTO student VALUES
 ('RA2411007010002','Surya', 5,3),
 ('RA2411007010003','Tharun',5,3),
 ('RA2411007010004','Uma',   5,3);

-- IT semester 5
INSERT INTO student VALUES
 ('RA2411005010001','Bharath',5,4),
 ('RA2411005010002','Chitra', 5,4),
 ('RA2411005010003','Dinesh', 5,4),
 ('RA2411005010004','Elango', 5,4),
 ('RA2411005010005','Fathima',5,4);

-- EEE semester 5
INSERT INTO student VALUES
 ('RA2411006010001','Gayathri',5,5),
 ('RA2411006010002','Hari',    5,5),
 ('RA2411006010003','Indu',    5,5),
 ('RA2411006010004','Jeeva',   5,5);

-- Semester 3 students
INSERT INTO student VALUES
 ('RA2511003010102','Vijay',   3,1),
 ('RA2511003010103','Yamini',  3,1),
 ('RA2511003010104','Zaid',    3,1),
 ('RA2511003010105','Aarthi',  3,1),
 ('RA2511004010001','Kiran',   3,2),
 ('RA2511004010002','Latha',   3,2),
 ('RA2511007010001','Mohan',   3,3),
 ('RA2511007010002','Nandhini',3,3);

-- ---------- Courses (IDs 8-16) ----------
-- Course 5 (EC302) is deliberately left unscheduled: it is used by the
-- clash tests at the end of exam_timetable.sql.
INSERT INTO course VALUES
 (8, 'IT301','Web Technologies',      5,4),
 (9, 'IT302','Software Engineering',  5,4),
 (10,'EE301','Power Systems',         5,5),
 (11,'EE302','Control Systems',       5,5),
 (12,'CS202','Discrete Mathematics',  3,1),
 (13,'CS304','Machine Learning',      5,1),
 (14,'ME302','Fluid Mechanics',       5,3),
 (15,'EC202','Analog Circuits',       3,2),
 (16,'ME201','Engineering Mechanics', 3,3);

-- ---------- Exams (IDs 7-15) ----------
-- Slot 1 = 09:30-12:30, Slot 2 = 14:00-17:00
INSERT INTO exam (exam_id, course_id, exam_date, slot_id) VALUES
 (7, 13,'2026-11-27',1),   -- Machine Learning        CSE sem 5
 (8,  8,'2026-11-23',2),   -- Web Technologies        IT  sem 5
 (9,  9,'2026-11-25',1),   -- Software Engineering    IT  sem 5
 (10,10,'2026-11-23',2),   -- Power Systems           EEE sem 5
 (11,11,'2026-11-25',1),   -- Control Systems         EEE sem 5
 (12,12,'2026-11-24',2),   -- Discrete Mathematics    CSE sem 3
 (13,14,'2026-11-26',2),   -- Fluid Mechanics         MECH sem 5
 (14,15,'2026-11-27',2),   -- Analog Circuits         ECE sem 3
 (15,16,'2026-11-28',1);   -- Engineering Mechanics   MECH sem 3

-- ---------- Invigilation (exam, room, faculty) ----------
INSERT INTO invigilation VALUES
 (7, 1, 6),
 (8, 5, 7),
 (9, 5, 7),
 (10,3, 8),
 (11,3, 8),
 (12,2, 9),
 (13,6,10),
 (14,7,11),
 (15,8,12);

-- ---------- Seat allocation ----------
-- Seats every student who does not have one yet, for every exam of their
-- department and semester. New seats continue after the highest seat
-- already used in that exam, so the first batch of seats is left untouched.
INSERT INTO seat_allocation (exam_id, reg_no, room_id, seat_no)
SELECT e.exam_id, s.reg_no, i.room_id,
       (SELECT COALESCE(MAX(sa.seat_no), 0)
        FROM seat_allocation sa
        WHERE sa.exam_id = e.exam_id)
       + ROW_NUMBER() OVER (PARTITION BY e.exam_id ORDER BY s.reg_no)
FROM exam e
JOIN course c       ON c.course_id = e.course_id
JOIN student s      ON s.dept_id = c.dept_id AND s.semester = c.semester
JOIN invigilation i ON i.exam_id = e.exam_id
WHERE NOT EXISTS (
  SELECT 1 FROM seat_allocation x
  WHERE x.exam_id = e.exam_id AND x.reg_no = s.reg_no
);

-- ---------- Quick checks ----------

-- Row counts per table
SELECT 'department' AS tbl, COUNT(*) AS n FROM department
UNION ALL SELECT 'student',         COUNT(*) FROM student
UNION ALL SELECT 'course',          COUNT(*) FROM course
UNION ALL SELECT 'faculty',         COUNT(*) FROM faculty
UNION ALL SELECT 'room',            COUNT(*) FROM room
UNION ALL SELECT 'time_slot',       COUNT(*) FROM time_slot
UNION ALL SELECT 'exam',            COUNT(*) FROM exam
UNION ALL SELECT 'invigilation',    COUNT(*) FROM invigilation
UNION ALL SELECT 'seat_allocation', COUNT(*) FROM seat_allocation;

-- Students per exam, with the venue
SELECT e.exam_id, c.code, e.exam_date, e.slot_id, r.room_name,
       r.building, COUNT(s.reg_no) AS students_seated, r.capacity
FROM exam e
JOIN course c       ON c.course_id = e.course_id
JOIN invigilation i ON i.exam_id   = e.exam_id
JOIN room r         ON r.room_id   = i.room_id
LEFT JOIN seat_allocation s ON s.exam_id = e.exam_id
GROUP BY e.exam_id, c.code, e.exam_date, e.slot_id, r.room_name, r.building, r.capacity
ORDER BY e.exam_date, e.slot_id;

-- Exam schedule for one of the new students
SELECT c.code, c.title, e.exam_date, t.start_time, r.building, r.room_name, s.seat_no
FROM seat_allocation s
JOIN exam e      ON e.exam_id   = s.exam_id
JOIN course c    ON c.course_id = e.course_id
JOIN time_slot t ON t.slot_id   = e.slot_id
JOIN room r      ON r.room_id   = s.room_id
WHERE s.reg_no = 'RA2411005010003'
ORDER BY e.exam_date, t.start_time;
