package com.example.hogotaro.service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.dto.CalendarDay;
import com.example.hogotaro.dto.EventCalendar;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.repository.EventRepository;
import com.example.hogotaro.repository.StaffRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional
public class EventService {
	private final EventRepository eventRepository; //Springが管理しているEventRepository(の参照値)を受け取る(自分でnewしない)
	private final StaffRepository staffRepository;
	
	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Event> findAll(Integer organizationId) {
		return eventRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}
	
	public EventCalendar search(
	        Integer organizationId,
	        Integer year,
	        Integer month) {

	    // 1. 日本時間の「今月」を取得
	    YearMonth targetMonth =
	            YearMonth.now(ZoneId.of("Asia/Tokyo"));

	    // 2. 正しい年月が指定されていれば、その月に変更
	    // 学習用に、表示できる年を1900〜2100年に限定
	    if (year != null && month != null
	            && year >= 1900 && year <= 2100
	            && month >= 1 && month <= 12) {

	        targetMonth = YearMonth.of(year, month);
	    }

	    // 3. その月の1日と末日
	    LocalDate firstDate = targetMonth.atDay(1);
	    LocalDate lastDate = targetMonth.atEndOfMonth();

	    // 4. カレンダーの最初の日曜日
	    int firstOffset = firstDate.getDayOfWeek().getValue() % 7;
	    LocalDate startDate = firstDate.minusDays(firstOffset);

	    // 5. カレンダーの最後の土曜日
	    int lastOffset = lastDate.getDayOfWeek().getValue() % 7;
	    LocalDate endDate = lastDate.plusDays(6 - lastOffset);

	    // 6. 表示する期間のイベントをまとめて取得
	    List<Event> events = eventRepository
	            .findByOrganizationIdAndEventDateBetweenOrderByEventDateAscEventTimeAsc(
	                    organizationId, startDate, endDate);

	    // 7. カレンダー全体の箱を作る
	    EventCalendar calendar = new EventCalendar();

	    calendar.setYear(targetMonth.getYear());
	    calendar.setMonth(targetMonth.getMonthValue());

	    YearMonth prevMonth = targetMonth.minusMonths(1);
	    YearMonth nextMonth = targetMonth.plusMonths(1);

	    calendar.setPrevYear(prevMonth.getYear());
	    calendar.setPrevMonth(prevMonth.getMonthValue());

	    calendar.setNextYear(nextMonth.getYear());
	    calendar.setNextMonth(nextMonth.getMonthValue());

	    // 8. 最初の日から、1週間ずつ作る
	    LocalDate date = startDate;

	    while (!date.isAfter(endDate)) {

	        List<CalendarDay> week = new ArrayList<>();

	        // 1週間は7日
	        for (int i = 0; i < 7; i++) {

	            boolean inMonth =
	                    YearMonth.from(date).equals(targetMonth);

	            CalendarDay day = new CalendarDay(date, inMonth);

	            // この日と同じ日付のイベントを入れる
	            for (Event event : events) {

	                if (date.equals(event.getEventDate())) {
	                    day.getEventList().add(event);
	                }
	            }

	            // 作った1日を、1週間の箱に入れる
	            week.add(day);

	            // 翌日へ進む
	            date = date.plusDays(1);
	        }

	        // 作った1週間を、カレンダー全体に入れる
	        calendar.getWeeks().add(week);
	    }

	    return calendar;
	}
	
	public Event findbyId(Integer id, Integer organizationId) {
		
		return eventRepository
				.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() ->
						new ResponseStatusException(HttpStatus.NOT_FOUND));
	}
	
	public Event complete(
	        Integer id,
	        Integer organizationId,
	        Integer staffId) {

	    // 1. 変更する予定を取り出す
	    Event event = findbyId(id, organizationId);

	    // 2. すでに対応済なら、そのまま返して終了
	    if (Boolean.TRUE.equals(event.getDone())) {
	        return event;
	    }

	    // 3. 操作したスタッフを取り出す
	    Staff staff = staffRepository
	            .findByIdAndOrganizationId(staffId, organizationId)
	            .orElseThrow(() ->
	                    new ResponseStatusException(HttpStatus.NOT_FOUND));

	    // 4. 予定に「対応済」と書き込む
	    event.setDone(true);

	    // 5. 予定に「対応した人」を書き込む
	    event.setStaff(staff);

	    // 6. 変更した予定を保存して、呼び出し元へ返す
	    return eventRepository.save(event);
	}
}
