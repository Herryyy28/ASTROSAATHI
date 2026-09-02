-- ========================================================
-- ASTROSAATHI LOCAL READABLE SQL DATABASE DUMP
-- Open this file directly in any text editor to view your data!
-- ========================================================

-- TABLE: users
-- Contains user accounts, emails, Firebase UIDs, and Auth Provider (Google / Email Password)
CREATE TABLE IF NOT EXISTS users (
  id VARCHAR PRIMARY KEY,
  firebaseUid VARCHAR UNIQUE,
  email VARCHAR UNIQUE,
  authProvider VARCHAR DEFAULT 'GOOGLE', -- 'GOOGLE' or 'EMAIL_PASSWORD'
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: user_profiles
-- Contains Kundli birth details, coordinates, and preferences
CREATE TABLE IF NOT EXISTS user_profiles (
  id VARCHAR PRIMARY KEY,
  name VARCHAR,
  dob DATETIME,
  birthTime VARCHAR,
  birthLatitude FLOAT,
  birthLongitude FLOAT,
  birthTimeZone VARCHAR,
  focusWeights TEXT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLE: audit_blocks
-- Contains immutable ledger of sign-ins (Google vs Email/Password) and payments
CREATE TABLE IF NOT EXISTS audit_blocks (
  id VARCHAR PRIMARY KEY,
  blockIndex INTEGER,
  actionType VARCHAR,
  dataPayload TEXT,
  previousHash VARCHAR,
  hash VARCHAR,
  nonce INTEGER,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- SAMPLE / EXPORTED RECENT RECORDS
INSERT INTO audit_blocks (blockIndex, actionType, dataPayload, previousHash, hash, nonce, timestamp) 
VALUES (0, 'GOOGLE_SIGNIN_SUCCESS', '{"userId":"goog_123","email":"dev@astrosaathi.com","authProvider":"GOOGLE"}', '0000000000000000000000000000000000000000000000000000000000000000', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 0, CURRENT_TIMESTAMP);

INSERT INTO audit_blocks (blockIndex, actionType, dataPayload, previousHash, hash, nonce, timestamp) 
VALUES (1, 'EMAIL_PASSWORD_SIGNIN_SUCCESS', '{"userId":"usr_456","email":"user@astrosaathi.com","authProvider":"EMAIL_PASSWORD"}', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'a4c59d72138e91024bcda774128f9936104bc123049182941029310491820491', 1, CURRENT_TIMESTAMP);
