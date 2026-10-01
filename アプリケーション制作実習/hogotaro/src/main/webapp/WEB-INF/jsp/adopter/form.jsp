<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>里親${mode == 'new' ? '新規登録' : '編集'} | ホゴタロウ</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1>里親${mode == 'new' ? '新規登録' : '編集'}</h1>

<%-- 送り先は新規と編集で違うので、先に action という名前の変数に入れておく --%>
<c:choose>
	<c:when test="${mode == 'new'}"><c:set var="action" value="/adopter/new"/></c:when>
	<c:otherwise><c:set var="action" value="/adopter/${adopterId}/edit"/></c:otherwise>
</c:choose>

<%-- POSTは必ずform:formで書く。（CSRFのトークンが自動で入る。<form>だと403） --%>
<form:form modelAttribute="adopterForm" method="post" action="${action}">
	<p>
		名前（必須）<form:input path="name" maxlength="30"/>
		<form:errors path="name"/>
	</p>
	<p>
		性別（必須）<form:radiobuttons path="gender" items="${genderList}" itemLabel="label"/>
		<form:errors path="gender"/>
	</p>
	<p>
		生年月日 <form:input path="birthday" type="date"/>
		<form:errors path="birthday"/>
	</p>
	<p>
		住所 <form:input path="address" maxlength="100"/>
		<form:errors path="address"/>
	</p>
	<p>
		電話番号（必須）<form:input path="phoneNumber" type="tel" maxlength="20"/>
		<form:errors path="phoneNumber"/>
	</p>
	<p>
		メールアドレス <form:input path="email" type="email" maxlength="255"/>
		<form:errors path="email"/>
	</p>
	<p>
		メモ<br>
		<form:textarea path="notes" rows="5" cols="50"/>
		<form:errors path="notes"/>
	</p>

	<button type="submit">${mode == 'new' ? '登録' : '更新'}</button>
	<%-- キャンセル：新規 → 一覧、編集 → 詳細（S-13） --%>
	<a href="${mode == 'new' ? '/adopter' : '/adopter/'.concat(adopterId)}">キャンセル</a>
</form:form>

</body>
</html>