# PROGRESS (newest first)

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
