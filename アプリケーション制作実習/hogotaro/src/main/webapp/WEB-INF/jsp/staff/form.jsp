<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:choose><c:when test="${mode == 'edit'}">スタッフ編集</c:when><c:otherwise>スタッフ新規登録</c:otherwise></c:choose> | ホゴタロウ</title>
<style>
    body {
        margin: 0;
        font-family: sans-serif;
        color: #222;
        background: #fff;
    }
    .form-container {
        width: 80%;
        max-width: 1050px;
        margin: 32px auto 60px;
    }
    .page-title {
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
    .form-table {
        width: 100%;
        border-collapse: collapse;
    }
    .form-table th,
    .form-table td {
        border: 1px solid #ccc;
        padding: 10px 14px;
        vertical-align: middle;
        font-size: 16px;
    }
    .form-table th {
        width: 220px;
        background: #f5f5f5;
        text-align: center;
    }
    .required {
        color: #d00000;
        font-weight: bold;
    }
    .input-text,
    .form-table input[type="text"],
    .form-table input[type="password"],
    .form-table input[type="date"],
    .form-table input[type="tel"],
    .form-table input[type="email"],
    .form-table select,
    .form-table textarea {
        box-sizing: border-box;
        max-width: 100%;
        padding: 7px 9px;
        border: 1px solid #888;
        border-radius: 5px;
        background: #fff;
        font-size: 16px;
    }
    .form-table input[type="text"],
    .form-table input[type="password"],
    .form-table input[type="date"],
    .form-table input[type="tel"],
    .form-table input[type="email"] {
        width: 470px;
    }
    .form-table textarea {
        width: 600px;
        max-width: 100%;
        resize: vertical;
    }
    .form-table select {
        min-width: 220px;
    }
    .form-note {
        margin-left: 10px;
        color: #555;
        font-size: 13px;
    }
    .error-message {
        display: block;
        margin-top: 5px;
        color: #d00000;
        font-weight: bold;
    }
    .warning-message {
        display: block;
        margin-top: 6px;
        color: #d00000;
        font-weight: bold;
    }
    .button-area {
        margin-top: 28px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
    }
    .btn-primary,
    .btn-primary:visited {
        display: inline-block;
        min-width: 130px;
        box-sizing: border-box;
        padding: 12px 34px;
        border: none;
        border-radius: 999px;
        background: #0070c0;
        color: #fff;
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
    @media (max-width: 800px) {
        .form-container {
            width: 94%;
        }
        .form-table th {
            width: 38%;
        }
        .form-table input[type="text"],
        .form-table input[type="password"],
        .form-table input[type="date"],
        .form-table input[type="tel"],
        .form-table input[type="email"],
        .form-table textarea {
            width: 100%;
        }
    }
</style>
</head>
<body>
    <%@ include file="/WEB-INF/jsp/common/header.jspf"%>

    <div class="form-container">
        <c:choose>
            <c:when test="${mode == 'edit'}">
                <h1 class="page-title">スタッフ編集</h1>
            </c:when>
            <c:otherwise>
                <h1 class="page-title">スタッフ新規登録</h1>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty message}">
            <div class="flash-message"><c:out value="${message}" /></div>
        </c:if>

        <form:form modelAttribute="staffForm" method="post">
            <table class="form-table">
                <c:choose>
                    <c:when test="${mode == 'edit'}">
                        <tr>
                            <th>ログインID</th>
                            <td><c:out value="${staff.loginId}" /></td>
                        </tr>
                        <tr>
                            <th>パスワード</th>
                            <td>
                                <form:password path="password" maxlength="72" autocomplete="new-password" />
                                <span class="form-note">変更する場合だけ入力してください</span>
                                <form:errors path="password" cssClass="error-message" />
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <th>ログインID <span class="required">（必須）</span></th>
                            <td>
                                <form:input path="loginId" maxlength="30" autocomplete="off" />
                                <form:errors path="loginId" cssClass="error-message" />
                            </td>
                        </tr>
                        <tr>
                            <th>パスワード <span class="required">（必須）</span></th>
                            <td>
                                <form:password path="password" maxlength="72" autocomplete="new-password" />
                                <form:errors path="password" cssClass="error-message" />
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>

                <tr>
                    <th>名前 <span class="required">（必須）</span></th>
                    <td>
                        <form:input path="name" maxlength="30" />
                        <form:errors path="name" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>性別 <span class="required">（必須）</span></th>
                    <td>
                        <c:forEach var="g" items="${genderList}">
                            <label>
                                <form:radiobutton path="gender" value="${g}" />
                                <c:out value="${g.label}" />
                            </label>
                        </c:forEach>
                        <form:errors path="gender" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>生年月日 <span class="required">（必須）</span></th>
                    <td>
                        <form:input path="birthday" type="date" />
                        <form:errors path="birthday" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>住所</th>
                    <td>
                        <form:input path="address" maxlength="100" />
                        <form:errors path="address" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>電話番号 <span class="required">（必須）</span></th>
                    <td>
                        <form:input path="phoneNumber" type="tel" maxlength="20" />
                        <form:errors path="phoneNumber" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>メールアドレス</th>
                    <td>
                        <form:input path="email" type="email" maxlength="255" />
                        <form:errors path="email" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>登録日</th>
                    <td>
                        <form:input path="joinedDate" type="date" />
                        <span class="form-note">団体にスタッフとして登録した日</span>
                        <form:errors path="joinedDate" cssClass="error-message" />
                    </td>
                </tr>
                <tr>
                    <th>ユーザー種別 <span class="required">（必須）</span></th>
                    <td>
                        <form:select path="userTypeId">
                            <form:option value="">選択してください</form:option>
                            <form:options items="${userTypeList}" itemValue="id" itemLabel="name" />
                        </form:select>
                        <form:errors path="userTypeId" cssClass="error-message" />
                        <c:if test="${mode == 'edit' && staff.id == loginUser.staffId}">
                            <span class="warning-message">自分自身のユーザー種別は変更できません</span>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th>特記事項</th>
                    <td>
                        <form:textarea path="notes" rows="4" maxlength="2000" />
                        <form:errors path="notes" cssClass="error-message" />
                    </td>
                </tr>
            </table>

            <div class="button-area">
                <c:choose>
                    <c:when test="${mode == 'edit'}">
                        <button type="submit" class="btn-primary">更新</button>
                        <a href="/staff/${staff.id}" class="btn-secondary">キャンセル</a>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" class="btn-primary">登録</button>
                        <a href="/staff" class="btn-secondary">キャンセル</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </form:form>
    </div>
</body>
</html>
