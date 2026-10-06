<%-- =========================================================
     一覧画面のテンプレート（見本：adopter/list.jsp）
     使い方：このファイルをコピーして、★の付いた所を書き換える
       ○○      → 画面の名前（例：里親）
       xxx      → URL・変数の名前（例：adopter）
     ========================================================= --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>○○一覧 | ホゴタロウ</title><%-- ★ --%>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">○○一覧</h1><%-- ★ --%>
<div class="container mb-5">

  <%-- 登録・編集・削除できなかった時のメッセージ --%>
  <%@ include file="/WEB-INF/jsp/common/message.jspf" %>

  <%-- ===== 検索フォーム =====
       method="get"。modelAttribute="searchForm"で、Controller の @ModelAttribute("searchForm")とつながる(検索後も入力が残る) --%>
  <form:form modelAttribute="searchForm" method="get" action="${ctx}/xxx" cssClass="hogo-card mb-4"><%-- ★ action --%>
    <div class="hogo-card-head">絞り込み検索</div>
    <div class="hogo-card-body">
      <div class="row g-3 align-items-end">

        <%-- 文字で検索する項目 ★必要な数だけコピーする --%>
        <div class="col-md">
          <form:label path="name" cssClass="form-label">名前</form:label>
          <form:input path="name" cssClass="form-control" placeholder="例：山田 花子"/>
        </div>

        <%-- チェックボックスで絞り込む項目（複数選べる）★不要なら消す
             xxxOptionList：選択肢のリスト（enum.values() など）を Controller から渡す --%>
        <%--
        <div class="col-12">
          <span class="form-label d-block">種別</span>
          <c:forEach var="opt" items="${xxxOptionList}">
            <div class="form-check form-check-inline">
              <form:checkbox path="xxxOptions" value="${opt}" id="opt-${opt}" cssClass="form-check-input"/>
              <label class="form-check-label" for="opt-${opt}">${opt.label}</label>
            </div>
          </c:forEach>
        </div>
        --%>

        <%-- ボタン。クリアは条件なしの一覧へ移動して、入力をリセットする --%>
        <div class="col-md-auto d-flex gap-2">
          <a href="${ctx}/xxx" class="btn btn-hogo-sub">クリア</a><%-- ★ --%>
          <button type="submit" class="btn btn-hogo">検索</button>
        </div>

      </div>
    </div>
  </form:form>

  <%-- ===== 件数（左）と新規登録ボタン（右） ===== --%>
  <div class="d-flex justify-content-between align-items-center mb-2">
    <%-- fn:length：リストの件数を数える関数 --%>
    <span class="hogo-count">検索結果 <strong>${fn:length(xxxList)}</strong> 件</span><%-- ★ --%>

    <%-- 新規登録は常勤スタッフ(S)以上だけ。ボランティアには出さない --%>
    <sec:authorize access="hasAnyRole('ADMIN','STAFF')">
      <a href="${ctx}/xxx/new" class="btn btn-hogo">＋ 新規登録</a><%-- ★ --%>
    </sec:authorize>
  </div>

  <%-- ===== 一覧の表 ===== --%>
  <c:choose><%-- 条件分岐 --%>
    <c:when test="${empty xxxList}"><%-- if ★ --%>
      <p class="hogo-empty">該当する○○はいません</p><%-- ★ --%>
    </c:when>
    <c:otherwise><%-- else --%>
      <%-- table-bordered：各セルに境界線 / table-hover：マウスを乗せた行に色 / align-middle：上下中央ぞろえ --%>
      <table class="table table-bordered table-hover align-middle">
        <thead class="table-peach"><%-- 項目行（ヘッダーと同じピーチ色） --%>
          <tr>
            <th>名前</th><%-- ★ 列の数だけ th を並べる --%>
            <th>項目2</th>
            <th>項目3</th>
          </tr>
        </thead>
        <tbody><%-- データ行 --%>
          <%-- xxxList を1件ずつ item に入れて繰り返す --%>
          <c:forEach items="${xxxList}" var="item"><%-- ★ --%>
            <tr>
              <%-- 名前をクリックで詳細画面へ。入力された文字は必ず c:out で表示する（XSS対策） --%>
              <td><a href="${ctx}/xxx/${item.id}"><c:out value="${item.name}"/></a></td><%-- ★ --%>
              <td><c:out value="${item.field2}" default="-"/></td><%-- ★ --%>
              <td><c:out value="${item.field3}" default="-"/></td><%-- ★ --%>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>

</div>
</body>
</html>
