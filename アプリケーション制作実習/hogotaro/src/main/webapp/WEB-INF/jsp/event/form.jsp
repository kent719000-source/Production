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

<style>
.event-form {
    max-width: 720px;
    margin: 32px auto;
    padding: 0 16px;
}

.field {
    margin-bottom: 20px;
}

.field label {
    display: block;
    margin-bottom: 6px;
    font-weight: bold;
}

.field input,
.field select,
.field textarea {
    box-sizing: border-box;
    width: 100%;
    padding: 8px;
    font: inherit;
}

.error {
    display: block;
    margin-top: 4px;
    color: #b02a37;
}

.actions {
    display: flex;
    align-items: center;
    gap: 20px;
}
</style>
</head>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<main class="event-form">
		<h1>${mode == 'new' ? 'イベント新規登録' : 'イベント編集'}</h1>
		
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
		           action="${submitUrl}" method="post">

        <div class="field">
            <label for="eventDate">日付（必須）</label>
            <form:input path="eventDate" id="eventDate" type="date" />
            <form:errors path="eventDate" cssClass="error" />
        </div>

        <div class="field">
            <label for="eventTime">時刻</label>
            <form:input path="eventTime" id="eventTime" type="time" />
            <form:errors path="eventTime" cssClass="error" />
        </div>

        <div class="field">
            <label for="animalId">個体（必須）</label>
            <form:select path="animalId" id="animalId" htmlEscape="true">
                <form:option value="" label="選択してください" />
                <form:options items="${animalList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <form:errors path="animalId" cssClass="error" />
        </div>

        <div class="field">
            <label for="eventTypeId">イベント種別（必須）</label>
            <form:select path="eventTypeId" id="eventTypeId"
                         htmlEscape="true">
                <form:option value="" label="選択してください" />
                <form:options items="${eventTypeList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <form:errors path="eventTypeId" cssClass="error" />
        </div>

        <div class="field">
            <label for="place">場所</label>
            <form:input path="place" id="place"
                        maxlength="100" htmlEscape="true" />
            <form:errors path="place" cssClass="error" />
        </div>

        <div class="field">
            <label for="adopterId">里親</label>
            <form:select path="adopterId" id="adopterId"
                         htmlEscape="true">
                <form:option value="" label="なし" />
                <form:options items="${adopterList}"
                              itemValue="id" itemLabel="name"
                              htmlEscape="true" />
            </form:select>
            <small>トライアル開始・譲渡の場合は選択してください。</small>
            <form:errors path="adopterId" cssClass="error" />
        </div>

        <div class="field">
            <label for="cost">費用（円）</label>
            <form:input path="cost" id="cost" type="number"
                        min="0" step="1" />
            <form:errors path="cost" cssClass="error" />
        </div>

        <div class="field">
            <label for="notes">特記事項</label>
            <form:textarea path="notes" id="notes"
                           rows="6" maxlength="2000"
                           htmlEscape="true" />
            <form:errors path="notes" cssClass="error" />
        </div>

		<div class="actions">
		    <button type="submit">
		        ${mode == 'new' ? '登録する' : '更新する'}
		    </button>
		
		    <a href="${fn:escapeXml(cancelUrl)}">キャンセル</a>
		</div>
    </form:form>
</main>
</body>
</html>