<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${mode == 'new' ? 'イベント新規登録' : 'イベント編集'} | ホゴタロウ</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">

<%-- Bootstrapの後に、君の共通CSSを読み込む --%>
<c:url var="hogoCssUrl" value="/css/hogotarou.css" />
<link rel="stylesheet" href="${fn:escapeXml(hogoCssUrl)}">

</head>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<main class="container mb-5">
    <div class="row justify-content-center">
    <div class="col-12 col-lg-10 col-xl-8">
		<h1 class="text-center my-5">${mode == 'new' ? 'イベント新規登録' : 'イベント編集'}</h1>
		
		<%-- 新規登録か編集かによって、リンク先を切り替える --%>
		<c:choose>
		    <c:when test="${mode == 'new'}">
		        <c:url var="submitUrl" value="/event/new" />
		        <c:url var="cancelUrl" value="/event" />
		    </c:when>
		
		    <c:otherwise>
		        <c:url var="submitUrl" value="/event/${eventId}/edit" />
		        <c:url var="cancelUrl" value="/event/${eventId}" />
		    </c:otherwise>
		</c:choose>
		
		<form:form modelAttribute="eventForm"
		           action="${submitUrl}" method="post" cssClass="hogo-card">
        <h2 class="hogo-card-head h6 m-0">イベント情報</h2>
        <div class="hogo-card-body">
          <p class="small text-body-secondary mb-4">「必須」の項目を入力してください。里親はトライアル開始・譲渡の場合に必須です。</p>
          <div class="row g-4">

        <div class="col-12 col-md-6">
            <label for="eventDate" class="form-label">日付<span class="hogo-required">必須</span></label>
            <form:input cssClass="form-control" cssErrorClass="form-control is-invalid" path="eventDate" id="eventDate" aria-describedby="eventDate.errors" type="date" />
            <form:errors path="eventDate" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="eventTime" class="form-label">時刻</label>
            <form:input cssClass="form-control" cssErrorClass="form-control is-invalid" path="eventTime" id="eventTime" aria-describedby="eventTime.errors" type="time" />
            <form:errors path="eventTime" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="animalId" class="form-label">個体<span class="hogo-required">必須</span></label>
            <form:select cssClass="form-select" cssErrorClass="form-select is-invalid" path="animalId" id="animalId" aria-describedby="animalId.errors" htmlEscape="true">
                <form:option value="" label="選択してください" />
                <form:options items="${animalList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <form:errors path="animalId" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="eventTypeId" class="form-label">イベント種別<span class="hogo-required">必須</span></label>
            <form:select cssClass="form-select" cssErrorClass="form-select is-invalid" path="eventTypeId" id="eventTypeId" aria-describedby="eventTypeId.errors"
                         htmlEscape="true">
                <form:option value="" label="選択してください" />
                <form:options items="${eventTypeList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <form:errors path="eventTypeId" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="place" class="form-label">場所</label>
            <form:input cssClass="form-control" cssErrorClass="form-control is-invalid" path="place" id="place" aria-describedby="place.errors"
                        maxlength="100" htmlEscape="true" />
            <form:errors path="place" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="adopterId" class="form-label">里親</label>
            <form:select cssClass="form-select" cssErrorClass="form-select is-invalid" path="adopterId" id="adopterId" aria-describedby="adopter-help adopterId.errors"
                         htmlEscape="true">
                <form:option value="" label="なし" />
                <form:options items="${adopterList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <div id="adopter-help" class="form-text">トライアル開始・譲渡の場合は選択してください。</div>
            <form:errors path="adopterId" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12 col-md-6">
            <label for="cost" class="form-label">費用（円）</label>
            <form:input cssClass="form-control" cssErrorClass="form-control is-invalid" path="cost" id="cost" aria-describedby="cost.errors" type="number"
                        min="0" step="1" />
            <form:errors path="cost" cssClass="invalid-feedback d-block" />
        </div>

        <div class="col-12">
            <label for="notes" class="form-label">特記事項</label>
            <form:textarea cssClass="form-control" cssErrorClass="form-control is-invalid" path="notes" id="notes" aria-describedby="notes.errors"
                           rows="6" maxlength="2000"
                           htmlEscape="true" />
            <form:errors path="notes" cssClass="invalid-feedback d-block" />
        </div>

		</div>
        </div>
        <div class="hogo-card-foot d-flex flex-wrap justify-content-end align-items-center gap-2">
		    <button type="submit" class="btn btn-hogo order-2">
		        ${mode == 'new' ? '登録する' : '更新する'}
		    </button>
		
		    <a class="btn btn-hogo-sub order-1" href="${fn:escapeXml(cancelUrl)}">キャンセル</a>
		</div>
    </form:form>
    </div>
    </div>
</main>
</body>
</html>