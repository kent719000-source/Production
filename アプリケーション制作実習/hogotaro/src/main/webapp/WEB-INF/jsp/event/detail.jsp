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
<title>イベント詳細 | ホゴタロウ</title>
<style>
  /* この画面だけのスタイル。共通のスタイルは hogotarou.css（head.jspf が読み込む） */
  /* イベント詳細固有の表示 */
  .event-detail .table { table-layout: fixed; }
  .event-detail td, .event-detail .hogo-notes { overflow-wrap: anywhere; }
  .event-detail .stamp-button {
    width: 76px; height: 76px; display: inline-flex;
    align-items: center; justify-content: center;
    border: 2px dashed #bca28d; border-radius: 50%;
    background: #fffaf5; color: var(--hogo-brown); cursor: pointer;
  }
  .event-detail .stamp-button:hover { background: var(--hogo-peach-light); }
  .event-detail .stamp-done {
    border: 3px solid var(--hogo-danger); color: var(--hogo-danger);
    font-size: 30px; font-weight: 700; transform: rotate(-10deg);
  }
  .event-detail a:focus-visible, .event-detail button:focus-visible {
    outline: 3px solid var(--hogo-accent); outline-offset: 3px;
  }
  .event-detail .status-panel small { display: block; margin-top: .75rem; color: #7a5a44; }
  .event-detail .alert { border-radius: 12px; }
  @media (max-width: 575.98px) {
    .event-detail .hogo-card-body { padding: 1rem; }
    .event-detail .hogo-th-label { width: 7rem; white-space: normal; }
    .event-detail .table > :not(caption) > * > * { padding: .65rem .75rem; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
<main class="container event-detail mb-5">
  <h1 class="text-center my-5">イベント詳細</h1>
  <c:if test="${not empty message}">
    <div class="alert alert-success" role="status"><c:out value="${message}" /></div>
  </c:if>

  <%-- 戻る先は、このイベントが登録されている年月 --%>
  <c:url var="calendarUrl" value="/event">
    <c:param name="year" value="${event.eventDate.year}" />
    <c:param name="month" value="${event.eventDate.monthValue}" />
  </c:url>
  <c:url var="animalUrl" value="/animal/${event.animal.id}" />

  <%-- 里親詳細と同じ配置：左に戻る、右に編集・削除 --%>
  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <a href="${fn:escapeXml(calendarUrl)}" class="btn btn-hogo-sub">← 一覧へ戻る</a>
    <div class="d-flex flex-wrap gap-2">
      <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
        <c:url var="editUrl" value="/event/${event.id}/edit" />
        <a href="${fn:escapeXml(editUrl)}" class="btn btn-hogo">編集</a>
      </sec:authorize>
      <sec:authorize access="hasRole('ADMIN')">
        <c:url var="deleteUrl" value="/event/${event.id}/delete" />
        <form:form id="event-delete" action="${deleteUrl}" method="post"
                   cssClass="m-0" data-confirm="本当に削除しますか？">
          <button type="submit" class="btn btn-hogo-danger">削除</button>
        </form:form>
      </sec:authorize>
    </div>
  </div>

  <%-- PCでは2列、狭い画面では縦に並ぶ --%>
  <div class="row g-4">
    <div class="col-lg-7">
      <section class="hogo-card" aria-labelledby="event-info-heading">
        <h2 id="event-info-heading" class="hogo-card-head h6 m-0">基本情報</h2>
        <div class="hogo-card-body">
          <table class="table table-bordered align-middle mb-0">
            <tbody>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">日付</th>
                <td><c:out value="${event.eventDate}" /></td>
            </tr>

            <c:if test="${not empty event.eventTime}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">時刻</th>
                    <td><c:out value="${event.eventTime}" /></td>
                </tr>
            </c:if>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">個体名</th>
                <td>
                    <a href="${fn:escapeXml(animalUrl)}">
                        <c:out value="${event.animal.name}" />
                    </a>
                </td>
            </tr>

            <tr>
                <th scope="row" class="table-peach hogo-th-label">イベント種別</th>
                <td><c:out value="${event.eventType.name}" /></td>
            </tr>

            <c:if test="${not empty event.place}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">場所</th>
                    <td><c:out value="${event.place}" /></td>
                </tr>
            </c:if>

            <c:if test="${not empty event.adopter}">
                <c:url var="adopterUrl"
                       value="/adopter/${event.adopter.id}" />

                <tr>
                    <th scope="row" class="table-peach hogo-th-label">里親</th>
                    <td>
                        <a href="${fn:escapeXml(adopterUrl)}">
                            <c:out value="${event.adopter.name}" />
                        </a>
                    </td>
                </tr>
            </c:if>

			<tr>
			    <th scope="row" class="table-peach hogo-th-label">対応スタッフ</th>
			    <td>
			        <c:if test="${event.done and not empty event.staff}">
			            <c:url var="staffUrl"
			                   value="/staff/${event.staff.id}" />
			
			            <a href="${fn:escapeXml(staffUrl)}">
			                <c:out value="${event.staff.name}" />
			            </a>
			        </c:if>
			    </td>
			</tr>

            <c:if test="${event.cost != null}">
                <tr>
                    <th scope="row" class="table-peach hogo-th-label">費用</th>
                    <td><c:out value="${event.cost}" /> 円</td>
                </tr>
            </c:if>



            
        
            </tbody>
          </table>
        </div>
      </section>
    </div>
    <div class="col-lg-5 d-flex flex-column gap-4">
      <section class="hogo-card" aria-labelledby="event-status-heading">
        <h2 id="event-status-heading" class="hogo-card-head h6 m-0">対応状況</h2>
        <div class="hogo-card-body status-panel text-center">

        <%-- 管理ユーザー・常勤スタッフは操作できる --%>
        <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
            <c:choose>

                <%-- 対応済なら、未対応に戻すボタン --%>
                <c:when test="${event.done}">
                    <c:url var="uncompleteUrl"
                           value="/event/${event.id}/uncomplete" />

                    <form:form id="event-uncomplete" cssClass="m-0" action="${uncompleteUrl}" method="post"
                        onsubmit="return confirm('イベントを未対応に戻しますか？個体の情報は自動では変わりません');">

                        <button type="submit"
                                class="stamp-button stamp-done"
                                aria-label="対応済。クリックすると未対応に戻します">
                            済
                        </button>
                    </form:form>

                    <small>クリックで未対応に戻す</small>
                </c:when>

                <%-- 未対応なら、完了にするボタン --%>
                <c:otherwise>
                    <c:url var="completeUrl"
                           value="/event/${event.id}/complete" />

                    <form:form id="event-complete" cssClass="m-0" action="${completeUrl}" method="post"
                        onsubmit="return confirm('イベントを完了にしますか？個体の情報は自動では変わりません');">

                        <button type="submit"
                                class="stamp-button"
                                aria-label="未対応。クリックすると対応済にします">
                        </button>
                    </form:form>

                    <small>未対応：クリックで対応済にする</small>
                </c:otherwise>

            </c:choose>
        </sec:authorize>

        <%-- ボランティアには文字だけ表示する --%>
        <sec:authorize access="hasRole('VOLUNTEER')">
            <c:choose>
                <c:when test="${event.done}"><span class="hogo-status hogo-status-done">対応済</span></c:when>
                <c:otherwise><span class="hogo-status hogo-status-todo">未対応</span></c:otherwise>
            </c:choose>
        </sec:authorize>
    
        </div>
      </section>
      <section class="hogo-card" aria-labelledby="event-notes-heading">
        <h2 id="event-notes-heading" class="hogo-card-head h6 m-0">特記事項</h2>
        <div class="hogo-card-body">
          <c:choose>
            <c:when test="${empty event.notes}">
              <p class="hogo-empty">特記事項はありません</p>
            </c:when>
            <c:otherwise>
              <p class="hogo-notes"><c:out value="${event.notes}" /></p>
            </c:otherwise>
          </c:choose>
        </div>
      </section>
    </div>
  </div>
</main>
<script>
document.addEventListener("submit", function (event) {
    const form = event.target;

    if (!(form instanceof HTMLFormElement)) {
        return;
    }

    // フォームのdata-confirmに書かれた確認文を取り出す
    const message = form.dataset.confirm;

    // 「キャンセル」なら送信を止める
    if (message && !window.confirm(message)) {
        event.preventDefault();
    }
});
</script>
</body>
</html>
