# PROGRESS (newest first)

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
