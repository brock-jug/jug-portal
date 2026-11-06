# JUG Portal – Plan

Self-hosted replacement for the vendor-built beverage-distribution system (staff portal + wholesale ordering) for JUG Beverage Company.

## Stack
Next.js (App Router, TS) · PostgreSQL · Prisma · Tailwind · NextAuth (credentials + bcrypt). One app, two route groups: `/staff` and `/order`. docker-compose for local Postgres.

## Hard rules
- No real customer data/credentials/tokens in the repo. Fake seed data only. Real import runs locally from `../jug-data/`.
- No card data in the app. Moneris hosted checkout/tokenization only; mock provider until M3.
- Tax & deposits (owner-confirmed 2026-11-05): canned water is zero-rated. New orders: tax = 0, deposit = 0, always. Keep the columns for legacy import (M5 maps verbatim). See `src/lib/money.ts`.

## Milestones
M0 Foundation · M1 Staff portal core · M2 Wholesale ordering · M3 Integrations · M4 Reports · M5 Migration & parallel run.
(Details in the original brief; domain model is reflected in `prisma/schema.prisma` once M0.2 lands.)

## Working agreement
Nightly agent does one task from TASKS.md, verifies build/tests, commits to main, updates PROGRESS.md.
