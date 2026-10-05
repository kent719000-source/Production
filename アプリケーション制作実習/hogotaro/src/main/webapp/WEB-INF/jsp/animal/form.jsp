<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

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


<style>

    /* 全体 */
    .form-container {
        width: 80%;
        max-width: 900px;
        margin: 30px auto;
    }

    .form-title {
        margin-bottom: 30px;
    }


    /* フォーム */
    .form-table {
        width: 100%;
        border-collapse: collapse;
    }

    .form-table th,
    .form-table td {
        border: 1px solid #ccc;
        padding: 10px;
        vertical-align: top;
    }

    .form-table th {
        width: 200px;
        background-color: #f5f5f5;
        text-align: left;
    }


    /* 必須 */
    .required {
        color: red;
        margin-left: 5px;
    }


    /* 入力 */
    input[type="text"],
    input[type="date"],
    select {
        box-sizing: border-box;
        padding: 6px;
        border: 1px solid #aaa;
    }

    input[type="text"] {
        width: 300px;
    }

    input[type="date"] {
        width: 200px;
    }

    select {
        width: 300px;
    }


    /* ラジオ・チェック */
    .radio-group {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        align-items: center;
    }


    /* テキストエリア */
    textarea {
        width: 100%;
        max-width: 600px;
        height: 150px;
        box-sizing: border-box;
        padding: 8px;
        resize: vertical;
    }


    /* エラーメッセージ */
    .error {
        color: red;
        font-size: 14px;
        margin-top: 5px;
    }


    /* 写真 */
    .photo-area {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .photo-preview {
        width: 180px;
        height: 180px;
        object-fit: cover;
        border: 1px solid #ccc;
    }

    .photo-placeholder {
        width: 180px;
        height: 180px;
        border: 1px dashed #999;

        display: flex;
        align-items: center;
        justify-content: center;

        color: #666;
        text-align: center;
    }

    .photo-note {
        font-size: 13px;
        color: #666;
    }


    /* 文字数 */
    .char-count {
        margin-top: 5px;
        color: #666;
        font-size: 13px;
    }


    /* ボタン */
    .button-area {
        margin-top: 30px;

        display: flex;
        justify-content: center;
        gap: 15px;
    }

    .button-area button,
    .button-area a {
        padding: 10px 30px;

        cursor: pointer;
        text-decoration: none;

        border: 1px solid #999;
        background-color: #eee;
        color: #333;
    }

    .submit-button {
        background-color: #007bff !important;
        color: white !important;
        border: none !important;
    }

</style>

</head>


<body>

<%-- ヘッダー --%>

<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<div class="form-container">

    <%-- タイトル --%>

    <h2 class="form-title">

        <c:choose>
            <c:when test="${mode == 'edit'}">個体編集</c:when>
            <c:otherwise>個体新規登録</c:otherwise>
        </c:choose>
    </h2>

    <%-- フォーム開始 --%>
    <c:choose>
        <%-- 編集 --%>
        <c:when test="${mode == 'edit'}">
            <form:form modelAttribute="animalForm" method="post" enctype="multipart/form-data" action="/animal/${animalId}/edit">
                   <%-- 写真 --%>
        <tr>
            <th>
                写真
            </th>
            <td>
                <div class="photo-area">

         <%-- 編集時に現在の写真がある場合 --%>
                    <c:choose>
                        <c:when test="${mode == 'edit' and not empty animal.imagePath}">

                            <img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${animal.name}" class="photo-preview" id="photoPreview">
                        </c:when>

                        <%-- 写真がない場合 --%>

                        <c:otherwise>
                            <div class="photo-placeholder" id="photoPlaceholder">
                                写真をアップロード<br>
                                してください
                            </div>

                            <img id="photoPreview" class="photo-preview" style="display: none;">
                        </c:otherwise>

                    </c:choose>

                    <%-- ファイル選択 --%>

                    <form:input path="photo" type="file" accept="image/jpeg,image/png" id="photoInput"/>
                    <div class="photo-note">
                        JPEG または PNG<br>
                        5MB以下
                    </div>
                    <form:errors path="photo" cssClass="error"/>
                </div>
            </td>
        </tr>
        <%-- 名前 --%>
        <tr>
            <th>
                名前
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="name" maxlength="10"/>
                <form:errors path="name" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 犬猫 --%>
        <tr>
            <th>
                犬猫
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="species" value="DOG"/>
                    犬
                    <form:radiobutton path="species" value="CAT"/>
                    猫

                </div>
                <form:errors path="species" cssClass="error"/>
            </td>
        </tr>
        <br>

         <%-- 品種 --%>
        <tr>
            <th>
                品種
            </th>
            <td>
                <select id="breedId" name="breedId">
                    <option value="">未選択</option>
                    <%-- プルダウンに猫の品種か犬の品種かわかるように表示させる --%>
                    <optgroup label="-- 猫 --">
                    <c:forEach var="breed" items="${breedList}">
                    	<c:if test="${breed.species == 'CAT'}">
                        <option value="${breed.id}">
                        	<c:out value="${breed.name}"/>
                        </option>
                        </c:if>
                    </c:forEach>
                    </optgroup>
                 	<optgroup label="-- 犬 --">
                 	<c:forEach var="breed" items="${breedList}">
                 		<c:if test="${breed.species == 'DOG'}">
                 		<option value="${breed.id}">
                 			<c:out value="${breed.name}"/>
                 		</option>
                 		</c:if>
                 	</c:forEach>
                 	</optgroup>
                </select>
                <form:errors path="breedId" cssClass="error"/>
                <br>
                <br>
                <%-- 新しい品種 --%>
                <label for="newBreedName">
                    新しい品種
                </label>
                <br>
                <form:input path="newBreedName" maxlength="50"/>
                <form:errors path="newBreedName" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 性別 --%>

        <tr>
            <th>
                性別
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="sex" value="MALE"/>
                    オス
                    <form:radiobutton path="sex" value="FEMALE"/>
                    メス
                    <form:radiobutton path="sex" value="UNKNOWN"/>
                    不明
                </div>

                <form:errors path="sex" cssClass="error"/>
            </td>
        </tr>

        <%-- 誕生日 --%>

        <tr>
            <th>
                誕生日
            </th>
            <td>
                <%-- 誕生日入力 --%>
                <form:input path="birthday" type="date"/>
                <form:errors path="birthday" cssClass="error"/>
                <br>
                <%-- 推定・推定ではない --%>
                <div class="radio-group">
                    <form:radiobutton path="isBirthdayEstimated" value="true"/>
                    推定
                    <form:radiobutton path="isBirthdayEstimated" value="false"/>
                    推定ではない
                </div>
            </td>
        </tr>

        <%-- 保護日 --%>
        <tr>
            <th>
                保護日
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakeDate" type="date"/>
                <form:errors path="intakeDate" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護場所 --%>

        <tr>
            <th>
                保護場所
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakePlace" maxlength="50"/>
                <form:errors path="intakePlace" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護方法 --%>
        <tr>
            <th>
                保護方法
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakeMethod" maxlength="30"/>
                <form:errors path="intakeMethod" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護状況 --%>
        <tr>
            <th>
                保護状況
                <span class="required">＊</span>
            </th>
            <td>
                <select id="status" name="status">
                    <option value="">
                        未選択
                    </option>
                    <c:forEach var="status" items="${statusList}">
                        <option value="${status.name()}"
                            <c:if test="${animalForm.status == status}">
                                selected
                            </c:if>>
                            <c:out value="${status.label}"/>
                        </option>
                    </c:forEach>
                </select>
                <form:errors path="status" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 里親 --%>
        <tr id="adopterRow">
            <th>
                里親
            </th>
            <td>
                <select id="adopterId" name="adopterId">
                    <option value="">
                        未選択
                    </option>
                    <c:forEach var="adopter" items="${adopterList}">
                        <option value="${adopter.id}"
                            <c:if test="${animalForm.adopterId == adopter.id}">
                                selected
                            </c:if>>
                            <c:out value="${adopter.name}"/>
                        </option>
                    </c:forEach>
                </select>
                <form:errors path="adopterId" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 避妊去勢 --%>
        <tr>
            <th>
                避妊去勢
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="neutered" value="DONE"/>
                    済
                    <form:radiobutton path="neutered" value="NOT_DONE"/>
                    未
                    <form:radiobutton path="neutered" value="UNKNOWN"/>
                    不明
                </div>
                <form:errors path="neutered" cssClass="error"/>
            </td>
        </tr>

        <%-- 混合ワクチン --%>
        <tr>
            <th>
                混合ワクチン
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="comboVaccine" value="true"/>
                    済
                    <form:radiobutton path="comboVaccine" value="false"/>
                    未
                </div>
                <form:errors path="comboVaccine" cssClass="error"/>
            </td>
        </tr>

        <%-- 狂犬病ワクチン --%>
        <tr id="rabiesRow">
            <th>
                狂犬病ワクチン
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="rabiesVaccine" value="true"/>
                    済
                    <form:radiobutton path="rabiesVaccine" value="false"/>
                    未
                </div>
                <form:errors path="rabiesVaccine" cssClass="error"/>
            </td>
        </tr>

        <%-- マイクロチップ --%>
        <tr>
            <th>
                マイクロチップ
            </th>
            <td>
                <form:input path="microchipNo" maxlength="15"/>
                <form:errors path="microchipNo" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 健康に関する特記事項 --%>
        <tr>
            <th>
                健康に関する特記事項
            </th>
            <td>
                <form:textarea path="healthNotes" maxlength="2000" id="healthNotes"/>
                <form:errors path="healthNotes" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- その他の特記事項 --%>
        <tr>
            <th>
                その他の特記事項
            </th>
            <td>
                <form:textarea path="notes" maxlength="2000" id="notes"/>
                <form:errors path="notes" cssClass="error"/>
            </td>
        </tr>

<%-- ボタン --%>
<div class="button-area">

    <%-- 登録・更新 --%>
    <button type="submit" class="submit-button">

        <c:choose>

            <c:when test="${mode == 'edit'}">
                更新する
            </c:when>

            <c:otherwise>
                登録する
            </c:otherwise>

        </c:choose>
    </button>

    <%-- キャンセル --%>
    <a href="${mode == 'new' ? '/animal' : '/animal/'.concat(animalId)}">
        キャンセル
    </a>

</div>

</table>

</form:form>

</c:when>

        <%-- 新規登録 --%>
        <c:otherwise>
            <form:form modelAttribute="animalForm" method="post" enctype="multipart/form-data" action="/animal/new">
        <%-- 写真 --%>
        <tr>
            <th>
                写真
            </th>
            <td>
                <div class="photo-area">

         <%-- 編集時に現在の写真がある場合 --%>
                    <c:choose>
                        <c:when test="${mode == 'edit' and not empty animal.imagePath}">

                            <img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${animal.name}" class="photo-preview" id="photoPreview">
                        </c:when>

                        <%-- 写真がない場合 --%>

                        <c:otherwise>
                            <div class="photo-placeholder" id="photoPlaceholder">
                                写真をアップロード<br>
                                してください
                            </div>

                            <img id="photoPreview" class="photo-preview" style="display: none;">
                        </c:otherwise>

                    </c:choose>

                    <%-- ファイル選択 --%>

                    <form:input path="photo" type="file" accept="image/jpeg,image/png" id="photoInput"/>

                    <div class="photo-note">
                        JPEG または PNG<br>
                        5MB以下
                    </div>
                    <form:errors path="photo" cssClass="error"/>
                </div>
            </td>
        </tr>
        <%-- 名前 --%>
        <tr>
            <th>
                名前
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="name" maxlength="10"/>
                <form:errors path="name" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 犬猫 --%>
        <tr>
            <th>
                犬猫
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="species" value="DOG"/>
                    犬
                    <form:radiobutton path="species" value="CAT"/>
                    猫

                </div>
                <form:errors path="species" cssClass="error"/>
            </td>
        </tr>
        <br>

         <%-- 品種 --%>
        <tr>
            <th>
                品種
            </th>
            <td>
                <select id="breedId" name="breedId">
                    <option value="">未選択</option>
                    <%-- プルダウンに猫の品種か犬の品種かわかるように表示させる --%>
                    <optgroup label="-- 猫 --">
                    <c:forEach var="breed" items="${breedList}">
                    	<c:if test="${breed.species == 'CAT'}">
                        <option value="${breed.id}" >
                            <c:out value="${breed.name}"/>
                        </option>
                        </c:if>
                    </c:forEach>
                    </optgroup>
                    
                    <optgroup label="-- 犬 --">
                    <c:forEach var="breed" items="${breedList}">
            			<c:if test="${breed.species == 'DOG'}">
                		<option value="${breed.id}">
                    		<c:out value="${breed.name}"/>
                		</option>
            			</c:if>
        			</c:forEach>
    				</optgroup>
                </select>
                <form:errors path="breedId" cssClass="error"/>
                <br>
                <br>
                <%-- 新しい品種 --%>
                <label for="newBreedName">
                    新しい品種
                </label>
                <br>
                <form:input path="newBreedName" maxlength="50"/>
                <form:errors path="newBreedName" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 性別 --%>

        <tr>
            <th>
                性別
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="sex" value="MALE"/>
                    オス
                    <form:radiobutton path="sex" value="FEMALE"/>
                    メス
                    <form:radiobutton path="sex" value="UNKNOWN"/>
                    不明
                </div>

                <form:errors path="sex" cssClass="error"/>
            </td>
        </tr>

        <%-- 誕生日 --%>

        <tr>
            <th>
                誕生日
            </th>
            <td>
                <%-- 誕生日入力 --%>
                <form:input path="birthday" type="date"/>
                <form:errors path="birthday" cssClass="error"/>
                <br>
                <%-- 推定・推定ではない --%>
                <div class="radio-group">
                    <form:radiobutton path="isBirthdayEstimated" value="true"/>
                    推定
                    <form:radiobutton path="isBirthdayEstimated" value="false"/>
                    推定ではない
                </div>
            </td>
        </tr>

        <%-- 保護日 --%>
        <tr>
            <th>
                保護日
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakeDate" type="date"/>
                <form:errors path="intakeDate" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護場所 --%>

        <tr>
            <th>
                保護場所
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakePlace" maxlength="50"/>
                <form:errors path="intakePlace" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護方法 --%>
        <tr>
            <th>
                保護方法
                <span class="required">＊</span>
            </th>
            <td>
                <form:input path="intakeMethod" maxlength="30"/>
                <form:errors path="intakeMethod" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 保護状況 --%>
        <tr>
            <th>
                保護状況
                <span class="required">＊</span>
            </th>
            <td>
                <select id="status" name="status">
                    <option value="">
                        未選択
                    </option>
                    <c:forEach var="status" items="${statusList}">
                        <option value="${status.name()}"
                            <c:if test="${animalForm.status == status}">
                                selected
                            </c:if>>
                            <c:out value="${status.label}"/>
                        </option>
                    </c:forEach>
                </select>
                <form:errors path="status" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 里親 --%>
        <tr id="adopterRow">
            <th>
                里親
            </th>
            <td>
                <select id="adopterId" name="adopterId">
                    <option value="">
                        未選択
                    </option>
                    <c:forEach var="adopter" items="${adopterList}">
                        <option value="${adopter.id}"
                            <c:if test="${animalForm.adopterId == adopter.id}">
                                selected
                            </c:if>>
                            <c:out value="${adopter.name}"/>
                        </option>
                    </c:forEach>
                </select>
                <form:errors path="adopterId" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 避妊去勢 --%>
        <tr>
            <th>
                避妊去勢
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="neutered" value="DONE"/>
                    済
                    <form:radiobutton path="neutered" value="NOT_DONE"/>
                    未
                    <form:radiobutton path="neutered" value="UNKNOWN"/>
                    不明
                </div>
                <form:errors path="neutered" cssClass="error"/>
            </td>
        </tr>

        <%-- 混合ワクチン --%>
        <tr>
            <th>
                混合ワクチン
                <span class="required">＊</span>
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="comboVaccine" value="true"/>
                    済
                    <form:radiobutton path="comboVaccine" value="false"/>
                    未
                </div>
                <form:errors path="comboVaccine" cssClass="error"/>
            </td>
        </tr>

        <%-- 狂犬病ワクチン --%>
        <tr id="rabiesRow">
            <th>
                狂犬病ワクチン
            </th>
            <td>
                <div class="radio-group">
                    <form:radiobutton path="rabiesVaccine" value="true"/>
                    済
                    <form:radiobutton path="rabiesVaccine" value="false"/>
                    未
                </div>
                <form:errors path="rabiesVaccine" cssClass="error"/>
            </td>
        </tr>

        <%-- マイクロチップ --%>
        <tr>
            <th>
                マイクロチップ
            </th>
            <td>
                <form:input path="microchipNo" maxlength="15"/>
                <form:errors path="microchipNo" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- 健康に関する特記事項 --%>
        <tr>
            <th>
                健康に関する特記事項
            </th>
            <td>
                <form:textarea path="healthNotes" maxlength="2000" id="healthNotes"/>
                <form:errors path="healthNotes" cssClass="error"/>
            </td>
        </tr>
        <br>

        <%-- その他の特記事項 --%>
        <tr>
            <th>
                その他の特記事項
            </th>
            <td>
                <form:textarea path="notes" maxlength="2000" id="notes"/>
                <form:errors path="notes" cssClass="error"/>
            </td>
        </tr>
    </table>

    <%-- ボタン --%>
    <div class="button-area">

        <%-- 登録・更新 --%>
        <button type="submit" class="submit-button">
            <c:choose>
                <c:when test="${mode == 'edit'}">
                    更新する
                </c:when>
                <c:otherwise>
                    登録する
                </c:otherwise>
            </c:choose>
        </button>
        <%-- キャンセル --%>
        <a href="${mode == 'new' ? '/animal' : '/animal/'.concat(animalId)}">キャンセル</a>
    </table>        
        	</form:form>
        </c:otherwise>
    </c:choose>
    <table class="form-table">

</div>
<%-- 選択した画像を表示させるJavaScript --%>
<script>
document.getElementById("photoInput").addEventListener("change", function(event) {

    const file = event.target.files[0];

    const preview = document.getElementById("photoPreview");
    const placeholder = document.getElementById("photoPlaceholder");

    if (file) {
        const reader = new FileReader();

        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = "block";

            if (placeholder) {
                placeholder.style.display = "none";
            }
        };

        reader.readAsDataURL(file);

    } else {
        preview.src = "";
        preview.style.display = "none";

        if (placeholder) {
            placeholder.style.display = "flex";
        }
    }
});
</script>
</body>

</html>
