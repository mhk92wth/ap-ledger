CREATE TABLE `terms` (
  `terms_id` int NOT NULL AUTO_INCREMENT,
  `terms_description` varchar(50) NOT NULL,
  `terms_due_days` int NOT NULL,
  PRIMARY KEY (`terms_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `general_ledger_accounts` (
  `account_number` int NOT NULL,
  `account_description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`account_number`),
  UNIQUE KEY `account_description` (`account_description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `vendors` (
  `vendor_id` int NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(50) NOT NULL,
  `vendor_address1` varchar(50) DEFAULT NULL,
  `vendor_address2` varchar(50) DEFAULT NULL,
  `vendor_city` varchar(50) NOT NULL,
  `vendor_state` char(2) NOT NULL,
  `vendor_zip_code` varchar(20) NOT NULL,
  `vendor_phone` varchar(50) DEFAULT NULL,
  `vendor_contact_last_name` varchar(50) DEFAULT NULL,
  `vendor_contact_first_name` varchar(50) DEFAULT NULL,
  `default_terms_id` int NOT NULL,
  `default_account_number` int NOT NULL,
  PRIMARY KEY (`vendor_id`),
  UNIQUE KEY `vendor_name` (`vendor_name`),
  KEY `vendors_fk_terms` (`default_terms_id`),
  KEY `vendors_fk_accounts` (`default_account_number`),
  CONSTRAINT `vendors_fk_accounts` FOREIGN KEY (`default_account_number`) REFERENCES `general_ledger_accounts` (`account_number`),
  CONSTRAINT `vendors_fk_terms` FOREIGN KEY (`default_terms_id`) REFERENCES `terms` (`terms_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `vendor_contacts` (
  `vendor_id` int NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `invoices` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `vendor_id` int NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `invoice_total` decimal(9,2) NOT NULL,
  `payment_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `credit_total` decimal(9,2) NOT NULL DEFAULT '0.00',
  `terms_id` int NOT NULL,
  `invoice_due_date` date NOT NULL,
  `payment_date` date DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `invoices_fk_vendors` (`vendor_id`),
  KEY `invoices_fk_terms` (`terms_id`),
  KEY `invoices_invoice_date_ix` (`invoice_date` DESC),
  CONSTRAINT `invoices_fk_terms` FOREIGN KEY (`terms_id`) REFERENCES `terms` (`terms_id`),
  CONSTRAINT `invoices_fk_vendors` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `invoice_line_items` (
  `invoice_id` int NOT NULL,
  `invoice_sequence` int NOT NULL,
  `account_number` int NOT NULL,
  `line_item_amount` decimal(9,2) NOT NULL,
  `line_item_description` varchar(100) NOT NULL,
  PRIMARY KEY (`invoice_id`,`invoice_sequence`),
  KEY `line_items_fk_acounts` (`account_number`),
  CONSTRAINT `line_items_fk_acounts` FOREIGN KEY (`account_number`) REFERENCES `general_ledger_accounts` (`account_number`),
  CONSTRAINT `line_items_fk_invoices` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


CREATE TABLE `invoice_archive` (
  `invoice_id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `invoice_total` decimal(9,2) NOT NULL,
  `payment_total` decimal(9,2) NOT NULL,
  `credit_total` decimal(9,2) NOT NULL,
  `terms_id` int NOT NULL,
  `invoice_due_date` date NOT NULL,
  `payment_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
