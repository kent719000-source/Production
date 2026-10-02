<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf"%>
<c:choose>
  <c:when test="${mode == 'edit'}">
    <h1>スタッフ編集</h1>
  </c:when>
  <c:otherwise>
    <h1>スタッフ新規登録</h1>
  </c:otherwise>
</c:choose>

	<form:form modelAttribute="staffForm" method="post" action="${action}">
		<div>
		<c:choose>
        	<c:when test="${mode == 'edit'}">
          	<%-- 編集ではログインIDを変更させないので、入力欄を出さず文字で出す（値は送られない） --%>
          		<div class="form-label">ログインID</div>
          		<div class="form-control-plaintext"><c:out value="${loginId}"/></div>
        	</c:when>
        	<c:otherwise>
        		<label for="loginId">ログインID</label>
          		<form:input path="loginId" maxlength="30" autocomplete="off"/>
         	<form:errors path="loginId"/>
        </c:otherwise>
    	</c:choose>
		</div>    	
		
		<div>
    	<label for="password">パスワード</label>
    	<%-- form:password は、入力エラーで戻ったときに値を入れ直さない（パスワードを HTML に書き出さないため）。
           autocomplete="new-password" は、ブラウザが保存している自分のパスワードを勝手に入れないようにする指定 --%>
    	<form:password path="password" maxlength="72" autocomplete="off"/>
    		<c:if test="${mode == 'edit'}">
    			<div>変更する場合だけ入力してください</div>
    		</c:if>
     	<form:errors path="password"/>
		</div>
		
    	<br><button type="submit">登録</button>
	</form:form>
	
</body>
</html>


<%-- --%>