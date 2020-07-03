--1. Добавить внешние ключи

ALTER TABLE room
ADD FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)

ALTER TABLE room
ADD FOREIGN KEY (id_room_category) REFERENCES room_category(id_room_category)

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_room) REFERENCES room(id_room)

ALTER TABLE room_in_booking
ADD FOREIGN KEY (id_booking) REFERENCES booking(id_booking)

ALTER TABLE booking
ADD FOREIGN KEY (id_client) REFERENCES client(id_client)

--2. Выдать информация о клиентах гостиницы "Космос", проживающих в номерах категории "Люкс" на 1 апреля 2019г

SELECT client.name, client.phone FROM client
JOIN booking ON client.id_client = booking.id_client
JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
JOIN room ON room.id_room = room_in_booking.id_room
JOIN room_category ON room_category.id_room_category = room.id_room_category
JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE room_in_booking.checkin_date <= '2019-04-01' AND room_in_booking.checkout_date > '2019-04-01' AND room_category.name = 'Люкс' AND hotel.name = 'Космос'

--3. Дать список свободных номеров всех гостиниц на 22 апреля

SELECT * FROM room
WHERE id_room NOT IN (
	SELECT room_in_booking.id_room FROM room_in_booking
	WHERE room_in_booking.checkin_date <= '22.04.2019' and 
	room_in_booking.checkout_date > '22.04.2019')

--4. Дать количество проживающих в гостинице "Космос" на 23 марта по каждой категории номеров

SELECT room_category.name, COUNT(*) AS room_count FROM room_category
JOIN room ON room.id_room_category = room_category.id_room_category
JOIN room_in_booking ON room_in_booking.id_room = room.id_room
JOIN hotel ON hotel.id_hotel = room.id_hotel
JOIN booking ON booking.id_booking = room_in_booking.id_booking
JOIN client ON client.id_client = booking.id_client
WHERE hotel.name = 'Космос' AND room_in_booking.checkin_date <= '23.04.2019' AND room_in_booking.checkout_date > '23.04.2019'
GROUP BY room_category.name

--5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда

SELECT room.id_room, client.name, room_in_booking.checkout_date FROM client
JOIN booking ON booking.id_client = client.id_client
JOIN room_in_booking ON room_in_booking.id_booking = booking.id_booking
JOIN (
	SELECT room_in_booking.id_room, MAX(room_in_booking.checkout_date) AS last_checkout_date FROM room_in_booking
	WHERE YEAR(room_in_booking.checkout_date) = '2019' AND MONTH(room_in_booking.checkout_date) = '04'
	GROUP BY room_in_booking.id_room)
	AS selected_room ON room_in_booking.id_room = selected_room.id_room
JOIN room ON room.id_room = room_in_booking.id_room
JOIN hotel ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' and .last_checkout_date = room_in_booking.checkout_date

--6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.

UPDATE room_in_booking 
SET checkout_date = DATEADD(day, 2, checkout_date)
FROM room_in_booking
JOIN room ON room_in_booking.id_room = room.id_room
JOIN hotel ON room.id_hotel = hotel.id_hotel
JOIN room_category ON room.id_room_category = room_category.id_room_category
WHERE hotel.name = 'Космос' AND room_category.name = 'Бизнес' AND room_in_booking.checkin_date = '10.05.2019';

--7. Найти все "пересекающиеся" варианты проживания.

SELECT * FROM room_in_booking b1
JOIN room_in_booking AS b2 ON B1.id_room = b2.id_room
WHERE 
	b1.id_room_in_booking != b2.id_room_in_booking AND
	b1.checkin_date <= b2.checkin_date AND b2.checkin_date < b1.checkout_date
ORDER BY b1.id_room_in_booking

--8. Создать бронирование в транзакции.

BEGIN TRANSACTION 
INSERT INTO booking VALUES(1, '2020.05.01')
INSERT INTO room_in_booking VALUES(2000, 20, '2020.05.05', '2020.05.10')
ROLLBACK;

--9. Добавить необходимые индексы для всех таблиц.

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON booking
(
	id_client ASC
)

CREATE NONCLUSTERED INDEX [IX_hotel_name] ON hotel
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_room_id_hotel] ON room
(
	id_hotel ASC
)

CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON room
(
	id_room_category ASC
)

CREATE NONCLUSTERED INDEX [IX_room_category_name] ON room_category
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_booking] ON room_in_booking
(
	id_booking ASC
)

CREATE NONCLUSTERED INDEX [IX_room_in_booking_id_room] ON room_in_booking
(
	id_room ASC
)