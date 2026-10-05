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


	<form:form method="post">
		<table>
			<c:choose>
				<c:when test="${mode == 'edit'}">
					<%-- 編集ではログインIDを変更させないので、入力欄を出さず文字で出す（値は送られない） --%>
					<tr>
						<th>ログインID</th>
						<td><c:out value="${staff.loginId}" /></td>
					</tr>
					<%-- パスワードは空のまま送ると変更しない。入力欄に値を入れ直さない（パスワードを HTML に書き出さないため）。
             autocomplete="new-password" は、ブラウザが保存している自分のパスワードを勝手に入れないようにする指定 --%>
					<tr>
						<th>パスワード</th>
						<td><input type="password" name="password" maxlength="72"
							autocomplete="new-password"> 変更する場合だけ入力してください</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th>ログインID（必須）</th>
						<td><input type="text" name="loginId"
							value="<c:out value='${staffForm.loginId}'/>" maxlength="30"
							autocomplete="off" required></td>
					</tr>
					<tr>
						<th>パスワード（必須）</th>
						<td><input type="password" name="password" maxlength="72"
							autocomplete="new-password" required></td>
					</tr>
				</c:otherwise>
			</c:choose>
			
			<tr>
				<th>名前（必須）</th>
				<td><input type="text" name="name"
					value="<c:out value='${staffForm.name}'/>" maxlength="30" required></td>
			</tr>
			<tr>
				<th>性別（必須）</th>
				<td>
					<%-- genderList は Gender.values()。value="${g}" で定数名（MALE など）を送り、画面には label（男性など）を出す。
             <label> で囲むと、文字をクリックしても選べる --%> <c:forEach var="g"
						items="${genderList}">
						<label><input type="radio" name="gender" value="${g}"
							<c:if test="${staffForm.gender == g}">checked</c:if>>${g.label}</label>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<th>生年月日（必須）</th>
				<%-- type="date" はカレンダーから選べる入力欄。"2026-09-30" の形で送られ、StaffForm の @DateTimeFormat で LocalDate になる --%>
				<td><input type="date" name="birthday"
					value="${staffForm.birthday}" required></td>
			</tr>
			<tr>
				<th>住所</th>
				<td><input type="text" name="address"
					value="<c:out value='${staffForm.address}'/>" maxlength="100"
					size="50"></td>
			</tr>
			<tr>
				<th>電話番号（必須）</th>
				<td><input type="tel" name="phoneNumber"
					value="<c:out value='${staffForm.phoneNumber}'/>" maxlength="20"
					required></td>
			</tr>
			<tr>
				<th>メールアドレス</th>
				<td><input type="email" name="email"
					value="<c:out value='${staffForm.email}'/>" maxlength="255"
					size="50"></td>
			</tr>
			<tr>
				<th>登録日</th>
				<td><input type="date" name="joinedDate"
					value="${staffForm.joinedDate}"> 団体にスタッフとして登録した日</td>
			</tr>
			<tr>
				<th>ユーザー種別（必須）</th>
				<td>
					<%-- 値（value）は id、表示は name。先頭の「選択してください」のまま送ると userTypeId が null になり、validate() のエラーになる --%>
					<select name="userTypeId" required>
						<option value="">選択してください</option>
						<c:forEach var="t" items="${userTypeList}">
							<option value="${t.id}"
								<c:if test="${staffForm.userTypeId == t.id}">selected</c:if>><c:out
									value="${t.name}" /></option>
						</c:forEach>
				</select> <c:if test="${mode == 'edit' && staff.id == loginUser.staffId}">
          自分自身のユーザー種別は変更できません
        </c:if>
				</td>
			</tr>
			<tr>
				<th>特記事項</th>
				<%-- textarea は value を持たないので、開始タグと終了タグの間に値を書く。間に空白や改行を入れると、それも値になるので 1 行で書く --%>
				<td><textarea name="notes" rows="4" cols="50" maxlength="2000"><c:out
							value="${staffForm.notes}" /></textarea></td>
			</tr>
		</table>





		<br>
		<button type="submit">登録</button>
	</form:form>

</body>
</html>


<%-- --%>