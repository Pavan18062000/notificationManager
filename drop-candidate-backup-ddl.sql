-- Backup DDL for tables planned to drop

-- TABLE: client_services
CREATE TABLE `client_services` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `is_enabled` bit(1) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `client_id` bigint NOT NULL,
  `service_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKa2qmhgjke0y4k8f2hcwtrb11r` (`client_id`,`service_id`),
  KEY `FK6pfi4r82qbss2j0ybylgvvng9` (`service_id`),
  CONSTRAINT `FK1chgp4jf7ugynj00i45vn63qd` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `FK6pfi4r82qbss2j0ybylgvvng9` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: clients
CREATE TABLE `clients` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `api_key_hash` varchar(128) NOT NULL,
  `client_code` varchar(255) NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK59ust0ah2ojukr079kddthcrm` (`client_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: email_logs
CREATE TABLE `email_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bcc_recipients` varchar(2000) DEFAULT NULL,
  `body` longtext NOT NULL,
  `body_type` enum('HTML','TEXT') NOT NULL,
  `cc_recipients` varchar(2000) DEFAULT NULL,
  `client_code` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `error_message` varchar(4000) DEFAULT NULL,
  `kafka_topic` varchar(255) DEFAULT NULL,
  `recipient_email` varchar(255) NOT NULL,
  `request_payload` longtext,
  `sent_at` datetime(6) DEFAULT NULL,
  `status` enum('FAILED','PENDING','SENT') NOT NULL,
  `subject` varchar(255) NOT NULL,
  `template_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: email_templates
CREATE TABLE `email_templates` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body_html` longtext NOT NULL,
  `client_code` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_active` bit(1) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `template_code` varchar(255) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKiu8651o8bry1xre0ewfkkc9nv` (`client_code`,`template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: message_logs
CREATE TABLE `message_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel` enum('EMAIL','SMS','PUSH','WHATSAPP') NOT NULL,
  `project_code` varchar(255) NOT NULL,
  `template_code` varchar(255) DEFAULT NULL,
  `destination` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `payload` longtext NOT NULL,
  `status` enum('PENDING','PROCESSING','SENT','FAILED','FAILED_RETRYABLE') NOT NULL,
  `error_message` varchar(4000) DEFAULT NULL,
  `kafka_topic` varchar(255) DEFAULT NULL,
  `request_payload` longtext,
  `created_at` datetime(6) NOT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_message_logs_channel_project_status` (`channel`,`project_code`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: message_templates
CREATE TABLE `message_templates` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel` enum('EMAIL','SMS','PUSH','WHATSAPP') NOT NULL,
  `project_code` varchar(255) NOT NULL,
  `template_code` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `payload` longtext NOT NULL,
  `is_active` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_message_templates_channel_project_template` (`channel`,`project_code`,`template_code`),
  UNIQUE KEY `UK210v5n6hmbpbyq6udc991rpxg` (`channel`,`project_code`,`template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: project_channel_config
CREATE TABLE `project_channel_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `enabled` bit(1) NOT NULL,
  `rate_limit` int DEFAULT NULL,
  `retry_count` int DEFAULT NULL,
  `channel_id` bigint NOT NULL,
  `project_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_channel_cfg` (`project_id`,`channel_id`),
  KEY `FK258inwbfqn7mdkpt839n8oiw8` (`channel_id`),
  CONSTRAINT `FK258inwbfqn7mdkpt839n8oiw8` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `FKkot7kslg7x3w7m8tham9o9axb` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: project_countries
CREATE TABLE `project_countries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `country_id` bigint NOT NULL,
  `is_enabled` bit(1) NOT NULL,
  `is_default_country` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `active` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_countries_project_country` (`project_id`,`country_id`),
  UNIQUE KEY `UK76g7g1fj2y0letslkcanl7497` (`project_id`,`country_id`),
  UNIQUE KEY `uk_project_country` (`project_id`,`country_id`),
  KEY `fk_project_countries_country` (`country_id`),
  CONSTRAINT `fk_project_countries_country` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `fk_project_countries_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: project_provider_config
CREATE TABLE `project_provider_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `active` bit(1) NOT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `api_secret` varchar(255) DEFAULT NULL,
  `config_json` text,
  `from_email` varchar(255) DEFAULT NULL,
  `priority` int NOT NULL,
  `sender_id` varchar(255) DEFAULT NULL,
  `channel_id` bigint NOT NULL,
  `country_id` bigint NOT NULL,
  `project_id` bigint NOT NULL,
  `provider_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ppc_lookup` (`project_id`,`country_id`,`channel_id`,`active`,`priority`),
  KEY `FKe9xlnnr4wsnj3vi407qcvtlvu` (`channel_id`),
  KEY `FKlvxuxigu3wru8i2aket5pyar0` (`country_id`),
  KEY `FKhu2k4qlnm0p54yd08tpsnliam` (`provider_id`),
  CONSTRAINT `FKe9xlnnr4wsnj3vi407qcvtlvu` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
  CONSTRAINT `FKhu2k4qlnm0p54yd08tpsnliam` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`),
  CONSTRAINT `FKib30qiagnbi0dw82kvu6sur0d` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `FKlvxuxigu3wru8i2aket5pyar0` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: project_services
CREATE TABLE `project_services` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_id` bigint NOT NULL,
  `service_id` bigint NOT NULL,
  `is_enabled` bit(1) NOT NULL,
  `direct_payload_enabled` bit(1) NOT NULL,
  `template_payload_enabled` bit(1) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_services_project_service` (`project_id`,`service_id`),
  UNIQUE KEY `UKbtit3i7hwqwb8byj32vje55oh` (`project_id`,`service_id`),
  KEY `fk_project_services_service` (`service_id`),
  CONSTRAINT `fk_project_services_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`),
  CONSTRAINT `fk_project_services_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: provider_channels
CREATE TABLE `provider_channels` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `channel_id` bigint NOT NULL,
  `provider_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider_channel` (`provider_id`,`channel_id`),
  KEY `FKcufsvmbbqfd2nj4cq22n8omrl` (`channel_id`),
  CONSTRAINT `FK9gubkjw0x7skxqg7of97piupx` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`),
  CONSTRAINT `FKcufsvmbbqfd2nj4cq22n8omrl` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: provider_countries
CREATE TABLE `provider_countries` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `active` bit(1) NOT NULL,
  `country_id` bigint NOT NULL,
  `provider_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider_country` (`provider_id`,`country_id`),
  KEY `FKt9fsrtd3hiqs22xaqx5341r35` (`country_id`),
  CONSTRAINT `FKk39mn9sv6c0df42vfk4p2exv8` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`),
  CONSTRAINT `FKt9fsrtd3hiqs22xaqx5341r35` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: services
CREATE TABLE `services` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `is_active` bit(1) NOT NULL,
  `service_code` varchar(255) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKrm9rfu0ekvjb9y1ff8blnaf0i` (`service_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: sms_logs
CREATE TABLE `sms_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_code` varchar(255) NOT NULL,
  `template_code` varchar(255) DEFAULT NULL,
  `recipient_phone` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `status` enum('PENDING','PROCESSING','SENT','FAILED','FAILED_RETRYABLE') NOT NULL,
  `error_message` varchar(4000) DEFAULT NULL,
  `kafka_topic` varchar(255) DEFAULT NULL,
  `request_payload` longtext,
  `created_at` datetime(6) NOT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_sms_logs_project_status` (`project_code`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TABLE: sms_templates
CREATE TABLE `sms_templates` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_code` varchar(255) NOT NULL,
  `template_code` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `is_active` bit(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sms_templates_project_template` (`project_code`,`template_code`),
  UNIQUE KEY `UK5tlafjf4j4wvfxq6amgxioc8r` (`project_code`,`template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
