ADD FOREIGN KEY (id_company) REFERENCES company(id_company)

ALTER TABLE dealer
ADD FOREIGN KEY (id_company) REFERENCES company(id_company)

ALTER TABLE [order]
ADD FOREIGN KEY (id_production) REFERENCES production(id_production)

ALTER TABLE [order]
ADD FOREIGN KEY (id_dealer) REFERENCES dealer(id_dealer)

ALTER TABLE [order]
ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy)

--2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.

SELECT pharmacy.name, [order].date, [order].quantity FROM medicine
INNER JOIN production ON production.id_medicine = medicine.id_medicine
INNER JOIN company ON company.id_company = production.id_company
INNER JOIN [order] ON [order].id_production = production.id_production
INNER JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус'

--3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

SELECT DISTINCT medicine.name
FROM medicine
JOIN production ON production.id_medicine = medicine.id_medicine
JOIN company ON company.id_company = production.id_company
JOIN [order] ON [order].id_production = production.id_production
WHERE company.name = 'Фарма' AND
	production.id_production NOT IN 
	(
		SELECT [order].id_production
		FROM [order]
		WHERE [order].date < N'2019-01-25'
	)

--4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.

SELECT company.name, MIN(production.rating) AS min_rating, MAX(production.rating) AS max_rating
FROM production
JOIN company ON company.id_company = production.id_company
JOIN [order] ON [order].id_production = production.id_production
GROUP BY company.name
HAVING COUNT([order].id_order) >= 120

--5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT dealer.name, pharmacy.name
FROM dealer
LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer
LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
JOIN company ON company.id_company = dealer.id_company
WHERE company.name = 'AstraZeneca'

--6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.

UPDATE production 
SET production.price = 0.8 * production.price
FROM production
JOIN medicine ON medicine.id_medicine = production.id_medicine
WHERE production.price > 3000 AND medicine.cure_duration <= 7

--7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX [IX_company_name] ON company
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON dealer
(
	id_company ASC
)

CREATE NONCLUSTERED INDEX [IX_dealer_name] ON dealer
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_medicine_name] ON medicine
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [order]
(
	id_production ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [order]
(
	id_dealer ASC
)

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [order]
(
	id_pharmacy ASC
)

CREATE NONCLUSTERED INDEX [IX_pharmacy_name] ON pharmacy
(
	name ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON production
(
	id_company ASC
)

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON production
(
	id_medicine ASC
)