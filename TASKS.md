# TASKS

## M0 Foundation
- [x] M0.1 Scaffold Next.js + Tailwind, vitest, docker-compose Postgres, .env.example, /staff and /order route stubs, money math (zero tax/deposit) + tests
- [ ] M0.2 Prisma: install, full schema per domain model (staff, users, accounts, products & lookups, orders, order_items, inventory, kegs, bols, pickups, notes/todos, accounting_log, tbs, banners), initial migration
- [ ] M0.3 Pricing module (account pricing class → product price lookup) + unit tests
- [ ] M0.4 NextAuth credentials (two providers: staff, customer), bcrypt, session typing
- [ ] M0.5 Permission middleware (staff codes OH/AC/DM/BO/IN/PP/SC/PO/US/ST/AL/AAC/IP or ALL; customers limited to /order) + tests
- [ ] M0.6 Seed script, fake data: 6 staff, ~50 accounts, 30 users, ~20 products, ~300 orders (tax/deposit 0)
- [ ] M0.7 Base layouts + navigation for /staff and /order, login pages

## M1 Staff portal core
- [ ] M1.1 Accounts list with filters/columns
- [ ] M1.2 Account detail + edit
- [ ] M1.3 Order history with filters and totals
- [ ] M1.4 Order entry (no tax, no deposits)
- [ ] M1.5 Dashboard (calendar preview, todos)

## M2 Wholesale ordering
- [ ] M2.1 Customer login + account picker
- [ ] M2.2 Catalog + place order
- [ ] M2.3 Order history + invoice view
- [ ] M2.4 Payment interface + mock provider, payment method page
- [ ] M2.5 About Me; legacy bcrypt hash import path

## M3 Integrations
- [ ] M3.1 Moneris Checkout  - [ ] M3.2 Shopify webhook  - [ ] M3.3 QuickBooks CSV export  - [ ] M3.4 Payment import

## M4 Reports
- [ ] M4.1 Inventory overview/transactions  - [ ] M4.2 Accounting log  - [ ] M4.3 TBS report  - [ ] M4.4 Delivery lists/map  - [ ] M4.5 LCBO inventory, summary exports

## M5 Migration
- [ ] M5.1 Importers for ref_data / accounts / users / orders / reports JSON in ../jug-data/
- [ ] M5.2 Reconciliation report
- [ ] M5.3 Cutover checklist
