<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/header.jspf"%>
	<h1>里親詳細</h1>

	<c:if test="${loginUser.role == 'ADMIN'}">
		<form:form method="post" action="/adopter/${adopter.id}/delete"
			onsubmit="return confirm('本当に削除しますか？')">
			<button type="submit">削除</button>
		</form:form>
	</c:if>


	<c:if test="${loginUser.role == 'ADMIN'}">
		<a href="/adopter/${adopter.id}/edit"y">編集</a>
	</c:if>

	<h2>情報</h2>
	<table>
		<tr>
			<th>項目</th>
			<th>内容</th>
		</tr>
		<tr>
			<td>名前</td>
			<td>${adopter.name }</td>
		</tr>
		<tr>
			<td>性別</td>
			<td>${adopter.gender.label }</td>
		</tr>
		<tr>
			<td>生年月日</td>
			<td>${adopter.birthday }</td>
		</tr>
		<tr>
			<td>年齢</td>
			<td>${adopter.age }</td>
		</tr>
		<tr>
			<td>住所</td>
			<td>${adopter.address }</td>
		</tr>
		<tr>
			<td>電話番号</td>
			<td>${adopter.phoneNumber }</td>
		</tr>
		<tr>
			<td>メールアドレス</td>
			<td>${adopter.email }</td>
		</tr>
		<tr>
			<td>特記事項</td>
			<td>${adopter.notes }</td>
		</tr>
	</table>

<%-- 登録・編集・削除できなかった時のメッセージ（フラッシュ。1回だけ表示される） --%>
	<h2>関連する個体</h2>
	<c:choose>
		<c:when test="${not empty message}">
			<p>関連する犬猫はいません</p>
		</c:when>
		<c:otherwise>
			<table>
				<tr><th>名前</th><th>犬猫</th><th>保護状況</th></tr>
				<c:forEach items="${animalList}" var="a">
					<tr>
						<td><a href="/animal/${a.id}"><c:out value="${a.name}"/></a></td>
						<td>${a/species.label}</td>
						<td>${a/status.label}</td>
					</tr>
				</c:forEach>
			</table>
		</c:otherwise>
	</c:choose>
