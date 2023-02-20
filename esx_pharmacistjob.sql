USE `es_extended`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('pharmacist', 'Pharmacist')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('pharmacist',0,'recruit','Stagaire',200,'{}','{}'),
	('pharmacist',100,'supplier','Stagaire',300,'{}','{}'),
	('pharmacist',300,'experienced_supplier','Ervaren Leverancier',350,'{}','{}'),
	('pharmacist',500,'store_employe','Winkelmedewerker',300,'{}','{}'),
	('pharmacist',700,'experienced_store','Ervaren Winkelmedewerker',350,'{}','{}'),
	('pharmacist',750,'lab_employe','Labmedewerker',400,'{}','{}'),
	('pharmacist',800,'experienced_lab_employe','Ervaren Labmedewerker',450,'{}','{}'),
	('pharmacist',825,'lead_suppliers','Leidinggevende Leveranciers',550,'{}','{}'),
	('pharmacist',850,'lead_storeemployes','Leidinggevende Winkelmedewerkers',550,'{}','{}'),
	('pharmacist',875,'lead_labemployes','Leidinggevende Labmedewerkers',550,'{}','{}'),
	('pharmacist',900,'manager','Manager',650,'{}','{}'),
	('pharmacist',1000,'boss','Beheerder',750,'{}','{}')
;

CREATE TABLE `fine_types` (
	`id` int NOT NULL AUTO_INCREMENT,
	`label` varchar(255) DEFAULT NULL,
	`amount` int DEFAULT NULL,
	`category` int DEFAULT NULL,

	PRIMARY KEY (`id`)
);
