INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacist', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('pharmacist', 'Pharmacist')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salar
	('pharmacist',0,'recruit','Recruit',60,'{}','{}'),
	('pharmacist',1,'supplier','Supplier',70,'{}','{}')
	('pharmacist',2,'store_employe','Store Employe',80,'{}','{}'),
	('pharmacist',3,'lab_employe','Lab Employe',90,'{}','{}'),
	('pharmacist',4,'boss','Manager',100,'{}','{}')
;
