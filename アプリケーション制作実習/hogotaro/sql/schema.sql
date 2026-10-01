-- ホゴタロウ DDL（基本設計 4 章）。mysql -u root -p --default-character-set=utf8mb4 < sql/schema.sql
-- このファイルは「DB を丸ごと作り直す」スクリプト。流すたびに hogotaro の中身は全部消える（開発用）。
-- 列を変えたら、このファイル → data.sql の順に流し直す。
-- 下の方にマスタ（user_types・event_types）の INSERT も入っている。マスタはプログラムが code で参照するので、テーブルと一緒に作る。
DROP DATABASE IF EXISTS hogotaro;
CREATE DATABASE hogotaro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hogotaro;

CREATE TABLE organizations (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(50)  NOT NULL,
  address       VARCHAR(100) NOT NULL,
  phone_number  VARCHAR(20),
  email         VARCHAR(255),
  capacity      INT NOT NULL,
  notes         TEXT                     -- 代表者名などもここに書く（代表者の列は作らない。決定 2-16）
);

CREATE TABLE user_types (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  code  VARCHAR(20) NOT NULL UNIQUE,    -- ADMIN / STAFF / VOLUNTEER。Spring Security のロール名になる
  name  VARCHAR(20) NOT NULL
);

CREATE TABLE event_types (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  code  VARCHAR(20) NOT NULL UNIQUE,    -- プログラムが見るのは RABIES_VACCINE / TRIAL_START / ADOPTION の 3 つだけ（入力チェック用）
  name  VARCHAR(20) NOT NULL
);

CREATE TABLE breeds (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  species  VARCHAR(20) NOT NULL,
  name     VARCHAR(50) NOT NULL,
  UNIQUE KEY uk_breeds (species, name)
);

CREATE TABLE staff (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  organization_id  INT NOT NULL,
  login_id         VARCHAR(30)  NOT NULL UNIQUE,
  password_hash    VARCHAR(255) NOT NULL,
  user_type_id     INT NOT NULL,
  name             VARCHAR(30)  NOT NULL,
  gender           VARCHAR(20)  NOT NULL,
  birthday         DATE NOT NULL,
  joined_date      DATE,
  address          VARCHAR(100),
  phone_number     VARCHAR(20)  NOT NULL,
  email            VARCHAR(255),
  notes            TEXT,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (organization_id) REFERENCES organizations(id),
  FOREIGN KEY (user_type_id)    REFERENCES user_types(id)
);

CREATE TABLE adopters (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  organization_id  INT NOT NULL,
  name             VARCHAR(30)  NOT NULL,
  gender           VARCHAR(20)  NOT NULL,
  birthday         DATE,
  address          VARCHAR(100),
  phone_number     VARCHAR(20)  NOT NULL,
  email            VARCHAR(255),
  notes            TEXT,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (organization_id) REFERENCES organizations(id)
);

CREATE TABLE animals (
  id                     INT AUTO_INCREMENT PRIMARY KEY,
  organization_id        INT NOT NULL,
  name                   VARCHAR(10) NOT NULL,
  species                VARCHAR(20) NOT NULL,
  sex                    VARCHAR(20) NOT NULL,
  breed_id               INT,
  birthday               DATE,
  is_birthday_estimated  BOOLEAN NOT NULL DEFAULT TRUE,
  intake_date            DATE NOT NULL,
  intake_place           VARCHAR(50) NOT NULL,
  intake_method          VARCHAR(30) NOT NULL,
  status                 VARCHAR(20) NOT NULL DEFAULT 'NOT_ADOPTABLE',
  adopter_id             INT,
  neutered               VARCHAR(20) NOT NULL DEFAULT 'UNKNOWN',   -- 旧 is_neutered BOOLEAN。DONE（済）/ NOT_DONE（未）/ UNKNOWN（不明）
  combo_vaccine          BOOLEAN NOT NULL DEFAULT FALSE,
  rabies_vaccine         BOOLEAN NOT NULL DEFAULT FALSE,           -- 猫は常に FALSE（画面に出さない。決定 2-5）
  microchip_no           VARCHAR(15),
  health_notes           TEXT,
  notes                  TEXT,
  image_path             VARCHAR(255),
  created_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (organization_id) REFERENCES organizations(id),
  FOREIGN KEY (breed_id)        REFERENCES breeds(id)   ON DELETE SET NULL,
  FOREIGN KEY (adopter_id)      REFERENCES adopters(id)
);

CREATE TABLE events (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  organization_id  INT NOT NULL,
  event_type_id    INT NOT NULL,
  animal_id        INT NOT NULL,
  adopter_id       INT,
  staff_id         INT,                  -- 対応スタッフ = 完了にした人。未対応のあいだは NULL
  event_date       DATE NOT NULL,
  event_time       TIME,
  place            VARCHAR(100),
  done             BOOLEAN NOT NULL DEFAULT FALSE,
  cost             INT,
  notes            TEXT,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (organization_id) REFERENCES organizations(id),
  FOREIGN KEY (event_type_id)   REFERENCES event_types(id),
  FOREIGN KEY (animal_id)       REFERENCES animals(id)  ON DELETE CASCADE,   -- 個体を消すとイベントも消える
  FOREIGN KEY (adopter_id)      REFERENCES adopters(id),
  FOREIGN KEY (staff_id)        REFERENCES staff(id)    ON DELETE SET NULL   -- スタッフを消すと対応スタッフが空になる
);

-- ===== マスタ（全団体共通） =====
-- id を明示しているのは、data.sql のデモデータが id で参照しているため。プログラムは id ではなく code で探す。

INSERT INTO user_types (id, code, name) VALUES
  (1, 'ADMIN',     '管理ユーザー'),
  (2, 'STAFF',     '常勤スタッフ'),
  (3, 'VOLUNTEER', 'ボランティア');

-- 完了しても個体は自動で更新しない（決定 2-18）。code は入力チェックだけに使う
INSERT INTO event_types (id, code, name) VALUES
  (1,  'HOSPITAL_VISIT',     '通院'),
  (2,  'HOSPITAL_ADMISSION', '入院'),
  (3,  'HOSPITAL_DISCHARGE', '退院'),
  (4,  'NEUTERING',          '避妊去勢手術'),
  (5,  'COMBO_VACCINE',      '混合ワクチン'),
  (6,  'RABIES_VACCINE',     '狂犬病ワクチン'),   -- 猫には登録できない（決定 2-5）
  (7,  'MICROCHIP',          'マイクロチップ装着'),
  (8,  'TRIAL_START',        'トライアル開始'),   -- 里親必須
  (9,  'TRIAL_RETURN',       'トライアル返却'),
  (10, 'ADOPTION',           '譲渡'),             -- 里親必須
  (11, 'OTHER',              'その他');
