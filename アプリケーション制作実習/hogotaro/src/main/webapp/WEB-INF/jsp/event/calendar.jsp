<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>イベントカレンダー | ホゴタロウ</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background-color: #f7f8fa;
            color: #333;
            font-family: sans-serif;
        }

        button {
            font: inherit;
        }

        [hidden] {
            display: none !important;
        }

        .page-container {
            max-width: 1400px;
            margin: 32px auto;
            padding: 0 16px;
        }

        /* 年月の見出しと月移動 */
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 20px;
        }

        .calendar-header h1 {
            margin: 0;
            font-size: 26px;
        }

        .calendar-navigation {
            display: flex;
            gap: 8px;
        }

        .nav-button,
        .close-button {
            display: inline-block;
            padding: 8px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fff;
            color: #333;
            text-decoration: none;
            cursor: pointer;
        }

        .nav-button:hover,
        .close-button:hover {
            background-color: #edf2f7;
        }

        a:focus-visible,
        button:focus-visible {
            outline: 3px solid #2563eb;
            outline-offset: 2px;
        }

        /* 左：カレンダー、右：概要ペイン */
        .calendar-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 20px;
            align-items: start;
        }

        .calendar-area {
            min-width: 0;
        }

        .calendar-scroll {
            overflow-x: auto;
        }

        .calendar-table {
            width: 100%;
            min-width: 700px;
            table-layout: fixed;
            border-collapse: collapse;
            background-color: #fff;
        }

        .calendar-table caption {
            padding: 8px 0;
            color: #666;
            text-align: left;
        }

        .calendar-table th,
        .calendar-table td {
            border: 1px solid #ddd;
        }

        .calendar-table th {
            padding: 12px 4px;
            background-color: #f0f3f6;
            font-weight: normal;
        }

        /* 日付のマス全体 */
        .calendar-day {
            height: 140px;
            padding: 8px;
            vertical-align: top;
            cursor: pointer;
        }

        .calendar-day:hover {
            background-color: #edf4ff;
        }

        .calendar-day.outside {
            background-color: #f3f4f6;
        }

        .calendar-day.outside:hover {
            background-color: #e5ecf5;
        }

        .calendar-day.is-selected {
            box-shadow: inset 0 0 0 3px #2563eb;
            background-color: #edf4ff;
        }

        /* キーボードでも日付を選べるよう、ボタンにする */
        .day-button {
            display: block;
            width: 100%;
            min-height: 112px;
            padding: 0;
            border: 0;
            background-color: transparent;
            color: inherit;
            text-align: left;
            cursor: pointer;
        }

        .day-number {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .calendar-table th:first-child,
        .calendar-day:first-child .day-number {
            color: #c0392b;
        }

        .calendar-table th:last-child,
        .calendar-day:last-child .day-number {
            color: #2563eb;
        }

        .calendar-day.outside .day-number {
            color: #888;
        }

        /* マスの中の予定の帯 */
        .event-bar {
            display: block;
            margin-top: 5px;
            padding: 5px 7px;
            border-left: 4px solid;
            border-radius: 4px;
            font-size: 12px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .event-time {
            font-weight: bold;
        }

        .pending {
            border-left-color: #c48a16;
            background-color: #fff0cc;
            color: #654800;
        }

        .done {
            border-left-color: #398451;
            background-color: #d9efdf;
            color: #245c35;
        }

        .calendar-legend {
            display: flex;
            gap: 16px;
            margin-top: 16px;
            font-size: 13px;
        }

        .legend-item,
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
        }

        /* 概要ペイン */
        .event-pane {
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fff;
            overflow-wrap: anywhere;
        }

        .event-pane h2 {
            margin: 0 0 16px;
            font-size: 20px;
        }

        .pane-message {
            color: #666;
            line-height: 1.8;
        }

        /* 概要ペイン内の予定1件分 */
        .event-card {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #ddd;
        }

        .event-card h3 {
            margin: 0 0 10px;
            font-size: 17px;
            line-height: 1.5;
        }

        .event-details {
            margin: 12px 0;
        }

        .event-details dt {
            margin-top: 10px;
            color: #666;
            font-size: 13px;
        }

        .event-details dd {
            margin: 3px 0 0;
            line-height: 1.6;
        }

        .notes {
            white-space: pre-wrap;
        }

        .close-button {
            margin-top: 20px;
        }

        /* 狭い画面では概要ペインを下へ */
        @media (max-width: 1000px) {
            .calendar-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>
<main class="page-container">

    <c:choose>
        <c:when test="${not empty calendar}">

            <%-- 月移動のURL --%>
            <c:url var="prevUrl" value="/event">
                <c:param name="year" value="${calendar.prevYear}" />
                <c:param name="month" value="${calendar.prevMonth}" />
            </c:url>

            <c:url var="nextUrl" value="/event">
                <c:param name="year" value="${calendar.nextYear}" />
                <c:param name="month" value="${calendar.nextMonth}" />
            </c:url>

            <c:url var="currentUrl" value="/event" />

            <div class="calendar-header">
                <h1>${calendar.year}年 ${calendar.month}月</h1>

                <nav class="calendar-navigation" aria-label="表示する月の変更">

                    <c:if test="${calendar.prevYear >= 1900}">
                        <a class="nav-button"
                           href="${fn:escapeXml(prevUrl)}">
                            前月
                        </a>
                    </c:if>

                    <a class="nav-button"
                       href="${fn:escapeXml(currentUrl)}">
                        今月
                    </a>

                    <c:if test="${calendar.nextYear <= 2100}">
                        <a class="nav-button"
                           href="${fn:escapeXml(nextUrl)}">
                            次月
                        </a>
                    </c:if>

                </nav>
            </div>

            <div class="calendar-layout">

                <section class="calendar-area" aria-label="月間カレンダー">

                    <div class="calendar-scroll">
                        <table class="calendar-table">

                            <caption>
                                日付のマスをクリックすると、その日の予定を表示します
                            </caption>

                            <thead>
                                <tr>
                                    <th scope="col">日</th>
                                    <th scope="col">月</th>
                                    <th scope="col">火</th>
                                    <th scope="col">水</th>
                                    <th scope="col">木</th>
                                    <th scope="col">金</th>
                                    <th scope="col">土</th>
                                </tr>
                            </thead>

                            <tbody>

                                <%-- ① 1週間ずつ取り出す --%>
                                <c:forEach var="week" items="${calendar.weeks}">
                                    <tr>

                                        <%-- ② 1日ずつ取り出す --%>
                                        <c:forEach var="d" items="${week}">

                                            <td class="calendar-day ${d.inMonth ? '' : 'outside'}"
                                                data-date="${fn:escapeXml(d.date)}">

                                                <%-- ③ カレンダー上に見せる部分 --%>
                                                <button
                                                    type="button"
                                                    class="day-button"
                                                    aria-label="${fn:escapeXml(d.date)}の予定を表示"
                                                    aria-controls="event-pane"
                                                    aria-pressed="false">

                                                    <time class="day-number"
                                                          datetime="${d.date}">
                                                        ${d.day}
                                                    </time>

                                                    <c:forEach var="e" items="${d.eventList}">
                                                        <span class="event-bar ${e.done ? 'done' : 'pending'}">

                                                            <c:if test="${not empty e.eventTime}">
                                                                <span class="event-time">
                                                                    <c:out value="${e.eventTime}" />
                                                                </span>
                                                            </c:if>

                                                            <span>
                                                                <c:out value="${e.animal.name}" />
                                                                ：
                                                                <c:out value="${e.eventType.name}" />
                                                            </span>

                                                            <span>
                                                                （${e.done ? '済' : '未'}）
                                                            </span>

                                                        </span>
                                                    </c:forEach>

                                                </button>

                                                <%-- ④ この日専用の概要。ここでは表示されない --%>
                                                <template class="day-details">

                                                    <c:choose>

                                                        <%-- 予定がない日 --%>
                                                        <c:when test="${empty d.eventList}">
                                                            <p class="pane-message">
                                                                この日の予定はありません。
                                                            </p>
                                                        </c:when>

                                                        <%-- 予定がある日 --%>
                                                        <c:otherwise>

                                                            <p>
                                                                予定：
                                                                ${fn:length(d.eventList)}件
                                                            </p>

                                                            <%-- その日の予定を全部並べる --%>
                                                            <c:forEach var="e" items="${d.eventList}">

                                                                <article class="event-card">

                                                                    <h3>
                                                                        <c:out value="${e.animal.name}" />
                                                                        ：
                                                                        <c:out value="${e.eventType.name}" />
                                                                    </h3>

																	 <c:choose>
																	
																	    <%-- すでに対応済なら、対応済の表示だけ出す --%>
																	    <c:when test="${e.done}">
																	        <span class="status-badge done">
																	            対応済
																	        </span>
																	    </c:when>
																	
																	    <%-- まだ未対応の場合 --%>
																	    <c:otherwise>
																	
																	        <c:choose>
																	
																	            <%-- 管理ユーザー・常勤スタッフは完了操作ができる --%>
																	            <c:when test="${loginUser.role == 'ADMIN'
																	                            or loginUser.role == 'STAFF'}">
																	
																	                <%-- このイベント専用の送信先を作る --%>
																	                <c:url var="completeUrl"
																	                       value="/event/${e.id}/complete" />
																	
																	                <form:form
																	                    action="${completeUrl}"
																	                    method="post"
																	                    onsubmit="return confirm('このイベントを完了にしますか？');">
																	
																	                    <button type="submit" class="complete-button">
																	                        対応済にする
																	                    </button>
																	
																	                </form:form>
																	
																	            </c:when>
																	
																	            <%-- ボランティアには状態だけ表示する --%>
																	            <c:otherwise>
																	                <span class="status-badge pending">
																	                    未対応
																	                </span>
																	            </c:otherwise>
																	
																	        </c:choose>
																	
																	    </c:otherwise>
																	</c:choose>

                                                                    <dl class="event-details">

                                                                        <dt>日付</dt>
                                                                        <dd>
                                                                            <c:out value="${e.eventDate}" />
                                                                        </dd>

                                                                        <c:if test="${not empty e.eventTime}">
                                                                            <dt>時刻</dt>
                                                                            <dd>
                                                                                <c:out value="${e.eventTime}" />
                                                                            </dd>
                                                                        </c:if>

                                                                        <dt>個体名</dt>
                                                                        <dd>
                                                                            <c:out value="${e.animal.name}" />
                                                                        </dd>

                                                                        <dt>イベント種別</dt>
                                                                        <dd>
                                                                            <c:out value="${e.eventType.name}" />
                                                                        </dd>

                                                                        <c:if test="${not empty e.place}">
                                                                            <dt>場所</dt>
                                                                            <dd>
                                                                                <c:out value="${e.place}" />
                                                                            </dd>
                                                                        </c:if>

                                                                        <c:if test="${e.cost != null}">
                                                                            <dt>費用</dt>
                                                                            <dd>
                                                                                <c:out value="${e.cost}" />円
                                                                            </dd>
                                                                        </c:if>

                                                                        <c:if test="${not empty e.adopter}">
                                                                            <dt>里親</dt>
                                                                            <dd>
                                                                                <c:out value="${e.adopter.name}" />
                                                                            </dd>
                                                                        </c:if>

                                                                        <c:if test="${not empty e.notes}">
                                                                            <dt>特記事項</dt>
                                                                            <dd class="notes"><c:out value="${e.notes}" /></dd>
                                                                        </c:if>

                                                                    </dl>

                                                                </article>
                                                            </c:forEach>

                                                        </c:otherwise>
                                                    </c:choose>

                                                </template>

                                            </td>
                                        </c:forEach>

                                    </tr>
                                </c:forEach>

                            </tbody>
                        </table>
                    </div>

                    <div class="calendar-legend">
                        <span class="legend-item pending">未対応</span>
                        <span class="legend-item done">対応済</span>
                    </div>

                </section>

                <%-- ⑤ 選んだ日の内容を表示する場所 --%>
                <aside id="event-pane"
                       class="event-pane"
                       aria-labelledby="pane-heading">

                    <h2 id="pane-heading" tabindex="-1">日付を選択</h2>

                    <p id="pane-placeholder" class="pane-message">
                        カレンダーの日付をクリックしてください。
                    </p>

                    <div id="pane-content" hidden></div>

                    <button type="button"
                            id="pane-close"
                            class="close-button"
                            hidden>
                        選択を解除
                    </button>

                </aside>

            </div>

        </c:when>

        <c:otherwise>
            <h1>イベントカレンダー</h1>
            <p>カレンダーを表示できませんでした。</p>
        </c:otherwise>
    </c:choose>

</main>

<script>
    // ⑥ 必要なHTML要素を取得する
    const dayCells = document.querySelectorAll(".calendar-day");
    const paneHeading = document.getElementById("pane-heading");
    const panePlaceholder = document.getElementById("pane-placeholder");
    const paneContent = document.getElementById("pane-content");
    const closeButton = document.getElementById("pane-close");

    // 現在選ばれている日付のマス
    let selectedCell = null;

    // ⑦ 各マスにクリック処理を登録する
    for (const cell of dayCells) {

        cell.addEventListener("click", function () {

            // 前に選んだマスの選択状態を外す
            if (selectedCell !== null) {
                selectedCell.classList.remove("is-selected");

                const previousButton =
                    selectedCell.querySelector(".day-button");

                previousButton.setAttribute("aria-pressed", "false");
            }

            // 今クリックしたマスを選択状態にする
            selectedCell = cell;
            cell.classList.add("is-selected");

            const currentButton = cell.querySelector(".day-button");
            currentButton.setAttribute("aria-pressed", "true");

            // ⑧ 選んだ日付を見出しに表示する
            const date = cell.dataset.date;
            paneHeading.textContent = date + "の予定";

            // ⑨ このマス専用の概要を取り出す
            const template = cell.querySelector(".day-details");

            // 概要の中身を、子要素も含めてコピーする
            const content = template.content.cloneNode(true);

            // 前の内容を消して、新しい概要に置き換える
            paneContent.replaceChildren(content);

            // ⑩ 概要を表示する
            panePlaceholder.hidden = true;
            paneContent.hidden = false;
            closeButton.hidden = false;

            // キーボード操作でも概要に移動できるようにする
            paneHeading.focus();
        });
    }

    // ⑪ 選択解除
    if (closeButton !== null) {

        closeButton.addEventListener("click", function () {

            paneHeading.textContent = "日付を選択";
            paneContent.replaceChildren();

            paneContent.hidden = true;
            closeButton.hidden = true;
            panePlaceholder.hidden = false;

            if (selectedCell !== null) {
                selectedCell.classList.remove("is-selected");

                const button =
                    selectedCell.querySelector(".day-button");

                button.setAttribute("aria-pressed", "false");
                button.focus();

                selectedCell = null;
            }
        });
    }
</script>

</body>
</html>