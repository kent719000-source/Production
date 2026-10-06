<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>イベントカレンダー | ホゴタロウ</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<%-- 丸ゴシック体（Zen Maru Gothic）を Google Fonts から読み込む --%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap" rel="stylesheet">
<style>
/* 里親一覧と共通の配色・フォント */
:root {
    --bs-body-font-family: 'Zen Maru Gothic', sans-serif; /* 丸ゴシックでやわらかい印象に */
    --bs-body-color: #4a3f38;              /* 真っ黒ではなく、こげ茶寄りの文字色 */
    --bs-body-bg: #fffaf5;                 /* ほんのり温かみのある白 */
    --bs-body-line-height: 1.8;            /* 行間を広げて読みやすく */
    --bs-link-color-rgb: 196, 98, 45;      /* リンクの色（オレンジ寄りの茶色） */
    --bs-link-hover-color-rgb: 150, 70, 30;/* リンクにマウスを乗せたときの色 */

    /* ホゴタロウの配色。色はここにまとめて、下のCSSでは変数名で使う */
    --hogo-peach: #FFD1A0;        /* ロゴ・ヘッダーと同じピーチ色 */
    --hogo-peach-light: #fff1e4;  /* ピーチをうすくした色（背景・ホバー用） */
    --hogo-accent: #c4622d;       /* ボタンなどの強調色（オレンジ寄りの茶色） */
    --hogo-accent-dark: #a34f22;  /* 強調色にマウスを乗せたときの色 */
    --hogo-brown: #6b4226;        /* 見出し・ラベルの茶色 */
    --hogo-border: #ecd6c4;       /* 淡いベージュの線 */
  }
  .btn-hogo {
    background-color: var(--hogo-accent);
    border: 1.5px solid var(--hogo-accent);
    color: #ffffff;
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1.4rem;
    transition: background-color 0.2s, box-shadow 0.2s;
  }
  .btn-hogo:hover,
  .btn-hogo:focus-visible {
    background-color: var(--hogo-accent-dark);
    border-color: var(--hogo-accent-dark);
    color: #ffffff;
    box-shadow: 0 3px 8px rgba(163, 79, 34, 0.25); /* ふわっと浮く */
  }
  /* サブのボタン（クリア）。普段は文字だけ、マウスを乗せるとうすいピーチ色 */
  .btn-hogo-sub {
    background-color: transparent;
    border: 1.5px solid transparent;
    color: var(--hogo-brown);
    font-weight: 500;
    border-radius: 999px;
    padding: 0.4rem 1rem;
    transition: background-color 0.2s;
  }
  .btn-hogo-sub:hover,
  .btn-hogo-sub:focus-visible {
    background-color: var(--hogo-peach-light);
    color: var(--hogo-accent);
  }


[hidden] { display: none !important; }
.hogo-calendar-page { max-width: 1400px; }
.hogo-calendar-page h1, .hogo-calendar-page h2, .hogo-calendar-page h3 {
    color: var(--hogo-brown); font-weight: 700;
}
.calendar-header { padding: 1.25rem; border-bottom: 1px solid var(--hogo-border); background: var(--hogo-peach-light); border-radius: 16px 16px 0 0; }
.calendar-month-selector { display: flex; align-items: center; gap: .75rem; }
.calendar-month-selector h2 { margin: 0; font-size: clamp(1.15rem, 3vw, 1.6rem); white-space: nowrap; }
.month-arrow { display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; padding: 0; border: 1px solid var(--hogo-border); border-radius: 50%; background: white; color: var(--hogo-brown); font-size: 1.5rem; line-height: 1; }
.month-arrow:hover { background: var(--hogo-peach); color: var(--hogo-brown); }
.calendar-layout { display: grid; grid-template-columns: minmax(0, 1fr) 320px; gap: 1.5rem; align-items: start; }
.calendar-area, .event-pane { min-width: 0; border: 1px solid var(--hogo-border); border-radius: 16px; background: #fff; box-shadow: 0 4px 12px rgba(160,90,40,.08); }
.calendar-scroll { overflow-x: auto; }
.calendar-table { width: 100%; min-width: 700px; table-layout: fixed; border-collapse: collapse; --bs-table-color: var(--bs-body-color); --bs-table-border-color: var(--hogo-border); margin-bottom: 0; }
.calendar-table caption { caption-side: top; padding: .8rem 1.25rem; font-size: .85rem; color: #806957; }
.calendar-table th { padding: .7rem .25rem; text-align: center; --bs-table-bg: var(--hogo-peach); color: var(--hogo-brown); }
.calendar-table th, .calendar-table td { border: 1px solid var(--hogo-border); }
.calendar-table .calendar-day { padding: 0; vertical-align: top; }
.calendar-day.outside { --bs-table-bg: #f7f2ec; }
.calendar-day.is-selected { --bs-table-bg: #fff1e4; box-shadow: inset 0 0 0 2px var(--hogo-accent); }
.day-content { padding: 7px; }
.day-number { display: block; margin: 0 0 8px; font-weight: 700; }
.calendar-table th:first-child, .calendar-day:first-child .day-number { color: #b95143; }
.calendar-table th:last-child, .calendar-day:last-child .day-number { color: #426b8c; }
.calendar-day.outside .day-number { color: #93867b; }
.day-events { min-height: 110px; display: flex; flex-direction: column; gap: 5px; }
/* 全件表示。文字を省略せず、長いタイトルは折り返す */
.event-bar { display: block; width: 100%; min-height: 44px; padding: 6px 7px; border: 0; border-left: 3px solid; border-radius: 7px; text-align: left; font: inherit; font-size: .78rem; line-height: 1.6; white-space: normal; overflow-wrap: anywhere; cursor: pointer; }
.event-bar:hover { filter: brightness(.97); }
.event-time { display: block; font-weight: 700; }
.pending { border-color: #ca8b3a; background: #fff0d5; color: #75501f; }
.done { border-color: #6c9470; background: #e4f1e3; color: #355c3c; }
.event-bar[aria-pressed="true"] { outline: 2px solid var(--hogo-accent); outline-offset: 1px; }
.calendar-legend { padding: 1rem 1.25rem; }
.legend-item { display: inline-block; border-left: 3px solid; border-radius: 6px; padding: .2rem .7rem; font-size: .8rem; }
.event-pane { padding: 1.25rem; overflow-wrap: anywhere; }
.event-pane > h2 { font-size: 1.1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--hogo-border); margin-bottom: 1rem; }
.pane-message { color: #806957; font-size: .9rem; line-height: 1.9; background: var(--hogo-peach-light); padding: 1rem; border-radius: 12px; }
.event-card h3 { font-size: 1.1rem; line-height: 1.7; margin-bottom: 1rem; }
.event-card small { display: block; margin-top: .5rem; color: #806957; }
.event-details { margin: 1.25rem 0; }
.event-details dt { font-size: .8rem; color: #806957; margin-top: .85rem; }
.event-details dd { margin: .15rem 0 0; padding-bottom: .65rem; border-bottom: 1px solid #f2e6dc; }
.notes { white-space: pre-wrap; }
.stamp-button { width: 64px; height: 64px; display: inline-flex; align-items: center; justify-content: center; border: 2px dashed #bca28d; border-radius: 50%; background: #fffaf5; cursor: pointer; }
.stamp-button:hover { background: var(--hogo-peach-light); }
.stamp-done { border: 3px solid #b95143; color: #b95143; font-size: 28px; font-weight: 700; }
.hogo-calendar-page a:focus-visible, .hogo-calendar-page button:focus-visible { outline: 3px solid var(--hogo-accent); outline-offset: 3px; }
.hogo-flash { border-radius: 12px; }
@media (max-width: 1100px) { .calendar-layout { grid-template-columns: 1fr; } }
@media (max-width: 575.98px) { .calendar-header { padding: 1rem; } .calendar-month-selector { gap: .5rem; } }
/* 「2026-10-11のイベント」などの見出しに出る黒枠を消す */
#pane-heading:focus,
#pane-heading:focus-visible {
    outline: none;
}
</style>
</head>

<body>
	<%@ include file="/WEB-INF/jsp/common/header.jspf"%>
	<main class="container-fluid hogo-calendar-page px-3 px-lg-4 mb-5">
    <h1 class="text-center my-5">イベント管理</h1>
    <c:if test="${not empty message}">
        <div class="alert alert-success hogo-flash" role="status"><c:out value="${message}" /></div>
    </c:if>
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
        <p class="mb-0 small">保護している子たちの予定を、カレンダーで確認できます。</p>
        <sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
            <c:url var="newEventUrl" value="/event/new" />
            <a class="btn btn-hogo" href="${fn:escapeXml(newEventUrl)}">＋ 新規登録</a>
        </sec:authorize>
    </div>

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

	<div class="calendar-layout">

					<section class="calendar-area" aria-label="月間カレンダー">
<div class="calendar-header d-flex flex-wrap align-items-center gap-3">
	    <div class="calendar-month-selector">
	
	        <%-- 前月へ --%>
	        <c:if test="${calendar.prevYear >= 1900}">
	            <a class="btn month-arrow"
	               href="${fn:escapeXml(prevUrl)}"
	               aria-label="前月へ"
	               title="前月へ">
	                ◁
	            </a>
	        </c:if>
	
	        <%-- 表示中の年月 --%>
	        <h2>${calendar.year}年${calendar.month}月</h2>
	
	        <%-- 次月へ --%>
	        <c:if test="${calendar.nextYear <= 2100}">
	            <a class="btn month-arrow"
	               href="${fn:escapeXml(nextUrl)}"
	               aria-label="次月へ"
	               title="次月へ">
	                ▷
	            </a>
	        </c:if>
	</div>
		
		  <a class="btn btn-hogo-sub"
		       href="${fn:escapeXml(currentUrl)}" title="今日が含まれる月のカレンダーを表示します">
		        今月を表示
		   </a>
		</div>
				

						<div class="calendar-scroll">
							<table class="table calendar-table">

								<caption>色付きの予定をクリックすると、イベントの概要を表示します。</caption>

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
														<div class="day-content">
														    <time class="day-number" datetime="${d.date}">
														        ${d.day}
														    </time>
														
														    <div class="day-events">
														        <c:forEach var="e" items="${d.eventList}">
														            <button type="button"
														                    class="event-bar ${e.done ? 'done' : 'pending'}"
														                    data-event-id="${e.id}"
														                    aria-controls="event-pane"
														                    aria-pressed="false"
														                    title="${fn:escapeXml(e.eventTime)} ${fn:escapeXml(e.animal.name)}：${fn:escapeXml(e.eventType.name)}">
														
														                <c:if test="${not empty e.eventTime}">
														                    <span class="event-time">
														                        <c:out value="${e.eventTime}" />
														                    </span>
														                </c:if>
														
														                <span>
														                    <c:out value="${e.animal.name}" />
														                    ：<c:out value="${e.eventType.name}" />
														                </span>
														
														                <span>（${e.done ? '済' : '未'}）</span>
														            </button>
														        </c:forEach>
														    </div>
														
														    
														</div>
														
														<template class="day-details">
														<c:choose>

															<%-- 予定がない日 --%>
															<c:when test="${empty d.eventList}">
																<p class="pane-message">この日の予定はありません。</p>
															</c:when>

															<%-- 予定がある日 --%>
															<c:otherwise>

																<p>予定： ${fn:length(d.eventList)}件</p>

																<%-- その日の予定を全部並べる --%>
																<c:forEach var="e" items="${d.eventList}">

																<article class="event-card" data-event-id="${e.id}">

																		<h3>
																			<c:out value="${e.animal.name}" />
																			：
																			<c:out value="${e.eventType.name}" />
																		</h3>

																			<%-- 管理ユーザー・常勤スタッフにはスタンプを表示 --%>
																			<sec:authorize access="hasAnyRole('ADMIN', 'STAFF')">
																			    <c:choose>
																			
																			        <c:when test="${e.done}">
																			            <c:url var="uncompleteUrl"
																			                   value="/event/${e.id}/uncomplete" />
																			
																			            <form:form id="uncomplete-${e.id}" action="${uncompleteUrl}" method="post"
																			                onsubmit="return confirm('未対応に戻しますか？');">
                            <%-- 保存後も、このイベントの概要を表示する --%>
                            <input type="hidden" name="reopenPane" value="true" />
																			
																			                <button type="submit"
																			                        class="stamp-button stamp-done"
																			                        aria-label="対応済。クリックすると未対応に戻します">
																			                    済
																			                </button>
																			            </form:form>
																			
																			            <small>クリックで未対応に戻す</small>
																			        </c:when>
																			
																			        <c:otherwise>
																			            <c:url var="completeUrl"
																			                   value="/event/${e.id}/complete" />
																			
																			            <form:form id="complete-${e.id}" action="${completeUrl}" method="post"
																			                onsubmit="return confirm('イベントを完了にしますか？個体の情報は自動では変わりません');">
                            <%-- 保存後も、このイベントの概要を表示する --%>
                            <input type="hidden" name="reopenPane" value="true" />
																			
																			                <button type="submit"
																			                        class="stamp-button"
																			                        aria-label="未対応。クリックすると対応済にします">
																			                </button>
																			            </form:form>
																			
																			            <small>未対応：クリックで対応済にする</small>
																			        </c:otherwise>
																			
																			    </c:choose>
																			</sec:authorize>
																			
																			<%-- ボランティアには文字だけ表示 --%>
																			<sec:authorize access="hasRole('VOLUNTEER')">
																			    <c:choose>
																			        <c:when test="${e.done}">対応済</c:when>
																			        <c:otherwise>未対応</c:otherwise>
																			    </c:choose>
																			</sec:authorize>

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
																					<c:out value="${e.cost}" />
																					円
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
																				<dd class="notes">
																					<c:out value="${e.notes}" />
																				</dd>
																			</c:if>

																		</dl>
																	<%-- このイベントの詳細画面へのリンク --%>	
																	<c:url var="detailUrl" value="/event/${e.id}" />

																	<p>
																	    <a class="btn btn-hogo w-100" href="${fn:escapeXml(detailUrl)}">詳細を見る</a>
																	</p>
																	
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

						<div class="calendar-legend d-flex flex-wrap gap-3">
							<span class="legend-item pending">未対応</span> <span
								class="legend-item done">対応済</span>
						</div>

					</section>

					<%-- ⑤ 選んだ日の内容を表示する場所 --%>
					<aside id="event-pane" class="event-pane"
						aria-labelledby="pane-heading">

						<h2 id="pane-heading" tabindex="-1">イベントを選択</h2>

						<p id="pane-placeholder" class="pane-message">
							カレンダーの色付きの予定を選ぶと、ここに内容が表示されます。</p>

						<div id="pane-content" hidden></div>

						<button type="button" id="pane-close" class="btn btn-hogo-sub w-100 mt-3" hidden>
							選択を解除</button>

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
	//必要なHTMLを取得する
    const eventButtons =
        document.querySelectorAll("button.event-bar");

    const paneHeading = document.getElementById("pane-heading");
    const panePlaceholder = document.getElementById("pane-placeholder");
    const paneContent = document.getElementById("pane-content");
    const closeButton = document.getElementById("pane-close");

    let selectedButton = null;

    // カラーバー1件ずつに、クリック時の処理を付ける
    for (const button of eventButtons) {
        button.addEventListener("click", function () {

            // 押したイベントのIDと、その日付のマスを取得
            const eventId = button.dataset.eventId;
            const cell = button.closest(".calendar-day");

            // その日の概要が入っているtemplateを取得
            const template = cell.querySelector(".day-details");

            // 押したイベントと同じIDの概要を探す
            const cards =
                template.content.querySelectorAll(".event-card");

            let targetCard = null;

            for (const card of cards) {
                if (card.dataset.eventId === eventId) {
                    targetCard = card;
                    break;
                }
            }

            if (targetCard === null) {
                return;
            }

            // 前に選んだイベントの選択表示を解除
            if (selectedButton !== null) {
                selectedButton.setAttribute("aria-pressed", "false");
                selectedButton.closest(".calendar-day")
                    .classList.remove("is-selected");
            }

            // 今押したイベントを選択状態にする
            selectedButton = button;
            button.setAttribute("aria-pressed", "true");
            cell.classList.add("is-selected");

            // 選んだイベントの概要だけをコピーして表示
            paneContent.replaceChildren(
                targetCard.cloneNode(true)
            );

            paneHeading.textContent =
                cell.dataset.date + "のイベント";

            panePlaceholder.hidden = true;
            paneContent.hidden = false;
            closeButton.hidden = false;

            paneHeading.focus();
        });
    }

    // 「選択を解除」を押したとき
    closeButton?.addEventListener("click", function () {

        const url = new URL(window.location.href);
        url.searchParams.delete("selectedEventId");
        window.history.replaceState(window.history.state, "", url);

        paneHeading.textContent = "イベントを選択";
        paneContent.replaceChildren();

        paneContent.hidden = true;
        closeButton.hidden = true;
        panePlaceholder.hidden = false;

        if (selectedButton !== null) {
            selectedButton.setAttribute("aria-pressed", "false");
            selectedButton.closest(".calendar-day")
                .classList.remove("is-selected");

            selectedButton.focus();
            selectedButton = null;
        }
    });

    // スタンプの保存後は、サーバーから届いた最新の内容で概要を開き直す。
    // URLの値はHTMLやCSSセレクターに埋め込まず、表示中のIDと比較する。
    const selectedEventId = new URLSearchParams(window.location.search)
        .get("selectedEventId");

    if (selectedEventId && paneContent) {
        for (const button of eventButtons) {
            if (button.dataset.eventId === selectedEventId) {
                button.click();
                break;
            }
        }
    }
</script>

</body>
</html>