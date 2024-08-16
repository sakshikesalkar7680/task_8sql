create table student(
	student_id int primary key,
	name text,
	age int
)

select * from student

create table course(
	course_id int primary key,
	course_name text,
	student_id int references 
	student(student_id)
)

select * from course

insert into student (student_id, name, age) values 
(1, 'alice', 20),
(2, 'bob', 21),
(3, 'charlie', 19)

insert into course (course_id, course_name, student_id) values 
(1, 'maths', 1),
(2, 'history', 2),
(3, 'science', 3)

create view student_course as
select s.student_id, s.name,
s.age, c.course_name 
from student s
join course c on s.student_id = c.student_id;

--insert:
create rule
student_course_insert as
on insert to student_course
do instead
(
	insert into student
(student_id, name, age) values (NEW.student_id, NEW.name, NEW.age);
	insert into course
(course_name, student_id) values (NEW.course_name, NEW.student_id);
);

insert into student_course (student_id, name, age, course_name) values (4, 'daisy', 22, 'art');


--update:
create rule
student_course_update as
on update to student_course
do instead
(
	update student set name = NEW.name, age = NEW.age where student_id = old.student_id;
	update course set
course_name = NEW.course_name where student_id = old.student_id;
);

update student_course set name = 'david', age = 23, course_name = 'philosophy' where student_id = 4;

--delete:
create rule
student_course_delete as
on delete to student_course
do instead
(
	delete from course where student_id = OLD.student_id;
	delete from student where student_id = OLD.student_id;
);

delete from student_course where student_id = 4;


