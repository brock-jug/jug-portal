import { describe, expect, it } from "vitest";
import { buildPriceBook, MissingPriceError, priceLines, priceRowFromDb, unitPriceCents } from "./pricing";
import { computeOrderTotals } from "./money";

const book = buildPriceBook([
  { productId: 1, pricingCategoryId: 1, priceCents: 12000 },
  { productId: 1, pricingCategoryId: 2, priceCents: 10500 },
  { productId: 2, pricingCategoryId: 1, priceCents: 2399 },
]);

describe("pricing", () => {
  it("looks up price by account pricing category", () => {
    expect(unitPriceCents(book, 1, 1)).toBe(12000);
    expect(unitPriceCents(book, 1, 2)).toBe(10500);
  });
  it("returns null when unpriced or account has no category", () => {
    expect(unitPriceCents(book, 2, 2)).toBeNull();
    expect(unitPriceCents(book, 1, null)).toBeNull();
  });
  it("prices lines and totals equal the sum with zero tax/deposit", () => {
    const lines = priceLines(book, 1, [{ productId: 1, qty: 2 }, { productId: 2, qty: 3 }]);
    expect(lines.map((l) => l.lineTotalCents)).toEqual([24000, 7197]);
    const t = computeOrderTotals(lines);
    expect(t.totalCents).toBe(31197);
    expect(t.taxCents).toBe(0);
    expect(t.depositCents).toBe(0);
  });
  it("throws on a missing price", () => {
    expect(() => priceLines(book, 2, [{ productId: 2, qty: 1 }])).toThrow(MissingPriceError);
  });
  it("converts decimal dollars from the database without float drift", () => {
    expect(priceRowFromDb({ productId: 1, pricingCategoryId: 1, price: "19.99" }).priceCents).toBe(1999);
    expect(priceRowFromDb({ productId: 1, pricingCategoryId: 1, price: 1.1 }).priceCents).toBe(110);
  });
});
