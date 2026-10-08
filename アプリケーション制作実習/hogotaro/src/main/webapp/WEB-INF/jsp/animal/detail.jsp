<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>

<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>個体詳細 | ホゴタロウ</title>

</head>

<body>
    <%@ include file="/WEB-INF/jsp/common/header.jspf" %>
    <%-- 横幅はほかの詳細画面（里親・スタッフ・イベント）と同じ container いっぱい。PC では左5：右7 の2列、スマホでは縦1列 --%>
    <main class="container py-4">
        <h1 class="detail-title mb-4">個体詳細</h1>
     <%-- フラッシュメッセージを表示 --%>
    		<c:if test="${not empty message}">
        		<div id="flash-message" class="alert alert-success">
            	<c:out value="${message}"/>
        		</div>
    		</c:if>
  <%-- gx-4: 列の間だけ空ける（縦の間はカードの mb-4。スマホで縦に並んだときに間が二重にならないように） --%>
  <div class="row gx-4">
    <%-- 左の列：写真と基本情報 --%>
    <div class="col-lg-5">
     <%-- 基本情報 --%>
	<div class="hogo-card mb-4">
    <div class="hogo-card-head">
        基本情報
    </div>

    <div class="hogo-card-body">

        <%-- 写真 --%>
        <div class="mb-4 text-center">
            <c:choose>

                <%-- 写真が登録されている場合 --%>
                <c:when test="${not empty animal.imagePath}">
                    <img
                        src="${pageContext.request.contextPath}${animal.imagePath}"
                        alt="${fn:escapeXml(animal.name)}"
                        class="img-fluid rounded"
                        style="max-width: 300px;">
                </c:when>

                <%-- 写真が登録されていない場合 --%>
                <c:otherwise>
                    <img
                        src="${pageContext.request.contextPath}/NoPhotos/NoPhotos.png"
                        alt="写真なし"
                        class="img-fluid rounded"
                        style="max-width: 300px;">
                </c:otherwise>

            </c:choose>
        </div>


        <%-- 名前 --%>
        <div class="mb-3">
            <div class="form-label fw-bold">
                名前
            </div>

            <div>
                <c:out value="${animal.name}" />
            </div>
        </div>


        <%-- 種別 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                種別
            </div>

            <div>
                ${animal.species.label}
            </div>
        </div>


        <%-- 性別 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                性別
            </div>

            <div>
                ${animal.sex.label}
            </div>
        </div>


        <%-- 品種 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                品種
            </div>

            <div>
                <c:choose>

                    <c:when test="${not empty animal.breed}">
                        <c:out value="${animal.breed.name}" />
                    </c:when>

                    <c:otherwise>
                        不明
                    </c:otherwise>

                </c:choose>
            </div>
        </div>


        <%-- 年齢 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                年齢
            </div>

            <div>
                <c:choose>

                    <c:when test="${not empty animal.age}">
                        ${animal.age}歳
                    </c:when>

                    <c:otherwise>
                        不明
                    </c:otherwise>

                </c:choose>
            </div>
        </div>


        <%-- 誕生日 --%>
        <div class="mb-0">
            <div class="form-label fw-bold">
                誕生日
            </div>

            <div>
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
            </div>
        </div>

    </div>
</div>
    </div>
    <%-- 右の列：保護情報・健康情報とイベント履歴 --%>
    <div class="col-lg-7">
<%-- 保護情報・健康情報 --%>
<div class="hogo-card mb-4">

    <div class="hogo-card-head">
        保護情報・健康情報
    </div>

    <div class="hogo-card-body">

        <%-- 保護日 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                保護日
            </div>
            <div>
                ${animal.intakeDate}
            </div>
        </div>

        <%-- 保護場所 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                保護場所
            </div>
            <div>
                <c:out value="${animal.intakePlace}" />
            </div>
        </div>

        <%-- 保護方法 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                保護方法
            </div>
            <div>
                <c:out value="${animal.intakeMethod}" />
            </div>
        </div>

        <%-- 保護状況 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                保護状況
            </div>
            <div>
                ${animal.status.label}
            </div>
        </div>

        <%-- 里親 --%>
        <c:if test="${animal.status == 'TRIAL' || animal.status == 'ADOPTED'}">
            <div class="mb-4">
                <div class="form-label fw-bold">
                    里親
                </div>

                <div>
                    <c:choose>
                        <c:when test="${not empty animal.adopter}">
                            <a href="${pageContext.request.contextPath}/adopter/${animal.adopter.id}">
                                <c:out value="${animal.adopter.name}" />
                            </a>
                        </c:when>

                        <c:otherwise>
                            -
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <%-- 避妊去勢 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                避妊去勢
            </div>
            <div>
                ${animal.neutered.label}
            </div>
        </div>

        <%-- 混合ワクチン --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                混合ワクチン
            </div>
            <div>
                <c:choose>
                    <c:when test="${animal.comboVaccine}">
                        済
                    </c:when>
                    <c:otherwise>
                        未
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 狂犬病ワクチン：犬の場合のみ表示 --%>
        <c:if test="${animal.species == 'DOG'}">
            <div class="mb-4">
                <div class="form-label fw-bold">
                    狂犬病ワクチン
                </div>

                <div>
                    <c:choose>
                        <c:when test="${animal.rabiesVaccine}">
                            済
                        </c:when>
                        <c:otherwise>
                            未
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

        <%-- マイクロチップ --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                マイクロチップ
            </div>

            <div>
                <c:choose>
                    <c:when test="${not empty animal.microchipNo}">
                        <c:out value="${animal.microchipNo}" />
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 健康に関する特記事項 --%>
        <div class="mb-4">
            <div class="form-label fw-bold">
                健康に関する特記事項
            </div>

            <div>
                <c:choose>
                    <c:when test="${not empty animal.healthNotes}">
                        <c:out value="${animal.healthNotes}" />
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- その他の特記事項 --%>
        <div class="mb-0">
            <div class="form-label fw-bold">
                その他の特記事項
            </div>

            <div>
                <c:choose>
                    <c:when test="${not empty animal.notes}">
                        <c:out value="${animal.notes}" />
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
 <%-- イベント履歴 --%>
<div class="hogo-card mb-4">

    <div class="hogo-card-head">
        イベント履歴
    </div>

    <div class="hogo-card-body">

        <c:choose>

            <c:when test="${not empty eventList}">

                <div class="table-responsive">

                    <table class="table table-hover align-middle mb-0">

                        <thead>
                            <tr>
                                <th>日付</th>
                                <th>イベント種別</th>
                                <th>内容</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="event" items="${eventList}">

                                <tr>
                                    <td>
                                        ${event.eventDate}
                                    </td>

                                    <td>
                                        ${event.eventType.name}
                                    </td>

                                    <td>
                                        <c:out value="${event.notes}" />
                                    </td>
                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </div>

            </c:when>

            <c:otherwise>

                <div class="hogo-empty">
                    イベント履歴はありません。
                </div>

            </c:otherwise>

        </c:choose>

    </div>

</div>
    </div>
  </div>
<%-- 操作ボタン --%>
<div class="d-flex flex-wrap gap-2 mb-4">

    <%-- ADMIN / STAFF：編集 --%>
    <sec:authorize access="hasAnyRole('ADMIN','STAFF')">

        <a
            href="${pageContext.request.contextPath}/animal/${animal.id}/edit"
            class="btn btn-hogo">
            編集する
        </a>

    </sec:authorize>


    <%-- ADMIN：削除 --%>
    <sec:authorize access="hasRole('ADMIN')">

        <form
            action="${pageContext.request.contextPath}/animal/${animal.id}/delete"
            method="post"
            class="d-inline"
            onsubmit="return confirm('この個体を削除してもよろしいですか？');">

            <input
                type="hidden"
                name="${_csrf.parameterName}"
                value="${_csrf.token}" />

            <button
                type="submit"
                class="btn btn-hogo-danger">
                削除する
            </button>

        </form>

    </sec:authorize>


    <%-- 一覧へ戻る --%>
    <a
        href="${pageContext.request.contextPath}/animal"
        class="btn btn-hogo-sub">
        一覧へ戻る
    </a>

</div>
    </main>
</body>

</html>