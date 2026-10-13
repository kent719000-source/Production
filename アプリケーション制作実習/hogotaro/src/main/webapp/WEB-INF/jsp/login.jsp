<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- ログイン画面（S-01）。GET /login で TopController#login が返す。POST /login は Spring Security が処理する --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>ログイン | ホゴタロウ</title>
<style>
  /* この画面だけのスタイル。共通のスタイルは hogotarou.css（head.jspf が読み込む） */
  .hogo-card-body {
    padding: 1.5rem 1.25rem;
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

</style>
</head>
<body>
<%-- ヘッダー。ログイン前なので、header.jspf はロゴだけの帯を出す（メニュー・団体名・ログアウトはログイン後だけ） --%>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

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
