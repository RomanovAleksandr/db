--1. INSERT
--1. Без указания списка полей
NSERT INTO actor VALUES ('Иван', 'Иванов', '2012-06-18', 1);
--2. С указанием списка полей
INSERT INTO actor (firstname, lastname, birthday, gender) VALUES ('Петр', 'Петров', '1990-02-11', 1);
--3. С чтением значения из другой таблицы
INSERT INTO author(firstname, lastname, birthday, gender) SELECT firstname, lastname, birthday, gender FROM actor;


--2. DELETE
--1. Всех записей
DELETE author
--2. По условию
DELETE FROM author WHERE firstname = 'Алиса'
--3. Очистить таблицу
TRUNCATE TABLE participation


--3. UPDATE
--1. Всех записей
UPDATE actor SET lastname = 'Васильев'
--2. По условию обновляя один атрибут
UPDATE actor SET lastname = 'Андреев' WHERE firstname = 'Андрей';
--3. По условию обновляя несколько атрибутов
UPDATE actor SET firstname = 'Василий', lastname = 'Васильев' WHERE birthday = '1990-02-11'


--4. SELECT
--1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
SELECT firstname, lastname FROM actor
--2. Со всеми атрибутами (SELECT * FROM...)
SELECT * FROM actor
--3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
SELECT * FROM actor WHERE firstname = 'Андрей'


--5. SELECT ORDER BY + TOP (LIMIT)
--1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 2 * FROM actor ORDER BY gender ASC
--2. С сортировкой по убыванию DESC
SELECT * FROM actor ORDER BY gender DESC
--3. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 3 * FROM actor ORDER BY gender DESC, firstname
--4. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT * FROM actor ORDER BY 1


--6. Работа с датами.
--1. WHERE по дате
SELECT * FROM actor WHERE birthday = '2012-06-18'
--2. Извлечь из таблицы не всю дату, а только год.
SELECT firstname, YEAR(birthday) AS birthday FROM actor


--7. SELECT GROUP BY с функциями агрегации
SELECT gender, MIN(birthday) AS birthday FROM actor GROUP BY gender
SELECT gender, MAX(birthday) AS birthday FROM actor GROUP BY gender
SELECT address, AVG(number_of_seats) AS seats FROM theater GROUP BY address
SELECT address, SUM(number_of_seats) AS seats FROM theater GROUP BY address
SELECT gender, COUNT(gender) AS gender_count FROM actor GROUP BY gender


--8. SELECT GROUP BY + HAVING
--1. Написать 3 разных запроса с использованием GROUP BY + HAVING
SELECT address, SUM(number_of_seats) FROM theater GROUP BY address HAVING AVG(number_of_seats) > 1000
SELECT date, AVG(price) FROM spectacle GROUP BY date HAVING MIN(price) > 5
SELECT date, MIN(price) FROM spectacle GROUP BY date HAVING SUM(price) > 10


--9. SELECT JOIN
--1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT firstname, title FROM author LEFT JOIN play ON author.author_id = play.author_id WHERE firstname = 'Алиса'
--2. RIGHT JOIN. Получить такую же выборку, как и в 9.1
SELECT firstname, title FROM play RIGHT JOIN author ON author.author_id = play.author_id WHERE title = 'Евгений Онегин'
--3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT play.title, theater.title FROM spectacle
LEFT JOIN play ON play.play_id = spectacle.play_id
LEFT JOIN theater ON theater.theater_id = spectacle.theater_id
--4. FULL OUTER JOIN двух таблиц
SELECT firstname, title FROM author FULL OUTER JOIN play ON play.author_id = author.author_id


--10. Подзапросы
--1. Написать запрос с WHERE IN (подзапрос)
SELECT * FROM play WHERE play.play_id IN (SELECT spectacle.play_id FROM spectacle)
--2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ... 
SELECT firstname, (SELECT title FROM play WHERE play.author_id = author.author_id) FROM author                                                                                       