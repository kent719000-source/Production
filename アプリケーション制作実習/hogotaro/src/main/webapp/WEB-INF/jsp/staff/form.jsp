<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:choose><c:when test="${mode == 'edit'}">スタッフ編集</c:when><c:otherwise>スタッフ新規登録</c:otherwise></c:choose> | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<%-- ここから「スタッフだけ」の前までは adopter/form.jsp と同じ。共通の head.jspf ができたら、その include 1行に置き換える --%>
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

  /* ===== ここからスタッフだけ ===== */
  /* プルダウン（ユーザー種別）も、入力欄と同じ枠線・角丸・光り方にする（共通CSS hogotarou.css と同じ指定） */
  .form-select {
    border-color: var(--hogo-border);
    border-radius: 10px;
    background-color: #fffdfb;
  }
  .form-select:focus {
    border-color: #e8a066;
    box-shadow: 0 0 0 0.25rem rgba(255, 170, 110, 0.3);
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<c:choose>
  <c:when test="${mode == 'edit'}">
    <h1 class="text-center my-5">スタッフ編集</h1>
  </c:when>
  <c:otherwise>
    <h1 class="text-center my-5">スタッフ新規登録</h1>
  </c:otherwise>
</c:choose>

<div class="container mb-5">
  <%-- フォームの横幅を読みやすい幅に収める（PCでは中央の8/12） --%>
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <%-- メッセージ（フラッシュ。1回だけ表示される） --%>
      <c:if test="${not empty message}">
        <div class="alert alert-warning"><c:out value="${message}"/></div>
      </c:if>

      <%-- action を書かないと、今開いている URL（/staff/new か /staff/{id}/edit）に POST する。CSRF のトークンは form:form が自動で入れる --%>
      <form:form modelAttribute="staffForm" method="post" cssClass="hogo-card">
        <h2 class="hogo-card-head h6 m-0">スタッフ情報</h2>

        <div class="hogo-card-body">
          <div class="row g-4">

            <c:choose>
              <c:when test="${mode == 'edit'}">
                <%-- 編集：ログインIDは変えられないので文字で出すだけ（値は送られない） --%>
                <div class="col-md-6">
                  <div class="form-label">ログインID</div>
                  <p class="form-control-plaintext"><c:out value="${staff.loginId}"/></p>
                </div>
                <div class="col-md-6">
                  <form:label path="password" cssClass="form-label">パスワード</form:label>
                  <%-- cssErrorClass：エラーがあるときだけ使われるクラス。is-invalid で枠が赤くなる --%>
                  <form:password path="password" maxlength="72" autocomplete="new-password" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                  <div class="form-text">変更する場合だけ入力してください</div>
                  <form:errors path="password" cssClass="invalid-feedback d-block"/>
                </div>
              </c:when>
              <c:otherwise>
                <div class="col-md-6">
                  <form:label path="loginId" cssClass="form-label">ログインID<span class="hogo-required">必須</span></form:label>
                  <form:input path="loginId" maxlength="30" autocomplete="off" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                  <form:errors path="loginId" cssClass="invalid-feedback d-block"/>
                </div>
                <div class="col-md-6">
                  <form:label path="password" cssClass="form-label">パスワード<span class="hogo-required">必須</span></form:label>
                  <form:password path="password" maxlength="72" autocomplete="new-password" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
                  <form:errors path="password" cssClass="invalid-feedback d-block"/>
                </div>
              </c:otherwise>
            </c:choose>

            <%-- 名前 --%>
            <div class="col-md-6">
              <form:label path="name" cssClass="form-label">名前<span class="hogo-required">必須</span></form:label>
              <form:input path="name" maxlength="30" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="name" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- 性別（ラジオボタンは複数あるので、fieldset と legend でひとまとまりにする） --%>
            <fieldset class="col-md-6">
              <legend class="form-label">性別<span class="hogo-required">必須</span></legend>
              <c:forEach var="g" items="${genderList}">
                <div class="form-check form-check-inline">
                  <form:radiobutton path="gender" value="${g}" id="gender-${g}" cssClass="form-check-input"/>
                  <label class="form-check-label" for="gender-${g}"><c:out value="${g.label}"/></label>
                </div>
              </c:forEach>
              <form:errors path="gender" cssClass="invalid-feedback d-block"/>
            </fieldset>

            <%-- 生年月日 --%>
            <div class="col-md-6">
              <form:label path="birthday" cssClass="form-label">生年月日<span class="hogo-required">必須</span></form:label>
              <form:input path="birthday" type="date" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="birthday" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- 電話番号 --%>
            <div class="col-md-6">
              <form:label path="phoneNumber" cssClass="form-label">電話番号<span class="hogo-required">必須</span></form:label>
              <form:input path="phoneNumber" type="tel" maxlength="20" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="phoneNumber" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- 住所（長いので横幅いっぱい） --%>
            <div class="col-12">
              <form:label path="address" cssClass="form-label">住所</form:label>
              <form:input path="address" maxlength="100" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="address" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- メールアドレス --%>
            <div class="col-12">
              <form:label path="email" cssClass="form-label">メールアドレス</form:label>
              <form:input path="email" type="email" maxlength="255" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="email" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- 登録日 --%>
            <div class="col-md-6">
              <form:label path="joinedDate" cssClass="form-label">登録日</form:label>
              <form:input path="joinedDate" type="date" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <div class="form-text">団体にスタッフとして登録した日</div>
              <form:errors path="joinedDate" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ユーザー種別 --%>
            <div class="col-md-6">
              <form:label path="userTypeId" cssClass="form-label">ユーザー種別<span class="hogo-required">必須</span></form:label>
              <form:select path="userTypeId" cssClass="form-select" cssErrorClass="form-select is-invalid">
                <form:option value="">選択してください</form:option>
                <form:options items="${userTypeList}" itemValue="id" itemLabel="name"/>
              </form:select>
              <form:errors path="userTypeId" cssClass="invalid-feedback d-block"/>
              <c:if test="${mode == 'edit' && staff.id == loginUser.staffId}">
                <div class="form-text text-danger">自分自身のユーザー種別は変更できません</div>
              </c:if>
            </div>

            <%-- 特記事項 --%>
            <div class="col-12">
              <form:label path="notes" cssClass="form-label">特記事項</form:label>
              <form:textarea path="notes" rows="4" maxlength="2000" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="notes" cssClass="invalid-feedback d-block"/>
            </div>

          </div>
        </div>

        <%-- ボタン。右寄せで「キャンセル」「登録/更新」の順に並べる（里親と同じ） --%>
        <div class="hogo-card-foot d-flex justify-content-end gap-2">
          <c:choose>
            <c:when test="${mode == 'edit'}">
              <a href="/staff/${staff.id}" class="btn btn-hogo-sub">キャンセル</a>
              <button type="submit" class="btn btn-hogo">更新</button>
            </c:when>
            <c:otherwise>
              <a href="/staff" class="btn btn-hogo-sub">キャンセル</a>
              <button type="submit" class="btn btn-hogo">登録</button>
            </c:otherwise>
          </c:choose>
        </div>
      </form:form>

    </div>
  </div>
</div>

</body>
</html>
