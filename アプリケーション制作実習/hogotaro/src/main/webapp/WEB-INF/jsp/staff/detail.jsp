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
<title>スタッフ詳細 | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<%-- ここから「スタッフだけ」の前までは adopter/detail.jsp と同じ。共通の head.jspf ができたら、その include 1行に置き換える --%>
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

  /* ===== ここからスタッフだけ ===== */
  /* 未入力の項目。目立ちすぎない薄い茶色 */
  .not-entered {
    color: #a08a7a;
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">スタッフ詳細</h1>
<div class="container mb-5">

  <%-- 登録・編集・削除のあとのメッセージ（フラッシュ。1回だけ表示される） --%>
  <c:if test="${not empty message}">
    <div class="alert alert-warning"><c:out value="${message}"/></div>
  </c:if>

  <%-- 操作ボタンの行。左に「一覧へ戻る」、右に「編集」「削除」（里親詳細と同じ並び） --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="/staff" class="btn btn-hogo-sub">← 一覧へ戻る</a>

    <%-- 編集・削除は管理ユーザーだけ --%>
    <c:if test="${loginUser.role == 'ADMIN'}">
      <div class="d-flex gap-2">
        <a href="/staff/${staff.id}/edit" class="btn btn-hogo">編集</a>
        <%-- 自分自身は削除できない --%>
        <c:if test="${staff.id != loginUser.staffId}">
          <form:form method="post" action="/staff/${staff.id}/delete"
              cssClass="m-0" onsubmit="return confirm('本当に削除しますか？')">
            <button type="submit" class="btn btn-hogo-danger">削除</button>
          </form:form>
        </c:if>
      </div>
    </c:if>
  </div>

  <%-- 2列レイアウト。PC(lg以上)では左5：右7、スマホでは縦1列 --%>
  <div class="row g-4">

    <%-- ===== 左の列 ===== --%>
    <div class="col-lg-5 d-flex flex-column gap-4">

      <%-- 基本情報 --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">基本情報</h2>
        <div class="hogo-card-body">
          <table class="table table-bordered align-middle mb-0">
            <tbody>
              <%-- 項目名のセルは table-peach（ピーチ色）＋ hogo-th-label（幅をそろえる） --%>
              <tr><th scope="row" class="table-peach hogo-th-label">ID</th><td><c:out value="${staff.id}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">ログインID</th><td><c:out value="${staff.loginId}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">名前</th><td><c:out value="${staff.name}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">性別</th><td><c:out value="${staff.gender.label}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">年齢</th><td><c:out value="${staff.age}"/>歳</td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">生年月日</th><td><c:out value="${staff.birthday}"/></td></tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">住所</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.address}"><c:out value="${staff.address}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr><th scope="row" class="table-peach hogo-th-label">電話番号</th><td><c:out value="${staff.phoneNumber}"/></td></tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">メールアドレス</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.email}"><c:out value="${staff.email}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">登録日</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.joinedDate}"><c:out value="${staff.joinedDate}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr><th scope="row" class="table-peach hogo-th-label">ユーザー種別</th><td><c:out value="${staff.userType.name}"/></td></tr>
            </tbody>
          </table>
        </div>
      </section>

      <%-- 特記事項 --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">特記事項</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${not empty staff.notes}">
              <%-- hogo-notes：入力したときの改行をそのまま表示する。c:out とタグの間に改行を入れない（余分な空白も表示されるため） --%>
              <p class="hogo-notes"><c:out value="${staff.notes}"/></p>
            </c:when>
            <c:otherwise><p class="m-0"><span class="not-entered">未入力</span></p></c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>

    <%-- ===== 右の列 ===== --%>
    <div class="col-lg-7 d-flex flex-column gap-4">

      <%-- 対応したイベント --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">
          対応したイベント
          <%-- fn:length：リストの件数を数える関数 --%>
          <span class="hogo-badge">${fn:length(eventList)}件</span>
        </h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty eventList}">
              <p class="hogo-empty">イベントはありません</p>
            </c:when>
            <c:otherwise>
              <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-peach"><%-- 項目行（ヘッダーと同じピーチ色） --%>
                  <tr><th>日付</th><th>種別</th><th>個体名</th></tr>
                </thead>
                <tbody>
                  <c:forEach var="e" items="${eventList}">
                    <tr>
                      <td><a href="/event/${e.id}"><c:out value="${e.eventDate}"/></a></td>
                      <td><c:out value="${e.eventType.name}"/></td>
                      <td><c:out value="${e.animal.name}"/></td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>
  </div>

</div>
</body>
</html>
