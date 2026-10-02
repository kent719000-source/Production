<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ホゴタロウ</title>
</head>
<body>
<%@ include file="common/header.jspf" %>
<h1>トップページ</h1>

<section>
	<h2>保護頭数</h2>
	<p>保護中：${inCare }/${organization.capacity }<br>
	空き：${organization.capacity - inCare}</p>
</section>


<section>
	<h2>カレンダー</h2>
	<p>${yearMonth.year}年${yearMonth.monthValue}月</p>
<table>

	<tr>
		<th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
	</tr>
	<c:forEach items="${weeks}" var="week">
		<tr>
			<c:forEach items="${week}" var="d">
				<td class="${d.monthValue != yearMonth.monthValue ? 'other' : ''}">
					${d.dayOfMonth}
				</td>
			</c:forEach>
		</tr>
	</c:forEach>
</table>
</section>

</body>
</html>