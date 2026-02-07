-- Создаю новую БД для проекта
CREATE DATABASE walmart_db
	WITH OWNER = postgres	-- супер-пользователь БД
	ENCODING = 'UTF8'		-- 8-битовый стандарт кодирования символов
	TEMPLATE = template0	-- базовый шаблон
    CONNECTION LIMIT = -1;	-- Кол-во соединений к БД неограниченно

-- Создаю схему БД для организации всех таблиц в одном пространстве имён
CREATE SCHEMA IF NOT EXISTS walmart_sls;

/*
	Удаляем таблицу cleaned_walmart_sales, если она уже существует или была создана ошибочно.
	Это позволяет безопасно пересоздать таблицу без ошибок при выполнении скрипта повторно.
*/

DROP TABLE IF EXISTS walmart_sls.cleaned_walmart_sales;

-- ========================================== DI ========================================== DI ==========================================

-- Создаем таблицу cleaned_walmart_sales с соответствующими типами данных
CREATE TABLE cleaned_walmart_sales (
	id SERIAL NOT NULL PRIMARY KEY, -- Для feature engineering в pandas
	store INTEGER,
	date DATE,
	weekly_sales NUMERIC,
	holiday_flag INTEGER,
	temperature NUMERIC,
	fuel_price NUMERIC,
	cpi NUMERIC,
	unemployment NUMERIC
);
-- -- ========================================== DI ========================================== DI ==========================================

-- Выводим первые 5 строк в консоль для просмотра датасета
SELECT * FROM cleaned_walmart_sales LIMIT 5;
-- -- ============================ DI ============================ DI ============================

-- Находим дубликаты. Если есть - реализовать логику удаления дубликатов.
SELECT store, date, count(*)
FROM cleaned_walmart_sales
GROUP BY store, date
HAVING count(*) > 1;
-- -- ========================================== DI ========================================== DI ==========================================

-- Просматриваем сумму кол-ва пропущенных значений
SELECT 
	count(*) AS total_rows,
	avg(CASE WHEN store IS NULL THEN 1 ELSE 0 END) AS null_store,
	sum(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
	sum(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS null_weekly_sales,
	sum(CASE WHEN holiday_flag IS NULL THEN 1 ELSE 0 END) AS null_holiday_flag,
	sum(CASE WHEN temperature IS NULL THEN 1 ELSE 0 END) AS null_temperature,
	sum(CASE WHEN fuel_price IS NULL THEN 1 ELSE 0 END) AS null_fuel_price,
	sum(CASE WHEN cpi IS NULL THEN 1 ELSE 0 END) AS null_cpi,
	sum(CASE WHEN unemployment IS NULL THEN 1 ELSE 0 END) AS null_unemployment
FROM cleaned_walmart_sales;
-- -- ========================================== DI ========================================== DI ==========================================

/*
	Проверка диапазонов и аномалий 
	Это поможет выявить:
  1. отрицательные значения, если они невозможны
  2. подозрительные нули
  3. экстремальные выбросы
*/
SELECT 
	min(weekly_sales) AS min_sales,
	max(weekly_sales) AS max_sales,
	avg(weekly_sales) AS avg_sales,
	min(temperature) AS min_temp,
	max(temperature) AS max_temp,
	avg(temperature) AS avg_temp,
	MIN(fuel_price) AS min_fuel,
	MAX(fuel_price) AS max_fuel,
	AVG(fuel_price) AS avg_fuel,
	MIN(cpi) AS min_cpi,
	MAX(cpi) AS max_cpi,
	AVG(cpi) AS avg_cpi,
	MIN(unemployment) AS min_unemp,
	MAX(unemployment) AS max_unemp,
	AVG(unemployment) AS avg_unemp
FROM cleaned_walmart_sales;
-- -- ========================================== DI ========================================== DI ==========================================

-- Просматриваем кол-во уникальных значений (важно для Holiday_Flag и Store)
SELECT 
	count(DISTINCT store) AS unique_stores,
	count(DISTINCT holiday_flag) AS unique_holiday_values
FROM cleaned_walmart_sales;
-- -- ========================================== DI ========================================== DI ==========================================

-- Убедиться, что даты охватывают год или несколько лет — для сезонного анализа.
SELECT 
	min(date) AS start_date,
	max(date) AS end_date,
	count(DISTINCT date) AS unique_weeks
FROM cleaned_walmart_sales;
-- -- ========================================== DI ========================================== DI ==========================================