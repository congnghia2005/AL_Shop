IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AI_E_COMMERCE')
BEGIN
    CREATE DATABASE [AI_E_COMMERCE];
END
GO
USE [AI_E_COMMERCE];
GO

/*USER*/

CREATE TABLE users(
	id INT PRIMARY KEY IDENTITY(1,1),
	email_address VARCHAR(255) NOT NULL,
	phone_number VARCHAR(10) NOT NULL,
	password VARCHAR(255) NOT NULL
);

CREATE TABLE country(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(255) NOT NULL
);

CREATE TABLE address(
	id INT PRIMARY KEY IDENTITY(1,1),
	unit_number INT NOT NULL,
	address_line1 NVARCHAR(255) NOT NULL,
	address_line2 NVARCHAR(255),
	region NVARCHAR(255),
	city NVARCHAR(255) NOT NULL,
	postal_code VARCHAR(255),
	country_id INT,
	FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE user_address(
	user_id INT ,
	address_id INT,
	PRIMARY KEY(user_id,address_id),
	address_default NVARCHAR(255) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (address_id) REFERENCES address(id)
);

/* PRODUCT*/

CREATE TABLE category(
 id INT PRIMARY KEY IDENTITY(1,1),
 name NVARCHAR(255) NOT NULL,
 parent_id INT,
 FOREIGN KEY (parent_id) REFERENCES category(id)
);

CREATE TABLE product(
 id INT PRIMARY KEY IDENTITY(1,1),
 name NVARCHAR(255) NOT NULL,
 description NVARCHAR(255) NOT NULL,
 product_image NVARCHAR(255) NOT NULL,
 category_id INT,
 FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE product_item(
	id INT PRIMARY KEY IDENTITY(1,1),
	SKU VARCHAR(255) NOT NULL,
	qty_in_store INT NOT NULL,
	image NVARCHAR(255),
	price INT NOT NULL,
	product_id INT NOT NULL,
	FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE variation(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(255) NOT NULL,
	category_id INT,
	FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE product_category(
    product_id INT NOT NULL,
    variation_id INT NOT NULL,

    PRIMARY KEY (product_id, variation_id),

    FOREIGN KEY (variation_id) REFERENCES variation(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE variation_option(
	id INT PRIMARY KEY IDENTITY(1,1),
	variation_id INT NOT NULL,
	value NVARCHAR(255) NOT NULL,
	FOREIGN KEY (variation_id) REFERENCES variation(id)
);

/*PROMOTION*/

CREATE TABLE promotion(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(255) NOT NULL,
	description NVARCHAR(255) NOT NULL,
	discount_rate INT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);

CREATE TABLE promotion_category (
	promotion_id INT NOT NULL,
	category_id INT NOT NULL,
	PRIMARY KEY(promotion_id,category_id),

	FOREIGN KEY (promotion_id) REFERENCES promotion(id),
    FOREIGN KEY (category_id) REFERENCES category(id)
);

/*PAYMENT*/

CREATE TABLE payment_type(
	id INT PRIMARY KEY IDENTITY(1,1),
	value NVARCHAR(255) NOT NULL
);

CREATE TABLE payment(
	id INT PRIMARY KEY IDENTITY(1,1),
	account_number VARCHAR(255) NOT NULL,
	is_default BIT DEFAULT 0,
	user_id INT NOT NULL,
	payment_type_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_type(id)
);

/* SHOPPING CART*/

CREATE TABLE shopping_cart(
	id INT PRIMARY KEY IDENTITY(1,1),
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE shopping_cart_item(
	id INT PRIMARY KEY IDENTITY(1,1),
	cart_id INT NOT NULL,
	product_item_id INT NOT NULL,
	qty INT NOT NULL,
	FOREIGN KEY (cart_id) REFERENCES shopping_cart(id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(id)
);

/* OERDER SHIPPING*/

CREATE TABLE shipping_method(
	id INT PRIMARY KEY IDENTITY(1,1),
	name NVARCHAR(255) NOT NULL,
	price INT NOT NULL
);

CREATE TABLE order_status(
	id INT PRIMARY KEY IDENTITY(1,1),
	status NVARCHAR(255) NOT NULL
);

CREATE TABLE orders(
	id INT PRIMARY KEY IDENTITY(1,1),
	user_id INT NOT NULL,
	payment_id INT NOT NULL,
	shipping_method_id INT NOT NULL,
	address_id INT NOT NULL,
	status_id INT NOT NULL,
	order_date DATE NOT NULL,
	order_total INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (payment_id) REFERENCES payment(id),
	FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(id),
	FOREIGN KEY (address_id) REFERENCES address(id),
	FOREIGN KEY (status_id) REFERENCES order_status(id)
);

CREATE TABLE order_line(
	id INT PRIMARY KEY IDENTITY(1,1),
	order_id INT NOT NULL,
	product_item_id INT NOT NULL,
	qty INT NOT NULL,
	price INT NOT NULL,
	FOREIGN KEY (product_item_id) REFERENCES product_item(id),
	FOREIGN KEY (order_id) REFERENCES orders(id)
);

/* USER REVIEW */

CREATE TABLE user_review(
	id INT PRIMARY KEY IDENTITY(1,1),
	user_id INT NOT NULL,
	order_item_id INT NOT NULL,
	rating_value INT NOT NULL,
	comment NVARCHAR(MAX),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (order_item_id) REFERENCES order_line(id),
);