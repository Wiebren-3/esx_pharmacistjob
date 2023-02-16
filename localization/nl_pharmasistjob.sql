USE `es_extended`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_pharmacist', 'Apotheker', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_pharmacist', 'Apotheker', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_pharmacist', 'Apotheker', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('pharmacist', 'Apotheker')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salar
	('pharmacist',0,'recruit','Stagair',60,'{}','{}'),
	('pharmacist',1,'supplier','Leverancier',70,'{}','{}')
	('pharmacist',2,'store_employe','Winkelmedewerker',80,'{}','{}'),
	('pharmacist',3,'lab_employe','Labmedewerker',90,'{}','{}'),
	('pharmacist',4,'boss','Manager',100,'{}','{}')
;
