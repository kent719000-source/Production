<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>イベント詳細 | ホゴタロウ</title>
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
    --hogo-danger: #b23b3b;       /* 削除ボタンの色（やわらかめの赤） */
  }

  /* ページの見出し */
  h1 {
    color: var(--hogo-brown);
    font-weight: 700;
  }

  /* ===== カード（一覧の検索フォームと同じデザイン） ===== */
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

  /* ===== ボタン ===== */
  /* メインのボタン（編集）。強調色で塗りつぶし、両端を丸く */
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
  /* サブのボタン（一覧へ戻る）。普段は文字だけ、マウスを乗せるとうすいピーチ色 */
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
  /* 削除ボタン。普段は赤い枠線だけ、マウスを乗せると赤く塗りつぶし（うっかり押さないよう控えめに） */
  .btn-hogo-danger {
    background-color: #ffffff;
    border: 1.5px solid #e5b4b4;
    color: var(--hogo-danger);
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1.4rem;
    transition: background-color 0.2s, color 0.2s;
  }
  .btn-hogo-danger:hover,
  .btn-hogo-danger:focus-visible {
    background-color: var(--hogo-danger);
    border-color: var(--hogo-danger);
    color: #ffffff;
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

  /* 項目の色（ヘッダーと同じピーチ色）。Bootstrapの表はこの変数で背景色を決めている */
  .table-peach {
    --bs-table-bg: var(--hogo-peach);
    --bs-table-color: var(--hogo-brown); /* 項目名は茶色にして、背景となじませる */
    font-weight: 500;                    /* 太すぎない太字 */
  }

  /* 基本情報の表の左側（項目名の列）。幅を固定して、折り返さない */
  .hogo-th-label {
    width: 9rem;
    white-space: nowrap;
  }

  /* 表の中のリンクは普段は下線なし、マウスを乗せたときだけ下線を出す */
  .table a {
    text-decoration: none;
  }
  .table a:hover {
    text-decoration: underline;
  }

  /* イベントの対応状況のバッジ（済＝やさしい緑、未＝ピーチ） */
  .hogo-status {
    display: inline-block;
    font-size: 0.85rem;
    font-weight: 500;
    border-radius: 999px;
    padding: 0.05rem 0.8rem;
  }
  .hogo-status-done {
    background-color: #e3f1e1;
    color: #3d7a3a;
  }
  .hogo-status-todo {
    background-color: var(--hogo-peach-light);
    color: var(--hogo-accent);
    border: 1px solid var(--hogo-peach);
  }

  /* 0件のとき・メモが空のときの表示 */
  .hogo-empty {
    background-color: var(--hogo-peach-light);
    border: 1px dashed var(--hogo-border);
    border-radius: 12px;
    color: var(--hogo-brown);
    text-align: center;
    padding: 1.25rem;
    margin: 0;
  }

  /* メモの本文 */
  .hogo-notes {
    white-space: pre-wrap;
    margin: 0;
  }

  /* イベント詳細固有の表示 */
  .event-detail .table { table-layout: fixed; }
  .event-detail td, .event-detail .hogo-notes { overflow-wrap: anywhere; }
  .event-detail .stamp-button {
    width: 76px; height: 76px; display: inline-flex;
    align-items: center; justify-content: center;
    border: 2px dashed #bca28d; border-radius: 50%;
    background: #fffaf5; color: var(--hogo-brown); cursor: pointer;
  }
  .event-detail .stamp-button:hover { background: var(--hogo-peach-light); }
  .event-detail .stamp-done {
    border: 3px solid var(--hogo-danger); color: var(--hogo-danger);
    font-size: 30px; font-weight: 700; transform: rotate(-10deg);
  }
  .event-detail a:focus-visible, .event-detail button:focus-visible {
    outline: 3px solid var(--hogo-accent); outline-offset: 3px;
  }
  .event-detail .status-panel small { display: block; margin-top: .75rem; color: #7a5a44; }
  .event-detail .alert { border-radius: 12px; }
  @media (max-width: 575.98px) {
    .event-detail .hogo-card-body { padding: 1rem; }
    .event-detail .hogo-th-label { width: 7rem; white-space: normal; }
    .event-detail .table > :not(caption) > * > * { padding: .65rem .75rem; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
<main class="container event-detail mb-5">
  <h1 class="text-center my-5">イベント詳細</h1>
  <c:if test="${not empty message}">
    <div class="alert alert-success" role="status"><c:out value="${message}" /></div>
  </c:if>

  <%-- 戻る先は、このイベントが登録されている年月 --%>
  <c:url var="calendarUrl" value="/event">
    <c:param name="year" value="${event.eventDate.year}" />
    <c:param name="month" value="${event.eventDate.monthValue}" />
  </c:url>
  <c:url var="animalUrl" value="/animal/${event.animal.id}" />

  <%-- 里親詳細と同じ配置：左に戻る、右に編集・削除 --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="${fn:escapeXml(calendarUrl)}" class="btn btn-hogo-sub">← 一覧へ戻る</a>
    <div class="d-flex flex-wrap gap-2">
      <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
        <c:url var="editUrl" value="/event/${event.id}/edit" />
        <a href="${fn:escapeXml(editUrl)}" class="btn btn-hogo">編集</a>
      </sec:authorize>
      <sec:authorize access="hasRole('ADMIN')">
        <c:url var="deleteUrl" value="/event/${event.id}/delete" />
        <form:form id="event-delete" action="${deleteUrl}" method="post"
                   cssClass="m-0" data-confirm="本当に削除しますか？">
          <button type="submit" class="btn btn-hogo-danger">削除</button>
        </form:form>
      </sec:authorize>
    </div>
  </div>

  <%-- PCでは2列、狭い画面では縦に並ぶ --%>
  <div class="row g-4">
    <div class="col-lg-7">
      <section class="hogo-card" aria-labelledby="event-info-heading">
        <h2 id="event-info-heading" class="hogo-card-head h6 m-0">基本情報</h2>
        <div class="hogo-card-body">
          <table class="table table-bordered align-middle mb-0">
            <tbody>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">日付</th>
                <td><c:out value="${event.eventDate}" /></td>
            </tr>

            <c:if test="${not empty event.eventTime}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">時刻</th>
                    <td><c:out value="${event.eventTime}" /></td>
                </tr>
            </c:if>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">個体名</th>
                <td>
                    <a href="${fn:escapeXml(animalUrl)}">
                        <c:out value="${event.animal.name}" />
                    </a>
                </td>
            </tr>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">イベント種別</th>
                <td><c:out value="${event.eventType.name}" /></td>
            </tr>

            <c:if test="${not empty event.place}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">場所</th>
                    <td><c:out value="${event.place}" /></td>
                </tr>
            </c:if>

            <c:if test="${not empty event.adopter}">
                <c:url var="adopterUrl"
                       value="/adopter/${event.adopter.id}" />

                <tr>
                    <th scope="row" class="table-peach hogo-th-label">里親</th>
                    <td>
                        <a href="${fn:escapeXml(adopterUrl)}">
                            <c:out value="${event.adopter.name}" />
                        </a>
                    </td>
                </tr>
            </c:if>

			<tr>
			    <th scope="row" class="table-peach hogo-th-label">対応スタッフ</th>
			    <td>
			        <c:if test="${event.done and not empty event.staff}">
			            <c:url var="staffUrl"
			                   value="/staff/${event.staff.id}" />
			
			            <a href="${fn:escapeXml(staffUrl)}">
			                <c:out value="${event.staff.name}" />
			            </a>
			        </c:if>
			    </td>
			</tr>

            <c:if test="${event.cost != null}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">費用</th>
                    <td><c:out value="${event.cost}" /> 円</td>
                </tr>
            </c:if>



            
        
            </tbody>
          </table>
        </div>
      </section>
    </div>
    <div class="col-lg-5 d-flex flex-column gap-4">
      <section class="hogo-card" aria-labelledby="event-status-heading">
        <h2 id="event-status-heading" class="hogo-card-head h6 m-0">対応状況</h2>
        <div class="hogo-card-body status-panel text-center">

        <%-- 管理ユーザー・常勤スタッフは操作できる --%>
        <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
            <c:choose>

                <%-- 対応済なら、未対応に戻すボタン --%>
                <c:when test="${event.done}">
                    <c:url var="uncompleteUrl"
                           value="/event/${event.id}/uncomplete" />

                    <form:form id="event-uncomplete" cssClass="m-0" action="${uncompleteUrl}" method="post"
                        onsubmit="return confirm('未対応に戻しますか？');">

                        <button type="submit"
                                class="stamp-button stamp-done"
                                aria-label="対応済。クリックすると未対応に戻します">
                            済
                        </button>
                    </form:form>

                    <small>クリックで未対応に戻す</small>
                </c:when>

                <%-- 未対応なら、完了にするボタン --%>
                <c:otherwise>
                    <c:url var="completeUrl"
                           value="/event/${event.id}/complete" />

                    <form:form id="event-complete" cssClass="m-0" action="${completeUrl}" method="post"
                        onsubmit="return confirm('イベントを完了にしますか？個体の情報は自動では変わりません');">

                        <button type="submit"
                                class="stamp-button"
                                aria-label="未対応。クリックすると対応済にします">
                        </button>
                    </form:form>

                    <small>未対応：クリックで対応済にする</small>
                </c:otherwise>

            </c:choose>
        </sec:authorize>

        <%-- ボランティアには文字だけ表示する --%>
        <sec:authorize access="hasRole('VOLUNTEER')">
            <c:choose>
                <c:when test="${event.done}"><span class="hogo-status hogo-status-done">対応済</span></c:when>
                <c:otherwise><span class="hogo-status hogo-status-todo">未対応</span></c:otherwise>
            </c:choose>
        </sec:authorize>
    
        </div>
      </section>
      <section class="hogo-card" aria-labelledby="event-notes-heading">
        <h2 id="event-notes-heading" class="hogo-card-head h6 m-0">特記事項</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty event.notes}">
              <p class="hogo-empty">特記事項はありません</p>
            </c:when>
            <c:otherwise>
              <p class="hogo-notes"><c:out value="${event.notes}" /></p>
            </c:otherwise>
          </c:choose>
        </div>
      </section>
    </div>
  </div>
</main>
<script>
document.addEventListener("submit", function (event) {
    const form = event.target;

    if (!(form instanceof HTMLFormElement)) {
        return;
    }

    // フォームのdata-confirmに書かれた確認文を取り出す
    const message = form.dataset.confirm;

    // 「キャンセル」なら送信を止める
    if (message && !window.confirm(message)) {
        event.preventDefault();
    }
});
</script>
</body>
</html>
