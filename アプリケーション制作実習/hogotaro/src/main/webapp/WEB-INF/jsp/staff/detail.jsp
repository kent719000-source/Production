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
<title>スタッフ詳細 | ホゴタロウ</title>
<style>
  /* この画面だけのスタイル。共通のスタイルは hogotarou.css（head.jspf が読み込む） */
  /* ===== ここからスタッフだけ ===== */
  /* 未入力の項目。目立ちすぎない薄い茶色 */
  .not-entered {
    color: #a08a7a;
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">スタッフ詳細</h1>
<div class="container mb-5">

  <%-- 登録・編集・削除のあとのメッセージ（フラッシュ。1回だけ表示される） --%>
  <c:if test="${not empty message}">
    <div class="alert alert-warning"><c:out value="${message}"/></div>
  </c:if>

  <%-- 操作ボタンの行。左に「一覧へ戻る」、右に「編集」「削除」（里親詳細と同じ並び） --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="/staff" class="btn btn-hogo-sub">← 一覧へ戻る</a>

    <%-- 編集・削除は管理ユーザーだけ --%>
    <c:if test="${loginUser.role == 'ADMIN'}">
      <div class="d-flex gap-2">
        <a href="/staff/${staff.id}/edit" class="btn btn-hogo">編集</a>
        <%-- 自分自身は削除できない --%>
        <c:if test="${staff.id != loginUser.staffId}">
          <form:form method="post" action="/staff/${staff.id}/delete"
              cssClass="m-0" onsubmit="return confirm('本当に削除しますか？')">
            <button type="submit" class="btn btn-hogo-danger">削除</button>
          </form:form>
        </c:if>
      </div>
    </c:if>
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
              <%-- 項目名のセルは table-peach（ピーチ色）＋ hogo-th-label（幅をそろえる） --%>
              <tr><th scope="row" class="table-peach hogo-th-label">ID</th><td><c:out value="${staff.id}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">ログインID</th><td><c:out value="${staff.loginId}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">名前</th><td><c:out value="${staff.name}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">性別</th><td><c:out value="${staff.gender.label}"/></td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">年齢</th><td><c:out value="${staff.age}"/>歳</td></tr>
              <tr><th scope="row" class="table-peach hogo-th-label">生年月日</th><td><c:out value="${staff.birthday}"/></td></tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">住所</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.address}"><c:out value="${staff.address}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr><th scope="row" class="table-peach hogo-th-label">電話番号</th><td><c:out value="${staff.phoneNumber}"/></td></tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">メールアドレス</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.email}"><c:out value="${staff.email}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr>
                <th scope="row" class="table-peach hogo-th-label">登録日</th>
                <td>
                  <c:choose>
                    <c:when test="${not empty staff.joinedDate}"><c:out value="${staff.joinedDate}"/></c:when>
                    <c:otherwise><span class="not-entered">未入力</span></c:otherwise>
                  </c:choose>
                </td>
              </tr>
              <tr><th scope="row" class="table-peach hogo-th-label">ユーザー種別</th><td><c:out value="${staff.userType.name}"/></td></tr>
            </tbody>
          </table>
        </div>
      </section>

      <%-- 特記事項 --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">特記事項</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${not empty staff.notes}">
              <%-- hogo-notes：入力したときの改行をそのまま表示する。c:out とタグの間に改行を入れない（余分な空白も表示されるため） --%>
              <p class="hogo-notes"><c:out value="${staff.notes}"/></p>
            </c:when>
            <c:otherwise><p class="m-0"><span class="not-entered">未入力</span></p></c:otherwise>
          </c:choose>
        </div>
      </section>

    </div>

    <%-- ===== 右の列 ===== --%>
    <div class="col-lg-7 d-flex flex-column gap-4">

      <%-- 対応したイベント --%>
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">
          対応したイベント
          <%-- fn:length：リストの件数を数える関数 --%>
          <span class="hogo-badge">${fn:length(eventList)}件</span>
        </h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty eventList}">
              <p class="hogo-empty">イベントはありません</p>
            </c:when>
            <c:otherwise>
              <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-peach"><%-- 項目行（ヘッダーと同じピーチ色） --%>
                  <tr><th>日付</th><th>種別</th><th>個体名</th></tr>
                </thead>
                <tbody>
                  <c:forEach var="e" items="${eventList}">
                    <tr>
                      <td><a href="/event/${e.id}"><c:out value="${e.eventDate}"/></a></td>
                      <td><c:out value="${e.eventType.name}"/></td>
                      <td><c:out value="${e.animal.name}"/></td>
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
