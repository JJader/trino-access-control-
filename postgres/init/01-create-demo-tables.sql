-- Synthetic demo data for testing Trino OPA access control and column masking.
-- These scripts run automatically only when PostgreSQL initializes an empty data directory.


CREATE TABLE users (
    user_id       INTEGER PRIMARY KEY,
    mask_full_name     VARCHAR NOT NULL,
    mask_email         VARCHAR NOT NULL,
    mask_phone         VARCHAR,
    date_of_birth DATE,
    address       VARCHAR,
    national_id   VARCHAR,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions (
    transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id        INTEGER NOT NULL REFERENCES users(user_id),
    amount         NUMERIC NOT NULL,
    currency       VARCHAR NOT NULL DEFAULT 'BRL',
    transaction_type VARCHAR NOT NULL,
    merchant       VARCHAR,
    mask_card_number    VARCHAR,
    transaction_at TIMESTAMP NOT NULL,
    status         VARCHAR NOT NULL
);

CREATE TABLE user_preferences (
    preference_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          INTEGER NOT NULL REFERENCES users(user_id),
    preference_key   VARCHAR NOT NULL,
    preference_value VARCHAR,
    marketing_opt_in BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, preference_key)
);


INSERT INTO users
    (user_id, mask_full_name, mask_email, mask_phone, date_of_birth, address, national_id)
VALUES
    (1, 'Alice Johnson', 'alice@example.com', '+55-11-98765-4321', '1990-04-12', '100 Example Street, Sao Paulo', 'DEMO-ID-001'),
    (2, 'Bruno Silva', 'bruno@example.com', '+55-21-97654-3210', '1985-09-23', '200 Sample Avenue, Rio de Janeiro', 'DEMO-ID-002'),
    (3, 'Carla Santos', 'carla@example.com', '+55-31-96543-2109', '1995-01-07', '300 Test Road, Belo Horizonte', 'DEMO-ID-003'),
    (4, 'Daniel Costa', 'daniel@example.com', '+55-41-95432-1098', '1988-12-02', '400 Demo Boulevard, Curitiba', 'DEMO-ID-004'),
    (5, 'Eva Pereira', 'eva@example.com', '+55-51-94321-0987', '1992-06-18', '500 Fictional Lane, Porto Alegre', 'DEMO-ID-005');

INSERT INTO transactions
    (user_id, amount, currency, transaction_type, merchant, mask_card_number, transaction_at, status)
VALUES
    (1, 129.90, 'BRL', 'PURCHASE', 'Example Market', '4111111111', '2026-10-01 10:15:00', 'APPROVED'),
    (1, 49.50, 'BRL', 'PURCHASE', 'Demo Coffee', '4111111111', '2026-10-02 08:40:00', 'APPROVED'),
    (2, 850.00, 'BRL', 'TRANSFER', 'Internal Transfer', NULL, '2026-10-03 14:20:00', 'APPROVED'),
    (2, 220.75, 'BRL', 'PURCHASE', 'Sample Electronics', '5555554444', '2026-10-04 18:05:00', 'PENDING'),
    (3, 35.00, 'BRL', 'PURCHASE', 'Test Pharmacy', '4000000002', '2026-10-05 09:30:00', 'APPROVED'),
    (3, 1200.00, 'BRL', 'TRANSFER', 'Demo Rent', NULL, '2026-10-06 12:00:00', 'APPROVED'),
    (4, 75.25, 'BRL', 'PURCHASE', 'Example Restaurant', '4111111111', '2026-10-07 20:10:00', 'DECLINED'),
    (5, 310.40, 'BRL', 'PURCHASE', 'Demo Store', '5555554444', '2026-10-08 16:45:00', 'APPROVED');

INSERT INTO user_preferences
    (user_id, preference_key, preference_value, marketing_opt_in)
VALUES
    (1, 'language', 'en', TRUE),
    (1, 'theme', 'dark', TRUE),
    (2, 'language', 'pt-BR', FALSE),
    (2, 'theme', 'light', FALSE),
    (3, 'language', 'pt-BR', TRUE),
    (3, 'notifications', 'email', TRUE),
    (4, 'language', 'en', FALSE),
    (5, 'language', 'pt-BR', TRUE);

CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_at ON transactions(transaction_at);
CREATE INDEX idx_preferences_user_id ON user_preferences(user_id);
