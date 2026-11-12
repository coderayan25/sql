-- ORACLE SQL SOLUTIONS: PCA2 SUGGESTIONS (SETS 1-10)
-- Run each set in order in Oracle SQL Developer / SQL*Plus.
-- Oracle equivalents: NUMBER for INT/DECIMAL, VARCHAR2 for VARCHAR.
-- Each multi-row insertion uses INSERT ALL ... SELECT 1 FROM DUAL.
-- Run a set only once unless you first drop its tables and triggers.

-- =========================================================
-- SET 1: GROCERY SUPERMARKET
-- =========================================================

CREATE TABLE Grocery_Items (
    item_id NUMBER(10) PRIMARY KEY,
    item_name VARCHAR2(100),
    price NUMBER(10,2),
    stock_count NUMBER(10)
);

CREATE TABLE Members (
    member_id NUMBER(10) PRIMARY KEY,
    member_name VARCHAR2(100),
    phone VARCHAR2(20)
);

CREATE TABLE Bill_Items (
    bill_id NUMBER(10) PRIMARY KEY,
    member_id NUMBER(10),
    item_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_bill_member FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CONSTRAINT fk_bill_item FOREIGN KEY (item_id) REFERENCES Grocery_Items(item_id)
);

INSERT ALL
    INTO Grocery_Items (item_id, item_name, price, stock_count) VALUES (1, 'Rice', 60.00, 100)
    INTO Grocery_Items (item_id, item_name, price, stock_count) VALUES (2, 'Milk', 30.00, 80)
    INTO Grocery_Items (item_id, item_name, price, stock_count) VALUES (3, 'Sugar', 45.00, 70)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Members (member_id, member_name, phone) VALUES (1, 'Amit Sharma', '9876543210')
    INTO Members (member_id, member_name, phone) VALUES (2, 'Priya Das', '9876501234')
SELECT 1 FROM DUAL;

UPDATE Grocery_Items SET price = 65.00 WHERE item_id = 1;

CREATE OR REPLACE TRIGGER trg_bill_items_stock
AFTER INSERT ON Bill_Items
FOR EACH ROW
BEGIN
    UPDATE Grocery_Items
    SET stock_count = stock_count - :NEW.quantity
    WHERE item_id = :NEW.item_id;
END;
/

-- Example to test the trigger:
-- INSERT INTO Bill_Items (bill_id, member_id, item_id, quantity) VALUES (1, 1, 1, 2);
-- SELECT * FROM Grocery_Items;


-- =========================================================
-- SET 2: MOBILE PHONE HUB
-- =========================================================

CREATE TABLE Phones (
    phone_id NUMBER(10) PRIMARY KEY,
    model_name VARCHAR2(100),
    mrp NUMBER(10,2),
    units_in_stock NUMBER(10)
);

CREATE TABLE Retailers (
    retailer_id NUMBER(10) PRIMARY KEY,
    shop_name VARCHAR2(100),
    region VARCHAR2(100)
);

CREATE TABLE Phone_Orders (
    order_id NUMBER(10) PRIMARY KEY,
    retailer_id NUMBER(10),
    phone_id NUMBER(10),
    ordered_qty NUMBER(10),
    CONSTRAINT fk_phone_order_retailer FOREIGN KEY (retailer_id) REFERENCES Retailers(retailer_id),
    CONSTRAINT fk_phone_order_phone FOREIGN KEY (phone_id) REFERENCES Phones(phone_id)
);

INSERT ALL
    INTO Phones (phone_id, model_name, mrp, units_in_stock) VALUES (10, 'Galaxy A15', 18000.00, 50)
    INTO Phones (phone_id, model_name, mrp, units_in_stock) VALUES (11, 'Redmi Note 13', 16000.00, 40)
    INTO Phones (phone_id, model_name, mrp, units_in_stock) VALUES (12, 'iPhone 15', 65000.00, 25)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Retailers (retailer_id, shop_name, region) VALUES (1, 'City Mobiles', 'Kolkata')
    INTO Retailers (retailer_id, shop_name, region) VALUES (2, 'Smart Phone Store', 'Howrah')
SELECT 1 FROM DUAL;

UPDATE Phones SET mrp = mrp + 1000 WHERE phone_id = 10;

CREATE OR REPLACE TRIGGER trg_phone_orders_stock
AFTER INSERT ON Phone_Orders
FOR EACH ROW
BEGIN
    UPDATE Phones
    SET units_in_stock = units_in_stock - :NEW.ordered_qty
    WHERE phone_id = :NEW.phone_id;
END;
/

-- Example:
-- INSERT INTO Phone_Orders (order_id, retailer_id, phone_id, ordered_qty) VALUES (1, 1, 10, 2);


-- =========================================================
-- SET 3: SPORTS EQUIPMENT STORE
-- =========================================================

CREATE TABLE Sports_Gear (
    gear_id NUMBER(10) PRIMARY KEY,
    gear_name VARCHAR2(100),
    cost NUMBER(10,2),
    stock_level NUMBER(10)
);

CREATE TABLE Coaches (
    coach_id NUMBER(10) PRIMARY KEY,
    coach_name VARCHAR2(100),
    sport_specialty VARCHAR2(100)
);

CREATE TABLE Gear_Purchases (
    purchase_id NUMBER(10) PRIMARY KEY,
    coach_id NUMBER(10),
    gear_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_gear_purchase_coach FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id),
    CONSTRAINT fk_gear_purchase_gear FOREIGN KEY (gear_id) REFERENCES Sports_Gear(gear_id)
);

INSERT ALL
    INTO Sports_Gear (gear_id, gear_name, cost, stock_level) VALUES (101, 'Football', 800.00, 50)
    INTO Sports_Gear (gear_id, gear_name, cost, stock_level) VALUES (102, 'Cricket Bat', 1500.00, 30)
    INTO Sports_Gear (gear_id, gear_name, cost, stock_level) VALUES (103, 'Badminton Racket', 1200.00, 40)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Coaches (coach_id, coach_name, sport_specialty) VALUES (1, 'Rahul Sen', 'Football')
    INTO Coaches (coach_id, coach_name, sport_specialty) VALUES (2, 'Neha Roy', 'Cricket')
SELECT 1 FROM DUAL;

UPDATE Sports_Gear SET cost = 950.00 WHERE gear_id = 101;

CREATE OR REPLACE TRIGGER trg_gear_purchases_stock
AFTER INSERT ON Gear_Purchases
FOR EACH ROW
BEGIN
    UPDATE Sports_Gear
    SET stock_level = stock_level - :NEW.quantity
    WHERE gear_id = :NEW.gear_id;
END;
/

-- Note: The question says "Coach" once, but the created table is "Coaches".
-- The foreign key correctly references Coaches(coach_id).


-- =========================================================
-- SET 4: FOOTWEAR SHOWROOM
-- =========================================================

CREATE TABLE Shoes (
    shoe_id NUMBER(10) PRIMARY KEY,
    brand VARCHAR2(100),
    price NUMBER(10,2),
    inventory NUMBER(10)
);

CREATE TABLE Stores (
    store_id NUMBER(10) PRIMARY KEY,
    store_city VARCHAR2(100),
    manager_name VARCHAR2(100)
);

CREATE TABLE Shoe_Sales (
    sale_id NUMBER(10) PRIMARY KEY,
    store_id NUMBER(10),
    shoe_id NUMBER(10),
    pairs_sold NUMBER(10),
    CONSTRAINT fk_shoe_sale_store FOREIGN KEY (store_id) REFERENCES Stores(store_id),
    CONSTRAINT fk_shoe_sale_shoe FOREIGN KEY (shoe_id) REFERENCES Shoes(shoe_id)
);

INSERT ALL
    INTO Shoes (shoe_id, brand, price, inventory) VALUES (201, 'Nike', 5000.00, 60)
    INTO Shoes (shoe_id, brand, price, inventory) VALUES (202, 'Adidas', 4500.00, 50)
    INTO Shoes (shoe_id, brand, price, inventory) VALUES (203, 'Puma', 4000.00, 45)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Stores (store_id, store_city, manager_name) VALUES (1, 'Kolkata', 'Sourav Das')
    INTO Stores (store_id, store_city, manager_name) VALUES (2, 'Durgapur', 'Anita Paul')
SELECT 1 FROM DUAL;

-- Festive discount of 10% on shoe_id 202:
UPDATE Shoes SET price = price * 0.90 WHERE shoe_id = 202;

CREATE OR REPLACE TRIGGER trg_shoe_sales_inventory
AFTER INSERT ON Shoe_Sales
FOR EACH ROW
BEGIN
    UPDATE Shoes
    SET inventory = inventory - :NEW.pairs_sold
    WHERE shoe_id = :NEW.shoe_id;
END;
/

-- =========================================================
-- SET 5: COSMETIC & SKINCARE STORE
-- =========================================================

CREATE TABLE Cosmetics (
    product_id NUMBER(10) PRIMARY KEY,
    item_name VARCHAR2(100),
    price NUMBER(10,2),
    available_stock NUMBER(10)
);

CREATE TABLE Clients (
    client_id NUMBER(10) PRIMARY KEY,
    client_name VARCHAR2(100),
    email VARCHAR2(150)
);

CREATE TABLE Cosmetic_Orders (
    order_id NUMBER(10) PRIMARY KEY,
    client_id NUMBER(10),
    product_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_cosmetic_order_client FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    CONSTRAINT fk_cosmetic_order_product FOREIGN KEY (product_id) REFERENCES Cosmetics(product_id)
);

INSERT ALL
    INTO Cosmetics (product_id, item_name, price, available_stock) VALUES (5, 'Face Wash', 250.00, 100)
    INTO Cosmetics (product_id, item_name, price, available_stock) VALUES (6, 'Moisturizer', 400.00, 80)
    INTO Cosmetics (product_id, item_name, price, available_stock) VALUES (7, 'Sunscreen', 550.00, 60)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Clients (client_id, client_name, email) VALUES (1, 'Riya Sen', 'riya@example.com')
    INTO Clients (client_id, client_name, email) VALUES (2, 'Arjun Roy', 'arjun@example.com')
SELECT 1 FROM DUAL;

UPDATE Cosmetics SET price = 275.00 WHERE product_id = 5;

CREATE OR REPLACE TRIGGER trg_cosmetic_orders_stock
AFTER INSERT ON Cosmetic_Orders
FOR EACH ROW
BEGIN
    UPDATE Cosmetics
    SET available_stock = available_stock - :NEW.quantity
    WHERE product_id = :NEW.product_id;
END;
/

-- =========================================================
-- SET 6: STATIONERY & BOOK STORE
-- =========================================================

CREATE TABLE Stationery_Items (
    item_id NUMBER(10) PRIMARY KEY,
    item_name VARCHAR2(100),
    unit_price NUMBER(10,2),
    stock_qty NUMBER(10)
);

CREATE TABLE Vendors (
    vendor_id NUMBER(10) PRIMARY KEY,
    vendor_name VARCHAR2(100),
    contact_no VARCHAR2(20)
);

CREATE TABLE Stationery_Sales (
    sale_id NUMBER(10) PRIMARY KEY,
    vendor_id NUMBER(10),
    item_id NUMBER(10),
    sold_qty NUMBER(10),
    CONSTRAINT fk_stationery_sale_vendor FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id),
    CONSTRAINT fk_stationery_sale_item FOREIGN KEY (item_id) REFERENCES Stationery_Items(item_id)
);

INSERT ALL
    INTO Stationery_Items (item_id, item_name, unit_price, stock_qty) VALUES (301, 'Notebook', 50.00, 200)
    INTO Stationery_Items (item_id, item_name, unit_price, stock_qty) VALUES (302, 'Pen', 10.00, 300)
    INTO Stationery_Items (item_id, item_name, unit_price, stock_qty) VALUES (303, 'Pencil', 5.00, 250)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Vendors (vendor_id, vendor_name, contact_no) VALUES (1, 'ABC Suppliers', '9876543210')
    INTO Vendors (vendor_id, vendor_name, contact_no) VALUES (2, 'National Stationers', '9876501234')
SELECT 1 FROM DUAL;

UPDATE Stationery_Items SET unit_price = 55.00 WHERE item_id = 301;

CREATE OR REPLACE TRIGGER trg_stationery_sales_stock
AFTER INSERT ON Stationery_Sales
FOR EACH ROW
BEGIN
    UPDATE Stationery_Items
    SET stock_qty = stock_qty - :NEW.sold_qty
    WHERE item_id = :NEW.item_id;
END;
/

-- =========================================================
-- SET 7: HOME APPLIANCE OUTLET
-- =========================================================

CREATE TABLE Appliances (
    appliance_id NUMBER(10) PRIMARY KEY,
    appliance_name VARCHAR2(100),
    price NUMBER(10,2),
    stock_units NUMBER(10)
);

CREATE TABLE Branches (
    branch_id NUMBER(10) PRIMARY KEY,
    branch_location VARCHAR2(100),
    manager VARCHAR2(100)
);

CREATE TABLE Appliance_Orders (
    order_id NUMBER(10) PRIMARY KEY,
    branch_id NUMBER(10),
    appliance_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_appliance_order_branch FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
    CONSTRAINT fk_appliance_order_appliance FOREIGN KEY (appliance_id) REFERENCES Appliances(appliance_id)
);

INSERT ALL
    INTO Appliances (appliance_id, appliance_name, price, stock_units) VALUES (40, 'Refrigerator', 25000.00, 20)
    INTO Appliances (appliance_id, appliance_name, price, stock_units) VALUES (41, 'Washing Machine', 18000.00, 15)
    INTO Appliances (appliance_id, appliance_name, price, stock_units) VALUES (42, 'Microwave Oven', 8000.00, 25)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Branches (branch_id, branch_location, manager) VALUES (1, 'Kolkata', 'Amit Ghosh')
    INTO Branches (branch_id, branch_location, manager) VALUES (2, 'Howrah', 'Pooja Nair')
SELECT 1 FROM DUAL;

-- Increase price by 5% to account for new taxes:
UPDATE Appliances SET price = price * 1.05 WHERE appliance_id = 40;

CREATE OR REPLACE TRIGGER trg_appliance_orders_stock
AFTER INSERT ON Appliance_Orders
FOR EACH ROW
BEGIN
    UPDATE Appliances
    SET stock_units = stock_units - :NEW.quantity
    WHERE appliance_id = :NEW.appliance_id;
END;
/

-- =========================================================
-- SET 8: PET SUPPLIES SHOP
-- =========================================================

CREATE TABLE Pet_Products (
    product_id NUMBER(10) PRIMARY KEY,
    product_name VARCHAR2(100),
    price NUMBER(10,2),
    stock NUMBER(10)
);

CREATE TABLE Pet_Owners (
    owner_id NUMBER(10) PRIMARY KEY,
    owner_name VARCHAR2(100),
    pet_type VARCHAR2(50)
);

CREATE TABLE Pet_Purchases (
    purchase_id NUMBER(10) PRIMARY KEY,
    owner_id NUMBER(10),
    product_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_pet_purchase_owner FOREIGN KEY (owner_id) REFERENCES Pet_Owners(owner_id),
    CONSTRAINT fk_pet_purchase_product FOREIGN KEY (product_id) REFERENCES Pet_Products(product_id)
);

INSERT ALL
    INTO Pet_Products (product_id, product_name, price, stock) VALUES (7, 'Dog Food', 700.00, 50)
    INTO Pet_Products (product_id, product_name, price, stock) VALUES (8, 'Cat Litter', 400.00, 40)
    INTO Pet_Products (product_id, product_name, price, stock) VALUES (9, 'Pet Shampoo', 250.00, 30)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Pet_Owners (owner_id, owner_name, pet_type) VALUES (1, 'Karan Mehta', 'Dog')
    INTO Pet_Owners (owner_id, owner_name, pet_type) VALUES (2, 'Mira Bose', 'Cat')
SELECT 1 FROM DUAL;

UPDATE Pet_Products SET price = 650.00 WHERE product_id = 7;

CREATE OR REPLACE TRIGGER trg_pet_purchases_stock
AFTER INSERT ON Pet_Purchases
FOR EACH ROW
BEGIN
    UPDATE Pet_Products
    SET stock = stock - :NEW.quantity
    WHERE product_id = :NEW.product_id;
END;
/

-- =========================================================
-- SET 9: PHARMACY STORE
-- =========================================================

CREATE TABLE Medicines (
    med_id NUMBER(10) PRIMARY KEY,
    med_name VARCHAR2(100),
    price NUMBER(10,2),
    stock_count NUMBER(10)
);

CREATE TABLE Patients (
    patient_id NUMBER(10) PRIMARY KEY,
    patient_name VARCHAR2(100),
    age NUMBER(3)
);

CREATE TABLE Prescription_Sales (
    sale_id NUMBER(10) PRIMARY KEY,
    patient_id NUMBER(10),
    med_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_prescription_patient FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    CONSTRAINT fk_prescription_medicine FOREIGN KEY (med_id) REFERENCES Medicines(med_id)
);

INSERT ALL
    INTO Medicines (med_id, med_name, price, stock_count) VALUES (50, 'Paracetamol', 20.00, 200)
    INTO Medicines (med_id, med_name, price, stock_count) VALUES (51, 'Cetirizine', 30.00, 150)
    INTO Medicines (med_id, med_name, price, stock_count) VALUES (52, 'Antacid', 45.00, 100)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Patients (patient_id, patient_name, age) VALUES (1, 'Rahul Das', 25)
    INTO Patients (patient_id, patient_name, age) VALUES (2, 'Sneha Roy', 32)
SELECT 1 FROM DUAL;

UPDATE Medicines SET price = 25.00 WHERE med_id = 50;

CREATE OR REPLACE TRIGGER trg_prescription_sales_stock
AFTER INSERT ON Prescription_Sales
FOR EACH ROW
BEGIN
    UPDATE Medicines
    SET stock_count = stock_count - :NEW.quantity
    WHERE med_id = :NEW.med_id;
END;
/

-- =========================================================
-- SET 10: HARDWARE & TOOLS STORE
-- =========================================================

CREATE TABLE Tools (
    tool_id NUMBER(10) PRIMARY KEY,
    tool_name VARCHAR2(100),
    unit_cost NUMBER(10,2),
    stock_quantity NUMBER(10)
);

CREATE TABLE Contractors (
    contractor_id NUMBER(10) PRIMARY KEY,
    contractor_name VARCHAR2(100),
    company VARCHAR2(100)
);

CREATE TABLE Tool_Orders (
    order_id NUMBER(10) PRIMARY KEY,
    contractor_id NUMBER(10),
    tool_id NUMBER(10),
    quantity NUMBER(10),
    CONSTRAINT fk_tool_order_contractor FOREIGN KEY (contractor_id) REFERENCES Contractors(contractor_id),
    CONSTRAINT fk_tool_order_tool FOREIGN KEY (tool_id) REFERENCES Tools(tool_id)
);

INSERT ALL
    INTO Tools (tool_id, tool_name, unit_cost, stock_quantity) VALUES (99, 'Hammer', 500.00, 60)
    INTO Tools (tool_id, tool_name, unit_cost, stock_quantity) VALUES (100, 'Screwdriver Set', 350.00, 45)
    INTO Tools (tool_id, tool_name, unit_cost, stock_quantity) VALUES (101, 'Drill Machine', 2500.00, 20)
SELECT 1 FROM DUAL;

INSERT ALL
    INTO Contractors (contractor_id, contractor_name, company) VALUES (1, 'Vikram Singh', 'BuildWell Ltd')
    INTO Contractors (contractor_id, contractor_name, company) VALUES (2, 'Sanjay Kumar', 'SafeBuild Co')
SELECT 1 FROM DUAL;

UPDATE Tools SET unit_cost = 450.00 WHERE tool_id = 99;

CREATE OR REPLACE TRIGGER trg_tool_orders_stock
AFTER INSERT ON Tool_Orders
FOR EACH ROW
BEGIN
    UPDATE Tools
    SET stock_quantity = stock_quantity - :NEW.quantity
    WHERE tool_id = :NEW.tool_id;
END;
/

-- =========================================================
-- OPTIONAL VERIFICATION EXAMPLES
-- Uncomment and run the relevant statements after creating
-- the tables and triggers for a set.
-- =========================================================
-- INSERT INTO Bill_Items (bill_id, member_id, item_id, quantity) VALUES (1, 1, 1, 2);
-- SELECT item_id, item_name, stock_count FROM Grocery_Items;
-- COMMIT;
