<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>個体一覧 | ホゴタロウ</title>
</head>
<%-- CSSもどき --%>
    <style>
        /* == 新規登録ボタン == */
        .new-button {
            display: inline-block;
            padding: 8px 25px;
            background-color: #0077c8;
            color: white;
            text-decoration: none;
            border-radius: 20px;
            margin-bottom: 20px;
        }
        .new-button:hover {
            opacity: 0.8;
        }

        /* == 検索エリア == */

        .search-box {
            background-color: #f8e4cf;
            border: 1px solid #888;
            padding: 25px;
            margin-bottom: 40px;
        }
        .search-row {
            margin-bottom: 20px;
        }
        .search-label {
            display: inline-block;
            width: 80px;
            font-weight: bold;
        }
        .search-button {
            display: block;
            margin-left: auto;
            padding: 8px 25px;
            font-size: 16px;
            cursor: pointer;
        }
        
        /* == 個体カード == */

        .animal-list {
            display: grid;
            grid-template-columns:
                repeat(4, 1fr);
            gap: 15px;
        }
        .animal-card {
            background-color: #f8e4cf;
            padding: 10px;
            text-decoration: none;
            color: black;
            border: 2px solid transparent;
            transition:
                border 0.2s,
                box-shadow 0.2s;
        }
        .animal-card:hover {
            border: 2px solid #0077c8;
            box-shadow:
                0 4px 10px rgba(0, 0, 0, 0.3);
        }

        /* == 写真 == */

        .animal-image {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        /* == 写真ない場合 == */
        .no-image {
            width: 100%;
            height: 150px;
            background-color: #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #777;
        }

        /* == カード情報 == */

        .animal-name {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            margin: 8px 0;
        }

        .animal-info {
            font-size: 13px;
            line-height: 1.6;
        }

    </style>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
<h1>個体一覧</h1>
<%-- 新規登録ボタン：ボランティア以外に表示) --%>
	<c:if test="${loginUser.role == 'ADMIN' || loginUser.role == 'STAFF'}">
    	<a href="/animal/new" class="new-button">新規登録</a>
	</c:if>
<%-- ファセット検索(になる予定) --%>
    <form action="${pageContext.request.contextPath}/animal" method="get">
    	<div class="search-box">
     <%-- 犬猫 --%>
     		<div class="search-row">
     			<span class="search-label">種別：</span>
        			<c:forEach var="species" items="${speciesList}">
            			<label>
						<input type="checkbox" name="species" value="${species}"
    						<c:if test="${searchForm.species != null && searchForm.species.contains(species)}">
        					checked
    						</c:if>>
                    			${species.label}
                 		</label>
             		</c:forEach>
      		</div>
      <%-- 保護状況 --%>
      		<div class="search-row">
      			<span class="search-label">保護状況：</span>
        			<c:forEach var="status" items="${statusList}">
            			<label>
						<input type="checkbox" name="statuses" value="${status}"
    						<c:if test="${searchForm.statuses != null && searchForm.statuses.contains(status)}">
        						checked
    						</c:if>>
                    			${status.label}
                		</label>
            		</c:forEach>
       		</div>
       <%-- 名前 --%>
       		<div class="search-row">
                		<label for="name" class="search-label">名前：</label>
                    		<input type="text" id="name" name="name" value="${searchForm.name}">
                    		<button type="submit" name="search" value="1" class="search-button">検索</button>
       		</div>
         </div>
     </form>    
     <br>

<%-- 個体カード一覧 --%>
	<table>
		<tr>
			<th>写真</th><th>名前</th><th>性別</th><th>品種</th><th>年齢</th>
		</tr>
    	<c:forEach var="animal" items="${animalList}">
        	<tr>
            	<td>
                	<a href="${pageContext.request.contextPath}/animal/${animal.id}">
                   	<c:choose>
                        	<c:when test="${not empty animal.imagePath}">
                            	<img src="${pageContext.request.contextPath}${animal.imagePath}" alt="${animal.name}" style="width: 100px; height: 100px; object-fit: cover;">
                        	</c:when>
                        	<c:otherwise>
								<img src="${pageContext.request.contextPath}/NoPhotos/NoPhotos.png" alt="画像なし" style="width: 100px; height: 100px; object-fit: cover;">
                        	</c:otherwise>
                    </c:choose>
                	</a>
            	</td>
            	<td>
                	<a href="${pageContext.request.contextPath}/animal/${animal.id}">${animal.name}</a>
            	</td>
            	<td>
                	${animal.sex.label}
            	</td>
            	<td>
                	<c:choose>
                    	<c:when test="${not empty animal.breed}">${animal.breed.name}
                    	</c:when>
                    	<c:otherwise>
                    	    -
                    	</c:otherwise>
                	</c:choose>
            	</td>
            	<td>
                	<c:choose>
                    	<c:when test="${not empty animal.age}">${animal.age}歳
                    	</c:when>
                    	<c:otherwise>
                     	   -
                    	</c:otherwise>
                	</c:choose>
            	</td>

        	</tr>

    	</c:forEach>
	</table>
</body>
</html>