package com.example.hogotaro.service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.dto.CalendarDay;
import com.example.hogotaro.dto.EventCalendar;
import com.example.hogotaro.entity.Adopter;
import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.entity.EventType;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.form.EventForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.AnimalRepository;
import com.example.hogotaro.repository.EventRepository;
import com.example.hogotaro.repository.EventTypeRepository;
import com.example.hogotaro.repository.OrganizationRepository;
import com.example.hogotaro.repository.StaffRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional
public class EventService {
	private final EventRepository eventRepository; //Springが管理しているEventRepository(の参照値)を受け取る(自分でnewしない)
	private final StaffRepository staffRepository;
	private final AnimalRepository animalRepository;
	private final EventTypeRepository eventTypeRepository;
	private final AdopterRepository adopterRepository;
	private final OrganizationRepository organizationRepository;
	
	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Event> findAll(Integer organizationId) {
		return eventRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}
	
	//イベントカレンダーの表示
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
	
	//イベントIDの取得
	public Event findbyId(Integer id, Integer organizationId) {
		
		return eventRepository
				.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() ->
						new ResponseStatusException(HttpStatus.NOT_FOUND));
	}
	
	//イベント対応済・未対応の表示
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
	
	//イベント対応済を未対応に戻す処理
	public Event uncomplete(Integer id, Integer organizationId) {

	    // 自分の団体のイベントを1件取得する
	    Event event = findbyId(id, organizationId);

	    // すでに未対応なら、そのまま返す
	    if (!Boolean.TRUE.equals(event.getDone())) {
	        return event;
	    }

	    // 未対応に戻す
	    event.setDone(false);

	    // 「完了にした人」の記録も空にする
	    event.setStaff(null);

	    // 保存したイベントを返す
	    return eventRepository.save(event);
	}
	
	// 保存済みのイベントから、現在値入りの編集フォームを作る
	public EventForm getEditForm(Integer id, Integer organizationId) {

	    Event event = findbyId(id, organizationId);
	    EventForm form = new EventForm();

	    form.setEventDate(event.getEventDate());
	    form.setEventTime(event.getEventTime());
	    form.setAnimalId(event.getAnimal().getId());
	    form.setEventTypeId(event.getEventType().getId());
	    form.setPlace(event.getPlace());
	    form.setCost(event.getCost());
	    form.setNotes(event.getNotes());

	    if (event.getAdopter() != null) {
	        form.setAdopterId(event.getAdopter().getId());
	    }

	    return form;
	}
	
	// 個体の選択肢：現在保護している個体＋このイベントの現在の個体
	public List<Animal> findAnimalList(
	        Integer organizationId, Integer currentAnimalId) {

	    List<Animal> animals = new ArrayList<>(
	            animalRepository.findByOrganizationIdAndStatusInOrderByNameAsc(
	                    organizationId, Status.inCare()));

	    if (currentAnimalId != null) {
	        Animal currentAnimal = animalRepository
	                .findByIdAndOrganizationId(currentAnimalId, organizationId)
	                .orElseThrow(() ->
	                        new ResponseStatusException(HttpStatus.NOT_FOUND));

	        boolean alreadyIncluded = false;

	        for (Animal animal : animals) {
	            if (animal.getId().equals(currentAnimalId)) {
	                alreadyIncluded = true;
	                break;
	            }
	        }

	        if (!alreadyIncluded) {
	            animals.add(currentAnimal);
	        }
	    }

	    return animals;
	}

	// イベント種別の選択肢
	public List<EventType> findEventTypeList() {
	    return eventTypeRepository.findAllByOrderById();
	}

	// 自分の団体の里親の選択肢
	public List<Adopter> findAdopterList(Integer organizationId) {
	    return adopterRepository
	            .findByOrganizationIdOrderByNameAsc(organizationId);
	}
	
	// 入力内容を確認して、イベントを更新する
	public void update(
	        Integer id,
	        EventForm form,
	        BindingResult result,
	        Integer organizationId) {

	    Event event = findbyId(id, organizationId);

	    // 必須項目や文字数などのエラーがあれば更新しない
	    if (result.hasErrors()) {
	        return;
	    }

	    // 選択された個体が、自分の団体に存在するか確認
	    Animal animal = animalRepository
	            .findByIdAndOrganizationId(form.getAnimalId(), organizationId)
	            .orElse(null);

	    if (animal == null) {
	        result.rejectValue(
	                "animalId", "invalid", "個体の指定が不正です");
	    } else if (!Status.inCare().contains(animal.getStatus())
	            && !animal.getId().equals(event.getAnimal().getId())) {
	        result.rejectValue(
	                "animalId", "invalid", "選択できない個体です");
	    }

	    // 選択されたイベント種別が存在するか確認
	    EventType eventType = eventTypeRepository
	            .findById(form.getEventTypeId())
	            .orElse(null);

	    if (eventType == null) {
	        result.rejectValue(
	                "eventTypeId", "invalid", "種別の指定が不正です");
	    }

	    // 里親が選択されていれば、自分の団体に存在するか確認
	    Adopter adopter = null;

	    if (form.getAdopterId() != null) {
	        adopter = adopterRepository
	                .findByIdAndOrganizationId(
	                        form.getAdopterId(), organizationId)
	                .orElse(null);

	        if (adopter == null) {
	            result.rejectValue(
	                    "adopterId", "invalid", "里親の指定が不正です");
	        }
	    }

	    // トライアル開始・譲渡では里親が必須
	    if (eventType != null) {
	        String code = eventType.getCode();

	        if (("TRIAL_START".equals(code) || "ADOPTION".equals(code))
	                && form.getAdopterId() == null) {
	            result.rejectValue(
	                    "adopterId", "required",
	                    "トライアル開始・譲渡の場合は里親を選択してください");
	        }

	        // 猫には狂犬病ワクチンのイベントを登録できない
	        if (animal != null
	                && animal.getSpecies() == Species.CAT
	                && "RABIES_VACCINE".equals(code)) {
	            result.rejectValue(
	                    "eventTypeId", "invalid",
	                    "猫には狂犬病ワクチンを登録できません");
	        }
	    }

	    // 追加のチェックに引っかかった場合も更新しない
	    if (result.hasErrors()) {
	        return;
	    }

	    // 全チェックを通ってから、保存済みのイベントを書き換える
	    event.setEventDate(form.getEventDate());
	    event.setEventTime(form.getEventTime());
	    event.setAnimal(animal);
	    event.setEventType(eventType);
	    event.setAdopter(adopter);
	    event.setPlace(emptyToNull(form.getPlace()));
	    event.setCost(form.getCost());
	    event.setNotes(emptyToNull(form.getNotes()));

	    eventRepository.save(event);
	}

	// 任意の文字列が空欄なら、DBにはnullで保存する
	private String emptyToNull(String value) {
	    return value == null || value.isBlank() ? null : value;
	}
	
	// イベントを削除する
	public LocalDate delete(Integer id, Integer organizationId) {

	    // 自分の団体のイベントを取得する
	    Event event = findbyId(id, organizationId);

	    // 削除後、その月のカレンダーへ戻るために日付を控える
	    LocalDate eventDate = event.getEventDate();

	    // データベースから削除する
	    eventRepository.delete(event);

	    return eventDate;
	}
	
	// 入力内容を確認して、新しいイベントを保存する
	public Event create(
	        EventForm form,
	        BindingResult result,
	        Integer organizationId) {

	    // 必須項目・文字数などに問題があれば保存しない
	    if (result.hasErrors()) {
	        return null;
	    }

	    // 個体が自分の団体に存在するか確認
	    Animal animal = animalRepository
	            .findByIdAndOrganizationId(
	                    form.getAnimalId(), organizationId)
	            .orElse(null);

	    if (animal == null) {
	        result.rejectValue(
	                "animalId", "invalid", "個体の指定が不正です");
	    } else if (!Status.inCare().contains(animal.getStatus())) {
	        result.rejectValue(
	                "animalId", "invalid", "選択できない個体です");
	    }

	    // イベント種別が存在するか確認
	    EventType eventType = eventTypeRepository
	            .findById(form.getEventTypeId())
	            .orElse(null);

	    if (eventType == null) {
	        result.rejectValue(
	                "eventTypeId", "invalid", "種別の指定が不正です");
	    }

	    // 里親が選ばれていれば、自分の団体に存在するか確認
	    Adopter adopter = null;

	    if (form.getAdopterId() != null) {
	        adopter = adopterRepository
	                .findByIdAndOrganizationId(
	                        form.getAdopterId(), organizationId)
	                .orElse(null);

	        if (adopter == null) {
	            result.rejectValue(
	                    "adopterId", "invalid", "里親の指定が不正です");
	        }
	    }

	    // イベント種別に応じた入力チェック
	    if (eventType != null) {
	        String code = eventType.getCode();

	        if (("TRIAL_START".equals(code) || "ADOPTION".equals(code))
	                && form.getAdopterId() == null) {

	            result.rejectValue(
	                    "adopterId", "required",
	                    "トライアル開始・譲渡の場合は里親を選択してください");
	        }

	        if (animal != null
	                && animal.getSpecies() == Species.CAT
	                && "RABIES_VACCINE".equals(code)) {

	            result.rejectValue(
	                    "eventTypeId", "invalid",
	                    "猫には狂犬病ワクチンを登録できません");
	        }
	    }

	    // チェックで問題が見つかったら、ここで終了
	    if (result.hasErrors()) {
	        return null;
	    }

	    // 新しいイベントに入力内容を移す
	    Event event = new Event();

	    event.setEventDate(form.getEventDate());
	    event.setEventTime(form.getEventTime());
	    event.setAnimal(animal);
	    event.setEventType(eventType);
	    event.setAdopter(adopter);
	    event.setPlace(emptyToNull(form.getPlace()));
	    event.setCost(form.getCost());
	    event.setNotes(emptyToNull(form.getNotes()));

	    // 新規登録時は「未対応」
	    event.setDone(false);
	    event.setStaff(null);

	    // ログインしている人の団体を設定する
	    event.setOrganization(
	            organizationRepository.getReferenceById(organizationId));

	    return eventRepository.save(event);
	}
	
}
