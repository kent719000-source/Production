-- 発表（10/15）用のデモデータ。data.sql の代わりに、schema.sql を流したあとに流す。
--   mysql -u root -p --default-character-set=utf8mb4 < sql/schema.sql
--   mysql -u root -p --default-character-set=utf8mb4 < sql/demo_data.sql
-- 全アカウントのパスワードは pass1234（BCrypt 済み）。
--
-- ■ 写真
--   demo_01.jpg 〜 demo_43.jpg は src/main/resources/static/photos/ に入っている（WAR の中に入るので、外部 Tomcat でもコピー不要）。
--   image_path の '/photos/demo_01.jpg' は static/photos/demo_01.jpg を指す（application.properties の static-locations で classpath:/static/ が先に探される）。
--   画面から登録した写真は今までどおり uploads/photos/ に保存され、同じ /photos/ファイル名 の URL で表示される。
--   写真が無いのは 33 クロ（返還済み）だけ。わざと。一覧を「すべて」で絞り込むと NO IMAGE のカードが1枚出る。
--
-- ■ 日付
--   イベントの日付は CURDATE()（流した日）を基準にしている。発表当日の朝に schema.sql → demo_data.sql を流し直すこと。
--   前日に流したままだと「今日のアクアの譲渡」が昨日の未対応になる。
--   デモで登録・変更したもの（こむぎ・森さん・アクアの譲渡など）もリハーサルのたびに残るので、リハーサルの前にも流し直す。
--
-- ■ デモの前提（台本.md と対応）
--   団体 1「わんにゃんの家」: 上限 30 頭のうち保護中 29 頭（残りわずか・空き 1）。
--     シーン 2 で子猫こむぎを登録 → 30/30（満員）。シーン 4 でアクアを譲渡済みにする → 29/30。
--   団体 2「みなと保護猫クラブ」: 上限 15 頭のうち保護中 8 頭（受け入れOK）。個体 id は 35〜43。
--     シーン 5 で団体 1 のウィンドウから /animal/35（レオ）を開くと 404。
USE hogotaro;

-- 品種（全団体共通）。1〜12 は data.sql と同じ。13〜16 は写真に合わせて足した
INSERT INTO breeds (id, species, name) VALUES
  (1, 'DOG', '雑種'), (2, 'DOG', '柴犬'), (3, 'DOG', 'トイプードル'), (4, 'DOG', 'チワワ'), (5, 'DOG', 'ミニチュアダックスフンド'), (6, 'DOG', '甲斐犬'),
  (7, 'CAT', '雑種'), (8, 'CAT', 'アメリカンショートヘア'), (9, 'CAT', 'スコティッシュフォールド'), (10, 'CAT', 'ノルウェージャンフォレストキャット'), (11, 'CAT', 'マンチカン'), (12, 'CAT', 'ロシアンブルー'),
  (13, 'DOG', 'シーズー'), (14, 'DOG', 'ゴールデンレトリーバー'), (15, 'CAT', 'ラグドール'), (16, 'CAT', 'ベンガル');

INSERT INTO organizations (id, name, address, phone_number, email, capacity, notes) VALUES
  (1, 'わんにゃんの家',     '東京都新宿区1-1-1',   '03-0000-0001', 'info@wannyan.example', 30, '代表: 山田 太郎。常勤3名・ボランティア10名'),
  (2, 'みなと保護猫クラブ', '神奈川県横浜市2-2-2', '045-000-0002', 'info@minato.example',  15, '猫専門');

-- ログイン ID: admin1 / staff1 / vol1（団体 1）、admin2 / staff2 / vol2（団体 2）は data.sql と同じ。
-- 団体 1 の追加分（kato・yoshida・yamamoto・matsumoto・inoue）はスタッフ一覧を実際の団体らしく見せるため
-- user_type_id は 1 = ADMIN、2 = STAFF、3 = VOLUNTEER（schema.sql のマスタ）
INSERT INTO staff (id, organization_id, login_id, password_hash, user_type_id, name, gender, birthday, joined_date, phone_number, email, notes) VALUES
  (1,  1, 'admin1',    '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 1, '山田 太郎',   'MALE',   '1980-04-01', '2020-04-01', '090-0000-0001', 'admin1@wannyan.example', '代表'),
  (2,  1, 'staff1',    '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 2, '佐藤 花子',   'FEMALE', '1990-05-02', '2022-04-01', '090-0000-0002', 'staff1@wannyan.example', NULL),
  (3,  1, 'vol1',      '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '鈴木 一朗',   'MALE',   '2000-06-03', '2024-04-01', '090-0000-0003', NULL, '週1回'),
  (4,  2, 'admin2',    '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 1, '高橋 次郎',   'MALE',   '1975-07-04', '2019-04-01', '090-0000-0004', 'admin2@minato.example', '代表'),
  (5,  2, 'staff2',    '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 2, '田中 美咲',   'FEMALE', '1995-08-05', '2023-04-01', '090-0000-0005', NULL, NULL),
  (6,  2, 'vol2',      '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '伊藤 健',     'OTHER',  '2001-09-06', '2025-04-01', '090-0000-0006', NULL, NULL),
  (7,  1, 'kato',      '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 2, '加藤 直樹',   'MALE',   '1987-09-12', '2023-10-01', '090-0000-0007', 'kato@wannyan.example', NULL),
  (8,  1, 'yoshida',   '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '吉田 さやか', 'FEMALE', '1998-01-25', '2025-01-10', '090-0000-0008', NULL, '週末のみ'),
  (9,  1, 'yamamoto',  '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '山本 翔',     'MALE',   '2003-07-07', '2025-06-01', '090-0000-0009', NULL, '大学生。散歩担当'),
  (10, 1, 'matsumoto', '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '松本 由紀',   'FEMALE', '1972-03-18', '2024-09-01', '090-0000-0010', NULL, '譲渡会の受付担当'),
  (11, 1, 'inoue',     '$2b$10$9yRU3BKtyFtcmegXvhFcieVJqKk30fmk8fvqc...rDyT.lmJemrxi', 3, '井上 浩',     'MALE',   '1965-11-30', '2023-05-01', '090-0000-0011', NULL, '11月末で退会予定');

-- 里親。トライアル中・譲渡済みの子がいる人と、まだ子が決まっていない希望者（山口さん）
-- シーン 4 で登録する「森さん」はここには入れない
INSERT INTO adopters (id, organization_id, name, gender, birthday, address, phone_number, email, notes) VALUES
  (1, 1, '中村 恵子',   'FEMALE', '1985-01-15', '東京都杉並区3-3-3',     '080-1111-0001', 'nakamura@example.com',  '一戸建て。先住猫1匹。日中在宅'),
  (2, 1, '小林 大輔',   'MALE',   '1992-11-20', '東京都練馬区4-4-4',     '080-1111-0002', NULL,                    'マンション（ペット可）。子ども2人'),
  (3, 2, '渡辺 さくら', 'FEMALE', '1988-03-30', '神奈川県川崎市5-5-5',   '080-2222-0001', 'watanabe@example.com',  '一人暮らし。在宅勤務'),
  (4, 1, '清水 拓也',   'MALE',   '1980-08-08', '東京都世田谷区6-6-6',   '080-1111-0003', 'shimizu@example.com',   '庭つき一戸建て。犬の飼育経験あり'),
  (5, 1, '斎藤 由美',   'FEMALE', '1990-02-02', '東京都中野区7-7-7',     '080-1111-0004', NULL,                    '夫婦二人暮らし'),
  (6, 1, '岡田 誠',     'MALE',   '1975-05-05', '東京都板橋区8-8-8',     '080-1111-0005', 'okada@example.com',     '以前も柴犬を飼っていた'),
  (7, 1, '山口 あや',   'FEMALE', '1995-12-12', '東京都豊島区9-9-9',     '080-1111-0006', 'yamaguchi@example.com', '猫を希望。ペット可の賃貸。ノアとお見合い済み'),
  (8, 2, '北村 ゆう',   'FEMALE', '1983-06-06', '神奈川県横浜市10-10-10', '080-2222-0002', NULL,                   NULL),
  (9, 1, '池田 健二',   'MALE',   '1970-10-10', '東京都練馬区11-11-11',  '080-1111-0007', NULL,                    '先住犬あり。ソラのトライアルは相性が合わず返却');

-- 個体。id 1〜11 が団体 1 の犬（保護中）、12〜29 が団体 1 の猫（保護中）、30〜34 が団体 1 の保護が終わった子、35〜43 が団体 2
-- 団体 1 の保護中 29 頭の内訳: 譲渡可 17・譲渡不可 8・入院中 2・トライアル中 2
-- neutered は DONE（済）/ NOT_DONE（未）/ UNKNOWN（不明）。猫の rabies_vaccine は常に FALSE
-- adopter_id はトライアル中・譲渡済の子だけに入れる
INSERT INTO animals (id, organization_id, name, species, sex, breed_id, birthday, is_birthday_estimated, intake_date, intake_place, intake_method, status, adopter_id, neutered, combo_vaccine, rabies_vaccine, microchip_no, health_notes, notes, image_path) VALUES
  -- 団体 1・犬（保護中）
  (1,  1, 'ポチ',     'DOG', 'MALE',   2,  '2020-01-10', FALSE, '2025-07-05', '中野区',           '飼い主放棄',         'ADOPTABLE',     NULL, 'NOT_DONE', TRUE,  TRUE,  '392140000000001', NULL, '散歩が大好き', '/photos/demo_01.jpg'),
  (2,  1, 'ハナ',     'DOG', 'FEMALE', 1,  '2019-02-14', TRUE,  '2025-08-01', '杉並区',           '保健所から引き取り', 'HOSPITALIZED',  NULL, 'DONE',     TRUE,  TRUE,  NULL, '右後ろ足の骨折で入院中', NULL, '/photos/demo_02.jpg'),
  (3,  1, 'コタロウ', 'DOG', 'MALE',   2,  '2022-05-05', TRUE,  '2026-03-10', '練馬区',           '迷子',               'TRIAL',         4,    'DONE',     TRUE,  TRUE,  '392140000000003', NULL, '清水さん宅でトライアル中', '/photos/demo_03.jpg'),
  (4,  1, 'ソラ',     'DOG', 'MALE',   1,  '2023-08-01', TRUE,  '2026-06-15', '世田谷区',         '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  NULL, NULL, '人懐こい。先住犬がいない家が向いている', '/photos/demo_04.jpg'),
  (5,  1, 'チョコ',   'DOG', 'FEMALE', 4,  '2018-11-11', TRUE,  '2026-02-01', '板橋区',           '多頭飼育崩壊',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  NULL, '歯石が多い。柔らかいフードを食べる', '最初は人を怖がったが、慣れてきた', '/photos/demo_05.jpg'),
  (6,  1, 'ゴン',     'DOG', 'MALE',   1,  '2016-04-01', TRUE,  '2025-12-20', '中野区',           '保健所から引き取り', 'NOT_ADOPTABLE', NULL, 'DONE',     TRUE,  TRUE,  NULL, '高齢。心臓の薬を毎日飲んでいる', '終生飼養も検討中', '/photos/demo_06.jpg'),
  (7,  1, 'マロン',   'DOG', 'FEMALE', 1,  '2021-09-01', TRUE,  '2026-05-20', '豊島区',           '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  '392140000000007', NULL, 'おとなしい。月1回のトリミングが必要', '/photos/demo_07.jpg'),
  (8,  1, '大福',     'DOG', 'MALE',   13, '2019-03-03', FALSE, '2026-08-25', '渋谷区',           '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  '392140000000008', '皮膚が弱い。月1回の薬浴', '飼い主の入院で手放された', '/photos/demo_08.jpg'),
  (9,  1, 'リク',     'DOG', 'MALE',   2,  '2024-01-15', TRUE,  '2026-09-20', '杉並区',           '迷子',               'NOT_ADOPTABLE', NULL, 'UNKNOWN',  FALSE, FALSE, NULL, NULL, '飼い主を探している（公示期間中）', '/photos/demo_09.jpg'),
  (10, 1, 'サクラ',   'DOG', 'FEMALE', 2,  '2020-04-04', TRUE,  '2026-04-10', '練馬区',           '保健所から引き取り', 'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  '392140000000010', NULL, '少し怖がり。慣れると甘えん坊', '/photos/demo_10.jpg'),
  (11, 1, 'ベル',     'DOG', 'FEMALE', 14, '2017-07-07', FALSE, '2026-07-01', '世田谷区',         '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  TRUE,  '392140000000011', '股関節に軽い不安あり', '大型犬。散歩の時間がとれる方へ', '/photos/demo_11.jpg'),
  -- 団体 1・猫（保護中）
  (12, 1, 'アクア',   'CAT', 'FEMALE', 7,  '2022-03-15', TRUE,  '2025-08-20', '高田馬場駅周辺',   '迷子',               'TRIAL',         1,    'DONE',     TRUE,  FALSE, NULL, NULL, '中村さん宅でトライアル中', '/photos/demo_12.jpg'),
  (13, 1, 'ファイア', 'CAT', 'MALE',   10, '2018-05-01', TRUE,  '2025-09-01', '新宿区役所前',     '保健所から引き取り', 'NOT_ADOPTABLE', NULL, 'DONE',     TRUE,  FALSE, NULL, '右目に軽い結膜炎。点眼中', '人懐こい。子どもが苦手', '/photos/demo_13.jpg'),
  (14, 1, 'ミケ',     'CAT', 'FEMALE', 7,  '2024-05-01', TRUE,  '2026-01-15', '中野区',           '野良猫の保護',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, '甘えん坊。ほかの猫とも仲良くできる', '/photos/demo_14.jpg'),
  (15, 1, 'トラ',     'CAT', 'MALE',   7,  '2021-10-10', TRUE,  '2025-11-05', '練馬区',           '野良猫の保護',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, 'のんびり屋。抱っこが好き', '/photos/demo_15.jpg'),
  (16, 1, 'ルナ',     'CAT', 'FEMALE', 12, '2020-02-20', FALSE, '2026-03-01', '渋谷区',           '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000016', NULL, '静かな環境が好き', '/photos/demo_16.jpg'),
  (17, 1, 'グレイ',   'CAT', 'MALE',   9,  '2019-12-01', TRUE,  '2026-02-14', '板橋区',           '多頭飼育崩壊',       'NOT_ADOPTABLE', NULL, 'DONE',     TRUE,  FALSE, NULL, '耳と関節の痛みに注意。定期検診が必要', '同じ現場から3頭を保護（グレイ・ユキ・ショコラ）', '/photos/demo_17.jpg'),
  (18, 1, 'ユキ',     'CAT', 'FEMALE', 9,  '2020-03-01', TRUE,  '2026-02-14', '板橋区',           '多頭飼育崩壊',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, '人に慣れてきた', '/photos/demo_18.jpg'),
  (19, 1, 'ショコラ', 'CAT', 'MALE',   9,  '2021-06-01', TRUE,  '2026-02-14', '板橋区',           '多頭飼育崩壊',       'HOSPITALIZED',  NULL, 'DONE',     TRUE,  FALSE, NULL, '尿路結石の手術で入院中', NULL, '/photos/demo_19.jpg'),
  (20, 1, 'こてつ',   'CAT', 'MALE',   7,  '2026-07-20', TRUE,  '2026-09-28', '杉並区の公園',     '野良猫の保護',       'NOT_ADOPTABLE', NULL, 'NOT_DONE', FALSE, FALSE, NULL, 'ワクチンは2回目が終わったら済にする', 'きなこと兄妹。まだ小さいので譲渡は先', '/photos/demo_20.jpg'),
  (21, 1, 'きなこ',   'CAT', 'FEMALE', 7,  '2026-07-20', TRUE,  '2026-09-28', '杉並区の公園',     '野良猫の保護',       'NOT_ADOPTABLE', NULL, 'NOT_DONE', FALSE, FALSE, NULL, 'ワクチンは2回目が終わったら済にする', 'こてつと兄妹', '/photos/demo_21.jpg'),
  (22, 1, 'シルク',   'CAT', 'FEMALE', 15, '2022-08-08', FALSE, '2026-05-05', '世田谷区',         '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000022', NULL, '長毛なので毎日ブラッシングが必要', '/photos/demo_22.jpg'),
  (23, 1, 'レン',     'CAT', 'MALE',   16, '2023-03-03', TRUE,  '2026-06-30', '渋谷区',           '迷子',               'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, '運動量が多い。キャットタワーがある家へ', '/photos/demo_23.jpg'),
  (24, 1, 'サバ',     'CAT', 'MALE',   7,  '2020-09-09', TRUE,  '2025-12-01', '練馬区',           '野良猫の保護',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, '猫エイズ（FIV）陽性。症状はない', '穏やか。理解のある方へ', '/photos/demo_24.jpg'),
  (25, 1, 'みかん',   'CAT', 'FEMALE', 7,  '2025-04-01', TRUE,  '2026-08-10', '豊島区',           '個人からの相談',     'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, '人見知りしない', '/photos/demo_25.jpg'),
  (26, 1, 'ノア',     'CAT', 'MALE',   8,  '2021-11-11', FALSE, '2026-07-15', '世田谷区',         '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000026', NULL, '山口さんとお見合い済み', '/photos/demo_26.jpg'),
  (27, 1, 'ぽんず',   'CAT', 'MALE',   7,  '2019-05-05', TRUE,  '2026-01-20', '板橋区',           '保健所から引き取り', 'NOT_ADOPTABLE', NULL, 'DONE',     TRUE,  FALSE, NULL, '腎臓の数値が高め。療法食', NULL, '/photos/demo_27.jpg'),
  (28, 1, 'ここあ',   'CAT', 'FEMALE', 11, '2023-02-02', FALSE, '2026-09-05', '渋谷区',           '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000028', NULL, '足が短いので段差に注意', '/photos/demo_28.jpg'),
  (29, 1, 'あずき',   'CAT', 'FEMALE', 7,  '2024-09-01', TRUE,  '2026-10-03', '新宿区',           '野良猫の保護',       'NOT_ADOPTABLE', NULL, 'UNKNOWN',  FALSE, FALSE, NULL, '保護したばかり。健康診断の結果待ち', NULL, '/photos/demo_29.jpg'),
  -- 団体 1・保護が終わった子（初期表示の一覧には出ない）
  (30, 1, 'モモ',     'DOG', 'FEMALE', 1,  '2015-06-20', TRUE,  '2024-12-01', '練馬区',           '保健所から引き取り', 'ADOPTED',       2,    'DONE',     TRUE,  TRUE,  NULL, '高齢。関節に注意', '2025年6月に小林さん宅へ譲渡', '/photos/demo_30.jpg'),
  (31, 1, 'ココ',     'DOG', 'FEMALE', 2,  '2021-12-24', TRUE,  '2026-04-02', '中野区',           '飼い主放棄',         'ADOPTED',       6,    'DONE',     TRUE,  TRUE,  '392140000000031', NULL, '2026年8月に岡田さん宅へ譲渡', '/photos/demo_31.jpg'),
  (32, 1, 'ハル',     'CAT', 'MALE',   7,  '2023-04-10', TRUE,  '2026-01-08', '新宿区',           '野良猫の保護',       'ADOPTED',       5,    'DONE',     TRUE,  FALSE, NULL, NULL, '2026年5月に斎藤さん宅へ譲渡', '/photos/demo_32.jpg'),
  (33, 1, 'クロ',     'CAT', 'MALE',   7,  '2023-04-01', TRUE,  '2025-09-15', '新宿御苑付近',     '迷子',               'RETURNED',      NULL, 'UNKNOWN',  FALSE, FALSE, '392140000000033', NULL, 'マイクロチップから飼い主が分かり返還', NULL),
  (34, 1, 'テン',     'CAT', 'FEMALE', 7,  '2022-06-06', TRUE,  '2026-03-15', '杉並区',           '野良猫の保護',       'TRANSFERRED',   NULL, 'DONE',     TRUE,  FALSE, NULL, '持病の治療のため移管', '医療体制のある団体へ移管', '/photos/demo_34.jpg'),
  -- 団体 2（みなと保護猫クラブ）
  (35, 2, 'レオ',     'CAT', 'MALE',   8,  '2021-09-09', TRUE,  '2025-09-10', '横浜駅西口',       '迷子',               'NOT_ADOPTABLE', NULL, 'UNKNOWN',  FALSE, FALSE, NULL, NULL, NULL, '/photos/demo_35.jpg'),
  (36, 2, 'ミルク',   'CAT', 'FEMALE', 15, '2021-04-04', FALSE, '2026-05-01', '横浜市中区',       '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000036', NULL, 'おっとりしている', '/photos/demo_36.jpg'),
  (37, 2, 'シエル',   'CAT', 'FEMALE', 10, '2022-10-10', TRUE,  '2026-06-12', '横浜市港北区',     '迷子',               'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, NULL, '/photos/demo_37.jpg'),
  (38, 2, 'タビ',     'CAT', 'MALE',   7,  '2023-01-20', TRUE,  '2026-04-18', '横浜市神奈川区',   '野良猫の保護',       'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, '足先だけ白い', '/photos/demo_38.jpg'),
  (39, 2, 'ふく',     'CAT', 'MALE',   7,  '2025-11-01', TRUE,  '2026-09-01', '横浜市西区',       '野良猫の保護',       'NOT_ADOPTABLE', NULL, 'NOT_DONE', TRUE,  FALSE, NULL, NULL, '去勢手術のあと譲渡可にする', '/photos/demo_39.jpg'),
  (40, 2, 'すず',     'CAT', 'FEMALE', 7,  '2023-07-07', TRUE,  '2026-03-03', '川崎市',           '野良猫の保護',       'TRIAL',         3,    'DONE',     TRUE,  FALSE, NULL, NULL, '渡辺さん宅でトライアル中', '/photos/demo_40.jpg'),
  (41, 2, 'こはる',   'CAT', 'FEMALE', 7,  '2024-03-03', TRUE,  '2026-07-07', '横浜市中区',       '個人からの相談',     'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, NULL, NULL, NULL, '/photos/demo_41.jpg'),
  (42, 2, 'ラテ',     'CAT', 'MALE',   11, '2022-12-12', FALSE, '2026-08-20', '横浜市港北区',     '飼い主放棄',         'ADOPTABLE',     NULL, 'DONE',     TRUE,  FALSE, '392140000000042', NULL, NULL, '/photos/demo_42.jpg'),
  (43, 2, 'ナナ',     'CAT', 'FEMALE', 8,  '2020-08-08', FALSE, '2026-02-20', '横浜市西区',       '飼い主放棄',         'ADOPTED',       8,    'DONE',     TRUE,  FALSE, NULL, NULL, '2026年7月に北村さん宅へ譲渡', '/photos/demo_43.jpg');

-- イベント。event_type_id は schema.sql のマスタ:
--   1 通院 / 2 入院 / 3 退院 / 4 避妊去勢手術 / 5 混合ワクチン / 6 狂犬病ワクチン / 7 マイクロチップ装着
--   8 トライアル開始 / 9 トライアル返却 / 10 譲渡 / 11 その他
-- staff_id（対応スタッフ）は完了済みのイベントだけに入れる。完了できるのは管理ユーザーと常勤スタッフ（1 山田・2 佐藤・7 加藤、団体 2 は 4 高橋・5 田中）

-- 過去の記録（日付固定）。個体詳細の「イベント」欄に経過が並ぶように入れている
INSERT INTO events (organization_id, event_type_id, animal_id, adopter_id, staff_id, event_date, event_time, place, done, cost, notes) VALUES
  (1, 5,  13, NULL, 2, '2025-09-15', '10:00:00', 'さくら動物病院', TRUE, 5000,  NULL),
  (1, 5,  14, NULL, 2, '2026-02-01', '10:00:00', 'さくら動物病院', TRUE, 5000,  '1回目'),
  (1, 5,  14, NULL, 2, '2026-03-01', '10:00:00', 'さくら動物病院', TRUE, 5000,  '2回目'),
  (1, 4,  14, NULL, 1, '2026-03-20', '09:30:00', 'さくら動物病院', TRUE, 15000, NULL),
  (1, 8,  30, 2,    1, '2025-06-01', '13:00:00', '小林さん宅',     TRUE, NULL,  '2週間のトライアル'),
  (1, 10, 30, 2,    1, '2025-06-15', '11:00:00', '小林さん宅',     TRUE, NULL,  NULL),
  (1, 8,  32, 5,    2, '2026-04-25', '13:00:00', '斎藤さん宅',     TRUE, NULL,  NULL),
  (1, 10, 32, 5,    2, '2026-05-10', '11:00:00', '斎藤さん宅',     TRUE, NULL,  NULL),
  (1, 8,  31, 6,    7, '2026-07-20', '10:00:00', '岡田さん宅',     TRUE, NULL,  NULL),
  (1, 10, 31, 6,    7, '2026-08-03', '10:00:00', '岡田さん宅',     TRUE, NULL,  NULL),
  (1, 11, 33, NULL, 2, '2025-09-20', '15:00:00', '事務所',         TRUE, NULL,  '飼い主へ返還（マイクロチップで判明）'),
  (1, 11, 34, NULL, 1, '2026-06-10', '14:00:00', '事務所',         TRUE, NULL,  '医療体制のある団体へ移管'),
  (2, 10, 43, 8,    4, '2026-07-01', '11:00:00', '北村さん宅',     TRUE, NULL,  NULL);

-- 今月の予定と記録（流した日 = CURDATE() が基準）。トップとイベント管理のカレンダーに出る
INSERT INTO events (organization_id, event_type_id, animal_id, adopter_id, staff_id, event_date, event_time, place, done, cost, notes) VALUES
  -- 済
  (1, 8,  4,  9,    2,    DATE_SUB(CURDATE(), INTERVAL 25 DAY), '13:00:00', '池田さん宅',             TRUE,  NULL,  NULL),
  (1, 5,  15, NULL, 2,    DATE_SUB(CURDATE(), INTERVAL 14 DAY), '10:00:00', 'さくら動物病院',         TRUE,  5000,  '年1回の追加接種'),
  (1, 4,  18, NULL, 1,    DATE_SUB(CURDATE(), INTERVAL 12 DAY), '09:30:00', 'さくら動物病院',         TRUE,  15000, NULL),
  (1, 9,  4,  9,    2,    DATE_SUB(CURDATE(), INTERVAL 11 DAY), '14:00:00', '池田さん宅',             TRUE,  NULL,  '先住犬と相性が合わず返却'),
  (1, 1,  13, NULL, 2,    DATE_SUB(CURDATE(), INTERVAL 10 DAY), '10:00:00', 'さくら動物病院',         TRUE,  3000,  '結膜炎の再診。点眼を続ける'),
  (1, 2,  19, NULL, 1,    DATE_SUB(CURDATE(), INTERVAL 9 DAY),  '11:00:00', 'みどり動物医療センター', TRUE,  NULL,  '尿路結石の手術のため入院'),
  (1, 8,  12, 1,    2,    DATE_SUB(CURDATE(), INTERVAL 7 DAY),  '13:00:00', '中村さん宅',             TRUE,  NULL,  '1週間のトライアル'),
  (1, 7,  8,  NULL, 7,    DATE_SUB(CURDATE(), INTERVAL 6 DAY),  '15:00:00', 'さくら動物病院',         TRUE,  1500,  NULL),
  (1, 1,  29, NULL, 2,    DATE_SUB(CURDATE(), INTERVAL 5 DAY),  '10:00:00', 'さくら動物病院',         TRUE,  4000,  '健康診断と血液検査。結果は来週'),
  (1, 8,  3,  4,    1,    DATE_SUB(CURDATE(), INTERVAL 4 DAY),  '10:00:00', '清水さん宅',             TRUE,  NULL,  '2週間のトライアル'),
  (1, 5,  20, NULL, 7,    DATE_SUB(CURDATE(), INTERVAL 3 DAY),  '10:00:00', 'さくら動物病院',         TRUE,  5000,  '1回目'),
  (1, 5,  21, NULL, 7,    DATE_SUB(CURDATE(), INTERVAL 3 DAY),  '10:00:00', 'さくら動物病院',         TRUE,  5000,  '1回目'),
  -- 未対応のまま日付が過ぎた予定（シーン 3 で見つける）
  (1, 5,  1,  NULL, NULL, DATE_SUB(CURDATE(), INTERVAL 2 DAY),  '10:00:00', 'さくら動物病院',         FALSE, 5000,  '追加接種'),
  -- 今日（シーン 4 でアクアの譲渡を完了にする）
  (1, 10, 12, 1,    NULL, CURDATE(),                            '11:00:00', '中村さん宅',             FALSE, NULL,  'トライアル終了。正式譲渡（契約書を持参）'),
  (1, 1,  6,  NULL, NULL, CURDATE(),                            '16:00:00', 'さくら動物病院',         FALSE, 3000,  '心臓の定期検診'),
  -- これからの予定
  (1, 3,  19, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 1 DAY),  '10:00:00', 'みどり動物医療センター', FALSE, NULL,  NULL),
  (1, 6,  9,  NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '14:00:00', 'さくら動物病院',         FALSE, 3500,  NULL),
  (1, 3,  2,  NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 3 DAY),  '11:00:00', 'さくら動物病院',         FALSE, NULL,  '骨折の経過は良好'),
  (1, 1,  27, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 5 DAY),  '10:30:00', 'さくら動物病院',         FALSE, 3000,  '腎臓の再検査'),
  (1, 5,  20, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 7 DAY),  '10:00:00', 'さくら動物病院',         FALSE, 5000,  '2回目'),
  (1, 5,  21, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 7 DAY),  '10:00:00', 'さくら動物病院',         FALSE, 5000,  '2回目'),
  (1, 4,  29, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 9 DAY),  '09:30:00', 'さくら動物病院',         FALSE, 15000, '健康診断の結果を見て最終判断'),
  (1, 8,  26, 7,    NULL, DATE_ADD(CURDATE(), INTERVAL 10 DAY), '13:00:00', '山口さん宅',             FALSE, NULL,  'お見合い済み'),
  (1, 1,  17, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 12 DAY), '10:00:00', 'さくら動物病院',         FALSE, 3000,  '耳の定期検診'),
  (1, 11, 11, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 14 DAY), '13:00:00', '新宿区民センター',       FALSE, NULL,  '譲渡会に参加'),
  (1, 7,  23, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 16 DAY), '15:00:00', 'さくら動物病院',         FALSE, 1500,  NULL),
  -- 団体 2
  (2, 5,  36, NULL, 5,    DATE_SUB(CURDATE(), INTERVAL 6 DAY),  '10:00:00', 'みなと動物クリニック',   TRUE,  5000,  NULL),
  (2, 8,  40, 3,    4,    DATE_SUB(CURDATE(), INTERVAL 1 DAY),  '13:00:00', '渡辺さん宅',             TRUE,  NULL,  '1週間のトライアル'),
  (2, 4,  39, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 2 DAY),  '09:30:00', 'みなと動物クリニック',   FALSE, 20000, NULL),
  (2, 1,  35, NULL, NULL, DATE_ADD(CURDATE(), INTERVAL 5 DAY),  '10:00:00', 'みなと動物クリニック',   FALSE, 4000,  '健康診断'),
  (2, 10, 40, 3,    NULL, DATE_ADD(CURDATE(), INTERVAL 6 DAY),  '11:00:00', '渡辺さん宅',             FALSE, NULL,  NULL);
