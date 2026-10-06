<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<style>
  /* ページ全体の文字。Bootstrapはこの変数でフォント・文字色・背景色を決めている */
  :root {
    --bs-body-font-family: 'Zen Maru Gothic', sans-serif; /* 丸ゴシックでやわらかい印象に */
    --bs-body-color: #4a3f38;              /* 真っ黒ではなく、こげ茶寄りの文字色 */
    --bs-body-bg: #fffaf5;                 /* ほんのり温かみのある白 */
    --bs-body-line-height: 1.8;            /* 行間を広げて読みやすく */
    --bs-link-color-rgb: 196, 98, 45;      /* リンクの色（オレンジ寄りの茶色） */
    --bs-link-hover-color-rgb: 150, 70, 30;/* リンクにマウスを乗せたときの色 */

    /* ホゴタロウの配色。色はここにまとめて、下のCSSでは変数名で使う */
    --hogo-peach: #FFD1A0;        /* ロゴ・ヘッダーと同じピーチ色 */
    --hogo-peach-light: #fff1e4;  /* ピーチをうすくした色（背景・ホバー用） */
    --hogo-accent: #c4622d;       /* ボタンなどの強調色（オレンジ寄りの茶色） */
    --hogo-accent-dark: #a34f22;  /* 強調色にマウスを乗せたときの色 */
    --hogo-brown: #6b4226;        /* 見出し・ラベルの茶色 */
    --hogo-border: #ecd6c4;       /* 淡いベージュの線 */
  }

  /* ページの見出し */
  h1 {
    color: var(--hogo-brown);
    font-weight: 700;
  }

  /* ===== 検索フォーム ===== */
  /* 全体を白いカードにして、角を丸く・影をうっすら付ける */
  .hogo-search {
    background-color: #ffffff;
    border: 1px solid var(--hogo-border);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(160, 90, 40, 0.08);
    overflow: hidden;           /* 中の見出し帯の角も丸く切り取る */
  }
  /* カード上部の見出し帯（うすいピーチ色） */
  .hogo-search-head {
    background-color: var(--hogo-peach-light);
    border-bottom: 1px solid var(--hogo-border);
    color: var(--hogo-brown);
    font-weight: 700;
    padding: 0.6rem 1.25rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .hogo-search-body {
    padding: 1.25rem;
  }
  /* 入力欄のラベル */
  .hogo-search .form-label {
    color: var(--hogo-brown);
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 0.3rem;
  }
  /* 入力欄。枠線を淡いベージュ、角を丸く */
  .hogo-search .form-control {
    border-color: var(--hogo-border);
    border-radius: 10px;
    background-color: #fffdfb;
  }
  /* 入力欄を選んだとき。Bootstrap標準の青い光を、ピーチ色の光に変える */
  .hogo-search .form-control:focus {
    border-color: #e8a066;
    box-shadow: 0 0 0 0.25rem rgba(255, 170, 110, 0.3);
  }
  /* 入力欄の中の薄い例文 */
  .hogo-search .form-control::placeholder {
    color: #c8b3a3;
  }

  /* ===== ボタン ===== */
  /* メインのボタン（検索・新規登録）。強調色で塗りつぶし、両端を丸く */
  .btn-hogo {
    background-color: var(--hogo-accent);
    border: 1.5px solid var(--hogo-accent);
    color: #ffffff;
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1.4rem;
    transition: background-color 0.2s, box-shadow 0.2s;
  }
  .btn-hogo:hover,
  .btn-hogo:focus-visible {
    background-color: var(--hogo-accent-dark);
    border-color: var(--hogo-accent-dark);
    color: #ffffff;
    box-shadow: 0 3px 8px rgba(163, 79, 34, 0.25); /* ふわっと浮く */
  }
  /* サブのボタン（クリア）。普段は文字だけ、マウスを乗せるとうすいピーチ色 */
  .btn-hogo-sub {
    background-color: transparent;
    border: 1.5px solid transparent;
    color: var(--hogo-brown);
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1rem;
    transition: background-color 0.2s;
  }
  .btn-hogo-sub:hover,
  .btn-hogo-sub:focus-visible {
    background-color: var(--hogo-peach-light);
    color: var(--hogo-accent);
  }

  /* 件数の表示 */
  .hogo-count {
    color: var(--hogo-brown);
  }
  .hogo-count strong {
    color: var(--hogo-accent);
    font-size: 1.2rem;
  }

  /* ===== 表 ===== */
  /* 表全体の文字色と境界線の色（境界線は黒っぽい灰色ではなく、淡いベージュに） */
  .table {
    --bs-table-color: var(--bs-body-color);
    --bs-table-border-color: var(--hogo-border);
    --bs-table-hover-bg: var(--hogo-peach-light); /* マウスを乗せた行もピーチ系に */
  }

  /* セルの内側の余白を少し広げて、ゆったり見せる */
  .table > :not(caption) > * > * {
    padding: 0.75rem 1rem;
  }

  /* 項目行の色（ヘッダーと同じピーチ色）。Bootstrapの表はこの変数で背景色を決めている */
  .table-peach {
    --bs-table-bg: var(--hogo-peach);
    --bs-table-color: var(--hogo-brown); /* 項目名は茶色にして、背景となじませる */
    font-weight: 500;                    /* 太すぎない太字 */
  }

  /* 表の中のリンクは普段は下線なし、マウスを乗せたときだけ下線を出す */
  .table a {
    text-decoration: none;
  }
  .table a:hover {
    text-decoration: underline;
  }

  /* 0件のときの表示 */
  .hogo-empty {
    background-color: var(--hogo-peach-light);
    border: 1px dashed var(--hogo-border);
    border-radius: 16px;
    color: var(--hogo-brown);
    text-align: center;
    padding: 2rem;
  }
</style>
</head>
<body>
	<%@ include file="common/header.jspf"%>
	<h1 class="text-center my-5">トップページ</h1>

	<%-- 管理画面へのリンク --%>
	<div class="container mb-5">
	<ul>
		<li><a href="/animal">個体管理へ</a></li>
		<li><a href="/event">イベント管理へ</a></li>
		<li><a href="/adopter">里親管理へ</a></li>
		<li><a href="/staff">スタッフ管理へ</a></li>
	</ul>
	

	<section>
		<h2>保護頭数</h2>
		<p>
			保護中：${inCare }/${organization.capacity }<br>
			空き：${organization.capacity - inCare}
		</p>
	</section>


	<section>
		<h2>カレンダー</h2>
		<p>${calendar.year}年${calendar.month}月</p>
		<table border="1">

			<tr>
				<th>日</th>
				<th>月</th>
				<th>火</th>
				<th>水</th>
				<th>木</th>
				<th>金</th>
				<th>土</th>
			</tr>
			<c:forEach items="${calendar.weeks}" var="week">
				<tr>
					<c:forEach items="${week}" var="d">
						<%-- 前月・次月のはみ出したマスには other を付ける（CSS で薄くする用） --%>
						<td class="${d.inMonth ? '' : 'other'}">
							${d.day} <%-- その日のイベント。「個体名 種別」で、時刻は出さない（10/1 の決定） --%>
								<c:forEach items="${d.eventList}" var="e">
																<%-- マスを押すと、その日の月のイベント管理へ。はみ出したマスはその月へ飛ぶように d.date の年・月を使う --%>
									<a href="/event?year=${d.date.year}&month=${d.date.monthValue}">
										<div>
											<c:out value="${e.animal.name}" />
											<c:out value="${e.eventType.name}" />
										</div>
									</a>
								</c:forEach>
						</td>
					</c:forEach>
				</tr>
			</c:forEach>
		</table>
	</section>
</div>
</body>
</html>