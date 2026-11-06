import { describe, expect, it } from "vitest";
import { computeOrderTotals, dollarsToCents, formatCents, lineTotalCents } from "./money";

describe("order totals (zero-rated water, no deposits)", () => {
  it("total equals sum of line items with zero tax and deposit", () => {
    const t = computeOrderTotals([
      { qty: 10, unitPriceCents: 4599 },
      { qty: 2, unitPriceCents: 12000 },
      { qty: 1, unitPriceCents: 1 },
    ]);
    expect(t.subtotalCents).toBe(45990 + 24000 + 1);
    expect(t.taxCents).toBe(0);
    expect(t.depositCents).toBe(0);
    expect(t.totalCents).toBe(t.subtotalCents);
  });
  it("empty order is zero", () => {
    expect(computeOrderTotals([])).toEqual({ subtotalCents: 0, taxCents: 0, depositCents: 0, totalCents: 0 });
  });
  it("rejects bad input", () => {
    expect(() => lineTotalCents({ qty: -1, unitPriceCents: 100 })).toThrow();
    expect(() => lineTotalCents({ qty: 1.5, unitPriceCents: 100 })).toThrow();
    expect(() => lineTotalCents({ qty: 1, unitPriceCents: 10.5 })).toThrow();
  });
});

describe("helpers", () => {
  it("converts dollars to cents without float drift", () => {
    expect(dollarsToCents(19.99)).toBe(1999);
    expect(dollarsToCents(0.1 + 0.2)).toBe(30);
  });
  it("formats CAD", () => {
    expect(formatCents(123456)).toContain("1,234.56");
  });
});
