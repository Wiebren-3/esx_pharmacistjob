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
	('pharmacist',0,'recruit','Recruit',20,'{}','{}'),
	('pharmacist',1,'supplier','Supplier',40,'{}','{}'),
	('pharmacist',2,'store_employe','Store Employe',60,'{}','{}'),
	('pharmacist',3,'lab_employe','Lab Employe',85,'{}','{}'),
	('pharmacist',4,'boss','Manager',100,'{}','{}')
;

CREATE TABLE `fine_types` (
	`id` int NOT NULL AUTO_INCREMENT,
	`label` varchar(255) DEFAULT NULL,
	`amount` int DEFAULT NULL,
	`category` int DEFAULT NULL,

	PRIMARY KEY (`id`)
);
