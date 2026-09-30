-- DROP DATABASE IF EXISTS hogotaro;
CREATE DATABASE IF NOT EXISTS hogotaro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hogotaro;

CREATE TABLE IF NOT EXISTS organizations(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(20),
    email   VARCHAR(255),
    capacity    INT NOT NULL,
    notes   TEXT
);

CREATE TABLE IF NOT EXISTS user_types(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20)    NOT NULL UNIQUE,
    name VARCHAR(20)    NOT NULL
);

CREATE TABLE IF NOT EXISTS event_types(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    code  VARCHAR(20) NOT NULL UNIQUE,
    name  VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS breeds(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    species VARCHAR(50) NOT NULL,
    name    VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS staff(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    login_id    VARCHAR(30) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    user_type_id    INT NOT NULL,
    name    VARCHAR(30) NOT NULL,
    gender  VARCHAR(20) NOT NULL,
    birthday         DATE NOT NULL,
    joined_date DATE,
    address          VARCHAR(100),
    phone_number    VARCHAR(20) NOT NULL,
    email   VARCHAR(255),
    notes   TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(organization_id) REFERENCES organizations(id),
    FOREIGN KEY(user_type_id) REFERENCES user_types(id)
);

CREATE TABLE IF NOT EXISTS adopters(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    name    VARCHAR(30) NOT NULL,
    gender  VARCHAR(20) NOT NULL,
    birthday    DATE,
    address VARCHAR(100),
    phone_number    VARCHAR(20) NOT NULL,
    email   VARCHAR(255),
    notes   TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(organization_id) REFERENCES organizations(id)
);

CREATE TABLE IF NOT EXISTS animals (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    organization_id       INT          NOT NULL,
    name                  VARCHAR(10)  NOT NULL,
    species               VARCHAR(20)  NOT NULL,
    sex                   VARCHAR(20)  NOT NULL,
    breed_id              INT,
    birthday              DATE,
    is_birthday_estimated BOOLEAN      NOT NULL DEFAULT TRUE,
    intake_date           DATE         NOT NULL,
    intake_place          VARCHAR(50)  NOT NULL,
    intake_method         VARCHAR(30)  NOT NULL,
    status                VARCHAR(20)  NOT NULL DEFAULT 'SHELTERED',
    adopter_id            INT,
    is_neutered           BOOLEAN      NOT NULL DEFAULT FALSE,
    combo_vaccine         BOOLEAN      NOT NULL DEFAULT FALSE,
    rabies_vaccine        BOOLEAN      NOT NULL DEFAULT FALSE,
    microchip_no          VARCHAR(15),
    health_notes          TEXT,
    notes                 TEXT,
    image_path            VARCHAR(255),
    created_at            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(id),
    FOREIGN KEY (breed_id)        REFERENCES breeds(id)   ON DELETE SET NULL,
    FOREIGN KEY (adopter_id)      REFERENCES adopters(id)
);

CREATE TABLE IF NOT EXISTS events(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    organization_id INT NOT NULL,
    event_type_id INT NOT NULL,
    animal_id INT NOT NULL,
    adopter_id INT,
    staff_id INT,
    event_date DATE NOT NULL,
    event_time  TIME,
    place   VARCHAR(100),
    done    BOOLEAN NOT NULL DEFAULT FALSE,
    cost    INT,
    notes   TEXT,
    created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY(organization_id) REFERENCES organizations(id),
    FOREIGN KEY(event_type_id) REFERENCES event_types(id),
    FOREIGN KEY(animal_id) REFERENCES animals(id),
    FOREIGN KEY(adopter_id) REFERENCES adopters(id),
    FOREIGN KEY(staff_id) REFERENCES staff(id)
);