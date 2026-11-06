/**
 * Money math. All amounts are integer cents to avoid float drift.
 *
 * BUSINESS RULE (owner-confirmed 2026-11-05): JUG sells canned water, which is
 * zero-rated. NO HST is charged and there are NO container deposits on new
 * orders. tax and deposit are always 0 for new orders. The columns still exist
 * in the schema because legacy orders carry them and the M5 importer maps them
 * verbatim.
 */

export type LineItem = { qty: number; unitPriceCents: number };

export type OrderTotals = {
  subtotalCents: number;
  taxCents: 0;
  depositCents: 0;
  totalCents: number;
};

export function lineTotalCents(item: LineItem): number {
  if (!Number.isInteger(item.qty) || item.qty < 0) throw new Error("qty must be a non-negative integer");
  if (!Number.isInteger(item.unitPriceCents) || item.unitPriceCents < 0)
    throw new Error("unitPriceCents must be a non-negative integer");
  return item.qty * item.unitPriceCents;
}

export function computeOrderTotals(items: LineItem[]): OrderTotals {
  const subtotalCents = items.reduce((sum, i) => sum + lineTotalCents(i), 0);
  return { subtotalCents, taxCents: 0, depositCents: 0, totalCents: subtotalCents };
}

export function dollarsToCents(d: number): number {
  return Math.round(d * 100);
}

export function formatCents(cents: number): string {
  return new Intl.NumberFormat("en-CA", { style: "currency", currency: "CAD" }).format(cents / 100);
}
