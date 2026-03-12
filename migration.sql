BEGIN;

-- 1. Add merchant_id column
ALTER TABLE transactions
ADD COLUMN merchant_id BIGINT;

-- 2. Insert missing merchants from transactions
-- Apply exact normalization to merchant_normalized
INSERT INTO merchant_mcc_cache (
    merchant_normalized,
    merchant_original,
    mcc_code,
    mcc_description
)
SELECT DISTINCT
    trim(regexp_replace(replace(upper(merchant), ' ', ''), '[^A-Z0-9]', '', 'g')) AS merchant_normalized,
    merchant AS merchant_original,
    mcc_code,
    category AS mcc_description
FROM transactions t
WHERE merchant IS NOT NULL
AND NOT EXISTS (
    SELECT 1
    FROM merchant_mcc_cache m
    WHERE m.merchant_original = t.merchant
);

-- 3. Map transactions → merchant_id based on exact merchant_original
UPDATE transactions t
SET merchant_id = m.id
FROM merchant_mcc_cache m
WHERE t.merchant = m.merchant_original;

-- 4. Create index for fast joins
CREATE INDEX IF NOT EXISTS idx_transactions_merchant_id
ON transactions(merchant_id);

-- 5. Add foreign key constraint
ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_merchant
FOREIGN KEY (merchant_id)
REFERENCES merchant_mcc_cache(id);

-- 6. Add MCC reference table for static local lookup
CREATE TABLE IF NOT EXISTS mcc_reference (
    mcc TEXT PRIMARY KEY,
    edited_description TEXT,
    combined_description TEXT,
    usda_description TEXT,
    irs_description TEXT,
    irs_reportable TEXT
);

-- Optional: load full MCC CSV only when file is available in the DB container.
-- If not available, skip these two lines.
TRUNCATE TABLE mcc_reference;
COPY mcc_reference (mcc, edited_description, combined_description, usda_description, irs_description, irs_reportable)
FROM '/mcc/mcclist.csv' WITH (FORMAT csv, HEADER true);


CREATE INDEX IF NOT EXISTS idx_mcc_reference_mcc
ON mcc_reference(mcc);

-- 7. Enable extension for similarity search
CREATE EXTENSION IF NOT EXISTS pg_trgm;
COMMIT;
