# Database Normalization
## Previous Design
| date | item_name | buy_amount | sell_amount | quantity | profit_per_item | total_profit | roi | total_spent_buying |
| ---- | --------- | ---------- | ----------- | -------- | --------------- | ------------ | --- | ------------------ |
|      |           |            |             |          |                 |              |     |                    |
## Normalized to 3NF
- **Items**(<u>item_name</u>, item_description, item_score)
- **Trade**(<u>trade_id</u>, date, item_name, buy_amount, sell_amount, quantity)
- **Shareholders**(<u>name</u>)
- **Investments**(<u>shareholder_name</u>, investment_date, investment_amount, fixed_roi)
- **Payouts**(<u>shareholder_name</u>, <u>payout_date</u>, principle_paid_out, interest_paid_out)
- **Bonds**(<u>bond_id</u>, bond_date, bond_amount)

