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
<title>里親詳細 | ホゴタロウ</title>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">里親詳細</h1>
<div class="container mb-5">

  <%-- 登録・編集・削除できなかった時のメッセージ（フラッシュ。1回だけ表示される） --%>
  <c:if test="${not empty message}">
    <div class="alert alert-warning"><c:out value="${message}"/></div>
  </c:if>

  <%-- 操作ボタンの行。左に「一覧へ戻る」、右に「編集」「削除」 --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="${pageContext.request.contextPath}/adopter" class="btn btn-hogo-sub">← 一覧へ戻る</a>

    <div class="d-flex gap-2">
      <%-- 編集は常勤スタッフ(S)以上だけ --%>
      <sec:authorize access="hasAnyRole('ADMIN','STAFF')"><%-- アクセス制限タグ --%>
        <a href="${pageContext.request.contextPath}/adopter/${adopter.id}/edit" class="btn btn-hogo">編集</a>
      </sec:authorize>

      <%-- 削除は管理者(ADMIN)だけ。POSTで送るので<form:form>で書く（CSRFトークンが自動で入る） --%>
      <sec:authorize access="hasAnyRole('ADMIN')">
        <form:form method="post" action="${pageContext.request.contextPath}/adopter/${adopter.id}/delete"
            cssClass="m-0" onsubmit="return confirm('本当に削除しますか？')">
          <button type="submit" class="btn btn-hogo-danger">削除</button>
        </form:form>
      </sec:authorize>
    </div>
  </div>

  <%-- 2列レイアウト。PC(lg以上)では左5：右7、スマホでは縦1列 --%>
  <div class="row g-4">

    <%-- ===== 左の列 ===== --%>
    <div class="col-lg-5 d-flex flex-column gap-4">

      <%-- 基本情報 --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">基本情報</h2>
        <div class="hogo-card-body">
          <table class="table table-bordered align-middle mb-0">
            <tbody>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">名前</th>
                <td><c:out value="${adopter.name}"/></td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">性別</th>
                <td>${adopter.gender.label}</td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">生年月日</th>
                <td>${empty adopter.birthday ? '不明' : adopter.birthday}</td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">年齢</th>
                <%-- += は文字列をつなげる演算子。年齢があれば「○歳」と表示する --%>
                <td>${empty adopter.age ? '不明' : adopter.age += '歳'}</td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">住所</th>
                <%-- default：値がnullのときに代わりに表示する文字 --%>
                <td><c:out value="${adopter.address}" default="-"/></td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">電話番号</th>
                <td><c:out value="${adopter.phoneNumber}" default="-"/></td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">メールアドレス</th>
                <td><c:out value="${adopter.email}" default="-"/></td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <%-- メモ --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">メモ</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty adopter.notes}">
              <p class="hogo-empty">メモはありません</p>
            </c:when>
            <c:otherwise>
              <%-- pre-wrap:入力したときの改行をそのまま表示する。c:out とタグの間に改行を入れない（余分な空白も表示されるため） --%>
              <p class="hogo-notes"><c:out value="${adopter.notes}"/></p>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>

    <%-- ===== 右の列 ===== --%>
    <div class="col-lg-7 d-flex flex-column gap-4">

      <%-- 関連する個体 --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">
          関連する個体
          <%-- fn:length：リストの件数を数える関数 --%>
          <span class="hogo-badge">${fn:length(animalList)}件</span>
        </h2>
        <div class="hogo-card-body">
          <c:choose><%-- 条件分岐 --%>
            <c:when test="${empty animalList}"><%-- if --%>
              <p class="hogo-empty">関連する犬猫はいません</p>
            </c:when>
            <c:otherwise><%-- else --%>
              <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-peach"><%-- 項目行（ヘッダーと同じピーチ色） --%>
                  <tr><th>名前</th><th>犬猫</th><th>保護状況</th></tr>
                </thead>
                <tbody>
                  <%-- animalList を1件ずつ a に入れて繰り返す --%>
                  <c:forEach items="${animalList}" var="a"><%-- 繰り返しタグ --%>
                    <tr>
                      <td><a href="${pageContext.request.contextPath}/animal/${a.id}"><c:out value="${a.name}"/></a></td>
                      <td>${a.species.label}</td>
                      <td>${a.status.label}</td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </c:otherwise>
          </c:choose>
        </div>
      </section>

      <%-- 関連するイベント --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">
          関連するイベント
          <span class="hogo-badge">${fn:length(eventList)}件</span>
        </h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty eventList}">
              <p class="hogo-empty">関連するイベントはありません</p>
            </c:when>
            <c:otherwise>
              <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-peach">
                  <tr><th>日付</th><th>種別</th><th>個体名</th><th>対応状況</th></tr>
                </thead>
                <tbody>
                  <c:forEach items="${eventList}" var="e">
                    <tr>
                      <td><a href="${pageContext.request.contextPath}/event/${e.id}">${e.eventDate}</a></td>
                      <td><c:out value="${e.eventType.name}"/></td>
                      <td><c:out value="${e.animal.name}"/></td>
                      <td>
                        <%-- 済・未でバッジの色を変える --%>
                        <c:choose>
                          <c:when test="${e.done}"><span class="hogo-status hogo-status-done">済</span></c:when>
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