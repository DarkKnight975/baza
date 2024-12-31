-- Створення бази даних
CREATE DATABASE IF NOT EXISTS furniture_shop_db;
USE furniture_shop_db;

-- Таблиця категорій
CREATE TABLE IF NOT EXISTS categories (
  category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (category_id),
  UNIQUE KEY name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця меблів
CREATE TABLE IF NOT EXISTS furniture_items (
  item_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) DEFAULT NULL,
  price DECIMAL(8,2) DEFAULT NULL,
  category_id INT DEFAULT NULL,
  material VARCHAR(100) DEFAULT NULL,
  dimensions VARCHAR(100) DEFAULT NULL,
  image_url VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (item_id),
  FOREIGN KEY (category_id) REFERENCES categories (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Вставка меблів
INSERT INTO furniture_items (name, price, category_id, material, dimensions, image_url) VALUES
  ('Крісло-шезлонг', 150.00, 1, 'Тканина, дерево', '80x80x90 см', 'furniture_shop_db\static\images\sofa.jpg'),
  ('Диван 3-містний', 500.00, 2, 'Шкіра, метал', '200x90x100 см', 'https://example.com/images/sofa.jpg'),
  ('Обідній стіл', 200.00, 3, 'Дерево', '120x80x75 см', 'https://example.com/images/table.jpg'),
  ('Шафа для одягу', 350.00, 4, 'МДФ', '180x80x60 см', 'https://example.com/images/wardrobe.jpg'),
  ('Двоспальне ліжко', 400.00, 5, 'Дерево, тканина', '200x160x100 см', 'https://example.com/images/bed.jpg');

-- Таблиця користувачів
CREATE TABLE IF NOT EXISTS users (
  user_id INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця замовлень
CREATE TABLE IF NOT EXISTS orders (
  order_id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50) DEFAULT 'Очікується',
  PRIMARY KEY (order_id),
  FOREIGN KEY (user_id) REFERENCES users (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця деталей замовлень
CREATE TABLE IF NOT EXISTS order_details (
  detail_id INT NOT NULL AUTO_INCREMENT,
  order_id INT NOT NULL,
  item_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (detail_id),
  FOREIGN KEY (order_id) REFERENCES orders (order_id),
  FOREIGN KEY (item_id) REFERENCES furniture_items (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця контактів
CREATE TABLE IF NOT EXISTS contacts (
  contact_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  phone VARCHAR(20) DEFAULT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (contact_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця відгуків
CREATE TABLE IF NOT EXISTS reviews (
  review_id INT NOT NULL AUTO_INCREMENT,
  customer_name VARCHAR(50) DEFAULT NULL,
  item_id INT DEFAULT NULL,
  rating INT DEFAULT NULL,
  comment TEXT,
  PRIMARY KEY (review_id),
  FOREIGN KEY (item_id) REFERENCES furniture_items (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця постачальників
CREATE TABLE IF NOT EXISTS suppliers (
  supplier_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  contact_email VARCHAR(100) NOT NULL,
  phone VARCHAR(20) DEFAULT NULL,
  address TEXT,
  PRIMARY KEY (supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця поставок
CREATE TABLE IF NOT EXISTS deliveries (
  delivery_id INT NOT NULL AUTO_INCREMENT,
  supplier_id INT NOT NULL,
  item_id INT NOT NULL,
  delivery_date DATE NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (delivery_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id),
  FOREIGN KEY (item_id) REFERENCES furniture_items (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця знижок
CREATE TABLE IF NOT EXISTS discounts (
  discount_id INT NOT NULL AUTO_INCREMENT,
  item_id INT NOT NULL,
  discount_percentage DECIMAL(5,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  PRIMARY KEY (discount_id),
  FOREIGN KEY (item_id) REFERENCES furniture_items (item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця логування
CREATE TABLE IF NOT EXISTS audit_logs (
  log_id INT NOT NULL AUTO_INCREMENT,
  action VARCHAR(50) NOT NULL,
  table_name VARCHAR(50) NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  details TEXT,
  PRIMARY KEY (log_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
