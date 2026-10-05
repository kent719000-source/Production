<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ホゴタロウ</title>
</head>
<body>
	<%@ include file="common/header.jspf"%>
	<h1>トップページ</h1>

	<%-- 管理画面へのリンク --%>
	<ul>
		<li><a href="/animal">個体管理へ</a></li>
		<li><a href="/event">イベント管理へ</a></li>
		<li><a href="/adopter">里親管理へ</a></li>
		<li><a href="/staff">スタッフ管理へ</a></li>
	</ul>

	<section>
		<h2>保護頭数</h2>
		<p>
			保護中：${inCare }/${organization.capacity }<br>
			空き：${organization.capacity - inCare}
		</p>
	</section>


	<section>
		<h2>カレンダー</h2>
		<p>${calendar.year}年${calendar.month}月</p>
		<table border="1">

			<tr>
				<th>日</th>
				<th>月</th>
				<th>火</th>
				<th>水</th>
				<th>木</th>
				<th>金</th>
				<th>土</th>
			</tr>
			<c:forEach items="${calendar.weeks}" var="week">
				<tr>
					<c:forEach items="${week}" var="d">
						<%-- 前月・次月のはみ出したマスには other を付ける（CSS で薄くする用） --%>
						<td class="${d.inMonth ? '' : 'other'}">
							${d.day} <%-- その日のイベント。「個体名 種別」で、時刻は出さない（10/1 の決定） --%>
								<c:forEach items="${d.eventList}" var="e">
																<%-- マスを押すと、その日の月のイベント管理へ。はみ出したマスはその月へ飛ぶように d.date の年・月を使う --%>
									<a href="/event?year=${d.date.year}&month=${d.date.monthValue}">
										<div>
											<c:out value="${e.animal.name}" />
											<c:out value="${e.eventType.name}" />
										</div>
									</a>
								</c:forEach>
						</td>
					</c:forEach>
				</tr>
			</c:forEach>
		</table>
	</section>

</body>
</html>