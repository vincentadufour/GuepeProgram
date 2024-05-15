-- This SQL file stores all SQL SELECT statements to create projections

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
WHERE test_trade_id IS NOT NULL
LIMIT(10);

-- like above but with 4 extra algebra columns
SELECT
    date,
    item_name,
    (sell_amount - buy_amount) AS profit_per_item,
    TO_CHAR((sell_amount - buy_amount) * quantity, 'FM999,999,999,999') AS total_profit,
    CONCAT(ROUND(CAST(((sell_amount - buy_amount)/buy_amount) * 100 AS DECIMAL), 2), '%') AS roi_percentage,
    TO_CHAR((buy_amount * quantity), 'FM999,999,999,999') AS total_spent_buying
FROM Trades
WHERE test_trade_id IS NOT NULL
LIMIT 10;

SELECT
    item_name,
    COUNT(*) AS num_of_trades,
    SUM((sell_amount - buy_amount) * quantity) AS total_profit
FROM Trades
WHERE test_trade_id IS NOT NULL AND item_name = 'Marigolds'
GROUP BY item_name;


-- still broken somehow, should be returning total profit like above minus the test trade per row
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