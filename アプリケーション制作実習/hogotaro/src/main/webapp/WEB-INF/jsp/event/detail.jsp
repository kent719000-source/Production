<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>イベント詳細 | ホゴタロウ</title>

<style>
.event-detail {
    max-width: 800px;
    margin: 32px auto;
    padding: 0 16px;
}

.detail-table {
    width: 100%;
    border-collapse: collapse;
}

.detail-table th,
.detail-table td {
    padding: 12px;
    border: 1px solid #ddd;
    text-align: left;
    vertical-align: top;
}

.detail-table th {
    width: 140px;
    background: #f5f5f5;
}

.notes {
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

.stamp-button {
    width: 64px;
    height: 64px;
    border: 2px dashed #777;
    border-radius: 50%;
    background: #fff;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.stamp-done {
    border: 3px solid #b02a37;
    color: #b02a37;
    font-size: 28px;
    font-weight: bold;
}

.stamp-button:focus-visible {
    outline: 3px solid #2563eb;
    outline-offset: 3px;
}

</style>
</head>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<main class="event-detail">
    <h1>イベント詳細</h1>
    <c:if test="${not empty message}">
    <p role="status">
        <c:out value="${message}" />
    </p>
</c:if>

    <%-- 関連画面へのリンク先を用意する --%>
    <c:url var="animalUrl" value="/animal/${event.animal.id}" />

    <c:url var="calendarUrl" value="/event">
        <c:param name="year" value="${event.eventDate.year}" />
        <c:param name="month" value="${event.eventDate.monthValue}" />
    </c:url>

    <table class="detail-table">
        <tbody>
            <tr>
                <th scope="row">日付</th>
                <td><c:out value="${event.eventDate}" /></td>
            </tr>

            <c:if test="${not empty event.eventTime}">
                <tr>
                    <th scope="row">時刻</th>
                    <td><c:out value="${event.eventTime}" /></td>
                </tr>
            </c:if>

            <tr>
                <th scope="row">個体名</th>
                <td>
                    <a href="${fn:escapeXml(animalUrl)}">
                        <c:out value="${event.animal.name}" />
                    </a>
                </td>
            </tr>

            <tr>
                <th scope="row">イベント種別</th>
                <td><c:out value="${event.eventType.name}" /></td>
            </tr>

            <c:if test="${not empty event.place}">
                <tr>
                    <th scope="row">場所</th>
                    <td><c:out value="${event.place}" /></td>
                </tr>
            </c:if>

            <c:if test="${not empty event.adopter}">
                <c:url var="adopterUrl"
                       value="/adopter/${event.adopter.id}" />

                <tr>
                    <th scope="row">里親</th>
                    <td>
                        <a href="${fn:escapeXml(adopterUrl)}">
                            <c:out value="${event.adopter.name}" />
                        </a>
                    </td>
                </tr>
            </c:if>

			<tr>
			    <th scope="row">対応スタッフ</th>
			    <td>
			        <c:if test="${event.done and not empty event.staff}">
			            <c:url var="staffUrl"
			                   value="/staff/${event.staff.id}" />
			
			            <a href="${fn:escapeXml(staffUrl)}">
			                <c:out value="${event.staff.name}" />
			            </a>
			        </c:if>
			    </td>
			</tr>

            <c:if test="${event.cost != null}">
                <tr>
                    <th scope="row">費用</th>
                    <td><c:out value="${event.cost}" /> 円</td>
                </tr>
            </c:if>

<tr>
    <th scope="row">対応状況</th>
    <td>
        <%-- 管理ユーザー・常勤スタッフは操作できる --%>
        <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
            <c:choose>

                <%-- 対応済なら、未対応に戻すボタン --%>
                <c:when test="${event.done}">
                    <c:url var="uncompleteUrl"
                           value="/event/${event.id}/uncomplete" />

                    <form:form action="${uncompleteUrl}" method="post"
                        onsubmit="return confirm('未対応に戻しますか？');">

                        <button type="submit"
                                class="stamp-button stamp-done"
                                aria-label="対応済。クリックすると未対応に戻します">
                            済
                        </button>
                    </form:form>

                    <small>クリックで未対応に戻す</small>
                </c:when>

                <%-- 未対応なら、完了にするボタン --%>
                <c:otherwise>
                    <c:url var="completeUrl"
                           value="/event/${event.id}/complete" />

                    <form:form action="${completeUrl}" method="post"
                        onsubmit="return confirm('イベントを完了にしますか？個体の情報は自動では変わりません');">

                        <button type="submit"
                                class="stamp-button"
                                aria-label="未対応。クリックすると対応済にします">
                        </button>
                    </form:form>

                    <small>未対応：クリックで対応済にする</small>
                </c:otherwise>

            </c:choose>
        </sec:authorize>

        <%-- ボランティアには文字だけ表示する --%>
        <sec:authorize access="hasRole('VOLUNTEER')">
            <c:choose>
                <c:when test="${event.done}">対応済</c:when>
                <c:otherwise>未対応</c:otherwise>
            </c:choose>
        </sec:authorize>
    </td>
</tr>

            <tr>
                <th scope="row">特記事項</th>
                <td class="notes"><c:out value="${event.notes}" /></td>
            </tr>
        </tbody>
    </table>
	<sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
    <c:url var="editUrl" value="/event/${event.id}/edit" />

    <p>
        <a href="${fn:escapeXml(editUrl)}">編集する</a>
    </p>
	</sec:authorize>
    <p>
        <a href="${fn:escapeXml(calendarUrl)}">一覧へ戻る</a>
    </p>
</main>
</body>
</html>