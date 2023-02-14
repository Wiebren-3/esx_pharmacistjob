INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacien', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacien', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_pharmacist', 'Pharmacien', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('pharmacist', 'Pharmacien')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salar
	('pharmacist',0,'recruit','Stagaire',60,'{}','{}'),
	('pharmacist',1,'supplier','Fournisseur',70,'{}','{}')
	('pharmacist',2,'store_employe','Vendeur',80,'{}','{}'),
	('pharmacist',3,'lab_employe','Ouvrier de laboratoire',90,'{}','{}'),
	('pharmacist',4,'boss','Directeur de succursale',100,'{}','{}')
;
