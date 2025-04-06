-- Active: 1736786939860@@127.0.0.1@3306@todo_list
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    UNIQUE (username)
);

INSERT INTO users (username, password) VALUES ('admin', '123456');    