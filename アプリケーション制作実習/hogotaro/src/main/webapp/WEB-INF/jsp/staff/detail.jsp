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

	<%-- スタッフの編集・削除は管理ユーザーだけ --%>
		<c:if test ="${loginUser.role == 'ADMIN'}">
			<a href="/staff/${staff.id}/edit"y">編集</a>
			<%-- 自分自身の削除はできない --%>
		<c:if test ="${staff.id != loginUser.staffId}">
			<form:form method="post" action="/staff/${staff.id}/delete" onsubmit="return confirm('本当に削除しますか？')">
        		<button type="submit">削除</button>
      		</form:form>
      	</c:if>
		</c:if>

		
		<table>
			<tr>
				<th>項目</th><th>内容</th>
			</tr>
			<tr>
				<td>ID</td><td>${staff.id }</td>
			</tr>
			<tr>
				<th>ログインID</th><td>${staff.loginId }/>
			</td></tr>
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
				<th>住所</th><td>${staff.address }</td>
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
			<%-- <pre>は入力した改行をそのまま出すタグ。タグの内側の空白や改行も画面に出てしまうので、xxx.notesの直前に置く --%>
			<tr>
				<td>特記事項</td><td><pre>${staff.notes }</pre></td>
			</tr>
		<table>

	<p><a href="/staff">一覧へ戻る</a></p>
</body>
</html>