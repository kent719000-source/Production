<%-- =========================================================
     新規登録・編集画面のテンプレート（見本：adopter/form.jsp）
     新規と編集を1つのJSPで作り、Controller から渡す mode（'new' / 'edit'）で切り替える
     使い方：このファイルをコピーして、★の付いた所を書き換える
       ○○      → 画面の名前（例：里親）
       xxx      → URL・変数の名前（例：adopter）
       xxxForm  → Controller の @ModelAttribute の名前（例：adopterForm）
     ========================================================= --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>○○${mode == 'new' ? '新規登録' : '編集'} | ホゴタロウ</title><%-- ★ --%>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">○○${mode == 'new' ? '新規登録' : '編集'}</h1><%-- ★ --%>

<%-- 送り先とキャンセル先は新規と編集で違うので、先に変数に入れておく --%>
<c:choose>
  <c:when test="${mode == 'new'}">
    <c:set var="action" value="${ctx}/xxx/new"/><%-- ★ --%>
    <%-- キャンセル：新規 → 一覧 --%>
    <c:set var="cancelUrl" value="${ctx}/xxx"/><%-- ★ --%>
  </c:when>
  <c:otherwise>
    <c:set var="action" value="${ctx}/xxx/${xxxId}/edit"/><%-- ★ --%>
    <%-- キャンセル：編集 → 詳細 --%>
    <c:set var="cancelUrl" value="${ctx}/xxx/${xxxId}"/><%-- ★ --%>
  </c:otherwise>
</c:choose>

<div class="container mb-5">
  <%-- フォームの横幅を読みやすい幅に収める（PCでは中央の8/12） --%>
  <div class="row justify-content-center">
    <div class="col-lg-8">

      <%-- 登録・編集・削除できなかった時のメッセージ --%>
      <%@ include file="/WEB-INF/jsp/common/message.jspf" %>

      <%-- 入力エラーがあるとき、フォームの上にまとめて知らせる --%>
      <spring:hasBindErrors name="xxxForm"><%-- ★ --%>
        <div class="alert alert-danger">入力内容に誤りがあります。赤枠の項目を確認してください。</div>
      </spring:hasBindErrors>

      <%-- POSTは必ずform:formで書く。（CSRFのトークンが自動で入る。<form>だと403）
           写真などのファイルを送る画面では enctype="multipart/form-data" を追加する --%>
      <form:form modelAttribute="xxxForm" method="post" action="${action}" cssClass="hogo-card"><%-- ★ --%>
        <h2 class="hogo-card-head h6 m-0">○○情報</h2><%-- ★ --%>

        <div class="hogo-card-body">
          <%-- row g-4：項目を並べる。短い項目は col-md-6（PCで2列）、長い項目は col-12（横幅いっぱい） --%>
          <div class="row g-4">

            <%-- ▼ 文字の入力（必須） --%>
            <div class="col-md-6">
              <form:label path="name" cssClass="form-label">名前<span class="hogo-required">必須</span></form:label>
              <%-- cssErrorClass：エラーがあるときだけ使われるクラス。is-invalid で枠が赤くなる --%>
              <form:input path="name" maxlength="30" cssClass="form-control" cssErrorClass="form-control is-invalid" placeholder="例：山田 花子"/>
              <%-- invalid-feedback は普段非表示なので d-block で表示させる --%>
              <form:errors path="name" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ▼ ラジオボタン（1つ選ぶ）。選択肢のリスト(enum.values()など)を Controller から渡す --%>
            <fieldset class="col-md-6">
              <legend class="form-label">区分<span class="hogo-required">必須</span></legend>
              <c:forEach var="k" items="${kindList}"><%-- ★ --%>
                <div class="form-check form-check-inline">
                  <form:radiobutton path="kind" value="${k}" id="kind-${k}" cssClass="form-check-input"/>
                  <label class="form-check-label" for="kind-${k}">${k.label}</label>
                </div>
              </c:forEach>
              <form:errors path="kind" cssClass="invalid-feedback d-block"/>
            </fieldset>

            <%-- ▼ 日付 --%>
            <div class="col-md-6">
              <form:label path="date" cssClass="form-label">日付</form:label>
              <form:input path="date" type="date" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="date" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ▼ プルダウン。form:options が選択済みの値に自動で selected を付ける --%>
            <div class="col-md-6">
              <form:label path="yyyId" cssClass="form-label">関連する○○</form:label>
              <form:select path="yyyId" cssClass="form-select" cssErrorClass="form-select is-invalid"><%-- ★ --%>
                <form:option value="" label="未選択"/>
                <%-- itemValue：送る値 / itemLabel：画面に出す文字 --%>
                <form:options items="${yyyList}" itemValue="id" itemLabel="name"/><%-- ★ --%>
              </form:select>
              <form:errors path="yyyId" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ▼ チェックボックス（はい／いいえの1つだけ） --%>
            <div class="col-md-6">
              <span class="form-label d-block">確認</span>
              <div class="form-check">
                <form:checkbox path="confirmed" id="confirmed" cssClass="form-check-input"/><%-- ★ --%>
                <label class="form-check-label" for="confirmed">済み</label>
              </div>
              <form:errors path="confirmed" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ▼ 長い文字の入力（横幅いっぱい） --%>
            <div class="col-12">
              <form:label path="address" cssClass="form-label">住所</form:label>
              <form:input path="address" maxlength="100" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="address" cssClass="invalid-feedback d-block"/>
            </div>

            <%-- ▼ 複数行の入力 --%>
            <div class="col-12">
              <form:label path="notes" cssClass="form-label">メモ</form:label>
              <form:textarea path="notes" rows="5" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
              <form:errors path="notes" cssClass="invalid-feedback d-block"/>
            </div>

          </div>
        </div>

        <%-- ボタン。右寄せで「キャンセル」「登録/更新」の順に並べる（メインの操作は右） --%>
        <div class="hogo-card-foot d-flex justify-content-end gap-2">
          <a href="${cancelUrl}" class="btn btn-hogo-sub">キャンセル</a>
          <button type="submit" class="btn btn-hogo">${mode == 'new' ? '登録する' : '更新する'}</button>
        </div>
      </form:form>

    </div>
  </div>
</div>

</body>
</html>
