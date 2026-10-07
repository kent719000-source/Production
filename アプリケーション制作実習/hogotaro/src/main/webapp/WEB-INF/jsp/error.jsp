<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%-- エラー画面（S-19）。見た目は adopter/detail.jsp と同じ書き方（Bootstrap ＋ 下の <style>） --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>エラー | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<%-- ここから </style> までは adopter/detail.jsp と同じ。共通の head.jspf ができたら、その include 1行に置き換える --%>
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
</style>
</head>
<body>
<%-- ヘッダーはログインしているときだけ出す。
     header.jspf は団体名・名前を表示するので、ログイン前のエラー（ログイン前に存在しないファイルを開いた など）で出すと、
     団体名を取ろうとして例外になり、エラー画面そのものが表示されなくなるため --%>
<c:if test="${loginUser.loggedIn}">
  <%@ include file="/WEB-INF/jsp/common/header.jspf" %>
</c:if>

<h1 class="text-center my-5">エラー</h1>
<div class="container mb-5">
  <%-- 中央1列（PCでは中央の8/12） --%>
  <div class="row">
    <div class="col-lg-8 mx-auto">

      <%-- Spring Boot が status（HTTP の番号）をモデルに入れてくれる。Java のエラー処理クラスは書かない（基本設計 8 章）
           400: フォームの値の形がおかしい（日付の欄に文字、他団体の id を送られた など。普通に画面を使っていれば起きない）
           403: 権限が無い（ボランティアが登録画面の URL を直接開いた など）
           404: 無い id（他団体の id を含む）。Service の find() の orElseThrow が出す
           413: 写真が 5MB を超えた（application.properties の max-file-size） --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">エラー ${status}</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${status == 400}">
              <p class="m-0">送信された内容に誤りがあります。画面を開き直してから、もう一度操作してください</p>
            </c:when>
            <c:when test="${status == 403}">
              <p class="m-0">この操作を行う権限がありません</p>
            </c:when>
            <c:when test="${status == 404}">
              <p class="m-0">指定されたデータは存在しません</p>
            </c:when>
            <c:when test="${status == 413}">
              <p class="m-0">ファイルは 5MB 以下にしてください</p>
            </c:when>
            <c:otherwise>
              <p class="m-0">システムエラーが発生しました。時間を置いて再度お試しください</p>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

      <%-- トップへ戻るボタン（中央） --%>
      <div class="text-center mt-4">
        <a href="/" class="btn btn-hogo">トップページへ</a>
      </div>

    </div>
  </div>
</div>
</body>
</html>
