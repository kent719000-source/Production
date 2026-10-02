package com.example.hogotaro.service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Organization;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.repository.AnimalRepository;
import com.example.hogotaro.repository.OrganizationRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TopService {
	private final AnimalRepository animalRepository;
	private final OrganizationRepository organizationRepository;
	
	// 指定した月のカレンダーを「週のリスト（1週 = 日〜土の7日）」で返す
		public List<List<LocalDate>> buildCalendar(YearMonth ym) {
			LocalDate first = ym.atDay(1); // 月の1日(2026-09-01)
			LocalDate last = ym.atEndOfMonth(); // 月末(2026-9-30)

			int offset = first.getDayOfWeek().getValue() % 7; //0 1日の曜日。日曜=0, 月曜=1 … 土曜=6(2026-09-01は火曜日で2)
			LocalDate date = first.minusDays(offset); // 表の左上（1日の前の日曜）から始める(2026-09-01のある週の日曜日の日、つまり2026-08-30)

			List<List<LocalDate>> weeks = new ArrayList<>();	//LocalDateの集まりのリストのList<LocalDate>、それのあつまりのList<List<LocalDate>>型のweeksを宣言(中はまだ空っぽ)

			//上のリストに詰めていく
			while (!date.isAfter(last)) { 					// 月末を過ぎた週まで詰めたら終わり
				List<LocalDate> week = new ArrayList<>();	//List<LocalDate>型のweekを宣言(中はまだ空っぽ)
				for (int i = 0; i < 7; i++) {				//以下の処理を7回する
					week.add(date);							//weekにdate(初期値2026-08-30)を追加
					date = date.plusDays(1);				//dateの中身を次の日(2026-08-31)にする
				}
				weeks.add(week);							//出来上がったweekをweeksに追加(当月を過ぎたらwhileのループを終了)
			}
			return weeks;
		}
		
		public Long countInCare(Integer organizationId){
			Collection<Status> statuses = Status.inCare();
			return animalRepository.countByOrganizationIdAndStatusIn(organizationId, statuses);
		}
		
		public Organization findOrganization(Integer id) {
			return organizationRepository.findById(id)
					.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));   // 無ければ 404。Spring Boot が error.jsp を出す
		}

}
