<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>個体一覧 | ホゴタロウ</title>
</head>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
<main class="container py-4">
<%-- ページタイトル --%>
<div class="d-flex justify-content-between align-items-center mb-4">
<h1 class="mb-0">個体一覧</h1>
<%-- 新規登録ボタン：ボランティア以外に表示) --%>
	<c:if test="${loginUser.role == 'ADMIN' || loginUser.role == 'STAFF'}">
    	<a href="${pageContext.request.contextPath}/animal/new" class="btn btn-hogo">新規登録</a>
	</c:if>
</div>
<%-- フラッシュメッセージ --%>
    <c:if test="${not empty message}">
        <div class="alert alert-success mb-4" role="alert">
            <c:out value="${message}"/>
        </div>
    </c:if>
<%-- 検索フォーム --%>
    <div class="hogo-card mb-4">
        <div class="hogo-card-head">個体を検索
        </div>
        <div class="hogo-card-body">
        <form action="${pageContext.request.contextPath}/animal" method="get">
                 <%-- 犬・猫 --%>
                <div class="mb-4">
                    <label class="form-label">
                        種別
                    </label>
                    <div class="d-flex flex-wrap gap-3">
                        <c:forEach var="species" items="${speciesList}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="species" value="${species}" id="species-${species}"
                                    <c:if test="${searchForm.species != null && searchForm.species.contains(species)}">
                                        checked
                                    </c:if>>
                                <label class="form-check-label" for="species-${species}">
                                    ${species.label}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <%-- 保護状況 --%>
                <div class="mb-4">
                    <label class="form-label">
                        保護状況
                    </label>
                    <div class="d-flex flex-wrap gap-3">
                        <c:forEach var="status" items="${statusList}">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="statuses" value="${status}" id="status-${status}"
                                    <c:if test="${searchForm.statuses != null && searchForm.statuses.contains(status)}">
                                        checked
                                    </c:if>>
                                <label class="form-check-label" for="status-${status}">
                                    ${status.label}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <%-- 名前 --%>
                <div class="row align-items-end">
                    <div class="col-md-8 col-lg-6">
                        <label for="name" class="form-label">
                            名前
                        </label>
                        <input type="text" id="name" name="name" class="form-control" value="${searchForm.name}" placeholder="個体名を入力してください">
                    </div>
                    <div class="col-md-auto mt-3 mt-md-0">
                        <button type="submit" name="search" value="1" class="btn btn-hogo">
                            検索
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
<%-- 個体カード --%>
    <c:if test="${not empty animalList}">
        <div class="row g-4">
            <c:forEach var="animal" items="${animalList}">
                <div class="col-12 col-sm-6 col-lg-4 col-xl-3">
                    <a href="${pageContext.request.contextPath}/animal/${animal.id}" class="text-decoration-none">
                        <div class="hogo-card h-100">

                            <%-- 写真 --%>
                            <c:choose>
                                <c:when test="${not empty animal.imagePath}">
                                    <img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${animal.name}" class="w-100 hogo-card-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/NoPhotos/NoPhotos.png" alt="画像なし" class="w-100 hogo-card-img"style="object-fit: contain;">
                                </c:otherwise>
                            </c:choose>

                            <%-- 個体情報 --%>
                            <div class="hogo-card-body">

                             <%-- 名前 --%>
                                <h3 class="h5 mb-3 text-center" style="color: var(--hogo-brown);">
                                    <c:out value="${animal.name}"/>
                                </h3>

                                <%-- 種別・性別 --%>
                                <div class="d-flex justify-content-center gap-2 mb-3">
                                    <span class="badge rounded-pill" style="background-color: var(--hogo-peach); color: var(--hogo-brown);">
                                        ${animal.species.label}
                                    </span>
                                    <span class="badge rounded-pill" style="background-color: var(--hogo-peach-light); color: var(--hogo-brown);">
                                        ${animal.sex.label}
                                    </span>
                                </div>

                                <%-- 品種・年齢 --%>
                                <div class="small">
                                    <div class="mb-1">
                                        <strong>品種：</strong>
                                        <c:choose>
                                            <c:when test="${not empty animal.breed}">
                                                <c:out value="${animal.breed.name}"/>
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <strong>年齢：</strong>
                                        <c:choose>
                                            <c:when test="${not empty animal.age}">
                                                ${animal.age}歳
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </c:if>
</main>

</body>
</html>