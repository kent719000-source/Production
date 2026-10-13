<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>スタッフ一覧 | ホゴタロウ</title>
<style>
  /* この画面だけのスタイル。共通のスタイルは hogotarou.css（head.jspf が読み込む） */
  /* ===== 検索フォーム ===== */
  /* 全体を白いカードにして、角を丸く・影をうっすら付ける */
  .hogo-search {
    background-color: #ffffff;
    border: 1px solid var(--hogo-border);
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(160, 90, 40, 0.08);
    overflow: hidden;           /* 中の見出し帯の角も丸く切り取る */
  }
  /* カード上部の見出し帯（うすいピーチ色） */
  .hogo-search-head {
    background-color: var(--hogo-peach-light);
    border-bottom: 1px solid var(--hogo-border);
    color: var(--hogo-brown);
    font-weight: 700;
    padding: 0.6rem 1.25rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .hogo-search-body {
    padding: 1.25rem;
  }
  /* 入力欄のラベル */
  .hogo-search .form-label {
    color: var(--hogo-brown);
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 0.3rem;
  }
  /* 入力欄。枠線を淡いベージュ、角を丸く */
  .hogo-search .form-control {
    border-color: var(--hogo-border);
    border-radius: 10px;
    background-color: #fffdfb;
  }
  /* 入力欄を選んだとき。Bootstrap標準の青い光を、ピーチ色の光に変える */
  .hogo-search .form-control:focus {
    border-color: #e8a066;
    box-shadow: 0 0 0 0.25rem rgba(255, 170, 110, 0.3);
  }
  /* 入力欄の中の薄い例文 */
  .hogo-search .form-control::placeholder {
    color: #c8b3a3;
  }

  /* 0件のときの表示 */
  .hogo-empty {
    background-color: var(--hogo-peach-light);
    border: 1px dashed var(--hogo-border);
    border-radius: 16px;
    color: var(--hogo-brown);
    text-align: center;
    padding: 2rem;
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">スタッフ一覧</h1>
<div class="container mb-5">

  <%-- 登録・編集・削除のあとのメッセージ（フラッシュ。1回だけ表示される） --%>
  <c:if test="${not empty message}">
    <div class="alert alert-warning"><c:out value="${message}"/></div>
  </c:if>

  <%-- 検索フォーム。method="get"。modelAttribute="searchForm"で、Controller の @ModelAttribute("searchForm") とつながる(検索後も入力が残る) --%>
  <form:form modelAttribute="searchForm" method="get" action="${pageContext.request.contextPath}/staff" cssClass="hogo-search mb-4">
    <%-- 見出し帯（虫めがねのアイコン＋タイトル） --%>
    <div class="hogo-search-head">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true">
        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0"/>
      </svg>
      絞り込み検索
    </div>
    <div class="hogo-search-body">
      <div class="row g-3 align-items-end">
        <div class="col-md">
          <form:label path="name" cssClass="form-label">名前</form:label>
          <form:input path="name" cssClass="form-control" placeholder="例：山田 太郎"/>
        </div>
        <div class="col-md">
          <form:label path="phoneNumber" cssClass="form-label">電話番号</form:label>
          <form:input path="phoneNumber" cssClass="form-control" placeholder="例：090-1234-5678"/>
        </div>
        <div class="col-md-auto d-flex gap-2">
          <%-- クリア：条件なしの一覧ページへ移動して、入力をリセットする --%>
          <a href="${pageContext.request.contextPath}/staff" class="btn btn-hogo-sub">クリア</a>
          <button type="submit" class="btn btn-hogo">検索</button>
        </div>
      </div>
    </div>
  </form:form>

  <%-- 件数（左）と新規登録ボタン（右）を1行に並べる --%>
  <div class="d-flex justify-content-between align-items-center mb-2">
    <%-- fn:length：リストの件数を数える関数 --%>
    <span class="hogo-count">検索結果 <strong>${fn:length(staffList)}</strong> 件</span>

    <%-- スタッフの新規登録は管理ユーザー(A)だけ（決定 2-14）。里親と違って常勤スタッフにも出さない --%>
    <sec:authorize access="hasRole('ADMIN')"><%-- アクセス制限タグ --%>
      <a href="${pageContext.request.contextPath}/staff/new" class="btn btn-hogo">＋ 新規登録</a>
    </sec:authorize>
  </div>

  <c:choose><%-- 条件分岐 --%>
    <c:when test="${empty staffList}"><%-- if --%>
      <p class="hogo-empty">該当するスタッフはいません</p>
    </c:when>
    <c:otherwise><%-- else --%>
      <%-- table-bordered：各セルに境界線 / table-hover：マウスを乗せた行に色 / align-middle：上下中央ぞろえ --%>
      <table class="table table-bordered table-hover align-middle">
        <thead class="table-peach"><%-- 項目行（ヘッダーと同じピーチ色） --%>
          <tr>
            <th>名前</th>
            <th>性別</th>
            <th>電話番号</th>
            <th>メールアドレス</th>
            <th>ユーザー種別</th>
          </tr>
        </thead>
        <tbody><%-- データ行 --%>
          <%-- staffList を1件ずつ s に入れて繰り返す --%>
          <c:forEach items="${staffList}" var="s"><%-- 繰り返しタグ --%>
            <tr>
              <td><a href="${pageContext.request.contextPath}/staff/${s.id}"><c:out value="${s.name}"/></a></td>
              <td><c:out value="${s.gender.label}"/></td>
              <td><c:out value="${s.phoneNumber}"/></td>
              <%-- メールアドレスは任意。空なら「未登録」（10/1 の表示ルール） --%>
              <td>
                <c:choose>
                  <c:when test="${empty s.email}">未登録</c:when>
                  <c:otherwise><c:out value="${s.email}"/></c:otherwise>
                </c:choose>
              </td>
              <td><c:out value="${s.userType.name}"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>

</div>
</body>
</html>
