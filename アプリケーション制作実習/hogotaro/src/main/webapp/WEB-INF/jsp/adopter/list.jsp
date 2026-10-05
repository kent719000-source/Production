<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>里親一覧 | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class='text-center my-5'>里親一覧</h1>
<div class='container'>
<%-- 登録・編集・削除できなかった時のメッセージ（フラッシュ。1回だけ表示される） --%>
<c:if test="${not empty message}">
	<p><c:out value="${message}"/></p>
</c:if>

<%-- 新規登録リンクは常勤スタッフ(S)以上だけ。ボランティアには出さない --%>
<sec:authorize access="hasAnyRole('ADMIN','STAFF')"><%-- アクセス制限タグ --%>
	<a href="/adopter/new">新規登録</a>
</sec:authorize>

<%-- 検索フォーム。method="get"。modelAttribute="searchForm"で、 Controller の @ModelAttribute("searchForm")とつながる(検索後も入力が残る) --%>
<form:form modelAttribute="searchForm" method="get" action="/adopter">
	名前<form:input path="name"/>
	電話番号<form:input path="phoneNumber"/>
	<button type="submit" class="btn btn-info">検索</button>
</form:form>

<c:choose><%-- 条件分岐 --%>
	<c:when test="${empty adopterList}"><%-- if --%>
		<p>該当する里親はいません</p>
	</c:when>
	<c:otherwise><%-- else --%>
		<table>
			<tr>
				<th>名前</th><th>電話番号</th><th>住所</th>
			</tr>
			<%-- adopterList を1件ずつ a に入れて繰り返す --%>
			<c:forEach items="${adopterList}" var="a"><%-- 繰り返しタグ--%>
				<tr>
					<td><a href="/adopter/${a.id}"><c:out value="${a.name}"/></a></td>
					<td><c:out value="${a.phoneNumber}"/></td>
					<td><c:out value="${a.address}"/></td>
				</tr>
			</c:forEach>
		</table>
	</c:otherwise>
</c:choose>
</div>
</body>
</html>