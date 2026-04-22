CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Add any other tables your app needs
INSERT INTO users (name, email) VALUES ('Admin', 'admin@example.com') ON DUPLICATE KEY UPDATE name=name;
