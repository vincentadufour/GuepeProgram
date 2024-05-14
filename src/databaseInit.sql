-- This SQL file initializes the PostgreSQL database

DROP DATABASE guepe;
DROP USER guepeAdmin;

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

INSERT INTO Investors VALUES
    ('Nathan Dufour'),
    ('Ruben Dufour'),
    ('Dan Dufour'),
    ('Vincent Dufour'),
    ('Elie Dufour');

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

-- testing

INSERT INTO Items VALUES
    ('Limpwurt Root', 'The root of a limpwurt plant.'),
    ('Rune Helmet', 'A medium sized helmet.');

INSERT INTO Trades (date, item_name, buy_amount, sell_amount, quantity) VALUES
    ('2018-04-10', 'Limpwurt Root', 2223, 2203, 1);   -- test trade

INSERT INTO Trades (date, item_name, buy_amount, sell_amount, quantity, test_trade_id) VALUES
    ('2018-04-10', 'Limpwurt Root', 2203, 2223, 100, 1); -- real trade


-- selecting total profit, then total profit with test trade
SELECT
    date,
    item_name,
    (sell_amount - buy_amount) * quantity AS profit
FROM Trades
WHERE test_trade_id IS NOT NULL;


--
SELECT
    A.date,
    A.item_name,
    ((A.sell_amount - A.buy_amount) * A.quantity) + ((B.sell_amount - B.buy_amount) * B.quantity) AS total_profit
FROM Trades A
JOIN Trades B
ON B.test_trade_id = A.id;


-- inserting raw swordfish trades
INSERT INTO Items VALUES
    ('Raw Swordfish', 'I should try cooking this.');

INSERT INTO Trades (date, item_name, buy_amount, sell_amount, quantity) VALUES
    ('2018-04-10', 'Raw Swordfish', 541, 536, 1);   -- test trade

INSERT INTO Trades (date, item_name, buy_amount, sell_amount, quantity, test_trade_id) VALUES
    ('2018-04-10', 'Raw Swordfish', 536, 541, 4571, 2),
    ('2018-04-10', 'Raw Swordfish', 536, 540, 9809, 2);-- real trade