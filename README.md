# Exam Time Table Management System

A simple web app where students find where and when they write their exams, and staff schedule exams. The system refuses clashes before they are saved.

**Live demo:** https://jaiaakash5607.github.io/exam_timetable_management_system/

## Features

- **Find my exam:** enter a register number (for example `RA2411003010001`) to see your exams with date, slot, venue, floor, room and seat number.
- **Timetable:** a grid view of the exam schedule, filtered by department.
- **All exams:** a table of every scheduled exam with date, slot, course, department and semester, venue and invigilator.
- **Schedule exam:** staff pick a course, date, slot, room and invigilator, then save.
- **Clash checking:** the same room or the same invigilator cannot be used on the same date and slot. The clash is shown before the exam is saved.
- **Automatic seat allocation:** saving an exam assigns seat numbers to the students of that department.

### Exam slots

| Slot | Timing |
|------|--------|
| Slot 1 | 09:30 to 12:30 |
| Slot 2 | 14:00 to 17:00 |

## Tech stack

- HTML
- CSS
- JavaScript (the clash checks and seat allocation run in the browser)
- Google Fonts: Bricolage Grotesque and Public Sans

## Database design

The system is designed around nine entities:

1. `department`
2. `student`
3. `course`
4. `faculty`
5. `room`
6. `time_slot`
7. `exam`
8. `invigilation`
9. `seat_allocation`

Date and slot live in `exam`, while room and faculty live in `invigilation`. Because of this, the "no clash" rules need a trigger or an application check. This demo runs those checks in JavaScript.

The query behind "Find my exam":

```sql
SELECT c.code, c.title, e.exam_date, t.start_time, t.end_time,
       r.building, r.floor, r.room_name, s.seat_no
FROM seat_allocation s
JOIN exam e ON e.exam_id = s.exam_id
JOIN course c ON c.course_id = e.course_id
JOIN time_slot t ON t.slot_id = e.slot_id
JOIN room r ON r.room_id = s.room_id
WHERE s.reg_no = 'RA2411003010001'
ORDER BY e.exam_date, t.start_time;
```

## Project structure

```
index.html    page layout and tabs
style.css     styling
script.js     data, clash checks, seat allocation, tab logic
README.md     this file
```

## Run locally

1. Clone the repository:
   ```bash
   git clone https://github.com/jaiaakash5607/exam_timetable_management_system.git
   ```
2. Open the project folder.
3. Open `index.html` in your browser. No installation or server is needed.

## Try it

- Search for the register number `RA2411003010001` under **Find my exam**.
- Under **Schedule exam**, choose Room A101 on 23 Nov in Slot 1. It is already taken, so the system shows a clash.

## Author

[jaiaakash5607](https://github.com/jaiaakash5607)
