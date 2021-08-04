CREATE DATABASE klimova
ON PRIMARY
(name = klimovaDB,
filename='/var/opt/mssql/data/KlimovaDB.mdf',
SIZE = 10MB,
MAXSIZE=15MB,
FILEGROWTH=1MB)
LOG ON
(name=KlimovaLog,
FILENAME='/var/opt/mssql/data/KlimovaLog.ldf',
SIZE=2MB,
MAXSIZE=3MB,
FILEGROWTH=10%)


use klimova
create table сотрудники
(
Табельный_номер int not null,
Дата_рождения datetime not null,
Фамилия varchar(30) not null,
Оклад int not null default 200,
Код_отдела int not null,
Отработано_дней int default 0,
Премия int default 0,
Пол varchar(1) default 'M'
)



ALTER TABLE сотрудники
ADD primary key(Табельный_номер);
ALTER TABLE сотрудники
ADD CONSTRAINT Оклад
check (Оклад>=200 AND Оклад<=1000);
ALTER TABLE сотрудники
ADD CONSTRAINT Премия
check (Премия>=0 AND Премия<=600);
ALTER TABLE сотрудники
ADD CONSTRAINT Отработано_дней
check (Отработано_дней>=0);
ALTER TABLE сотрудники
ADD CONSTRAINT Пол 
CHECK (Пол='M' OR Пол='F')


create table Отделы
(
    Код_отдела int not NULL,
    Название_отдела varchar(30) not null default 'неизвестно',
    Количество_сотрудников int not null default 0,
    Табельный_номер_хачальника_отдела INT not null
)

alter table Отделы
ADD primary key(Код_отдела)

alter table сотрудники
ADD foreign key(Код_отдела) REFERENCES Отделы(Код_отдела)

use klimova

insert Отделы
values(1,'Fire',45,70);
insert Отделы
values(2,'Water',2,1);
insert Отделы
values(3,'Gym',8,6);
insert Отделы
values(4,'IT',1,1);
insert Отделы
values(5,'Network',7,10);
insert Отделы
values(6,'Cisco',3,8);
insert Отделы
values(7,'Intel',2,14);
insert Отделы
values(8,'Health',5,2);
insert Отделы
values(9,'HR',13,6);
insert Отделы
values(10,'Sport',4,15);
insert Отделы
values(11,'Psycho',5,20);


insert into сотрудники
VALUES(5,'1968-01-01','Andrew',250,1,26,200,'M');
insert into сотрудники
VALUES(6,'1997-02-17','Diane',600,2,19,300,'F');
insert into сотрудники
VALUES(7,'1980-02-14','Fabrice',400,3,14,100,'M');
insert into сотрудники
VALUES(8,'1978-09-21','Lily',450,4,18,200,'F');
insert into сотрудники
VALUES(9,'1952-03-02','Maxim',620,5,13,100,'F');
insert into сотрудники
VALUES(10,'1952-03-03','Dimitri',700,7,23,50,'M');
insert into сотрудники
VALUES(11,'1980-04-04','Miriam',604,8,27,80,'F');


update сотрудники
SET Оклад=Оклад*1.3
where Пол='M';

update сотрудники
set Премия = Премия + 130
where Дата_рождения<'1960-01-01';

-- удаление имен, начинающихся с букв " D " и "M"
delete from сотрудники
where Фамилия LIKE 'D%' OR Фамилия LIKE 'M%';

insert into сотрудники
values(6,'1974-05-14','Neymar',DEFAULT,1,17,140,DEFAULT);

use klimova
select * from сотрудники
select * from Отделы



select Табельный_номер,Дата_рождения,Фамилия,Пол from сотрудники
ORDER BY Фамилия DESC
select Табельный_номер,Дата_рождения,Фамилия,Пол from сотрудники
ORDER BY Дата_рождения



SELECT Оклад+Премия AS К_выдаче from сотрудники;


SELECT * from сотрудники
where Оклад=650;


SELECT * from сотрудники
where Оклад>=500 AND Пол='M';


SELECT * from сотрудники
where Оклад BETWEEN 500 AND 800;



SELECT  Отделы.Название_отдела, COUNT(Табельный_номер) as количество_сотрудников
FROM сотрудники INNER JOIN Отделы on сотрудники.Код_отдела=Отделы.Код_отдела
GROUP BY Отделы.Название_отдела

SELECT сотрудники.Код_отдела,COUNT(сотрудники.Код_отдела) as количество_сотрудников
FROM сотрудники
GROUP BY сотрудники.Код_отдела



SELECT Код_отдела,SUM(Премия)  as Сумма_премии from сотрудники
GROUP BY Код_отдела;



SELECT Табельный_номер,Дата_рождения,Фамилия,Премия INTO new_table from сотрудники



SELECT Фамилия,Дата_рождения,Название_отдела from сотрудники INNER JOIN Отделы 
ON Отделы.Код_отдела=сотрудники.Код_отдела;


-- триггер для обновления
CREATE TRIGGER my_trigger ON Отделы
AFTER UPDATE
AS BEGIN
PRINT 'Table changed! The database has been updated'
END



-- триггер для удаления
CREATE TRIGGER our_trigger ON Отделы
AFTER DELETE
AS BEGIN
PRINT 'Table changed! Some content was deleted'
END


-- триггер для доблавления
CREATE TRIGGER his_trigger ON Отделы
AFTER INSERT
AS BEGIN
PRINT 'Table changed: New stuffs were added!'
END



-- Задача 2

CREATE TRIGGER tri ON сотрудники
AFTER INSERT, DELETE AS
SET NOCOUNT ON

IF EXISTS (SELECT * FROM Inserted)
BEGIN
UPDATE Отделы SET Отделы.Количество_сотрудников=Отделы.Количество_сотрудников + 1 FROM inserted
WHERE Inserted.Код_отдела=Отделы.Код_отдела
PRINT 'A worker has been added to the database'
END


IF EXISTS (SELECT * FROM deleted)
BEGIN
UPDATE Отделы SET Отделы.Количество_сотрудников=Отделы.Количество_сотрудников - 1 FROM Deleted
WHERE Deleted.Код_отдела=Отделы.Код_отдела
PRINT 'A worker has been deleted from the database'
END


use klimova
delete from сотрудники
where Фамилия='PPP'

