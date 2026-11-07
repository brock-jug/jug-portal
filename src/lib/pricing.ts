/**
 * Pricing: an account belongs to one pricing category; each product has one
 * price per category. Pure functions (no DB) so they are easy to test; the
 * caller loads ProductPrice rows and passes them in. Amounts are integer cents.
 */
import { dollarsToCents, lineTotalCents } from "./money";

export type PriceRow = { productId: number; pricingCategoryId: number; priceCents: number };

export type PriceBook = Map<string, number>;

const key = (productId: number, pricingCategoryId: number) => `${productId}:${pricingCategoryId}`;

export function buildPriceBook(rows: PriceRow[]): PriceBook {
  const book: PriceBook = new Map();
  for (const r of rows) book.set(key(r.productId, r.pricingCategoryId), r.priceCents);
  return book;
}

/** Convert Prisma-style rows (price as Decimal/string/number dollars) to PriceRow. */
export function priceRowFromDb(r: {
  productId: number;
  pricingCategoryId: number;
  price: { toString(): string } | number | string;
}): PriceRow {
  return {
    productId: r.productId,
    pricingCategoryId: r.pricingCategoryId,
    priceCents: dollarsToCents(Number(r.price.toString())),
  };
}

/** Price in cents for a product at an account's pricing category, or null if unpriced. */
export function unitPriceCents(
  book: PriceBook,
  productId: number,
  pricingCategoryId: number | null | undefined,
): number | null {
  if (pricingCategoryId == null) return null;
  return book.get(key(productId, pricingCategoryId)) ?? null;
}

export class MissingPriceError extends Error {
  constructor(public productId: number, public pricingCategoryId: number | null | undefined) {
    super(`No price for product ${productId} in pricing category ${pricingCategoryId ?? "none"}`);
  }
}

/** Price cart lines for an account; throws MissingPriceError if any product is unpriced. */
export function priceLines(
  book: PriceBook,
  pricingCategoryId: number | null | undefined,
  lines: { productId: number; qty: number }[],
) {
  return lines.map((l) => {
    const unit = unitPriceCents(book, l.productId, pricingCategoryId);
    if (unit === null) throw new MissingPriceError(l.productId, pricingCategoryId);
    return { productId: l.productId, qty: l.qty, unitPriceCents: unit, lineTotalCents: lineTotalCents({ qty: l.qty, unitPriceCents: unit }) };
  });
}
