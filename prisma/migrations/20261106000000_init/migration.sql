-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "RecordStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CHEQUE', 'CREDIT_CARD', 'COD', 'EFT', 'INVOICE', 'CASH', 'OTHER');

-- CreateEnum
CREATE TYPE "ShippingStatus" AS ENUM ('PENDING', 'SCHEDULED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SalesChannel" AS ENUM ('WHOLESALE', 'INDIVIDUAL');

-- CreateTable
CREATE TABLE "staff" (
    "staff_id" SERIAL NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "status" "RecordStatus" NOT NULL DEFAULT 'ACTIVE',
    "permissions" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "staff_pkey" PRIMARY KEY ("staff_id")
);

-- CreateTable
CREATE TABLE "users" (
    "user_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone" TEXT,
    "newsletter" BOOLEAN NOT NULL DEFAULT false,
    "reminder" BOOLEAN NOT NULL DEFAULT false,
    "status" "RecordStatus" NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "user_accounts" (
    "user_id" INTEGER NOT NULL,
    "account_id" INTEGER NOT NULL,

    CONSTRAINT "user_accounts_pkey" PRIMARY KEY ("user_id","account_id")
);

-- CreateTable
CREATE TABLE "account_types" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "account_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "banners" (
    "banner_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "banners_pkey" PRIMARY KEY ("banner_id")
);

-- CreateTable
CREATE TABLE "pricing_categories" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "pricing_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounts" (
    "account_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "license_num" TEXT,
    "account_type_id" INTEGER,
    "status" "RecordStatus" NOT NULL DEFAULT 'ACTIVE',
    "is_prospect" BOOLEAN NOT NULL DEFAULT false,
    "address" TEXT,
    "billing_address" TEXT,
    "city" TEXT,
    "province" TEXT DEFAULT 'ON',
    "postal_code" TEXT,
    "phone" TEXT,
    "lat" DOUBLE PRECISION,
    "lng" DOUBLE PRECISION,
    "sales_rep_id" INTEGER,
    "banner_id" INTEGER,
    "channel" TEXT,
    "delivery_day" INTEGER,
    "delivery_week" INTEGER,
    "delivery_inventory_source_id" INTEGER,
    "call_frequency" INTEGER,
    "call_days" TEXT,
    "call_weeks" TEXT,
    "allow_cod" BOOLEAN NOT NULL DEFAULT false,
    "allow_delayed_cc" BOOLEAN NOT NULL DEFAULT false,
    "allow_invoice" BOOLEAN NOT NULL DEFAULT false,
    "credit" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "credit_limit" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "pricing_category_id" INTEGER,
    "pricing_class" TEXT,
    "date_opened" TIMESTAMP(3),
    "notes" TEXT,
    "qb_token" TEXT,
    "delivery_instructions" TEXT,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("account_id")
);

-- CreateTable
CREATE TABLE "products_parent" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "products_parent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_categories" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_owners" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "product_owners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_factors" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "units" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "product_factors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "product_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "parent_id" INTEGER,
    "category_id" INTEGER,
    "owner_id" INTEGER,
    "factor_id" INTEGER,
    "deposit" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "status" "RecordStatus" NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT "products_pkey" PRIMARY KEY ("product_id")
);

-- CreateTable
CREATE TABLE "product_prices" (
    "product_id" INTEGER NOT NULL,
    "pricing_category_id" INTEGER NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,

    CONSTRAINT "product_prices_pkey" PRIMARY KEY ("product_id","pricing_category_id")
);

-- CreateTable
CREATE TABLE "orders" (
    "order_id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "date_ordered" TIMESTAMP(3) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "tax" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "deposit" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "total" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "credit_applied" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "is_paid" BOOLEAN NOT NULL DEFAULT false,
    "paid_date" TIMESTAMP(3),
    "payment_method" "PaymentMethod",
    "manual_payment_ref" TEXT,
    "manual_payment_notes" TEXT,
    "shipping_status" "ShippingStatus" NOT NULL DEFAULT 'PENDING',
    "est_delivery_date" TIMESTAMP(3),
    "delivery_date" TIMESTAMP(3),
    "inventory_source_id" INTEGER,
    "channel" "SalesChannel" NOT NULL DEFAULT 'WHOLESALE',
    "purchase_order" TEXT,
    "reference_id" TEXT,
    "auth_id" TEXT,
    "card_type" TEXT,
    "last_four" TEXT,
    "void_date" TIMESTAMP(3),
    "credit_order_id" INTEGER,
    "is_credit_memo" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "delivery_instructions" TEXT,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("order_id")
);

-- CreateTable
CREATE TABLE "order_items" (
    "id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "qty" INTEGER NOT NULL,
    "unit_price" DECIMAL(12,2) NOT NULL,
    "deposit" DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT "order_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_sources" (
    "source_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "is_third_party" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "inventory_sources_pkey" PRIMARY KEY ("source_id")
);

-- CreateTable
CREATE TABLE "inventory_transactions" (
    "id" SERIAL NOT NULL,
    "action_type" TEXT NOT NULL,
    "category" TEXT,
    "source_id" INTEGER,
    "destination_id" INTEGER,
    "product_id" INTEGER NOT NULL,
    "qty" INTEGER NOT NULL,
    "order_type" TEXT,
    "staff_id" INTEGER,
    "date" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "inventory_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kegs" (
    "id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "kegs_out" INTEGER NOT NULL DEFAULT 0,
    "returned" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "kegs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bols" (
    "bol_id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "order_id" INTEGER,
    "shipping_status" "ShippingStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bols_pkey" PRIMARY KEY ("bol_id")
);

-- CreateTable
CREATE TABLE "bol_items" (
    "id" SERIAL NOT NULL,
    "bol_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "qty" INTEGER NOT NULL,

    CONSTRAINT "bol_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pickups" (
    "pickup_id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "staff_id" INTEGER,
    "date" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "pickups_pkey" PRIMARY KEY ("pickup_id")
);

-- CreateTable
CREATE TABLE "pickup_items" (
    "id" SERIAL NOT NULL,
    "pickup_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "qty" INTEGER NOT NULL,

    CONSTRAINT "pickup_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "call_notes" (
    "id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "staff_id" INTEGER,
    "note" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "call_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "todos" (
    "id" SERIAL NOT NULL,
    "account_id" INTEGER,
    "staff_id" INTEGER,
    "text" TEXT NOT NULL,
    "due_date" TIMESTAMP(3),
    "done" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "todos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounting_log" (
    "id" SERIAL NOT NULL,
    "event_type" TEXT NOT NULL,
    "account_id" INTEGER,
    "order_id" INTEGER,
    "staff_id" INTEGER,
    "amount" DECIMAL(12,2),
    "details" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "accounting_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbs_stores" (
    "id" SERIAL NOT NULL,
    "store_num" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "city" TEXT,
    "banner_id" INTEGER,

    CONSTRAINT "tbs_stores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbs_listings" (
    "id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "sku" TEXT,
    "listed_on" TIMESTAMP(3),

    CONSTRAINT "tbs_listings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbs_sales" (
    "id" SERIAL NOT NULL,
    "store_id" INTEGER NOT NULL,
    "product_id" INTEGER,
    "period" TIMESTAMP(3) NOT NULL,
    "units" INTEGER NOT NULL,

    CONSTRAINT "tbs_sales_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "staff_email_key" ON "staff"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "account_types_name_key" ON "account_types"("name");

-- CreateIndex
CREATE UNIQUE INDEX "banners_name_key" ON "banners"("name");

-- CreateIndex
CREATE UNIQUE INDEX "pricing_categories_name_key" ON "pricing_categories"("name");

-- CreateIndex
CREATE INDEX "accounts_status_is_prospect_idx" ON "accounts"("status", "is_prospect");

-- CreateIndex
CREATE INDEX "accounts_city_idx" ON "accounts"("city");

-- CreateIndex
CREATE INDEX "accounts_sales_rep_id_idx" ON "accounts"("sales_rep_id");

-- CreateIndex
CREATE INDEX "accounts_banner_id_idx" ON "accounts"("banner_id");

-- CreateIndex
CREATE UNIQUE INDEX "products_parent_name_key" ON "products_parent"("name");

-- CreateIndex
CREATE UNIQUE INDEX "product_categories_name_key" ON "product_categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "product_owners_name_key" ON "product_owners"("name");

-- CreateIndex
CREATE UNIQUE INDEX "product_factors_name_key" ON "product_factors"("name");

-- CreateIndex
CREATE INDEX "orders_account_id_date_ordered_idx" ON "orders"("account_id", "date_ordered");

-- CreateIndex
CREATE INDEX "orders_date_ordered_idx" ON "orders"("date_ordered");

-- CreateIndex
CREATE INDEX "orders_is_paid_idx" ON "orders"("is_paid");

-- CreateIndex
CREATE INDEX "orders_shipping_status_idx" ON "orders"("shipping_status");

-- CreateIndex
CREATE INDEX "order_items_order_id_idx" ON "order_items"("order_id");

-- CreateIndex
CREATE INDEX "order_items_product_id_idx" ON "order_items"("product_id");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_sources_name_key" ON "inventory_sources"("name");

-- CreateIndex
CREATE INDEX "inventory_transactions_product_id_date_idx" ON "inventory_transactions"("product_id", "date");

-- CreateIndex
CREATE INDEX "inventory_transactions_source_id_idx" ON "inventory_transactions"("source_id");

-- CreateIndex
CREATE INDEX "inventory_transactions_destination_id_idx" ON "inventory_transactions"("destination_id");

-- CreateIndex
CREATE UNIQUE INDEX "kegs_account_id_product_id_key" ON "kegs"("account_id", "product_id");

-- CreateIndex
CREATE INDEX "accounting_log_created_at_idx" ON "accounting_log"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "tbs_stores_store_num_key" ON "tbs_stores"("store_num");

-- CreateIndex
CREATE INDEX "tbs_sales_store_id_period_idx" ON "tbs_sales"("store_id", "period");

-- AddForeignKey
ALTER TABLE "user_accounts" ADD CONSTRAINT "user_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_accounts" ADD CONSTRAINT "user_accounts_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_account_type_id_fkey" FOREIGN KEY ("account_type_id") REFERENCES "account_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_sales_rep_id_fkey" FOREIGN KEY ("sales_rep_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_banner_id_fkey" FOREIGN KEY ("banner_id") REFERENCES "banners"("banner_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_pricing_category_id_fkey" FOREIGN KEY ("pricing_category_id") REFERENCES "pricing_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounts" ADD CONSTRAINT "accounts_delivery_inventory_source_id_fkey" FOREIGN KEY ("delivery_inventory_source_id") REFERENCES "inventory_sources"("source_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "products_parent"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "product_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "product_owners"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_factor_id_fkey" FOREIGN KEY ("factor_id") REFERENCES "product_factors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_prices" ADD CONSTRAINT "product_prices_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_prices" ADD CONSTRAINT "product_prices_pricing_category_id_fkey" FOREIGN KEY ("pricing_category_id") REFERENCES "pricing_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_inventory_source_id_fkey" FOREIGN KEY ("inventory_source_id") REFERENCES "inventory_sources"("source_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_credit_order_id_fkey" FOREIGN KEY ("credit_order_id") REFERENCES "orders"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_source_id_fkey" FOREIGN KEY ("source_id") REFERENCES "inventory_sources"("source_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_destination_id_fkey" FOREIGN KEY ("destination_id") REFERENCES "inventory_sources"("source_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kegs" ADD CONSTRAINT "kegs_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kegs" ADD CONSTRAINT "kegs_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bols" ADD CONSTRAINT "bols_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bols" ADD CONSTRAINT "bols_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bol_items" ADD CONSTRAINT "bol_items_bol_id_fkey" FOREIGN KEY ("bol_id") REFERENCES "bols"("bol_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bol_items" ADD CONSTRAINT "bol_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pickups" ADD CONSTRAINT "pickups_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pickups" ADD CONSTRAINT "pickups_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pickup_items" ADD CONSTRAINT "pickup_items_pickup_id_fkey" FOREIGN KEY ("pickup_id") REFERENCES "pickups"("pickup_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pickup_items" ADD CONSTRAINT "pickup_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_notes" ADD CONSTRAINT "call_notes_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_notes" ADD CONSTRAINT "call_notes_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "todos" ADD CONSTRAINT "todos_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "todos" ADD CONSTRAINT "todos_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_log" ADD CONSTRAINT "accounting_log_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("account_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "accounting_log" ADD CONSTRAINT "accounting_log_staff_id_fkey" FOREIGN KEY ("staff_id") REFERENCES "staff"("staff_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbs_stores" ADD CONSTRAINT "tbs_stores_banner_id_fkey" FOREIGN KEY ("banner_id") REFERENCES "banners"("banner_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbs_listings" ADD CONSTRAINT "tbs_listings_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("product_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbs_sales" ADD CONSTRAINT "tbs_sales_store_id_fkey" FOREIGN KEY ("store_id") REFERENCES "tbs_stores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

