DROP DATABASE IF EXISTS exam_timetable;
CREATE DATABASE exam_timetable;
USE exam_timetable;

-- ---------- 1. TABLES ----------

CREATE TABLE department (
  dept_id    INT PRIMARY KEY,
  dept_name  VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE student (
  reg_no    VARCHAR(15) PRIMARY KEY CHECK (reg_no REGEXP '^RA[0-9]{13}$'),
  name      VARCHAR(60) NOT NULL,
  semester  INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
  dept_id   INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE course (
  course_id  INT PRIMARY KEY,
  code       VARCHAR(10) NOT NULL UNIQUE,
  title      VARCHAR(80) NOT NULL,
  semester   INT NOT NULL CHECK (semester BETWEEN 1 AND 8),
  dept_id    INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE faculty (
  faculty_id  INT PRIMARY KEY,
  name        VARCHAR(60) NOT NULL,
  dept_id     INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE TABLE room (
  room_id    INT PRIMARY KEY,
  room_name  VARCHAR(20) NOT NULL UNIQUE,
  building   VARCHAR(30) NOT NULL,
  floor      INT NOT NULL,
  capacity   INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE time_slot (
  slot_id     INT PRIMARY KEY,
  start_time  TIME NOT NULL,
  end_time    TIME NOT NULL,
  CHECK (end_time > start_time)
);

CREATE TABLE exam (
  exam_id    INT PRIMARY KEY AUTO_INCREMENT,
  course_id  INT NOT NULL UNIQUE,              -- one exam per course
  exam_date  DATE NOT NULL,
  slot_id    INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES course(course_id),
  FOREIGN KEY (slot_id)   REFERENCES time_slot(slot_id)
);

CREATE TABLE invigilation (
  exam_id     INT NOT NULL,
  room_id     INT NOT NULL,
  faculty_id  INT NOT NULL,
  PRIMARY KEY (exam_id, room_id),
  FOREIGN KEY (exam_id)    REFERENCES exam(exam_id) ON DELETE CASCADE,
  FOREIGN KEY (room_id)    REFERENCES room(room_id),
  FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
);

CREATE TABLE seat_allocation (
  exam_id  INT NOT NULL,
  reg_no   VARCHAR(15) NOT NULL,
  room_id  INT NOT NULL,
  seat_no  INT NOT NULL CHECK (seat_no > 0),
  PRIMARY KEY (exam_id, reg_no),               -- one seat per student per exam
  UNIQUE (exam_id, room_id, seat_no),          -- one student per seat
  FOREIGN KEY (exam_id) REFERENCES exam(exam_id) ON DELETE CASCADE,
  FOREIGN KEY (reg_no)  REFERENCES student(reg_no),
  FOREIGN KEY (room_id) REFERENCES room(room_id)
);

-- ---------- 2. TRIGGERS (clash rules) ----------

DELIMITER $$

-- Same department + semester cannot have two exams in one date/slot
CREATE TRIGGER trg_exam_class_clash
BEFORE INSERT ON exam
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM exam e
    JOIN course c1 ON c1.course_id = e.course_id
    JOIN course c2 ON c2.course_id = NEW.course_id
    WHERE e.exam_date = NEW.exam_date
      AND e.slot_id   = NEW.slot_id
      AND c1.dept_id  = c2.dept_id
      AND c1.semester = c2.semester
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Clash: this department and semester already has an exam in that slot';
  END IF;
END$$

-- A room cannot host two exams, and a faculty member cannot invigilate
-- two exams, in the same date/slot
CREATE TRIGGER trg_invigilation_clash
BEFORE INSERT ON invigilation
FOR EACH ROW
BEGIN
  DECLARE v_date DATE;
  DECLARE v_slot INT;

  SELECT exam_date, slot_id INTO v_date, v_slot
  FROM exam WHERE exam_id = NEW.exam_id;

  IF EXISTS (
    SELECT 1 FROM invigilation i
    JOIN exam e ON e.exam_id = i.exam_id
    WHERE e.exam_date = v_date AND e.slot_id = v_slot
      AND i.room_id = NEW.room_id AND i.exam_id <> NEW.exam_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Room is already booked for another exam in that slot';
  END IF;

  IF EXISTS (
    SELECT 1 FROM invigilation i
    JOIN exam e ON e.exam_id = i.exam_id
    WHERE e.exam_date = v_date AND e.slot_id = v_slot
      AND i.faculty_id = NEW.faculty_id AND i.exam_id <> NEW.exam_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invigilator is already assigned to another exam in that slot';
  END IF;
END$$

-- Seat number must fit inside the room
CREATE TRIGGER trg_seat_capacity
BEFORE INSERT ON seat_allocation
FOR EACH ROW
BEGIN
  DECLARE v_cap INT;
  SELECT capacity INTO v_cap FROM room WHERE room_id = NEW.room_id;
  IF NEW.seat_no > v_cap THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Seat number exceeds room capacity';
  END IF;
END$$

DELIMITER ;

-- ---------- 3. SAMPLE DATA ----------

INSERT INTO department VALUES (1,'CSE'), (2,'ECE'), (3,'MECH');

INSERT INTO student VALUES
 ('RA2411003010001','Anita',  5,1), ('RA2411003010002','Bala',   5,1),
 ('RA2411003010003','Charan', 5,1), ('RA2411003010004','Divya',  5,1),
 ('RA2411004010001','Eshwar', 5,2), ('RA2411004010002','Farah',  5,2),
 ('RA2411007010001','Gokul',  5,3), ('RA2511003010101','Harini', 3,1);

INSERT INTO course VALUES
 (1,'CS301','Database Management Systems',5,1),
 (2,'CS302','Operating Systems',          5,1),
 (3,'CS303','Computer Networks',          5,1),
 (4,'EC301','Digital Signal Processing',  5,2),
 (5,'EC302','VLSI Design',                5,2),
 (6,'ME301','Thermodynamics',             5,3),
 (7,'CS201','Data Structures',            3,1);

INSERT INTO faculty VALUES
 (1,'Dr. Meena',1), (2,'Prof. Arun',2), (3,'Dr. Kavitha',1),
 (4,'Prof. Rahul',3), (5,'Dr. Suresh',1);

INSERT INTO room VALUES
 (1,'Room A101','Block A',1,120),
 (2,'Room A102','Block A',1,100),
 (3,'Room B201','Block B',2,80),
 (4,'Main Hall','Admin Block',0,200);

INSERT INTO time_slot VALUES
 (1,'09:30:00','12:30:00'),
 (2,'14:00:00','17:00:00');

INSERT INTO exam (exam_id, course_id, exam_date, slot_id) VALUES
 (1,1,'2026-11-23',1),
 (2,4,'2026-11-23',1),
 (3,2,'2026-11-24',1),
 (4,6,'2026-11-24',2),
 (5,3,'2026-11-25',2),
 (6,7,'2026-11-26',1);

INSERT INTO invigilation VALUES
 (1,1,1), (2,2,2), (3,1,3), (4,3,4), (5,4,1), (6,4,5);

-- Auto-assign seats: students of the course's dept + semester, numbered by reg_no
INSERT INTO seat_allocation (exam_id, reg_no, room_id, seat_no)
SELECT e.exam_id, s.reg_no, i.room_id,
       ROW_NUMBER() OVER (PARTITION BY e.exam_id ORDER BY s.reg_no)
FROM exam e
JOIN course c       ON c.course_id = e.course_id
JOIN student s      ON s.dept_id = c.dept_id AND s.semester = c.semester
JOIN invigilation i ON i.exam_id = e.exam_id;

-- ---------- 4. QUERIES ----------

-- Q1. "Find my exam": where and when does a student write?
SELECT c.code, c.title, e.exam_date, t.start_time, t.end_time,
       r.building, r.floor, r.room_name, s.seat_no
FROM seat_allocation s
JOIN exam e      ON e.exam_id   = s.exam_id
JOIN course c    ON c.course_id = e.course_id
JOIN time_slot t ON t.slot_id   = e.slot_id
JOIN room r      ON r.room_id   = s.room_id
WHERE s.reg_no = 'RA2411003010001'
ORDER BY e.exam_date, t.start_time;

-- Q2. Full timetable
SELECT e.exam_date, t.start_time, c.code, c.title, d.dept_name,
       c.semester, r.room_name, r.building, f.name AS invigilator
FROM exam e
JOIN course c       ON c.course_id  = e.course_id
JOIN department d   ON d.dept_id    = c.dept_id
JOIN time_slot t    ON t.slot_id    = e.slot_id
JOIN invigilation i ON i.exam_id    = e.exam_id
JOIN room r         ON r.room_id    = i.room_id
JOIN faculty f      ON f.faculty_id = i.faculty_id
ORDER BY e.exam_date, t.start_time;

-- Q3. Seating list for one exam (hall ticket sheet)
SELECT s.seat_no, st.reg_no, st.name
FROM seat_allocation s
JOIN student st ON st.reg_no = s.reg_no
WHERE s.exam_id = 1
ORDER BY s.seat_no;

-- Q4. Invigilation duty count per faculty
SELECT f.name, COUNT(*) AS duties
FROM invigilation i
JOIN faculty f ON f.faculty_id = i.faculty_id
GROUP BY f.faculty_id, f.name
ORDER BY duties DESC;

-- Q5. Room utilisation: seats used vs capacity
SELECT r.room_name, r.capacity, e.exam_date, e.slot_id,
       COUNT(s.reg_no) AS students_seated
FROM invigilation i
JOIN room r ON r.room_id = i.room_id
JOIN exam e ON e.exam_id = i.exam_id
LEFT JOIN seat_allocation s ON s.exam_id = i.exam_id AND s.room_id = i.room_id
GROUP BY r.room_id, r.room_name, r.capacity, e.exam_date, e.slot_id;

-- Q6. Courses with no exam scheduled yet
SELECT c.code, c.title
FROM course c
LEFT JOIN exam e ON e.course_id = c.course_id
WHERE e.exam_id IS NULL;

