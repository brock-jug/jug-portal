# PROGRESS (newest first)

## 2026-11-07 — M0.3 Pricing rules
**Executive summary**
Tonight I built the pricing engine: given a customer account and a product, it looks up the right price for that account's price tier (the old system has 24 tiers), and prices a whole order from those. New orders always come out as the sum of the line items with $0 tax and $0 deposit, and automated tests prove it. Everything still builds and all 10 checks pass. Foundation (M0) is now 3 of 7 tasks done; next are logins, permissions, fake sample data, and the basic screens. Tomorrow night: M0.4, staff and customer login.

**Technical notes**
- `src/lib/pricing.ts`: pure functions (price book built from ProductPrice rows, `unitPriceCents`, `priceLines`, `MissingPriceError`); no DB access so it is easy to test. Callers load rows and convert Decimal dollars via `priceRowFromDb`.
- Accounts with no pricing category, or products unpriced in a category, are treated as unpriced (order entry must block or flag these).
- `pricingClass` string on Account is kept but unused; the importer (M5) should decide whether it maps to a category.
- `npm ci` was needed in the fresh sandbox; no dependency changes.
- Questions for Brock: none.

## 2026-11-06 — M0.2 Database design
**Executive summary**
Tonight I designed the full database layout for the new system: every table the old vendor system holds (staff, customers, accounts, products, orders, inventory, kegs, bills of lading, pickups, rep notes, accounting log, Beer Store data) now has a home. Order tax and deposit fields are kept only so old orders can be imported exactly; new orders always get $0 for both. The app still builds and all checks pass. Foundation (M0) is now 2 of 7 tasks done; next comes the product pricing rules, then logins and permissions, then fake sample data. Tomorrow night: M0.3, the pricing module (how each account's price for each product is looked up).

**Technical notes**
- Prisma 6 (not 7) chosen as the stable boring option; schema in `prisma/schema.prisma`, initial migration SQL generated with `prisma migrate diff` (no live DB in the build sandbox, so it was not applied against Postgres yet; run `npm run db:migrate` locally after `docker compose up -d`).
- Money is Decimal(12,2); legacy tax/deposit columns kept (tax, deposit on orders; deposit on order_items/products).
- Enums used for status, payment method, shipping status, channel. Legacy importer (M5) will need to map vendor strings to these enums; unknown values may require adding enum members.
- Permissions stored as a string ("ALL" or comma codes) on staff for simplicity.
- Added `postinstall: prisma generate` and db scripts to package.json. `.env` is gitignored.
- Questions for Brock: none.

## 2026-11-06 — M0.1 Scaffold
**Built**
- Next.js 16 (App Router, TypeScript, Tailwind 4, ESLint) in the repo root, with `/staff` and `/order` placeholder pages.
- `docker-compose.yml` for local Postgres 16 and `.env.example`.
- `src/lib/money.ts`: integer-cent money math. Tax and deposit are always 0, so total = sum of line items. Tests in `money.test.ts` assert this.
- Vitest 3 (`npm test`). `npm run build`, lint and tests all pass.
- PLAN.md and TASKS.md created.

**Decisions**
- Pinned vitest to v3 because vitest 5 conflicts with `@types/node@20` from the scaffold.
- Money is stored and computed in integer cents.

**Next night:** M0.2, the Prisma schema and initial migration.

**Questions for Brock:** none.
