<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>ホゴタロウ</title>
	</head>
		<body>
			<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
			<h1>スタッフ一覧</h1>
			<a href ="/staff/new">新規登録</a>
			<table>
				<tr>
					<th>ID</th><th>名前</th>
				</tr>
				<c:forEach var="s" items="${staffList}">
					<tr>
						<td><c:out value="${s.id}"/></td>
						<td><a href="/staff/${s.id}"><c:out value="${s.name}"/></a></td>
					</tr>
				</c:forEach>
			</table>
		
		
		</body>
</html>