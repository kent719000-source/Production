<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<%@ include file="/WEB-INF/jsp/common/head.jspf" %>
<title>ホゴタロウ</title>
<style>
  /* この画面だけのスタイル。共通のスタイルは hogotarou.css（head.jspf が読み込む） */
  /* カレンダーの7列を同じ幅にする（無いと、文字の多い日の列だけ広がる） */
  .mini-cal {
    table-layout: fixed;
  }
  /* 前月・次月のはみ出したマスは文字を薄くする */
  .mini-cal .other {
    color: #c8b3a3;
  }
  /* マスの中のイベント。小さめの文字で1件ずつ。左に色の線を付けた小さな帯にする */
  .mini-cal .event-link {
    display: block;
    font-size: 0.8rem;
    line-height: 1.4;
    border-left: 3px solid;
    border-radius: 6px;
    padding: 2px 6px;
    margin-top: 4px;
  }
  /* 対応状況の色。イベント管理のカレンダー（event/calendar.jsp の .pending / .done）と同じ色にそろえる。
     色が見分けにくい人もいるので、色だけでなく（未）（済）の文字も出す */
  .mini-cal .event-link.pending {
    border-color: #ca8b3a;        /* 未対応：オレンジ */
    background-color: #fff0d5;
    color: #75501f;
  }
  .mini-cal .event-link.done {
    border-color: #6c9470;        /* 対応済：緑 */
    background-color: #e4f1e3;
    color: #355c3c;
  }
  /* イベントが多い日は、マスの中だけスクロールさせる（イベント管理のカレンダーの .day-events.is-scrollable と同じ考え方）。
     トップはマスが狭く1件が2〜3行に折り返すので、3件以上・高さ 9rem で区切る */
  .mini-cal .mini-events.is-scrollable {
    max-height: 9rem;
    overflow-y: scroll;
    padding-right: 4px;
    scrollbar-width: thin;
  }
  /* 保護頭数カード*/
  /* 空きの状態ごとの色。 is-ok / is-few / is-full のクラスで切り替える*/
  .hogo-capacity {--status-color: #3f8f5a;} /*受け入れOK：緑*/
  .hogo-capacity.is-few {--status-color: #b87400;} /*残りわずか：黄*/
  .hogo-capacity.is-full {--status-color: #c0392b;}/*満員：赤*/
  
  /* ステータスの大きな箱*/
  .hogo-status{
  	background-color: var(--status-color);
  	color: #ffffff;
  	border-radius: 14px;
  	padding: 1.5rem 1rem;
  	text-align: center;
  	/* hogotarou.css の .hogo-status（済・未の小さなバッジ）と名前が同じなので、バッジ用の指定を打ち消す */
  	display: block;
  	font-size: 1rem;
  	font-weight: 400;
  }
  /*白い丸の中にステータスアイコン*/
  .hogo-status-icon{
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 3.2rem;
	height: 3.2rem;
	border-radius: 50%;
	background-color: #ffffff;
	color: var(--status-color);
	font-size: 1.8rem;
	font-weight: 700;
	line-height: 1;
  }
  /*受け入れステータス*/
  .hogo-status-text{
  	font-size: 2.2rem;
  	font-weight: 700;
  	line-height: 1.3;
  	margin-top: 0.5rem;
  }
  /*空き頭数*/
  .hogo-status-free{
  	display: inline-block;
  	margin-top: 0.75rem;
  	padding: 0.2rem 1.2rem;
  	border-radius: 999px;
  	background-color: rgba(255,255,255,0.22);
  	font-size: 1.1rem;
  	font-weight: 500;
  }
  .hogo-status-free strong{
  	font-size: 2rem;
  	margin: 0 0.15em;
  }
  /*保護中/定員*/
  .hogo-incare{
  	text-align: center;
  	margin-top: 1.5rem;
  }
  .hogo-incare-label{
  	color: var(--hogo-brown);
  	font-size: 0.95rem;
  	font-weight: 700;
  }
  .hogo-incare-num{
  	color: var(--hogo-brown);
  	font-weight: 700;
  	line-height: 1.2;
  }
  .hogo-incare-num .now{ /*今の頭数は大きく強調*/
  	color: var(--hogo-accent);
  	font-size: 3.2rem;
  }
  .hogo-incare-num .cap{
  	font-size: 1.8rem;
  }
  .hogo-incare-num small{
  	font-size: 1rem;
  	font-weight: 500;
  	margin-left: 0.15em;
  }
  
  /*使用状況のバー*/
  .hogo-meter{
  	--bs-progress-height: 14px;
  	--bs-progress-bg: #f3e6da;
  	--bs-progress-border-radius: 999px;
  	--bs-progress-bar-bg: var(--status-color);
  	
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/jsp/common/header.jspf" %>

<h1 class="text-center my-5">トップページ</h1>
<div class="container mb-5">

  <%-- 管理画面へのリンク。ボタンを横に並べる（狭い画面では折り返す） --%>
  <div class="d-flex flex-wrap justify-content-center gap-2 mb-4">
    <a href="/animal" class="btn btn-hogo">個体管理へ</a>
    <a href="/event" class="btn btn-hogo">イベント管理へ</a>
    <a href="/adopter" class="btn btn-hogo">里親管理へ</a>
    <a href="/staff" class="btn btn-hogo">スタッフ管理へ</a>
  </div>

  <%-- 2列レイアウト。PC(lg以上)では左4：右8、スマホでは縦1列 --%>
  <div class="row g-4">

    <%-- ===== 左の列：保護頭数 ===== --%>
    <%-- 表示用の変数を先に作っておく --%>
    <c:set var="capacity" value="${organization.capacity}" />
    <c:set var="vacancy"  value="${capacity - inCare}" />
    <%-- 使用率（%）。定員が0のときは0で割らないようにする --%>
    <c:set var="usageRate" value="${capacity > 0 ? inCare * 100 / capacity : 0}" />
    <%-- 空きの状態：満員（赤）／残りわずか（黄）／受け入れOK（緑） --%>
    <c:choose>
      <c:when test="${vacancy <= 0}">
        <c:set var="capStatus" value="full" /><c:set var="capLabel" value="満員" /><c:set var="capIcon" value="✕" />
      </c:when>
      <c:when test="${usageRate >= 80}">
        <c:set var="capStatus" value="few" /><c:set var="capLabel" value="残りわずか" /><c:set var="capIcon" value="!" />
      </c:when>
      <c:otherwise>
        <c:set var="capStatus" value="ok" /><c:set var="capLabel" value="受け入れOK" /><c:set var="capIcon" value="✓" />
      </c:otherwise>
    </c:choose>

    <div class="col-lg-4">
      <%-- is-ok / is-few / is-full で色が切り替わる（上の <style>） --%>
      <section class="hogo-card hogo-capacity is-${capStatus}">
        <h2 class="hogo-card-head h6 m-0">保護頭数</h2>
        <div class="hogo-card-body">

          <%-- ステータス（一番目立たせる） --%>
          <div class="hogo-status">
            <div class="hogo-status-icon" aria-hidden="true">${capIcon}</div>
            <div class="hogo-status-text">${capLabel}</div>
            <%-- 定員オーバーでもマイナスは出さず0にする --%>
            <div class="hogo-status-free">空き<strong>${vacancy < 0 ? 0 : vacancy}</strong>頭</div>
          </div>

          <%-- 保護中 / 定員 --%>
          <div class="hogo-incare">
            <div class="hogo-incare-label">保護中 / 定員</div>
            <div class="hogo-incare-num">
              <span class="now">${inCare}</span><span class="cap"> / ${capacity}</span><small>頭</small>
            </div>
          </div>

          <%-- 使用状況のバー（Bootstrapの progress） --%>
          <div class="mt-2">
            <div class="progress hogo-meter" role="progressbar" aria-label="保護頭数の使用状況"
                 aria-valuenow="${inCare}" aria-valuemin="0" aria-valuemax="${capacity}">
              <%-- 100%を超えてもバーがはみ出さないよう100で止める --%>
              <div class="progress-bar" style="width: ${usageRate > 100 ? 100 : usageRate}%"></div>
            </div>
            <div class="text-end small mt-1">
              <fmt:formatNumber value="${usageRate}" maxFractionDigits="0" />% 使用中
            </div>
          </div>

        </div>
      </section>
    </div>

    <%-- ===== 右の列：カレンダー ===== --%>
    <div class="col-lg-8">
      <section class="hogo-card">
        <h2 class="hogo-card-head h6 m-0">カレンダー（${calendar.year}年${calendar.month}月）</h2>
        <div class="hogo-card-body">
          <%-- table-bordered：各セルに境界線 / align-middle：上下中央ぞろえ / mini-cal：7列を同じ幅に（上の <style>） --%>
          <table class="table table-bordered align-middle mb-0 mini-cal">
            <thead class="table-peach"><%-- 曜日の行（ヘッダーと同じピーチ色） --%>
              <tr>
                <th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${calendar.weeks}" var="week">
                <tr>
                  <c:forEach items="${week}" var="d">
                    <%-- 前月・次月のはみ出したマスには other を付ける（上の <style> で薄くする） --%>
                    <td class="${d.inMonth ? '' : 'other'}">
                      ${d.day}
                      <%-- その日のイベント。「個体名 種別（未/済）」で、時刻は出さない（10/1 の決定）。
                           色は対応状況で変える（未対応＝pending、対応済＝done。上の <style>）。
                           押すと、イベント管理のカレンダーで、このイベントを選んだ状態で開く。
                           selectedEventId はカレンダー側（event/calendar.jsp）の JS が読む名前なので、変えるときはイベント担当とそろえる。
                           はみ出したマスはその月へ飛ぶように d.date の年・月を使う --%>
                      <div class="mini-events ${fn:length(d.eventList) >= 3 ? 'is-scrollable' : ''}">
                      <c:forEach items="${d.eventList}" var="e">
                        <a href="/event?year=${d.date.year}&month=${d.date.monthValue}&selectedEventId=${e.id}"
                           class="event-link ${e.done ? 'done' : 'pending'}">
                          <c:out value="${e.animal.name}" />
                          <c:out value="${e.eventType.name}" />
                          （${e.done ? '済' : '未'}）
                        </a>
                      </c:forEach>
                      </div>
                    </td>
                  </c:forEach>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </section>
    </div>

  </div>
</div>
</body>
</html>
