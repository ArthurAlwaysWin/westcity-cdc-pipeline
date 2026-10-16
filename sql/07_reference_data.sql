\connect core_banking

INSERT INTO branch (bsb, branch_name, state) VALUES
    ('936000', 'Perth (Head Office)', 'WA'),
    ('932000', 'Sydney CBD',          'NSW'),
    ('932150', 'Parramatta',          'NSW'),
    ('932600', 'Canberra',            'ACT'),
    ('933000', 'Melbourne CBD',       'VIC'),
    ('934000', 'Brisbane CBD',        'QLD'),
    ('935000', 'Adelaide',            'SA'),
    ('935800', 'Darwin',              'NT'),
    ('937000', 'Hobart',              'TAS');

INSERT INTO product (product_code, product_name, product_type, monthly_fee, interest_rate) VALUES
    ('EVERYDAY', 'Everyday Account', 'TRANSACTION',  0.00, 0.00),
    ('SAVINGS',  'Bonus Saver',      'SAVINGS',      0.00, 4.50),
    ('STUDENT',  'Student Account',  'TRANSACTION',  0.00, 0.00),
    ('PREMIUM',  'Premium Account',  'TRANSACTION', 15.00, 0.50);

CREATE EXTENSION postgres_fdw;
CREATE SERVER identity_fraud_server FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (dbname 'identity_fraud');
CREATE USER MAPPING FOR westcity_admin SERVER identity_fraud_server
    OPTIONS (user 'westcity_admin', password 'lab_admin');
CREATE SCHEMA identity_fraud;
IMPORT FOREIGN SCHEMA public LIMIT TO (risk_assessment)
    FROM SERVER identity_fraud_server INTO identity_fraud;

\connect identity_fraud

INSERT INTO device (device_fingerprint)
SELECT md5('ring-device-' || ring)                                       -- hashed, like every fingerprint
FROM generate_series(1, 4) AS ring;

\connect loyalty

INSERT INTO loyalty_offer (product_code, bonus_points) VALUES
    ('EVERYDAY', 5000),
    ('SAVINGS',  3000),
    (NULL,       1000);
