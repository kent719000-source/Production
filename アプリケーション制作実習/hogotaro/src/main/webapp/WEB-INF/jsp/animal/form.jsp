<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.2/cropper.min.js"></script>

<title>
    <c:choose>
        <c:when test="${mode == 'edit'}">
            個体編集
        </c:when>
        <c:otherwise>
            個体新規登録
        </c:otherwise>
    </c:choose>
</title>

</head>

<body>

<%-- ヘッダー --%>

<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<main class="container py-4">

    <%-- タイトル --%>
    <h1 class="mb-4">
        <c:choose>
            <c:when test="${mode == 'edit'}">個体編集</c:when>
            <c:otherwise>個体新規登録</c:otherwise>
        </c:choose>
    </h1>

    <%-- フォーム開始 --%>
    <c:choose>
        <%-- 編集 --%>
        <c:when test="${mode == 'edit'}">
            <form:form id="animalForm" modelAttribute="animalForm" method="post" enctype="multipart/form-data" action="/animal/${animalId}/edit">
   <%-- 基本情報 --%>
<div class="hogo-card mb-4">

    <div class="hogo-card-head">
        基本情報
    </div>
    <div class="hogo-card-body">
        <%-- 写真 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                写真
            </label>
            <div class="mb-3">
                <c:choose>
                    <%-- 編集時に現在の写真がある場合 --%>
                    <c:when test="${mode == 'edit' and not empty animal.imagePath}">
                        <img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${fn:escapeXml(animal.name)}" class="img-fluid rounded" id="photoPreview" style="max-width: 300px;">
                    </c:when>

                    <%-- 写真がない場合 --%>
                    <c:otherwise>
                        <div id="photoPlaceholder" class="d-flex align-items-center justify-content-center bg-light rounded" style="width: 300px; height: 200px;">
                            写真をアップロードしてください
                        </div>

                        <img id="photoPreview" class="img-fluid rounded" style="display: none; max-width: 300px;">
                    </c:otherwise>
                </c:choose>
            </div>
            <form:input path="photo" type="file" accept="image/jpeg,image/png" id="photoInput" cssClass="form-control"/>
            <div class="form-text">
                JPEG または PNG / 5MB以下
            </div>
            <form:errors path="photo" cssClass="text-danger small"/>
        </div>

        <%-- 名前 --%>
        <div class="mb-4">
            <label for="name" class="form-label fw-bold">
                名前
                <span class="text-danger">（必須）</span>
            </label>

            <form:input path="name" maxlength="10" id="name" cssClass="form-control"/>

            <form:errors path="name" cssClass="text-danger small"/>
        </div>

        <%-- 犬猫 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                犬猫
                <span class="text-danger">（必須）</span>
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton path="species" value="DOG" id="speciesDog" cssClass="form-check-input" onchange="toggleRabies()"/>
                    <label class="form-check-label" for="speciesDog">
                        犬
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton path="species" value="CAT" id="speciesCat" cssClass="form-check-input" onchange="toggleRabies()"/>
                    <label class="form-check-label" for="speciesCat">
                        猫
                    </label>
                </div>

            </div>

            <form:errors path="species" cssClass="text-danger small"/>
        </div>

        <%-- 品種 --%>
        <div class="mb-4">
            <label for="breedId" class="form-label fw-bold">
                品種
            </label>

            <select id="breedId" name="breedId" class="form-select">
                <option value="">未選択</option>
                <optgroup label="-- 猫 --">
                    <c:forEach var="breed" items="${breedList}">
                        <c:if test="${breed.species == 'CAT'}">
                            <option value="${breed.id}" ${animalForm.breedId == breed.id ? 'selected="selected"' : ''}>
                                <c:out value="${breed.name}"/>
                            </option>
                        </c:if>
                    </c:forEach>
                </optgroup>

                <optgroup label="-- 犬 --">
                    <c:forEach var="breed" items="${breedList}">
                        <c:if test="${breed.species == 'DOG'}">
                            <option value="${breed.id}" ${animalForm.breedId == breed.id ? 'selected="selected"' : ''}>
                                <c:out value="${breed.name}"/>
                            </option>
                        </c:if>
                    </c:forEach>
                </optgroup>
            </select>

            <form:errors path="breedId" cssClass="text-danger small"/>

            <%-- 新しい品種 --%>
            <div class="mt-3">
                <label for="newBreedName" class="form-label">
                    新しい品種
                </label>

                <form:input path="newBreedName" maxlength="50" id="newBreedName" cssClass="form-control"/>
                <form:errors path="newBreedName" cssClass="text-danger small"/>
            </div>
        </div>
        
        <%-- 性別 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                性別
                <span class="text-danger">（必須）</span>
            </label>

            <div class="d-flex gap-4">

                <div class="form-check">
                    <form:radiobutton path="sex" value="MALE" cssClass="form-check-input" id="sexMale"/>
                    <label class="form-check-label" for="sexMale">
                        オス
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton path="sex" value="FEMALE" cssClass="form-check-input" id="sexFemale"/>
                    <label class="form-check-label" for="sexFemale">
                        メス
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton path="sex" value="UNKNOWN" cssClass="form-check-input" id="sexUnknown"/>
                    <label class="form-check-label" for="sexUnknown">
                        不明
                    </label>
                </div>
            </div>

            <form:errors path="sex" cssClass="text-danger small"/>
        </div>
    </div>
</div>
<%-- 保護情報・健康情報 --%>
<div class="hogo-card mb-4">
    <div class="hogo-card-head">
        保護情報・健康情報
    </div>
    <div class="hogo-card-body">

        <%-- 誕生日 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                誕生日
            </label>
            <div class="row g-2 align-items-center">
                <div class="col-md-6">
                    <form:input path="birthday" type="date" cssClass="form-control"/>

                    <form:errors path="birthday" cssClass="text-danger small"/>
                </div>
                <div class="col-md-6">
                    <div class="d-flex gap-3">
                        <div class="form-check">
                            <form:radiobutton path="isBirthdayEstimated" value="true" id="birthdayEstimatedTrue" cssClass="form-check-input"/>
                            <label class="form-check-label" for="birthdayEstimatedTrue">
                                推定
                            </label>
                        </div>
                        <div class="form-check">
                            <form:radiobutton path="isBirthdayEstimated" value="false" id="birthdayEstimatedFalse" cssClass="form-check-input"/>
                            <label class="form-check-label" for="birthdayEstimatedFalse">
                                推定ではない
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- 保護日 --%>
        <div class="mb-4">
            <label for="intakeDate" class="form-label fw-bold">
                保護日
                <span class="text-danger">（必須）</span>
            </label>

            <form:input path="intakeDate" type="date" id="intakeDate" cssClass="form-control"/>
            <form:errors path="intakeDate" cssClass="text-danger small"/>
        </div>

        <%-- 保護場所 --%>
        <div class="mb-4">
            <label for="intakePlace" class="form-label fw-bold">
                保護場所
                <span class="text-danger">（必須）</span>
            </label>

            <form:input path="intakePlace" maxlength="50" id="intakePlace" cssClass="form-control"/>

            <form:errors path="intakePlace" cssClass="text-danger small"/>
        </div>

        <%-- 保護方法 --%>
        <div class="mb-4">
            <label for="intakeMethod" class="form-label fw-bold">
                保護方法
                <span class="text-danger">（必須）</span>
            </label>

            <form:input path="intakeMethod" maxlength="30" id="intakeMethod" cssClass="form-control"/>
            <form:errors path="intakeMethod" cssClass="text-danger small"/>
        </div>

        <%-- 保護状況 --%>
        <div class="mb-4">
            <label
                for="status"
                class="form-label fw-bold">
                保護状況
                <span class="text-danger">（必須）</span>
            </label>
            <select
                id="status"
                name="status"
                class="form-select">
                <option value="">
                    未選択
                </option>
                <c:forEach var="status" items="${statusList}">
                    <option
                        value="${status.name()}"
                        <c:if test="${animalForm.status == status}">
                            selected
                        </c:if>>
                        <c:out value="${status.label}"/>
                    </option>
                </c:forEach>
            </select>
            <form:errors path="status" cssClass="text-danger small"/>
        </div>

        <%-- 里親 --%>
        <div class="mb-4">
            <label
                for="adopterId"
                class="form-label fw-bold">
                里親
            </label>
            <select
                id="adopterId"
                name="adopterId"
                class="form-select">
                <option value="">
                    未選択
                </option>
                <c:forEach var="adopter" items="${adopterList}">
                    <option
                        value="${adopter.id}"
                        <c:if test="${animalForm.adopterId == adopter.id}">
                            selected
                        </c:if>>
                        <c:out value="${adopter.name}"/>
                    </option>
                </c:forEach>
            </select>
            <form:errors
                path="adopterId"
                cssClass="text-danger small"/>
        </div>

        <%-- 避妊去勢 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                避妊去勢
                <span class="text-danger">（必須）</span>
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="DONE"
                        cssClass="form-check-input"
                        id="neuteredDone"/>
                    <label
                        class="form-check-label"
                        for="neuteredDone">
                        済
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="NOT_DONE"
                        cssClass="form-check-input"
                        id="neuteredNotDone"/>
                    <label
                        class="form-check-label"
                        for="neuteredNotDone">
                        未
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="UNKNOWN"
                        cssClass="form-check-input"
                        id="neuteredUnknown"/>
                    <label
                        class="form-check-label"
                        for="neuteredUnknown">
                        不明
                    </label>
                </div>
            </div>
            <form:errors
                path="neutered"
                cssClass="text-danger small"/>
        </div>

        <%-- 混合ワクチン --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                混合ワクチン
                <span class="text-danger">（必須）</span>
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton
                        path="comboVaccine"
                        value="true"
                        cssClass="form-check-input"
                        id="comboVaccineTrue"/>
                    <label
                        class="form-check-label"
                        for="comboVaccineTrue">
                        済
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="comboVaccine"
                        value="false"
                        cssClass="form-check-input"
                        id="comboVaccineFalse"/>
                    <label
                        class="form-check-label"
                        for="comboVaccineFalse">
                        未
                    </label>
                </div>
            </div>
            <form:errors
                path="comboVaccine"
                cssClass="text-danger small"/>
        </div>

        <%-- 狂犬病ワクチン --%>
        <div class="mb-4" id="rabiesRow">
            <label class="form-label fw-bold">
                狂犬病ワクチン
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton
                        path="rabiesVaccine"
                        value="true"
                        cssClass="form-check-input"
                        id="rabiesVaccineTrue"/>
                    <label
                        class="form-check-label"
                        for="rabiesVaccineTrue">
                        済
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="rabiesVaccine"
                        value="false"
                        cssClass="form-check-input"
                        id="rabiesVaccineFalse"/>
                    <label
                        class="form-check-label"
                        for="rabiesVaccineFalse">
                        未
                    </label>
                </div>
            </div>
            <form:errors
                path="rabiesVaccine"
                cssClass="text-danger small"/>
        </div>

        <%-- マイクロチップ --%>
        <div class="mb-4">
            <label
                for="microchipNo"
                class="form-label fw-bold">
                マイクロチップ
            </label>
            <form:input
                path="microchipNo"
                maxlength="15"
                id="microchipNo"
                cssClass="form-control"/>
            <form:errors
                path="microchipNo"
                cssClass="text-danger small"/>
        </div>

        <%-- 健康に関する特記事項 --%>
        <div class="mb-4">
            <label
                for="healthNotes"
                class="form-label fw-bold">
                健康に関する特記事項
            </label>
            <form:textarea
                path="healthNotes"
                maxlength="2000"
                id="healthNotes"
                cssClass="form-control"
                rows="5"/>
            <form:errors
                path="healthNotes"
                cssClass="text-danger small"/>
        </div>

        <%-- その他の特記事項 --%>
        <div class="mb-4">
            <label
                for="notes"
                class="form-label fw-bold">
                その他の特記事項
            </label>
            <form:textarea
                path="notes"
                maxlength="2000"
                id="notes"
                cssClass="form-control"
                rows="5"/>
            <form:errors
                path="notes"
                cssClass="text-danger small"/>
        </div>
    </div>
</div>

<%-- ボタン --%>
<div class="button-area"
     style="display: flex; justify-content: flex-end; align-items: center; gap: 8px; padding: 16px 20px; border-top: 1px solid #f0ddd2;">

    <a href="${pageContext.request.contextPath}/animal/${animalId}" class="btn btn-hogo-sub">
        キャンセル
    </a>
    <button type="submit" class="btn btn-hogo">
        更新する
    </button>
</div>
</form:form>
</c:when>
<%-- 新規登録 --%>
        <c:otherwise>
            <form:form id="animalForm" modelAttribute="animalForm" method="post" enctype="multipart/form-data" action="/animal/new">

<%-- 基本情報 --%>
<div class="hogo-card mb-4">
    <div class="hogo-card-head">
        基本情報
    </div>
    <div class="hogo-card-body">

        <%-- 写真 --%>
        <div class="mb-4">

            <label class="form-label fw-bold">
                写真
            </label>
            <div class="mb-3">
                <div id="photoPlaceholder"
                     class="d-flex align-items-center justify-content-center bg-light rounded"
                     style="width: 300px; height: 200px;">
                    写真をアップロードしてください
                </div>
                <img id="photoPreview"
                     class="img-fluid rounded"
                     style="display: none; max-width: 300px;">
            </div>
            <form:input
                path="photo"
                type="file"
                accept="image/jpeg,image/png"
                id="photoInput"
                cssClass="form-control"/>
            <div class="form-text">
                JPEG または PNG / 5MB以下
            </div>
            <form:errors
                path="photo"
                cssClass="text-danger small"/>
        </div>

        <%-- 名前 --%>
        <div class="mb-4">
            <label for="name" class="form-label fw-bold">
                名前
                <span class="text-danger">（必須）</span>
            </label>
            <form:input
                path="name"
                maxlength="10"
                id="name"
                cssClass="form-control"/>
            <form:errors
                path="name"
                cssClass="text-danger small"/>
        </div>

        <%-- 犬猫 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                犬猫
                <span class="text-danger">（必須）</span>
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton
                        path="species"
                        value="DOG"
                        id="speciesDog"
                        cssClass="form-check-input"
                        onchange="toggleRabies()"/>

                    <label class="form-check-label" for="speciesDog">
                        犬
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="species"
                        value="CAT"
                        id="speciesCat"
                        cssClass="form-check-input"
                        onchange="toggleRabies()"/>

                    <label class="form-check-label" for="speciesCat">
                        猫
                    </label>
                </div>
            </div>
            <form:errors
                path="species"
                cssClass="text-danger small"/>
        </div>

        <%-- 品種 --%>
        <div class="mb-4">
            <label for="breedId" class="form-label fw-bold">
                品種
            </label>
            <select
                id="breedId"
                name="breedId"
                class="form-select">
                <option value="">未選択</option>
                <optgroup label="-- 猫 --">
                    <c:forEach var="breed" items="${breedList}">
                        <c:if test="${breed.species == 'CAT'}">
                            <option value="${breed.id}"${animalForm.breedId == breed.id ? 'selected="selected"' : ''}>
                                <c:out value="${breed.name}"/>
                            </option>
                        </c:if>
                    </c:forEach>
                </optgroup>
                <optgroup label="-- 犬 --">
                    <c:forEach var="breed" items="${breedList}">
                        <c:if test="${breed.species == 'DOG'}">
                            <option value="${breed.id}"${animalForm.breedId == breed.id ? 'selected="selected"' : ''}>
                                <c:out value="${breed.name}"/>
                            </option>
                        </c:if>
                    </c:forEach>
                </optgroup>
            </select>
            <form:errors
                path="breedId"
                cssClass="text-danger small"/>

            <%-- 新しい品種 --%>
            <div class="mt-3">
                <label for="newBreedName" class="form-label">
                    新しい品種
                </label>
                <form:input
                    path="newBreedName"
                    maxlength="50"
                    id="newBreedName"
                    cssClass="form-control"/>
                <form:errors
                    path="newBreedName"
                    cssClass="text-danger small"/>
            </div>
        </div>

        <%-- 性別 --%>
        <div class="mb-4">
            <label class="form-label fw-bold">
                性別
                <span class="text-danger">（必須）</span>
            </label>
            <div class="d-flex gap-4">
                <div class="form-check">
                    <form:radiobutton
                        path="sex"
                        value="MALE"
                        cssClass="form-check-input"
                        id="sexMale"/>
                    <label class="form-check-label" for="sexMale">
                        オス
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="sex"
                        value="FEMALE"
                        cssClass="form-check-input"
                        id="sexFemale"/>
                    <label class="form-check-label" for="sexFemale">
                        メス
                    </label>
                </div>
                <div class="form-check">
                    <form:radiobutton
                        path="sex"
                        value="UNKNOWN"
                        cssClass="form-check-input"
                        id="sexUnknown"/>
                    <label class="form-check-label" for="sexUnknown">
                        不明
                    </label>
                </div>
            </div>
            <form:errors
                path="sex"
                cssClass="text-danger small"/>
        </div>
    </div>
</div>
<%-- 詳細情報 --%>
<div class="hogo-card mb-4">

    <div class="hogo-card-head">
        保護情報・健康情報
    </div>

    <div class="hogo-card-body">

        <div class="mb-4">

            <label class="form-label fw-bold">
                誕生日
            </label>

            <div class="row g-2 align-items-center">

                <div class="col-md-6">
                    <form:input
                        path="birthday"
                        type="date"
                        cssClass="form-control"/>

                    <form:errors
                        path="birthday"
                        cssClass="text-danger small"/>
                </div>

                <div class="col-md-6">
                    <div class="d-flex gap-3">

                        <div class="form-check">
                            <form:radiobutton
                                path="isBirthdayEstimated"
                                value="true"
                                id="birthdayEstimatedTrue"
                                cssClass="form-check-input"/>

                            <label
                                class="form-check-label"
                                for="birthdayEstimatedTrue">
                                推定
                            </label>
                        </div>

                        <div class="form-check">
                            <form:radiobutton
                                path="isBirthdayEstimated"
                                value="false"
                                id="birthdayEstimatedFalse"
                                cssClass="form-check-input"/>

                            <label
                                class="form-check-label"
                                for="birthdayEstimatedFalse">
                                推定ではない
                            </label>
                        </div>

                    </div>
                </div>

            </div>

        </div>
         <%-- 保護日 --%>
        <div class="mb-4">

            <label for="intakeDate" class="form-label fw-bold">
                保護日
                <span class="text-danger">（必須）</span>
            </label>

            <form:input
                path="intakeDate"
                type="date"
                id="intakeDate"
                cssClass="form-control"/>

            <form:errors
                path="intakeDate"
                cssClass="text-danger small"/>

        </div>
        <%-- 保護場所 --%>
        <div class="mb-4">

            <label for="intakePlace" class="form-label fw-bold">
                保護場所
                <span class="text-danger">（必須）</span>
            </label>

            <form:input
                path="intakePlace"
                maxlength="50"
                id="intakePlace"
                cssClass="form-control"/>

            <form:errors
                path="intakePlace"
                cssClass="text-danger small"/>

        </div>
		<%-- 保護方法 --%>
        <div class="mb-4">

            <label for="intakeMethod" class="form-label fw-bold">
                保護方法
                <span class="text-danger">（必須）</span>
            </label>

            <form:input
                path="intakeMethod"
                maxlength="30"
                id="intakeMethod"
                cssClass="form-control"/>

            <form:errors
                path="intakeMethod"
                cssClass="text-danger small"/>

        </div>
        <%-- 保護状況 --%>
        <div class="mb-4">

            <label for="status" class="form-label fw-bold">
                保護状況
                <span class="text-danger">（必須）</span>
            </label>

            <select
                id="status"
                name="status"
                class="form-select">

                <option value="">
                    未選択
                </option>

                <c:forEach var="status" items="${statusList}">
                    <option
                        value="${status.name()}"
                        <c:if test="${animalForm.status == status}">
                            selected
                        </c:if>>
                        <c:out value="${status.label}"/>
                    </option>
                </c:forEach>

            </select>

            <form:errors
                path="status"
                cssClass="text-danger small"/>

        </div>
        <%-- 里親 --%>
        <div class="mb-4">

            <label for="adopterId" class="form-label fw-bold">
                里親
            </label>

            <select
                id="adopterId"
                name="adopterId"
                class="form-select">

                <option value="">
                    未選択
                </option>

                <c:forEach var="adopter" items="${adopterList}">
                    <option
                        value="${adopter.id}"
                        <c:if test="${animalForm.adopterId == adopter.id}">
                            selected
                        </c:if>>
                        <c:out value="${adopter.name}"/>
                    </option>
                </c:forEach>

            </select>

            <form:errors
                path="adopterId"
                cssClass="text-danger small"/>

        </div>

<%-- 避妊去勢 --%>
        <div class="mb-4">

            <label class="form-label fw-bold">
                避妊去勢
                <span class="text-danger">（必須）</span>
            </label>

            <div class="d-flex gap-4">

                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="DONE"
                        cssClass="form-check-input"
                        id="neuteredDone"/>

                    <label
                        class="form-check-label"
                        for="neuteredDone">
                        済
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="NOT_DONE"
                        cssClass="form-check-input"
                        id="neuteredNotDone"/>

                    <label
                        class="form-check-label"
                        for="neuteredNotDone">
                        未
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton
                        path="neutered"
                        value="UNKNOWN"
                        cssClass="form-check-input"
                        id="neuteredUnknown"/>

                    <label
                        class="form-check-label"
                        for="neuteredUnknown">
                        不明
                    </label>
                </div>

            </div>

            <form:errors
                path="neutered"
                cssClass="text-danger small"/>

        </div>
        <%-- 混合ワクチン --%>
        <div class="mb-4">

            <label class="form-label fw-bold">
                混合ワクチン
                <span class="text-danger">（必須）</span>
            </label>

            <div class="d-flex gap-4">

                <div class="form-check">
                    <form:radiobutton
                        path="comboVaccine"
                        value="true"
                        cssClass="form-check-input"
                        id="comboVaccineTrue"/>

                    <label
                        class="form-check-label"
                        for="comboVaccineTrue">
                        済
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton
                        path="comboVaccine"
                        value="false"
                        cssClass="form-check-input"
                        id="comboVaccineFalse"/>

                    <label
                        class="form-check-label"
                        for="comboVaccineFalse">
                        未
                    </label>
                </div>

            </div>

            <form:errors
                path="comboVaccine"
                cssClass="text-danger small"/>

        </div>
        <%-- 狂犬病ワクチン --%>
        <div class="mb-4" id="rabiesRow">

            <label class="form-label fw-bold">
                狂犬病ワクチン
            </label>

            <div class="d-flex gap-4">

                <div class="form-check">
                    <form:radiobutton
                        path="rabiesVaccine"
                        value="true"
                        cssClass="form-check-input"
                        id="rabiesVaccineTrue"/>

                    <label
                        class="form-check-label"
                        for="rabiesVaccineTrue">
                        済
                    </label>
                </div>

                <div class="form-check">
                    <form:radiobutton
                        path="rabiesVaccine"
                        value="false"
                        cssClass="form-check-input"
                        id="rabiesVaccineFalse"/>

                    <label
                        class="form-check-label"
                        for="rabiesVaccineFalse">
                        未
                    </label>
                </div>

            </div>

            <form:errors
                path="rabiesVaccine"
                cssClass="text-danger small"/>

        </div>
		<%-- マイクロチップ --%>
        <div class="mb-4">

            <label for="microchipNo" class="form-label fw-bold">
                マイクロチップ
            </label>

            <form:input
                path="microchipNo"
                maxlength="15"
                id="microchipNo"
                cssClass="form-control"/>

            <form:errors
                path="microchipNo"
                cssClass="text-danger small"/>

        </div>
        <%-- 健康に関する特記事項 --%>
        <div class="mb-4">

            <label for="healthNotes" class="form-label fw-bold">
                健康に関する特記事項
            </label>

            <form:textarea
                path="healthNotes"
                maxlength="2000"
                id="healthNotes"
                cssClass="form-control"
                rows="5"/>

            <form:errors
                path="healthNotes"
                cssClass="text-danger small"/>

        </div>
        <%-- その他の特記事項 --%>
        <div class="mb-4">

            <label for="notes" class="form-label fw-bold">
                その他の特記事項
            </label>

            <form:textarea
                path="notes"
                maxlength="2000"
                id="notes"
                cssClass="form-control"
                rows="5"/>

            <form:errors
                path="notes"
                cssClass="text-danger small"/>

        </div>

    </div>
</div>

<%-- ボタン --%>
<div class="button-area"
     style="display: flex; justify-content: flex-end; align-items: center; gap: 8px; padding: 16px 20px; border-top: 1px solid #f0ddd2;">

    <%-- キャンセル --%>
    <a href="${mode == 'new' ? '/animal' : '/animal/'.concat(animalId)}"
       class="btn btn-hogo-sub">
        キャンセル
    </a>

    <%-- 登録・更新 --%>
    <button type="submit" class="btn btn-hogo">
        <c:choose>
            <c:when test="${mode == 'edit'}">
                更新する
            </c:when>
            <c:otherwise>
                登録する
            </c:otherwise>
        </c:choose>
    </button>

</div>         
        	</form:form>
        </c:otherwise>
    </c:choose>

</main>
<%-- 画像プレビュー・トリミング --%>
<script>
const form = document.getElementById("animalForm");
const input = document.getElementById("photoInput");
const preview = document.getElementById("photoPreview");
const placeholder = document.getElementById("photoPlaceholder");

let cropper = null;

// 写真が選択されたとき
input.addEventListener("change", function(event) {

    const file = event.target.files[0];

    if (!file) {
        return;
    }
 	// 写真を選択したらプレースホルダーを消す
    if (placeholder) {
        placeholder.classList.add("d-none");
    }

    // 前回のトリミング枠があれば削除
    if (cropper) {
        cropper.destroy();
        cropper = null;
    }

    // 選択した画像をプレビュー表示
    const reader = new FileReader();

    reader.onload = function(e) {

        preview.src = e.target.result;
        preview.style.display = "block";

     // 「写真をアップロードしてください」を消す
        if (placeholder) {
            placeholder.classList.add("d-none");
        }

        // 画像が表示されてからCropperを起動
        preview.onload = function() {

        	// 念のためCropper起動直前にも消す
        	if (placeholder) {
        	    placeholder.classList.add("d-none");
        	}

            cropper = new Cropper(preview, {

                // 正方形
                aspectRatio: 1,

                // 枠が画像の外にはみ出さない
                viewMode: 1,

                // 画像をドラッグして位置調整
                dragMode: "move"

            });

        };
    };

    reader.readAsDataURL(file);

});

// 送信時
form.addEventListener("submit", function(event) {

    // 写真を選択していなければ、そのまま送信
    if (!cropper) {
        return;
    }

    // 一旦送信を止める
    event.preventDefault();

    // トリミングした画像を600×600で作成
    cropper.getCroppedCanvas({
        width: 600,
        height: 600
    }).toBlob(function(blob) {

        // トリミング後の画像でファイルを作り直す
        const dt = new DataTransfer();

        dt.items.add(
            new File(
                [blob],
                "photo.jpg",
                {
                    type: "image/jpeg"
                }
            )
        );

        // photoの中身をトリミング後の画像に差し替える
        input.files = dt.files;

        // 改めてフォームを送信
        form.submit();

    }, "image/jpeg", 0.9);

});

// 犬猫によって狂犬病ワクチンの表示を切り替える
function toggleRabies() {

    const dog = document.getElementById("speciesDog");
    const rabiesRow = document.getElementById("rabiesRow");

    if (!dog || !rabiesRow) {
        return;
    }

    if (dog.checked) {
        rabiesRow.style.display = "";
    } else {
        rabiesRow.style.display = "none";
    }

}

window.addEventListener("load", toggleRabies);

</script>
</body>

</html>
