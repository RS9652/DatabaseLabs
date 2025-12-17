CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    item_status VARCHAR(20),

    fk_owner_id INTEGER NOT NULL,
    fk_sector_id INTEGER NOT NULL,

    CONSTRAINT fk_item_owner
        FOREIGN KEY (fk_owner_id)
        REFERENCES customers(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_sector
        FOREIGN KEY (fk_sector_id)
        REFERENCES sectors(id)
        ON DELETE CASCADE
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    phone VARCHAR(100)
);

CREATE TABLE sectors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(1) NOT NULL
);
