<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>個体詳細</title>

<%-- CSSもどき --%>
<style>
    .detail-container {
        width: 80%;
        max-width: 900px;
        margin: 30px auto;
    }

    .detail-title {
        margin-bottom: 30px;
    }

    /* 写真 */
    .photo-area {
        text-align: center;
        margin-bottom: 30px;
    }

    .animal-photo,
    .photo-placeholder {
        width: 300px;
        height: 300px;
    }

    .animal-photo {
        object-fit: cover;
    }

    .photo-placeholder {
        margin: 0 auto;
        background-color: #eee;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #666;
    }

    /* 個体情報 */
    .detail-table {
        width: 100%;
        border-collapse: collapse;
    }

    .detail-table th,
    .detail-table td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: left;
        vertical-align: top;
    }

    .detail-table th {
        width: 200px;
        background-color: #f5f5f5;
    }

    /* 特記事項 */
    .notes {
        white-space: pre-wrap;
    }

    /* ボタン */
    .button-area {
        margin-top: 30px;
        display: flex;
        gap: 10px;
    }

    .button-area a,
    .button-area button {
        padding: 8px 20px;
        text-decoration: none;
        cursor: pointer;
    }

</style>

</head>

<body>
    <%@ include file="/WEB-INF/jsp/common/header.jspf" %>
    <div class="detail-container">
        <h1 class="detail-title">個体詳細</h1>
        
        <%-- 写真 --%>
        <div class="photo-area">
            <c:choose>
            <%-- 写真が登録されている場合 --%>
                <c:when test="${not empty animal.imagePath}">
                    <img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${animal.name}" class="animal-photo">
                </c:when>
            <%-- 写真が登録されていない場合 --%>
                <c:otherwise>
            		<img src="${pageContext.request.contextPath}/NoPhotos/NoPhotos.png" alt="写真なし" class="animal-photo">
                </c:otherwise>
            </c:choose>
        </div>

        <%-- 基本情報 --%>
        <table class="detail-table">
            <tr>
                <th>名前</th>
                <td>
                    <c:out value="${animal.name}" />
                </td>
            </tr>

            <tr>
                <th>種別</th>
                <td>
                    ${animal.species.label}
                </td>
            </tr>

            <tr>
                <th>性別</th>
                <td>
                    ${animal.sex.label}
                </td>
            </tr>

            <tr>
                <th>品種</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty animal.breed}">
                            <c:out value="${animal.breed.name}" />
                        </c:when>

                        <c:otherwise>
                            不明
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>年齢</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty animal.age}">
                            ${animal.age}歳
                        </c:when>

                        <c:otherwise>
                            不明
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>誕生日</th>
                <td>
                    <c:choose>

                        <c:when test="${not empty animal.birthday}">
                            ${animal.birthday}

                            <c:if test="${animal.isBirthdayEstimated}">
                                （推定）
                            </c:if>
                        </c:when>

                        <c:otherwise>
                            不明
                        </c:otherwise>

                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>保護日</th>
                <td>
                    ${animal.intakeDate}
                </td>
            </tr>

            <tr>
                <th>保護場所</th>
                <td>
                    <c:out value="${animal.intakePlace}" />
                </td>
            </tr>

            <tr>
                <th>保護方法</th>
                <td>
                    <c:out value="${animal.intakeMethod}" />
                </td>
            </tr>

            <tr>
                <th>保護状況</th>
                <td>
                    ${animal.status.label}
                </td>
            </tr>

            <%-- 里親 --%>
            <%-- トライアル中・譲渡済の場合のみ表示 --%>
            <c:if test="${animal.status == 'TRIAL' || animal.status == 'ADOPTED'}">

                <tr>
                    <th>里親</th>
                    <td>

                        <c:if test="${not empty animal.adopter}">

                            <a href="${pageContext.request.contextPath}/adopter/${animal.adopter.id}">
                                <c:out value="${animal.adopter.name}" />
                            </a>

                        </c:if>

                    </td>
                </tr>

            </c:if>

            <%-- 医療 --%>

            <tr>
                <th>避妊去勢</th>
                <td>
                    ${animal.neutered.label}
                </td>
            </tr>

            <tr>
                <th>混合ワクチン</th>
                <td>

                    <c:choose>

                        <c:when test="${animal.comboVaccine}">
                            済
                        </c:when>

                        <c:otherwise>
                            未
                        </c:otherwise>

                    </c:choose>

                </td>
            </tr>

            <%-- 狂犬病ワクチン：犬の場合のみ表示 --%>
            <c:if test="${animal.species == 'DOG'}">

                <tr>
                    <th>狂犬病ワクチン</th>
                    <td>

                        <c:choose>
                            <c:when test="${animal.rabiesVaccine}">
                                済
                            </c:when>
                            <c:otherwise>
                                未
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>

            </c:if>

            <tr>
                <th>マイクロチップ</th>
                <td>

                    <c:choose>
                        <c:when test="${not empty animal.microchipNo}">
                            <c:out value="${animal.microchipNo}" />
                        </c:when>

                        <c:otherwise>
                            -
                        </c:otherwise>

                    </c:choose>

                </td>
            </tr>

            <%-- 特記事項 --%>

            <tr>
                <th>健康に関する特記事項</th>
                <td class="notes">
                    <c:choose>
                        <c:when test="${not empty animal.healthNotes}">
                            <c:out value="${animal.healthNotes}" />
                        </c:when>
                        <c:otherwise>
                            -
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>

            <tr>
                <th>その他の特記事項</th>
                <td class="notes">
                    <c:choose>

                        <c:when test="${not empty animal.notes}">
                            <c:out value="${animal.notes}" />
                        </c:when>

                        <c:otherwise>
                            -
                        </c:otherwise>

                    </c:choose>
                </td>
            </tr>

        </table>

        <%-- 操作 --%>
        <div class="button-area">
        
    		<%-- 管理ユーザー・常勤スタッフだけ編集を表示 --%>
    		<c:if test="${loginUser.role == 'ADMIN' || loginUser.role == 'STAFF'}">

        	<%-- 編集 --%>
        		<a href="${pageContext.request.contextPath}/animal/${animal.id}/edit">
            		編集
        		</a>
    		</c:if>

    		<%-- 管理ユーザーだけ削除を表示 --%>
    		<c:if test="${loginUser.role == 'ADMIN'}">

           	<%-- 削除 --%>
            <form action="${pageContext.request.contextPath}/animal/${animal.id}/delete" method="post" style="display: inline;">

    			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    			
                <button type="submit" onclick="return confirm('紐づくイベントと写真も削除されます。本当に削除しますか？');">削除
                </button>
            </form>
            </c:if>

            <%-- 一覧へ戻る --%>
            <a href="${pageContext.request.contextPath}/animal">一覧へ戻る</a>
        </div>

    </div>

</body>

</html>