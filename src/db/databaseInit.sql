-- This SQL file initializes the PostgreSQL database

DROP DATABASE guepe;
DROP USER guepe;

CREATE DATABASE guepe;

\c guepe

-- table creation

CREATE TABLE Items(
    name VARCHAR(50) PRIMARY KEY,
    description VARCHAR(250),
    score INT,
    comment VARCHAR(500)
    );

CREATE TABLE Trades(
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    item_name VARCHAR(50),
    buy_amount FLOAT NOT NULL,
    sell_amount FLOAT NOT NULL,
    quantity INT NOT NULL,
    test_trade_id INT,
    comment VARCHAR(500),
    FOREIGN KEY (item_name) REFERENCES Items(name),
    FOREIGN KEY (test_trade_id) REFERENCES Trades(id)
    );

CREATE TABLE Investors(
    name VARCHAR(150) PRIMARY KEY
    );

CREATE TABLE Investments(
    investor_name VARCHAR(150),
    date DATE,
    amount FLOAT,
    fixed_roi FLOAT NOT NULL,
    comment VARCHAR(500),
    PRIMARY KEY (investor_name, date, amount),
    FOREIGN KEY (investor_name) REFERENCES Investors(name)
    );

CREATE TABLE Payouts(
    investor_name VARCHAR(150),
    date DATE,
    principle FLOAT,
    interest FLOAT,
    comment VARCHAR(500),
    PRIMARY KEY (investor_name, date),
    FOREIGN KEY (investor_name) REFERENCES Investors(name)
    );

CREATE TABLE Bonds(
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    price FLOAT NOT NULL
    );

-- creating admin user
CREATE USER guepe WITH PASSWORD '135791';
GRANT ALL PRIVILEGES ON TABLE Items to guepe;
GRANT ALL PRIVILEGES ON TABLE Trades to guepe;
GRANT ALL PRIVILEGES ON TABLE Investors to guepe;
GRANT ALL PRIVILEGES ON TABLE Investments to guepe;
GRANT ALL PRIVILEGES ON TABLE Payouts to guepe;
GRANT ALL PRIVILEGES ON TABLE Bonds to guepe;
GRANT ALL PRIVILEGES ON SEQUENCE bonds_id_seq TO guepe;
GRANT ALL PRIVILEGES ON SEQUENCE trades_id_seq TO guepe;


-- if a Trade INSERT includes an item_name that doesn't exist, create the new Item
CREATE FUNCTION create_new_item() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Items WHERE name = NEW.item_name)
                THEN
                    INSERT INTO Items(name)
                    VALUES (NEW.item_name);
            END IF;
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER trade_with_new_item
    BEFORE INSERT ON Trades
    FOR EACH ROW
    EXECUTE PROCEDURE create_new_item();

-- This is to account for all trades previous to 14-05-2024 not having any valid test trades
INSERT INTO Trades (date, item_name, buy_amount, sell_amount, quantity, comment) VALUES
    ('05/14/2024', 'Fake Item', 0, 0, 0, 'fake trade');
