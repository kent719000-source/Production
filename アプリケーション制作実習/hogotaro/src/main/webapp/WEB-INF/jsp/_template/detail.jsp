<%-- =========================================================
     詳細画面のテンプレート（見本：adopter/detail.jsp）
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
<title>○○詳細 | ホゴタロウ</title><%-- ★ --%>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">○○詳細</h1><%-- ★ --%>
<div class="container mb-5">

  <%-- 登録・編集・削除できなかった時のメッセージ --%>
  <%@ include file="/WEB-INF/jsp/common/message.jspf" %>

  <%-- ===== 操作ボタンの行。左に「一覧へ戻る」、右に「編集」「削除」 ===== --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="${ctx}/xxx" class="btn btn-hogo-sub">← 一覧へ戻る</a><%-- ★ --%>

    <div class="d-flex gap-2">
      <%-- 編集は常勤スタッフ(S)以上だけ --%>
      <sec:authorize access="hasAnyRole('ADMIN','STAFF')">
        <a href="${ctx}/xxx/${xxx.id}/edit" class="btn btn-hogo">編集</a><%-- ★ --%>
      </sec:authorize>

      <%-- 削除は管理者(ADMIN)だけ。POSTで送るので<form:form>で書く（CSRFトークンが自動で入る） --%>
      <sec:authorize access="hasAnyRole('ADMIN')">
        <form:form method="post" action="${ctx}/xxx/${xxx.id}/delete"
            cssClass="m-0" onsubmit="return confirm('本当に削除しますか？')"><%-- ★ --%>
          <button type="submit" class="btn btn-hogo-danger">削除</button>
        </form:form>
      </sec:authorize>
    </div>
  </div>

  <%-- ===== 2列レイアウト。PC(lg以上)では左5：右7、スマホでは縦1列 =====
       関連する情報が無い画面なら、左の列だけ残して class="col-lg-8 mx-auto" にすると中央1列になる --%>
  <div class="row g-4">

    <%-- ===== 左の列 ===== --%>
    <div class="col-lg-5 d-flex flex-column gap-4">

      <%-- 基本情報（項目名を左に縦に並べる表） --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">基本情報</h2>
        <div class="hogo-card-body">
          <table class="table table-bordered align-middle mb-0">
            <tbody>
              <%-- ★ 項目の数だけ tr をコピーする --%>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">名前</th>
                <td><c:out value="${xxx.name}"/></td>
              </tr>
              <tr>
                <%-- enum の表示名は .label で出す --%>
                <th scope="row" class="table-peach hogo-th-label">区分</th>
                <td>${xxx.kind.label}</td>
              </tr>
              <tr>
                <%-- 空のときに出す文字を決めたいときは三項演算子 --%>
                <th scope="row" class="table-peach hogo-th-label">日付</th>
                <td>${empty xxx.date ? '不明' : xxx.date}</td>
              </tr>
              <tr>
                <%-- default：値がnullのときに代わりに表示する文字 --%>
                <th scope="row" class="table-peach hogo-th-label">テキスト</th>
                <td><c:out value="${xxx.text}" default="-"/></td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <%-- メモ（複数行のテキスト） --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">メモ</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty xxx.notes}"><%-- ★ --%>
              <p class="hogo-empty">メモはありません</p>
            </c:when>
            <c:otherwise>
              <%-- hogo-notes(pre-wrap):入力したときの改行をそのまま表示する。c:out とタグの間に改行を入れない（余分な空白も表示されるため） --%>
              <p class="hogo-notes"><c:out value="${xxx.notes}"/></p><%-- ★ --%>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>

    <%-- ===== 右の列 ===== --%>
    <div class="col-lg-7 d-flex flex-column gap-4">

      <%-- 関連する情報の一覧 ★必要な数だけ section をコピーする --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">
          関連する○○<%-- ★ --%>
          <span class="hogo-badge">${fn:length(relatedList)}件</span><%-- ★ --%>
        </h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty relatedList}"><%-- ★ --%>
              <p class="hogo-empty">関連する○○はありません</p><%-- ★ --%>
            </c:when>
            <c:otherwise>
              <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-peach">
                  <tr><th>名前</th><th>項目2</th><th>状況</th></tr><%-- ★ --%>
                </thead>
                <tbody>
                  <c:forEach items="${relatedList}" var="r"><%-- ★ --%>
                    <tr>
                      <td><a href="${ctx}/yyy/${r.id}"><c:out value="${r.name}"/></a></td><%-- ★ --%>
                      <td><c:out value="${r.field2}" default="-"/></td><%-- ★ --%>
                      <td>
                        <%-- 済・未のような2択は、色付きバッジにすると見落としにくい --%>
                        <c:choose>
                          <c:when test="${r.done}"><span class="hogo-status hogo-status-done">済</span></c:when>
                          <c:otherwise><span class="hogo-status hogo-status-todo">未</span></c:otherwise>
                        </c:choose>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>
  </div>

</div>
</body>
</html>
