<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- ログイン画面（S-01）。GET /login で TopController#login が返す。POST /login は Spring Security が処理する --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>ログイン | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<%-- ここから「ログイン画面だけ」の前までは adopter/form.jsp と同じ。共通の head.jspf ができたら、その include 1行に置き換える --%>
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

  /* ===== カード（一覧の検索フォーム・詳細ページと同じデザイン） ===== */
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
    padding: 1.5rem 1.25rem;
  }
  /* カード下部のボタンを並べる帯 */
  .hogo-card-foot {
    background-color: #fffdfb;
    border-top: 1px solid var(--hogo-border);
    padding: 1rem 1.25rem;
  }

  /* ===== 入力欄 ===== */
  /* 入力欄のラベル */
  .form-label {
    color: var(--hogo-brown);
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 0.3rem;
  }
  /* 入力欄。枠線を淡いベージュ、角を丸く */
  .form-control {
    border-color: var(--hogo-border);
    border-radius: 10px;
    background-color: #fffdfb;
  }
  /* 入力欄を選んだとき。Bootstrap標準の青い光を、ピーチ色の光に変える */
  .form-control:focus {
    border-color: #e8a066;
    box-shadow: 0 0 0 0.25rem rgba(255, 170, 110, 0.3);
  }
  /* 入力欄の中の薄い例文 */
  .form-control::placeholder {
    color: #c8b3a3;
  }
  /* ラジオボタンを選んだときの色（Bootstrap標準の青 → 強調色） */
  .form-check-input:checked {
    background-color: var(--hogo-accent);
    border-color: var(--hogo-accent);
  }
  .form-check-input:focus {
    border-color: #e8a066;
    box-shadow: 0 0 0 0.25rem rgba(255, 170, 110, 0.3);
  }

  /* 「必須」の小さなバッジ */
  .hogo-required {
    display: inline-block;
    background-color: var(--hogo-accent);
    color: #ffffff;
    font-size: 0.7rem;
    font-weight: 500;
    border-radius: 999px;
    padding: 0 0.5rem;
    margin-left: 0.4rem;
    vertical-align: middle;
  }

  /* ===== ボタン ===== */
  /* メインのボタン（登録・更新）。強調色で塗りつぶし、両端を丸く */
  .btn-hogo {
    background-color: var(--hogo-accent);
    border: 1.5px solid var(--hogo-accent);
    color: #ffffff;
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1.6rem;
    transition: background-color 0.2s, box-shadow 0.2s;
  }
  .btn-hogo:hover,
  .btn-hogo:focus-visible {
    background-color: var(--hogo-accent-dark);
    border-color: var(--hogo-accent-dark);
    color: #ffffff;
    box-shadow: 0 3px 8px rgba(163, 79, 34, 0.25); /* ふわっと浮く */
  }
  /* サブのボタン（キャンセル）。普段は文字だけ、マウスを乗せるとうすいピーチ色 */
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

  /* ===== ここからログイン画面だけ ===== */
  /* ヘッダーの帯（header.jspf から写したもの。ロゴだけの帯にするので、メニューとログアウトの部分は写していない） */
  /* ヘッダー全体。背景はロゴと同じピーチ色(#FFD1A0)にして、ロゴと一体に見せる */
  .hogo-header {
    background-color: #FFD1A0;
    font-family: 'Zen Maru Gothic', sans-serif; /* 丸ゴシックでやわらかい印象に */
    line-height: 1.5;
    padding: 0.75rem 0;                         /* 上下の余白。ヘッダーの縦幅はここで調整 */
    border-bottom: 1px solid #f0b985;           /* 下に細い線を引いて本文と区切る */
    box-shadow: 0 2px 6px rgba(160, 90, 40, 0.12); /* うっすら影を付けて浮かせる */
  }
  /* 幅の計算に余白と枠線を含める（Bootstrapが無い画面でも同じ大きさにするため） */
  .hogo-header,
  .hogo-header * {
    box-sizing: border-box;
  }

  /* 中身を並べる箱。Bootstrapの container と同じ幅にして、本文と左右の端をそろえる */
  .hogo-header .hogo-header-inner {
    width: 100%;
    margin: 0 auto;
    padding: 0 0.75rem;
    display: flex;
    flex-wrap: wrap;            /* 画面がせまいときは、はみ出さずに折り返す */
    align-items: center;
    gap: 1rem;
  }
  @media (min-width: 576px)  { .hogo-header .hogo-header-inner { max-width: 540px; } }
  @media (min-width: 768px)  { .hogo-header .hogo-header-inner { max-width: 720px; } }
  @media (min-width: 992px)  { .hogo-header .hogo-header-inner { max-width: 960px; } }
  @media (min-width: 1200px) { .hogo-header .hogo-header-inner { max-width: 1140px; } }
  @media (min-width: 1400px) { .hogo-header .hogo-header-inner { max-width: 1320px; } }

  /* ロゴ。マウスを乗せると少し薄くなり、押せることがわかる */
  .hogo-header .hogo-logo {
    display: inline-block;
    line-height: 0;             /* 画像の下にできるすき間をなくす */
  }
  .hogo-header .hogo-logo img {
    height: 64px;               /* 元画像(高さ138px)を約半分で表示するので、高解像度画面でもくっきり */
    width: auto;
    transition: opacity 0.2s;
  }
  .hogo-header .hogo-logo:hover img {
    opacity: 0.75;
  }
</style>
</head>
<body>
<%-- ヘッダー。ログイン前なので header.jspf は読まず、ロゴだけの帯にする（設計書 S-01 の画面イメージ）。
     header.jspf は団体名・名前を表示するので、ログイン前に読むと例外になる。見た目は header.jspf と同じクラス名・同じCSS --%>
<nav class="hogo-header">
  <div class="hogo-header-inner">
    <span class="hogo-logo">
      <img src="/images/hogotarou_logo_peach.png" alt="ホゴタロウ">
    </span>
  </div>
</nav>

<h1 class="text-center my-5">ログイン</h1>
<div class="container mb-5">
  <%-- フォームの横幅を読みやすい幅に収める（PCでは中央の4/12、タブレットでは6/12） --%>
  <div class="row justify-content-center">
    <div class="col-md-6 col-lg-4">

      <%-- メッセージ。フラッシュではなく、URL の ?error ?logout を見て出す（設計書 S-01）
           ?error：ログインIDかパスワードが違う（SecurityConfig の failureUrl）
           ?logout：ログアウトした（Spring Security がログアウト後に /login?logout へ戻す） --%>
      <c:if test="${param.error != null}">
        <div class="alert alert-danger">ログインに失敗しました</div>
      </c:if>
      <c:if test="${param.logout != null}">
        <div class="alert alert-success">ログアウトしました</div>
      </c:if>

      <%-- POST /login は Spring Security が受け取る（Controller は書かない）。
           form:form で書くと CSRF のトークンが自動で入る（生の <form> だと 403） --%>
      <form:form action="/login" method="post" cssClass="hogo-card">
        <h2 class="hogo-card-head h6 m-0">ログイン情報</h2>

        <div class="hogo-card-body">
          <div class="row g-4">
            <%-- name="loginId" は SecurityConfig の usernameParameter("loginId") と合わせる --%>
            <div class="col-12">
              <label for="loginId" class="form-label">ログインID</label>
              <input type="text" id="loginId" name="loginId" class="form-control" autocomplete="username" required autofocus>
            </div>
            <%-- name="password" は SecurityConfig の passwordParameter("password") と合わせる --%>
            <div class="col-12">
              <label for="password" class="form-label">パスワード</label>
              <input type="password" id="password" name="password" class="form-control" autocomplete="current-password" required>
            </div>
          </div>
        </div>

        <%-- ボタン。横幅いっぱい（w-100） --%>
        <div class="hogo-card-foot">
          <button type="submit" class="btn btn-hogo w-100">ログイン</button>
        </div>
      </form:form>

    </div>
  </div>
</div>
</body>
</html>
