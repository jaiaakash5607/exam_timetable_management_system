# Exam Time Table Management System (SQL-Focused)

A relational database project for scheduling university exams. Students look up where and when they write, and staff schedule exams without room or invigilator clashes.

This repository focuses on the **database design and SQL**: a normalized 9-table schema, integrity constraints, multi-table joins and clash-prevention logic. A small HTML/CSS/JavaScript front end demonstrates the data.

**Live demo:** https://jaiaakash5607.github.io/exam_timetable_management_system/

## SQL skills demonstrated

| Skill | Where it is used |
|-------|------------------|
| Schema design and normalization | 9 tables, each storing one kind of fact, linked by keys |
| Primary keys | Every table, including composite keys on `invigilation` and `seat_allocation` |
| Foreign keys | `REFERENCES` links from child tables to parent tables |
| `UNIQUE` constraints | `dept_name`, `course.code`, `room_name`, one exam per course, one seat per room per exam |
| `CHECK` with `REGEXP` | Register numbers must match `RA` followed by 13 digits |
| `NOT NULL` and `AUTO_INCREMENT` | Required columns and generated exam IDs |
| Multi-table `JOIN`s | Up to 5 tables joined in a single query |
| `WHERE`, `ORDER BY` | Filtering by register number, sorting by date and time |
| Triggers (`SIGNAL`) | Blocking double-booked rooms and invigilators |

## Entity overview

| # | Table | Purpose |
|---|-------|---------|
| 1 | `department` | Departments |
| 2 | `student` | Students, each in one department |
| 3 | `course` | Courses, each in one department |
| 4 | `faculty` | Faculty, each in one department |
| 5 | `room` | Building, floor and capacity |
| 6 | `time_slot` | Session start and end times |
| 7 | `exam` | Course + date + slot |
| 8 | `invigilation` | Exam + room + faculty |
| 9 | `seat_allocation` | Student + exam + room + seat |

Relationships:

- A department has many students, courses and faculty.
- Each course has at most one exam (`exam.course_id` is `UNIQUE`).
- An exam can use many rooms, each with an invigilator (`invigilation`).
- Each student gets one seat per exam (`seat_allocation`).

## Schema

```sql
CREATE TABLE department (
  dept_id   INT PRIMARY KEY,
  dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE student (
  reg_no   VARCHAR(15) PRIMARY KEY CHECK (reg_no REGEXP '^RA[0-9]{13}$'),
  name     VARCHAR(60) NOT NULL,
  semester INT NOT NULL,
  dept_id  INT NOT NULL REFERENCES department(dept_id)
);

CREATE TABLE course (
  course_id INT PRIMARY KEY,
  code      VARCHAR(10) UNIQUE NOT NULL,
  title     VARCHAR(80) NOT NULL,
  semester  INT NOT NULL,
  dept_id   INT NOT NULL REFERENCES department(dept_id)
);

CREATE TABLE faculty (
  faculty_id INT PRIMARY KEY,
  name       VARCHAR(60) NOT NULL,
  dept_id    INT NOT NULL REFERENCES department(dept_id)
);

CREATE TABLE room (
  room_id   INT PRIMARY KEY,
  room_name VARCHAR(20) UNIQUE NOT NULL,
  building  VARCHAR(30) NOT NULL,
  floor     INT NOT NULL,
  capacity  INT NOT NULL
);

CREATE TABLE time_slot (
  slot_id    INT PRIMARY KEY,
  start_time TIME NOT NULL,
  end_time   TIME NOT NULL
);

CREATE TABLE exam (
  exam_id   INT PRIMARY KEY AUTO_INCREMENT,
  course_id INT NOT NULL UNIQUE REFERENCES course(course_id),
  exam_date DATE NOT NULL,
  slot_id   INT NOT NULL REFERENCES time_slot(slot_id)
);

CREATE TABLE invigilation (
  exam_id    INT NOT NULL REFERENCES exam(exam_id),
  room_id    INT NOT NULL REFERENCES room(room_id),
  faculty_id INT NOT NULL REFERENCES faculty(faculty_id),
  PRIMARY KEY (exam_id, room_id)
);

CREATE TABLE seat_allocation (
  exam_id INT NOT NULL REFERENCES exam(exam_id),
  reg_no  VARCHAR(15) NOT NULL REFERENCES student(reg_no),
  room_id INT NOT NULL REFERENCES room(room_id),
  seat_no INT NOT NULL,
  PRIMARY KEY (exam_id, reg_no),
  UNIQUE (exam_id, room_id, seat_no)
);
```

### Design decisions

- **Composite primary keys** on `invigilation (exam_id, room_id)` and `seat_allocation (exam_id, reg_no)` stop duplicate rows without needing an extra ID column.
- **`UNIQUE (exam_id, room_id, seat_no)`** guarantees two students never get the same seat in the same exam.
- **`exam.course_id` is `UNIQUE`**, so a course cannot be scheduled twice.
- **The register number format is enforced in the database** with a `CHECK` and a regular expression, not only in the form.

## Queries

### Find my exam (student view)

Joins five tables to show a student's exams with venue and seat.

```sql
SELECT c.code, c.title, e.exam_date, t.start_time, t.end_time,
       r.building, r.floor, r.room_name, s.seat_no
FROM seat_allocation s
JOIN exam e      ON e.exam_id = s.exam_id
JOIN course c    ON c.course_id = e.course_id
JOIN time_slot t ON t.slot_id = e.slot_id
JOIN room r      ON r.room_id = s.room_id
WHERE s.reg_no = 'RA2411003010001'
ORDER BY e.exam_date, t.start_time;
```

### All exams (staff view)

Every scheduled exam with its department, venue and invigilator.

```sql
SELECT e.exam_date, t.start_time, t.end_time,
       c.code, c.title, d.dept_name, c.semester,
       r.building, r.room_name, f.name AS invigilator
FROM exam e
JOIN course c       ON c.course_id = e.course_id
JOIN department d   ON d.dept_id = c.dept_id
JOIN time_slot t    ON t.slot_id = e.slot_id
JOIN invigilation i ON i.exam_id = e.exam_id
JOIN room r         ON r.room_id = i.room_id
JOIN faculty f      ON f.faculty_id = i.faculty_id
ORDER BY e.exam_date, t.start_time;
```

## Clash prevention

Date and slot are stored in `exam`, while room and faculty are stored in `invigilation`. A plain `UNIQUE` constraint cannot span both tables, so the "no clash" rules need a trigger (or an application check).

```sql
DELIMITER //

CREATE TRIGGER trg_no_room_clash
BEFORE INSERT ON invigilation
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM invigilation i
    JOIN exam e  ON e.exam_id = i.exam_id
    JOIN exam ne ON ne.exam_id = NEW.exam_id
    WHERE i.room_id = NEW.room_id
      AND e.exam_date = ne.exam_date
      AND e.slot_id = ne.slot_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Room already booked for this date and slot';
  END IF;
END//

CREATE TRIGGER trg_no_invigilator_clash
BEFORE INSERT ON invigilation
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM invigilation i
    JOIN exam e  ON e.exam_id = i.exam_id
    JOIN exam ne ON ne.exam_id = NEW.exam_id
    WHERE i.faculty_id = NEW.faculty_id
      AND e.exam_date = ne.exam_date
      AND e.slot_id = ne.slot_id
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Invigilator already assigned for this date and slot';
  END IF;
END//

DELIMITER ;
```

The web demo runs the same two checks in JavaScript. Try **Room A101 on 23 Nov in Slot 1**: it is already taken, so the exam is refused.

## Web demo

The front end has four tabs:

- **Find my exam:** look up exams by register number.
- **Timetable:** grid view filtered by department.
- **All exams:** table of every scheduled exam.
- **Schedule exam:** add an exam, with clash checking and automatic seat allocation.

Exam slots: Slot 1 is 09:30 to 12:30, Slot 2 is 14:00 to 17:00.

## Project structure

```
index.html    page layout, tabs and SQL schema reference
style.css     styling
script.js     demo data, clash checks, seat allocation
README.md     this file
```

## Run locally

1. Clone the repository:
   ```bash
   git clone https://github.com/jaiaakash5607/exam_timetable_management_system.git
   ```
2. Open `index.html` in your browser. No installation is needed.
3. To try the SQL, run the schema and triggers above in MySQL 8 (the `AUTO_INCREMENT`, `REGEXP` and `SIGNAL` syntax is MySQL).

## Author

[jaiaakash5607](https://github.com/jaiaakash5607)
