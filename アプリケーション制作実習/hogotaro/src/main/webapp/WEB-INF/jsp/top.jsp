<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<%-- ここから「トップだけ」の前までは adopter/list.jsp と同じ。共通の head.jspf ができたら、その include 1行に置き換える --%>
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

  /* ===== ここからトップだけ ===== */
  /* カード（adopter/detail.jsp と同じ。共通CSS hogotarou.css にも同じ名前で入っている） */
  /* 白いカード。角を丸く・影をうっすら付ける */
  .hogo-card {
    background-color: #ffffff;
    border: 1px solid var(--hogo-border);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(160, 90, 40, 0.08);
    overflow: hidden;           /* 中の見出し帯の角も丸く切り取る */
  }
  /* カード上部の見出し帯（うすいピーチ色） */
  .hogo-card-head {
    background-color: var(--hogo-peach-light);
    border-bottom: 1px solid var(--hogo-border);
    color: var(--hogo-brown);
    font-weight: 700;
    padding: 0.6rem 1.25rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  /* 見出しの左に付ける丸い縦棒（目印） */
  .hogo-card-head::before {
    content: "";
    width: 5px;
    height: 1.1em;
    border-radius: 999px;
    background-color: var(--hogo-accent);
  }
  .hogo-card-body {
    padding: 1.25rem;
  }
  /* 見出し帯の右側に出す件数バッジ */
  .hogo-badge {
    margin-left: auto;          /* 右端に寄せる */
    background-color: var(--hogo-peach);
    color: var(--hogo-brown);
    font-size: 0.8rem;
    font-weight: 500;
    border-radius: 999px;
    padding: 0.1rem 0.7rem;
  }

  /* カレンダーの7列を同じ幅にする（無いと、文字の多い日の列だけ広がる） */
  .mini-cal {
    table-layout: fixed;
  }
  /* 前月・次月のはみ出したマスは文字を薄くする */
  .mini-cal .other {
    color: #c8b3a3;
  }
  /* マスの中のイベント。小さめの文字で1件ずつ */
  .mini-cal .event-link {
    display: block;
    font-size: 0.8rem;
    line-height: 1.4;
  }
  /* 保護頭数カード*/
  /* 空きの状態ごとの色。 is-ok / is-few / is-full のクラスで切り替える*/
  .hogo-capacity {--status-color: #3f8f5a;} /*受け入れOK：緑*/
  .hogo-capacity.is-few {--status-color: #b87400;} /*残りわずか：黄*/
  .hogo-capacity.is-full {--status-color: #c0392b;}/*満員：赤*/
  
  /* ステータスの大きな箱*/
  .hogo-status{
  	background-color: var(--status-color);
  	color: #ffffff;
  	border-radius: 14px;
  	padding: 1.5rem 1rem;
  	text-align: center;
  }
  /*白い丸の中にステータスアイコン*/
  .hogo-status-icon{
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 3.2rem;
	height: 3.2rem;
	border-radius: 50%;
	background-color: #ffffff;
	color: var(--status-color);
	font-size: 1.8rem;
	font-weight: 700;
	line-height: 1;
  }
  /*受け入れステータス*/
  .hogo-status-text{
  	font-size: 2.2rem;
  	font-weight: 700;
  	line-height: 1.3;
  	margin-top: 0.5rem;
  }
  /*空き頭数*/
  .hogo-status-free{
  	display: inline-block;
  	margin-top: 0.75rem;
  	padding: 0.2rem 1.2rem;
  	border-radius: 999px;
  	background-color: rgba(255,255,255,0.22);
  	font-size: 1.1rem;
  	font-weight: 500;
  }
  .hogo-status-free strong{
  	font-size: 2rem;
  	margin: 0 0.15em;
  }
  /*保護中/定員*/
  .hogo-incare{
  	text-align: center;
  	margin-top: 1.5rem;
  }
  .hogo-incare-label{
  	color: var(--hogo-brown);
  	font-size: 0.95rem;
  	font-weight: 700;
  }
  .hogo-incare-num{
  	color: var(--hogo-brown);
  	font-weight: 700;
  	line-height: 1.2;
  }
  .hogo-incare-num .now{ /*今の頭数は大きく強調*/
  	color: var(--hogo-accent);
  	font-size: 3.2rem;
  }
  .hogo-incare-num .cap{
  	font-size: 1.8rem;
  }
  .hogo-incare-num small{
  	font-size: 1rem;
  	font-weight: 500;
  	margin-left: 0.15em;
  }
  
  /*使用状況のバー*/
  .hogo-meter{
  	--bs-progress-height: 14px;
  	--bs-progress-bg: #f3e6da;
  	--bs-progress-border-radius: 999px;
  	--bs-progress-bar-bg: var(--status-color);
  	
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">トップページ</h1>
<div class="container mb-5">

  <%-- 管理画面へのリンク。ボタンを横に並べる（狭い画面では折り返す） --%>
  <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
    <a href="/animal" class="btn btn-hogo">個体管理へ</a>
    <a href="/event" class="btn btn-hogo">イベント管理へ</a>
    <a href="/adopter" class="btn btn-hogo">里親管理へ</a>
    <a href="/staff" class="btn btn-hogo">スタッフ管理へ</a>
  </div>

  <%-- 2列レイアウト。PC(lg以上)では左4：右8、スマホでは縦1列 --%>
  <div class="row g-4">

    <%-- ===== 左の列：保護頭数 ===== --%>
    <%-- 表示用の変数を先に作っておく --%>
    <c:set var="capacity" value="${organization.capacity}" />
    <c:set var="vacancy"  value="${capacity - inCare}" />
    <%-- 使用率（%）。定員が0のときは0で割らないようにする --%>
    <c:set var="usageRate" value="${capacity > 0 ? inCare * 100 / capacity : 0}" />
    <%-- 空きの状態：満員（赤）／残りわずか（黄）／受け入れOK（緑） --%>
    <c:choose>
      <c:when test="${vacancy <= 0}">
        <c:set var="capStatus" value="full" /><c:set var="capLabel" value="満員" /><c:set var="capIcon" value="✕" />
      </c:when>
      <c:when test="${usageRate >= 80}">
        <c:set var="capStatus" value="few" /><c:set var="capLabel" value="残りわずか" /><c:set var="capIcon" value="!" />
      </c:when>
      <c:otherwise>
        <c:set var="capStatus" value="ok" /><c:set var="capLabel" value="受け入れOK" /><c:set var="capIcon" value="✓" />
      </c:otherwise>
    </c:choose>

    <div class="col-lg-4">
      <%-- is-ok / is-few / is-full で色が切り替わる（上の <style>） --%>
      <section class="hogo-card hogo-capacity is-${capStatus}">
        <h2 class="hogo-card-head h6 m-0">保護頭数</h2>
        <div class="hogo-card-body">

          <%-- ステータス（一番目立たせる） --%>
          <div class="hogo-status">
            <div class="hogo-status-icon" aria-hidden="true">${capIcon}</div>
            <div class="hogo-status-text">${capLabel}</div>
            <%-- 定員オーバーでもマイナスは出さず0にする --%>
            <div class="hogo-status-free">空き<strong>${vacancy < 0 ? 0 : vacancy}</strong>頭</div>
          </div>

          <%-- 保護中 / 定員 --%>
          <div class="hogo-incare">
            <div class="hogo-incare-label">保護中 / 定員</div>
            <div class="hogo-incare-num">
              <span class="now">${inCare}</span><span class="cap"> / ${capacity}</span><small>頭</small>
            </div>
          </div>

          <%-- 使用状況のバー（Bootstrapの progress） --%>
          <div class="mt-2">
            <div class="progress hogo-meter" role="progressbar" aria-label="保護頭数の使用状況"
                 aria-valuenow="${inCare}" aria-valuemin="0" aria-valuemax="${capacity}">
              <%-- 100%を超えてもバーがはみ出さないよう100で止める --%>
              <div class="progress-bar" style="width: ${usageRate > 100 ? 100 : usageRate}%"></div>
            </div>
            <div class="text-end small mt-1">
              <fmt:formatNumber value="${usageRate}" maxFractionDigits="0" />% 使用中
            </div>
          </div>

        </div>
      </section>
    </div>

    <%-- ===== 右の列：カレンダー ===== --%>
    <div class="col-lg-8">
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">カレンダー（${calendar.year}年${calendar.month}月）</h2>
        <div class="hogo-card-body">
          <%-- table-bordered：各セルに境界線 / align-middle：上下中央ぞろえ / mini-cal：7列を同じ幅に（上の <style>） --%>
          <table class="table table-bordered align-middle mb-0 mini-cal">
            <thead class="table-peach"><%-- 曜日の行（ヘッダーと同じピーチ色） --%>
              <tr>
                <th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${calendar.weeks}" var="week">
                <tr>
                  <c:forEach items="${week}" var="d">
                    <%-- 前月・次月のはみ出したマスには other を付ける（上の <style> で薄くする） --%>
                    <td class="${d.inMonth ? '' : 'other'}">
                      ${d.day}
                      <%-- その日のイベント。「個体名 種別」で、時刻は出さない（10/1 の決定）。
                           押すと、その日の月のイベント管理へ。はみ出したマスはその月へ飛ぶように d.date の年・月を使う --%>
                      <c:forEach items="${d.eventList}" var="e">
                        <a href="/event?year=${d.date.year}&month=${d.date.monthValue}" class="event-link">
                          <c:out value="${e.animal.name}" />
                          <c:out value="${e.eventType.name}" />
                        </a>
                      </c:forEach>
                    </td>
                  </c:forEach>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </section>
    </div>

  </div>
</div>
</body>
</html>
