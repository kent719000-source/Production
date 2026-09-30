<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

        .calendar-container {
            max-width: 1200px;
            margin: 32px auto;
            padding: 0 16px;
        }

        /* タイトルと月移動のボタン */
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
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

        .nav-button {
            display: inline-block;
            padding: 8px 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fff;
            color: #333;
            text-decoration: none;
        }

        .nav-button:hover {
            background-color: #edf2f7;
        }

        .nav-button:focus-visible {
            outline: 3px solid #2563eb;
            outline-offset: 2px;
        }

        /* スマホではカレンダーを横にスクロール */
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
            padding: 8px;
            text-align: left;
            color: #666;
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

        .calendar-table td {
            height: 130px;
            padding: 8px;
            vertical-align: top;
        }

        /* 日曜は赤、土曜は青 */
        .calendar-table th:first-child,
        .calendar-table td:first-child .day-number {
            color: #c0392b;
        }

        .calendar-table th:last-child,
        .calendar-table td:last-child .day-number {
            color: #2563eb;
        }

        /* 前月・翌月の日付 */
        .calendar-table td.outside {
            background-color: #f3f4f6;
        }

        .calendar-table td.outside .day-number {
            color: #888;
        }

        .day-number {
            display: inline-block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        /* イベントの帯 */
        .event {
            margin-top: 5px;
            padding: 6px 8px;
            border-left: 4px solid;
            border-radius: 4px;
            font-size: 13px;
            line-height: 1.5;
            overflow-wrap: anywhere;
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

        .event-time {
            font-weight: bold;
        }

        .event-status {
            display: block;
            margin-top: 3px;
            font-size: 11px;
        }

        .calendar-legend {
            display: flex;
            gap: 16px;
            margin-top: 16px;
            font-size: 13px;
        }

        .legend-item {
            padding: 4px 10px;
            border-radius: 4px;
        }

        .calendar-message {
            padding: 24px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fff;
        }
    </style>
</head>

<body>
<main class="calendar-container">

    <c:choose>
        <%-- Controllerからcalendarが渡されている場合 --%>
        <c:when test="${not empty calendar}">

            <%-- 月移動用のURLを作る --%>
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
                <h1>
                    ${calendar.year}年 ${calendar.month}月
                </h1>

                <nav class="calendar-navigation" aria-label="表示する月の変更">

                    <%-- Service側の表示範囲：1900〜2100年 --%>
                    <c:if test="${calendar.prevYear >= 1900}">
                        <a class="nav-button"
                           href="<c:out value='${prevUrl}' />">
                            前月
                        </a>
                    </c:if>

                    <a class="nav-button"
                       href="<c:out value='${currentUrl}' />">
                        今月
                    </a>

                    <c:if test="${calendar.nextYear <= 2100}">
                        <a class="nav-button"
                           href="<c:out value='${nextUrl}' />">
                            次月
                        </a>
                    </c:if>

                </nav>
            </div>

            <div class="calendar-scroll">
                <table class="calendar-table">

                    <caption>イベントカレンダー</caption>

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
                        <%-- ① カレンダーから1週間を取り出す --%>
                        <c:forEach var="week" items="${calendar.weeks}">
                            <tr>

                                <%-- ② 1週間から1日を取り出す --%>
                                <c:forEach var="d" items="${week}">
                                    <td class="${d.inMonth ? '' : 'outside'}">

                                        <%-- LocalDateの日付と、表示用の日番号 --%>
                                        <time class="day-number"
                                              datetime="${d.date}">
                                            ${d.day}
                                        </time>

                                        <%-- ③ その日のイベントを取り出す --%>
                                        <c:forEach var="e" items="${d.eventList}">
                                            <div class="event ${e.done ? 'done' : 'pending'}">

                                                <%-- 時刻が登録されていれば表示 --%>
                                                <c:if test="${not empty e.eventTime}">
                                                    <div class="event-time">
                                                        <c:out value="${e.eventTime}" />
                                                    </div>
                                                </c:if>

                                                <div>
                                                    <c:out value="${e.animal.name}" />
                                                    ：
                                                    <c:out value="${e.eventType.name}" />
                                                </div>

                                                <span class="event-status">
                                                    ${e.done ? '対応済' : '未対応'}
                                                </span>

                                            </div>
                                        </c:forEach>

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

        </c:when>

        <%-- データが渡されていない場合 --%>
        <c:otherwise>
            <h1>イベントカレンダー</h1>
            <p class="calendar-message">
                カレンダーを表示できませんでした。
            </p>
        </c:otherwise>
    </c:choose>

</main>
</body>
</html>