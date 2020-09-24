#Create database and declare it for use
CREATE DATABASE rustitems;

USE rustitems;

#Create initial tables for resources, components, categories, construction, weapons, attire, explosives, food, and tools
CREATE TABLE resources(
	resource_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    resource_name VARCHAR(100) NOT NULL);
    
CREATE TABLE components(
	component_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    component_name VARCHAR(100) NOT NULL);
    
CREATE TABLE categories(
	category_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL);

CREATE TABLE construction(
	construction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    decay_time DOUBLE NOT NULL,
    health INT NOT NULL);

CREATE TABLE weapons(
	weapon_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    weapon_damage INT NOT NULL,
    weapon_rate_of_fire DOUBLE NOT NULL,
    weapon_aim_cone DOUBLE NOT NULL,
    weapon_capacity INT NOT NULL,
    weapon_reload_speed DOUBLE NOT NULL,
    weapon_draw_speed DOUBLE NOT NULL);

CREATE TABLE attire(
	attire_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    projectile_protection INT NOT NULL,
    melee_protection INT NOT NULL,
    bite_protection INT NOT NULL,
    radiation_protection INT NOT NULL,
    cold_protection INT NOT NULL);
    
CREATE TABLE explosives(
	explosive_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    explosive_damage INT NOT NULL,
    explosive_radius INT NOT NULL,
    explosive_delay INT NOT NULL);
    
CREATE TABLE food(
	food_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    food_calories INT NOT NULL,
    food_hydration INT NOT NULL,
    food_health INT NOT NULL);
    
CREATE TABLE tools(
	tool_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    tool_damage INT NOT NULL,
    tool_attack_speed INT NOT NULL,
    tool_range DOUBLE NOT NULL,
    tool_draw_speed DOUBLE NOT NULL,
    tool_throwable BOOLEAN NOT NULL);


#Create stats table and create relationships between itself and all item types
CREATE TABLE stats(
	stat_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    fk_construction_stat_id INT,
    fk_weapon_stat_id INT,
    fk_attire_stat_id INT,
    fk_explosive_stat_id INT,
    fk_food_stat_id INT,
    fk_tool_stat_id INT,
    FOREIGN KEY(fk_construction_stat_id)
    REFERENCES construction(construction_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_weapon_stat_id)
    REFERENCES weapons(weapon_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_attire_stat_id)
    REFERENCES attire(attire_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_explosive_stat_id)
    REFERENCES explosives(explosive_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_food_stat_id)
    REFERENCES food(food_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_tool_stat_id)
    REFERENCES tools(tool_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

#Create items table and link it to stats and categories
CREATE TABLE items(
	item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    fk_item_category_id INT NOT NULL,
    fk_stat_id INT,
    FOREIGN KEY(fk_item_category_id)
    REFERENCES categories(category_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_stat_id)
    REFERENCES stats(stat_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

#Create junction tables for item's crafting cost and recycling output
CREATE TABLE item_recipe_components(
	fk_item_id INT NOT NULL,
    fk_component_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY(fk_item_id)
    REFERENCES items(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_component_id)
    REFERENCES components(component_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
CREATE TABLE item_recycle_components(
	fk_item_id INT NOT NULL,
	fk_component_id INT NOT NULL,
	quantity INT NOT NULL,
	chance INT NOT NULL,
	FOREIGN KEY(fk_item_id)
    REFERENCES items(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_component_id)
    REFERENCES components(component_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
CREATE TABLE item_recipe_resources(
	fk_item_id INT NOT NULL,
    fk_resource_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY(fk_item_id)
    REFERENCES items(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_resource_id)
    REFERENCES resources(resource_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
CREATE TABLE item_recycle_resources(
	fk_item_id INT NOT NULL,
    fk_resource_id INT NOT NULL,
    quantity INT NOT NULL,
    chance INT NOT NULL,
    FOREIGN KEY(fk_item_id)
    REFERENCES items(item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(fk_resource_id)
    REFERENCES resources(resource_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

#Populate tables
INSERT INTO categories
(category_id, category_name)
VALUES
(1, 'Weapons'),
(2, 'Construction'),
(3, 'Deployables'),
(4, 'Attire'),
(5, 'Tools'),
(6, 'Explosives'),
(7, 'Food'),
(8, 'Ammo'),
(9, 'Traps'),
(10, 'Misc'),
(11, 'Electrical'),
(12, 'Fun');

INSERT INTO resources
(resource_id, resource_name)
VALUES
(1, 'Wood'),
(2, 'Stone'),
(3, 'Metal Fragments'),
(4, 'Sulfur'),
(5, 'Scrap'),
(6, 'Bone Fragments'),
(7, 'Low Grade Fuel'),
(8, 'Animal Fat'),
(9, 'Leather'),
(10, 'High Quality Metal'),
(11, 'CCTV Camera'),
(12, 'Targeting Computer'),
(13, 'Wolf Skull'),
(14, 'Cloth');

INSERT INTO components
(component_id, component_name)
VALUES
(1, 'Metal Blade'),
(2, 'Metal Pipe'),
(3, 'Metal Spring'),
(4, 'Rope'),
(5, 'Sewing Kit'),
(6, 'Road Signs'),
(7, 'Rifle Body'),
(8, 'SMG Body'),
(9, 'Semi Auto Body'),
(10, 'Tarp'),
(11, 'Tech Trash'),
(12, 'Empty Propane Tank'),
(13, 'Sheet Metal');

INSERT INTO weapons
(weapon_id, weapon_damage, weapon_rate_of_fire, weapon_aim_cone, weapon_capacity, weapon_reload_speed, weapon_draw_speed)
VALUES
#Bolt
(1, 80, 35, 0, 4, 5, 1),
#Custom
(2, 30, 600, .5, 24, 4, 1),
#LR
(3, 40, 500, .2, 30, 4, 2),
#M92
(4, 45, 400, 1, 15, 2.2, .5),
#M39
(5, 50, 300, .1, 20, 3.25, 1),
#L96
(6, 80, 23, 0, 5, 3, 1),
#Revolver
(7, 35, 343, .75, 8, 3.4, .5),
#Semi Pistol
(8, 40, 400, .75, 10, 2.9, .5),
#Semi Rifle
(9, 37, 462, .5, 20, 4, 1),
#Thompson
(10, 40, 343, .25, 16, 4.4, 1.6);

INSERT INTO attire
(attire_id, projectile_protection, melee_protection, bite_protection, radiation_protection, cold_protection)
VALUES
#Boots
(1, 10, 10, 3, 3, 8),
#Metal Facemask
(2, 50, 70, 8, -4, 8),
#Hoodie
(3, 15, 15, 6, 5, 8),
#Bandana
(4, 5, 10, 3, 3, 10),
#Coffee Can
(5, 35, 50, 8, 5, 8),
#Pants
(6, 15, 15, 3, 5, 8),
#Roadsign Gloves
(7, 10, 15, 10, 0, -8),
#Wolf Headdress
(8, 30, 60, 10, 4, 6),
#Wood Pants
(9, 10, 40, 5, 5, 0),
#Wood Chest
(10, 10, 40, 5, 5, 0);


INSERT INTO explosives
(explosive_id, explosive_damage, explosive_radius, explosive_delay)
VALUES
#Satchel
(1, 475, 4, 6),
#C4
(2, 550, 4, 10),
#Survey Charge
(3, 20, 5, 5),
#HE Grenade
(4, 125, 5, 9),
#Explosive 556
(5, 4, 3, 10),
#Rocket
(6, 350, 3.8, 9),
#Hi vi rocket
(7, 480, 3, 9),
#F1
(8, 225, 6, 3),
#Beancan
(9, 115, 5, 4),
#Incendary Rocket
(10, 25, 5, 9);

INSERT INTO construction
(construction_id, decay_time, health)
VALUES
#Tool Cupboard
(1, 48, 100), 
#Reinforced Window
(2, 12, 500),
#Metal Embrasure
(3, 8, 750),
#Shop Front
(4, 8, 500), 
#Chainlink Fence
(5, 8, 75),
#Sheet Metal Door
(6, 8, 250),
#Armored Door
(7, 12, 800),
#High External Stone Wall
(8, 8, 500),
#Garage Door
(9, 8, 600),
#Wood Door
(10, 3, 200);

INSERT INTO food
(food_id, food_calories, food_hydration, food_health)
VALUES
#Apple
(1, 30, 15, 2),
#Black Raspberry
(2, 40, 20, 10),
#Blueberry
(3, 30, 20, 10),
#Chocolate bar
(4, 100, 1, 2),
#Granola Bar
(5, 60, 0, 5),
#Mushroom
(6, 15, 5, 3),
#Potato
(7, 125, 5, 6),
#Corn
(8, 75, 10, 6),
#Pumpkin
(9, 100, 30, 10),
#Pickles
(10, 50, 20, 5);

INSERT INTO tools
(tool_id, tool_damage, tool_attack_speed, tool_range, tool_draw_speed, tool_throwable)
VALUES
#Bone club
(1, 12, 86, 1.5, 1, true),
#Salvaged axe
(2, 40, 48, 1.5, 1, true),
#Pickaxe
(3, 30, 40, 1.5, 1, true),
#Salvaged hammer
(4, 30, 60, 1.5, 1, true),
#Stone Hatchet
(5, 15, 67, 1.5, 1, true),
#Chainsaw
(6, 12, 300, 1.5, 1, false),
#Hatchet
(7, 25, 67, 1.5, 1, true),
#Salvaged Icepick
(8, 40, 48, 1.5, 1, true),
#Stone pickaxe
(9, 17, 67, 1.5, 1, true),
#rock
(10, 10, 46, 1.25, 1, true);

#After typing the following insert query, I realized I could do seperate insert statements without typing all of the nulls, but frankly I do not want to retype it
INSERT INTO stats
(stat_id, fk_construction_stat_id, fk_weapon_stat_id, fk_attire_stat_id, fk_explosive_stat_id, fk_food_stat_id, fk_tool_stat_id)
VALUES
(1, NULL, 1, NULL, NULL, NULL, NULL),
(2, NULL, 2, NULL, NULL, NULL, NULL),
(3, NULL, 3, NULL, NULL, NULL, NULL),
(4, NULL, 4, NULL, NULL, NULL, NULL),
(5, NULL, 5, NULL, NULL, NULL, NULL),
(6, NULL, 6, NULL, NULL, NULL, NULL),
(7, NULL, 7, NULL, NULL, NULL, NULL),
(8, NULL, 8, NULL, NULL, NULL, NULL),
(9, NULL, 9, NULL, NULL, NULL, NULL),
(10, NULL, 10, NULL, NULL, NULL, NULL),
(11, NULL, NULL, 1, NULL, NULL, NULL),
(12, NULL, NULL, 2, NULL, NULL, NULL),
(13, NULL, NULL, 3, NULL, NULL, NULL),
(14, NULL, NULL, 4, NULL, NULL, NULL),
(15, NULL, NULL, 5, NULL, NULL, NULL),
(16, NULL, NULL, 6, NULL, NULL, NULL),
(17, NULL, NULL, 7, NULL, NULL, NULL),
(18, NULL, NULL, 8, NULL, NULL, NULL),
(19, NULL, NULL, 9, NULL, NULL, NULL),
(20, NULL, NULL, 10, NULL, NULL, NULL),
(21, 1, NULL, NULL, NULL, NULL, NULL),
(22, 2, NULL, NULL, NULL, NULL, NULL),
(23, 3, NULL, NULL, NULL, NULL, NULL),
(24, 4, NULL, NULL, NULL, NULL, NULL),
(25, 5, NULL, NULL, NULL, NULL, NULL),
(26, 6, NULL, NULL, NULL, NULL, NULL),
(27, 7, NULL, NULL, NULL, NULL, NULL),
(28, 8, NULL, NULL, NULL, NULL, NULL),
(29, 9, NULL, NULL, NULL, NULL, NULL),
(30, 10, NULL, NULL, NULL, NULL, NULL),
(31, NULL, NULL, NULL, 1, NULL, NULL),
(32, NULL, NULL, NULL, 2, NULL, NULL),
(33, NULL, NULL, NULL, 3, NULL, NULL),
(34, NULL, NULL, NULL, 4, NULL, NULL),
(35, NULL, NULL, NULL, 5, NULL, NULL),
(36, NULL, NULL, NULL, 6, NULL, NULL),
(37, NULL, NULL, NULL, 7, NULL, NULL),
(38, NULL, NULL, NULL, 8, NULL, NULL),
(39, NULL, NULL, NULL, 9, NULL, NULL),
(40, NULL, NULL, NULL, 10, NULL, NULL),
(41, NULL, NULL, NULL, NULL, 1, NULL),
(42, NULL, NULL, NULL, NULL, 2, NULL),
(43, NULL, NULL, NULL, NULL, 3, NULL),
(44, NULL, NULL, NULL, NULL, 4, NULL),
(45, NULL, NULL, NULL, NULL, 5, NULL),
(46, NULL, NULL, NULL, NULL, 6, NULL),
(47, NULL, NULL, NULL, NULL, 7, NULL),
(48, NULL, NULL, NULL, NULL, 8, NULL),
(49, NULL, NULL, NULL, NULL, 9, NULL),
(50, NULL, NULL, NULL, NULL, 10, NULL),
(51, NULL, NULL, NULL, NULL, NULL, 1),
(52, NULL, NULL, NULL, NULL, NULL, 2),
(53, NULL, NULL, NULL, NULL, NULL, 3),
(54, NULL, NULL, NULL, NULL, NULL, 4),
(55, NULL, NULL, NULL, NULL, NULL, 5),
(56, NULL, NULL, NULL, NULL, NULL, 6),
(57, NULL, NULL, NULL, NULL, NULL, 7),
(58, NULL, NULL, NULL, NULL, NULL, 8),
(59, NULL, NULL, NULL, NULL, NULL, 9),
(60, NULL, NULL, NULL, NULL, NULL, 10);


INSERT INTO items
(item_id, item_name, fk_item_category_id, fk_stat_id)
VALUES
(1, 'Bolt Action Rifle', 1, 1),
(2, 'Custom SMG', 1, 2),
(3, 'LR-300 Assault Rifle', 1, 3),
(4, 'M92 Pistol', 1, 4),
(5, 'M39 Rifle', 1, 5),
(6, 'L96 Sniper Rifle', 1, 6),
(7, 'Revolver', 1, 7),
(8, 'Semi-automatic Pistol', 1, 8),
(9, 'Semi-automatic Rifle', 1, 9),
(10, 'Thompson', 1, 10),
(11, 'Boots', 4, 11),
(12, 'Metal Facemask', 4, 12),
(13, 'Hoodie', 4, 13),
(14, 'Coffe Can Helmet', 4, 14),
(15, 'Bandana', 4, 15),
(16, 'Pants', 4, 16),
(17, 'Roadsign Gloves', 4, 17),
(18, 'Wolf Headdress', 4, 18),
(19, 'Wood Armor Pants', 4, 19),
(20, 'Wood Armor Chestplate', 4, 20),
(21, 'Tool Cupboard', 2, 21),
(22, 'Reinforced Glass Window', 2, 22),
(23, 'Metal Vertical Embrasure', 2, 23),
(24, 'Shop Front Window', 2, 24),
(25, 'Chainlink Fence', 2, 25),
(26, 'Sheet Metal Door', 2, 26),
(27, 'Armored Door', 2, 27),
(28, 'High External Stone Wall', 2, 28),
(29, 'Garage Door', 2, 29),
(30, 'Wooden Door', 2, 30),
(31, 'Satchel Charge', 6, 31),
(32, 'Timed Explosive Charge', 6, 32),
(33, 'Survey Charge', 6, 33),
(34, '40mm HE Grenade', 6, 34),
(35, 'Explosive 556 Rifle Ammo', 6, 35),
(36, 'Rocket', 6, 36),
(37, 'High Velocity Rocekt', 6, 37),
(38, 'F1 Grenade', 6, 38),
(39, 'Beancan Grenade', 6, 39),
(40, 'Incendiary Rocket', 6, 40),
(41, 'Apple', 7, 41),
(42, 'Black Raspberry', 7, 42),
(43, 'Blueberry', 7, 43),
(44, 'Chocolate Bar', 7, 44),
(45, 'Granola Bar', 7, 45),
(46, 'Mushroom', 7, 46),
(47, 'Potato', 7, 47),
(48, 'Corn', 7, 48),
(49, 'Pumpkin', 7, 49),
(50, 'Pickles', 7, 50),
(51, 'Bone Club', 5, 51),
(52, 'Salvaged Axe', 5, 52),
(53, 'Pickaxe', 5, 53),
(54, 'Salvaged Hammer', 5, 54),
(55, 'Stone Hatchet', 5, 55),
(56, 'Chainsaw', 5, 56),
(57, 'Hatchet', 5, 57),
(58, 'Salvaged Icepick', 5, 58),
(59, 'Stone Pickaxe', 5, 59),
(60, 'Rock', 5, 60);

#Populate junction tables containing crafting recipes. Some items require resources and components, only resources, or only components
INSERT INTO item_recipe_components
(fk_item_id, fk_component_id, quantity)
VALUES
(9, 9, 1),
(9, 3, 1),
(2, 3, 1),
(2, 8, 1),
(11, 5, 1),
(13, 5, 1),
(12, 5, 6),
(8, 9, 1),
(8, 2, 1),
(58, 2, 1),
(58, 1, 5);

INSERT INTO item_recipe_resources
(fk_item_id, fk_resource_id, quantity)
VALUES
(9, 3, 450),
(9, 10, 4),
(2, 10, 8),
(11, 3, 15),
(11, 9, 20),
(13, 14, 80),
(12, 9, 50),
(12, 10, 15),
(8, 10, 4),
(26, 3, 150);

#Populate junction tables for recycle yields. Recycling can yield items at a percent chance, even resources. However in this case with the items I used, all resources drop with 100% certianty 
INSERT INTO item_recycle_components
(fk_item_id, fk_component_id, quantity, chance)
VALUES
(9, 9, 1, 50),
(9, 3, 1, 50),
(2, 3, 1, 50),
(2, 8, 1, 50),
(11, 5, 1, 50),
(13, 5, 1, 50),
(12, 5, 3, 100),
(8, 9, 1, 50),
(8, 2, 1, 50),
(58, 1, 3, 100),
(58, 2, 1, 50);

INSERT INTO item_recycle_resources
(fk_item_id, fk_resource_id, quantity, chance)
VALUES
(9, 3, 225, 100),
(9, 10, 2, 100),
(2, 10, 4, 100),
(11, 9, 10, 100),
(11, 3, 8, 100),
(13, 14, 40, 100),
(12, 9, 25, 100),
(12, 10, 8, 100),
(8, 10, 2, 100),
(26, 3, 75, 100);

#Query 1
SELECT * FROM components;

#Query 2
SELECT item_name, resource_name, quantity FROM items
INNER JOIN item_recipe_resources
ON item_id = fk_item_id
INNER JOIN resources 
ON resource_id = fk_resource_id
WHERE item_name = 'Hoodie';

#Query 3
SELECT * FROM weapons
LEFT JOIN stats
ON fk_weapon_stat_id = weapon_id;

#Query 4a
SELECT SUM(quantity)
FROM item_recipe_resources
WHERE fk_item_id IN (9, 11)
AND fk_resource_id = 3;

#Query 4b
SELECT COUNT(fk_item_id)
FROM item_recipe_resources
WHERE fk_resource_id = 10;

#Query 5
SELECT COUNT(item_id), category_name
FROM items JOIN categories
ON fk_item_category_id = category_id
GROUP BY fk_item_category_id;

#Query 6
SELECT item_name, cold_protection
FROM items JOIN stats
ON fk_stat_id = stat_id
JOIN attire
ON fk_attire_stat_id = attire_id
GROUP BY cold_protection
HAVING cold_protection > 5;

#Query 7
SELECT item_name, projectile_protection
FROM items JOIN stats
ON fk_stat_id = stat_id
JOIN attire
ON fk_attire_stat_id = attire_id
ORDER BY projectile_protection DESC;

#Query 8
SELECT item_name, weapon_damage
FROM items JOIN stats
ON fk_stat_id = stat_id
JOIN weapons
ON fk_weapon_stat_id = weapon_id
ORDER BY weapon_damage DESC
LIMIT 1;

#Query 9
SELECT item_name FROM item_recycle_resources
JOIN items 
ON fk_item_id = item_id
WHERE fk_resource_id IN 
(SELECT resource_id FROM resources WHERE resource_name = 'High Quality Metal');

#Query 10
SELECT item_name, component_name, irc.quantity, resource_name, irr.quantity
FROM items JOIN item_recipe_components AS irc
ON item_id = irc.fk_item_id
JOIN components
ON irc.fk_component_id = component_id
JOIN item_recipe_resources AS irr
ON item_id = irr.fk_item_id
JOIN resources
ON irr.fk_resource_id = resource_id
WHERE item_id = 9;
