<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
	<h1>スタッフ詳細詳細</h1>
	
		<c:if test ="${loginUser.role == 'ADMIN'}">
			<form:form method="post" action="/staff/${staff.id}/delete" onsubmit="return confirm('本当に削除しますか？')">
        		<button type="submit">削除</button>
      		</form:form>
      	</c:if>
		<c:if test ="${loginUser.role == 'ADMIN'}">
			<a href="/staff/${staff.id}/edit"y">編集</a>
		</c:if>
		
		<table>
			<tr>
				<th>項目</th><th>内容</th>
			</tr>
			<tr>
				<td>ID</td><td>${staff.id }</td>
			</tr>
			<tr>
				<td>名前</td><td>${staff.name }</td>
			</tr>
			<tr>
				<td>性別</td><td>${staff.gender.label }</td>
			</tr>
			<tr>
				<td>年齢</td><td>${staff.age }</td>
			</tr>
			<tr>
				<td>生年月日</td><td>${staff.birthday }</td>
			</tr>
			<tr>
				<td>電話番号</td><td>${staff.phoneNumber }</td>
			</tr>
			<tr>
				<td>メールアドレス</td><td>${staff.email }</td>
			</tr>
			<tr>
				<td>登録日</td><td>${staff.joinedDate }</td>
			</tr>
			<tr>
				<td>ユーザー種別</td><td>${staff.userType.name }</td>
			</tr>
			<tr>
				<td>特記事項</td><td>${staff.notes }</td>
			</tr>
		<table>
</body>
</html>