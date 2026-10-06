<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>スタッフ詳細 | ホゴタロウ</title>
<style>
    body {
        margin: 0;
        font-family: sans-serif;
        color: #222;
        background: #fff;
    }
    .detail-container {
        width: 80%;
        max-width: 1000px;
        margin: 32px auto 60px;
    }
    .detail-title {
        margin: 0 0 24px;
        font-size: 30px;
    }
    .flash-message {
        margin: 0 0 24px;
        padding: 14px 18px;
        border: 1px solid #a7d7b0;
        border-radius: 6px;
        background: #ecf8ef;
        color: #176b2c;
        font-weight: bold;
    }
    .detail-table {
        width: 100%;
        border-collapse: collapse;
    }
    .detail-table th,
    .detail-table td {
        border: 1px solid #ccc;
        padding: 10px 12px;
        vertical-align: top;
        font-size: 17px;
    }
    .detail-table th {
        width: 220px;
        background: #f5f5f5;
        text-align: center;
        font-weight: bold;
    }
    .detail-table td {
        text-align: left;
    }
    .notes {
        min-height: 80px;
        white-space: pre-wrap;
    }
    .not-entered {
        color: #d00000;
        font-weight: bold;
    }
    .section-title {
        margin: 34px 0 14px;
        font-size: 24px;
    }
    .event-table {
        width: 100%;
        border-collapse: collapse;
    }
    .event-table th,
    .event-table td {
        border: 1px solid #ccc;
        padding: 10px 12px;
        text-align: center;
        font-size: 16px;
    }
    .event-table th {
        background: #f5f5f5;
    }
    .event-link {
        color: #0000ee;
        text-decoration: underline;
        font-weight: bold;
    }
    .empty-message {
        color: #d00000;
        font-weight: bold;
    }
    .button-area {
        margin-top: 32px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
    }
    .btn-primary,
    .btn-primary:visited {
        display: inline-block;
        min-width: 120px;
        box-sizing: border-box;
        border: none;
        border-radius: 999px;
        padding: 12px 32px;
        color: #fff;
        background: #0070c0;
        font-size: 20px;
        font-weight: bold;
        text-align: center;
        text-decoration: none;
        cursor: pointer;
        box-shadow: 0 5px 10px rgba(0,0,0,.22);
    }
    .btn-primary:hover {
        background: #005b9e;
    }
    .btn-secondary,
    .btn-secondary:visited {
        display: inline-block;
        padding: 10px 24px;
        border: 1px solid #888;
        border-radius: 6px;
        background: #f4f4f4;
        color: #222;
        text-decoration: none;
        font-weight: bold;
    }
    .delete-form {
        margin: 0;
    }
    @media (max-width: 800px) {
        .detail-container {
            width: 94%;
        }
        .detail-table th {
            width: 38%;
        }
        .detail-table th,
        .detail-table td,
        .event-table th,
        .event-table td {
            font-size: 14px;
        }
    }
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jsp/common/header.jspf" %>

    <div class="detail-container">
        <h1 class="detail-title">スタッフ詳細</h1>

        <c:if test="${not empty message}">
            <div class="flash-message"><c:out value="${message}"/></div>
        </c:if>

        <table class="detail-table">
            <tr><th>ID</th><td><c:out value="${staff.id}" /></td></tr>
            <tr><th>ログインID</th><td><c:out value="${staff.loginId}" /></td></tr>
            <tr><th>名前</th><td><c:out value="${staff.name}" /></td></tr>
            <tr><th>性別</th><td><c:out value="${staff.gender.label}" /></td></tr>
            <tr><th>年齢</th><td><c:out value="${staff.age}" />歳</td></tr>
            <tr><th>生年月日</th><td><c:out value="${staff.birthday}" /></td></tr>
            <tr>
                <th>住所</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty staff.address}"><c:out value="${staff.address}" /></c:when>
                        <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>電話番号</th><td><c:out value="${staff.phoneNumber}" /></td></tr>
            <tr>
                <th>メールアドレス</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty staff.email}"><c:out value="${staff.email}" /></c:when>
                        <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>登録日</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty staff.joinedDate}"><c:out value="${staff.joinedDate}" /></c:when>
                        <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr><th>ユーザー種別</th><td><c:out value="${staff.userType.name}" /></td></tr>
            <tr>
                <th>特記事項</th>
                <td class="notes">
                    <c:choose>
                        <c:when test="${not empty staff.notes}"><c:out value="${staff.notes}" /></c:when>
                        <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>

        <h2 class="section-title">対応したイベント</h2>
        <c:choose>
            <c:when test="${empty eventList}">
                <p class="empty-message">イベントはありません</p>
            </c:when>
            <c:otherwise>
                <table class="event-table">
                    <thead>
                        <tr>
                            <th>日付</th>
                            <th>種別</th>
                            <th>個体名</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${eventList}">
                            <tr>
                                <td>
                                    <a class="event-link" href="/event/${e.id}">
                                        <c:out value="${e.eventDate}" />
                                    </a>
                                </td>
                                <td><c:out value="${e.eventType.name}" /></td>
                                <td><c:out value="${e.animal.name}" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <div class="button-area">
            <c:if test="${loginUser.role == 'ADMIN'}">
                <a href="/staff/${staff.id}/edit" class="btn-primary">編集</a>
                <c:if test="${staff.id != loginUser.staffId}">
                    <form:form class="delete-form"
                            method="post"
                            action="/staff/${staff.id}/delete"
                            onsubmit="return confirm('本当に削除しますか？')">
                        <button type="submit" class="btn-primary">削除</button>
                    </form:form>
                </c:if>
            </c:if>
            <a href="/staff" class="btn-secondary">一覧へ戻る</a>
        </div>
    </div>
</body>
</html>
