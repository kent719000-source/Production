-- デモデータ。schema.sql（テーブルとマスタ）を流したあとに流す。mysql -u root -p --default-character-set=utf8mb4 < sql/data.sql
-- 全アカウントのパスワードは pass1234（BCrypt 済み）。
USE hogotaro;

-- 品種の初期値（全団体共通）。個体フォームの「新しい品種」から画面でも増やせる
INSERT INTO breeds (species, name) VALUES
  ('DOG', '雑種'), ('DOG', '柴犬'), ('DOG', 'トイプードル'), ('DOG', 'チワワ'), ('DOG', 'ミニチュアダックスフンド'), ('DOG', '甲斐犬'),
  ('CAT', '雑種'), ('CAT', 'アメリカンショートヘア'), ('CAT', 'スコティッシュフォールド'), ('CAT', 'ノルウェージャンフォレストキャット'), ('CAT', 'マンチカン'), ('CAT', 'ロシアンブルー');

-- 団体は運営が SQL で登録する（登録画面は作らない。基本設計 8 章「団体の追加手順」）
INSERT INTO organizations (id, name, address, phone_number, email, capacity, notes) VALUES
  (1, 'わんにゃんの家', '東京都新宿区1-1-1', '03-0000-0001', 'info@wannyan.example', 30, '代表: 山田 太郎'),
  (2, 'みなと保護猫クラブ', '神奈川県横浜市2-2-2', '045-000-0002', 'info@minato.example', 15, NULL);

-- ログイン ID: admin1 / staff1 / vol1（団体 1）、admin2 / staff2 / vol2（団体 2）。パスワードは全員 pass1234
-- password_hash は BCryptPasswordEncoder.encode("pass1234") の結果。{bcrypt} は付けない（SecurityConfig が BCryptPasswordEncoder だから）
-- user_type_id は 1 = ADMIN、2 = STAFF、3 = VOLUNTEER（schema.sql のマスタ）
INSERT INTO staff (organization_id, login_id, password_hash, user_type_id, name, gender, birthday, joined_date, phone_number, email) VALUES
  (1, 'admin1', '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 1, '山田 太郎', 'MALE',   '1980-04-01', '2020-04-01', '090-0000-0001', 'admin1@wannyan.example'),
  (1, 'staff1', '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 2, '佐藤 花子', 'FEMALE', '1990-05-02', '2022-04-01', '090-0000-0002', 'staff1@wannyan.example'),
  (1, 'vol1',   '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '鈴木 一朗', 'MALE',   '2000-06-03', '2024-04-01', '090-0000-0003', NULL),
  (2, 'admin2', '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 1, '高橋 次郎', 'MALE',   '1975-07-04', '2019-04-01', '090-0000-0004', 'admin2@minato.example'),
  (2, 'staff2', '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 2, '田中 美咲', 'FEMALE', '1995-08-05', '2023-04-01', '090-0000-0005', NULL),
  (2, 'vol2',   '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '伊藤 健',   'OTHER',  '2001-09-06', '2025-04-01', '090-0000-0006', NULL);

INSERT INTO adopters (organization_id, name, gender, birthday, address, phone_number, email, notes) VALUES
  (1, '中村 恵子', 'FEMALE', '1985-01-15', '東京都杉並区3-3-3', '080-1111-0001', 'nakamura@example.com', '一戸建て。先住猫1匹。日中在宅'),
  (1, '小林 大輔', 'MALE',   '1992-11-20', '東京都練馬区4-4-4', '080-1111-0002', NULL, 'マンション（ペット可）。子ども2人'),
  (2, '渡辺 さくら', 'FEMALE', '1988-03-30', '神奈川県川崎市5-5-5', '080-2222-0001', 'watanabe@example.com', NULL);

-- neutered は DONE（済）/ NOT_DONE（未）/ UNKNOWN（不明）。猫の rabies_vaccine は常に FALSE
INSERT INTO animals (organization_id, name, species, sex, breed_id, birthday, is_birthday_estimated, intake_date, intake_place, intake_method, status, adopter_id, neutered, combo_vaccine, rabies_vaccine, microchip_no, health_notes, notes) VALUES
  (1, 'ファイア', 'CAT', 'MALE',   10, '2018-05-01', TRUE,  '2025-09-01', '新宿区役所前',   '保健所から引き取り', 'NOT_ADOPTABLE', NULL, 'DONE',     TRUE,  FALSE, NULL, '右目に軽い結膜炎。点眼中', '人懐こい。子どもが苦手'),
  (1, 'アクア',   'CAT', 'FEMALE', 7,  '2022-03-15', TRUE,  '2025-08-20', '高田馬場駅周辺', '迷子',               'TRIAL',         1,    'DONE',     TRUE,  FALSE, NULL, NULL, 'トライアル中（中村さん宅）'),
  (1, 'ポチ',     'DOG', 'MALE',   2,  '2020-01-10', FALSE, '2025-07-05', '中野区',         '飼い主放棄',         'ADOPTABLE',     NULL, 'NOT_DONE', TRUE,  TRUE,  '392140000000001', NULL, '散歩が大好き'),
  (1, 'モモ',     'DOG', 'FEMALE', 1,  '2015-06-20', TRUE,  '2024-12-01', '練馬区',         '保健所から引き取り', 'ADOPTED',       2,    'DONE',     TRUE,  TRUE,  NULL, '高齢。関節に注意', '2025-06 に小林さん宅へ譲渡'),
  (2, 'レオ',     'CAT', 'MALE',   8,  '2021-09-09', TRUE,  '2025-09-10', '横浜駅西口',     '迷子',               'NOT_ADOPTABLE', NULL, 'UNKNOWN',  FALSE, FALSE, NULL, NULL, NULL),
  -- 以下 2 頭は絞り込みの確認用（id 6, 7）。ハナは入院中（保護頭数に入る）、クロは返還済（初期表示では出ない）
  (1, 'ハナ',     'DOG', 'FEMALE', 1,  '2019-02-14', TRUE,  '2025-08-01', '杉並区',         '保健所から引き取り', 'HOSPITALIZED',  NULL, 'DONE',     TRUE,  TRUE,  NULL, '骨折の手術で入院中（10/10 退院予定）', NULL),
  (1, 'クロ',     'CAT', 'MALE',   7,  '2023-04-01', TRUE,  '2025-09-15', '新宿御苑付近',   '迷子',               'RETURNED',      NULL, 'UNKNOWN',  FALSE, FALSE, '392140000000002', NULL, 'マイクロチップから飼い主が判明し 9/20 に返還');

-- event_type_id は schema.sql のマスタ（1 通院 / 4 避妊去勢手術 / 5 混合ワクチン / 6 狂犬病ワクチン / 10 譲渡 など）
-- staff_id（対応スタッフ）は完了済みのイベントだけに入れる。未対応は NULL
INSERT INTO events (organization_id, event_type_id, animal_id, adopter_id, staff_id, event_date, event_time, place, done, cost, notes) VALUES
  (1, 1,  1, NULL, NULL, CURDATE(),                            '10:00:00', 'さくら動物病院',       FALSE, 3000,  '結膜炎の経過観察'),
  (1, 6,  3, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '14:00:00', 'さくら動物病院',       FALSE, 3500,  NULL),
  (1, 10, 2, 1,    NULL, DATE_ADD(CURDATE(), INTERVAL 5 DAY),  '11:00:00', '中村さん宅',           FALSE, NULL,  'トライアル終了後に正式譲渡'),
  (1, 5,  1, NULL, 2,    DATE_SUB(CURDATE(), INTERVAL 30 DAY), '10:00:00', 'さくら動物病院',       TRUE,  5000,  NULL),
  (1, 3,  6, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 9 DAY),  NULL,       'さくら動物病院',       FALSE, NULL,  '退院の迎え'),
  (2, 4,  5, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 10 DAY), '09:30:00', 'みなと動物クリニック', FALSE, 20000, NULL);
