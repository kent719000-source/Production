<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%-- エラー画面（S-19）。ほかの画面と同じく head.jspf（Bootstrap・共通CSS）と header.jspf を読む --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>エラー | ホゴタロウ</title>
</head>
<body>
<%-- ヘッダー。ログイン前のエラーでは、header.jspf がロゴだけの帯を出す（団体名などはログイン後だけ） --%>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

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
