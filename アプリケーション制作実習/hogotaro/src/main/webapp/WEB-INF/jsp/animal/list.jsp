<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>個体一覧 | ホゴタロウ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  /* カード画像の高さをそろえ、はみ出た部分は切り取る */
  .animal-img { height: 200px; object-fit: cover; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<div class="container my-4">

  <%-- タイトル＋新規登録ボタン（ボランティア以外に表示） --%>
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h1 class="h3 mb-0">個体一覧</h1>
    <c:if test="${loginUser.role == 'ADMIN' || loginUser.role == 'STAFF'}">
      <a href="${pageContext.request.contextPath}/animal/new" class="btn btn-primary">新規登録</a>
    </c:if>
  </div>

  <%-- ファセット検索(になる予定) --%>
  <form action="${pageContext.request.contextPath}/animal" method="get" class="card card-body mb-4">

    <%-- 犬猫 --%>
    <div class="mb-2">
      <span class="fw-bold me-2">種別：</span>
      <c:forEach var="species" items="${speciesList}">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="checkbox" name="species" value="${species}" id="species-${species}"
            <c:if test="${searchForm.speciesList.contains(species)}">checked</c:if>>
          <label class="form-check-label" for="species-${species}">${species.label}</label>
        </div>
      </c:forEach>
    </div>

    <%-- 保護状況 --%>
    <div class="mb-3">
      <span class="fw-bold me-2">保護状況：</span>
      <c:forEach var="status" items="${statusList}">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="checkbox" name="status" value="${status}" id="status-${status}"
            <c:if test="${searchForm.statusList.contains(status)}">checked</c:if>>
          <label class="form-check-label" for="status-${status}">${status.label}</label>
        </div>
      </c:forEach>
    </div>

    <%-- 名前 --%>
    <div class="row g-2 align-items-center">
      <div class="col-auto">
        <label for="name" class="col-form-label fw-bold">名前：</label>
      </div>
      <div class="col">
        <input type="text" id="name" name="name" class="form-control" value="<c:out value='${searchForm.name}'/>">
      </div>
      <div class="col-auto">
        <button type="submit" class="btn btn-outline-primary">検索</button>
      </div>
    </div>
  </form>

  <%-- 0件のとき --%>
  <c:if test="${empty animalList}">
    <p class="text-muted">該当する個体がいません。</p>
  </c:if>

  <%-- 個体カード一覧 --%>
  <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
    <c:forEach var="animal" items="${animalList}">
      <div class="col">
        <div class="card h-100 shadow-sm">
          <c:choose>
            <c:when test="${not empty animal.imagePath}">
              <img src="${pageContext.request.contextPath}${animal.imagePath}" class="card-img-top animal-img" alt="<c:out value='${animal.name}'/>">
            </c:when>
            <c:otherwise>
              <img src="${pageContext.request.contextPath}/NoPhotos/NoPhotos.png" class="card-img-top animal-img" alt="画像なし">
            </c:otherwise>
          </c:choose>
          <div class="card-body">
            <h5 class="card-title">
              <%-- stretched-link：カード全体をクリック可能にする --%>
              <a href="${pageContext.request.contextPath}/animal/${animal.id}" class="stretched-link text-decoration-none">
                <c:out value="${animal.name}"/>
              </a>
            </h5>
            <ul class="list-unstyled small text-muted mb-0">
              <li>性別：${animal.sex.label}</li>
              <li>品種：
                <c:choose>
                  <c:when test="${not empty animal.breed}"><c:out value="${animal.breed.name}"/></c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </li>
              <li>年齢：
                <c:choose>
                  <c:when test="${not empty animal.age}">${animal.age}歳</c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>