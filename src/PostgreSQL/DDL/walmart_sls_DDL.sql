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

DROP TABLE IF EXISTS cleaned_walmart_sales;

-- ========================================== DI ========================================== DI ==========================================

-- Создаем таблицу cleaned_walmart_sales с соответствующими типами данных
CREATE TABLE cleaned_walmart_sales (
	id SERIAL PRIMARY KEY,
	store INTEGER NOT NULL,
	date DATE NOT NULL,
	weekly_sales NUMERIC(12, 2) NOT NULL,
	holiday_flag BOOLEAN,
	temperature NUMERIC(10, 3),
	fuel_price NUMERIC(10, 3),
	cpi NUMERIC(10, 3),
	unemployment NUMERIC(10, 3)
);
-- -- ========================================== DI ========================================== DI ==========================================