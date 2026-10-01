package com.example.hogotaro.dto;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.example.hogotaro.entity.Event;

import lombok.Getter;

@Getter
public class CalendarDay {
	
	// このマスの日付
	private final LocalDate date;
	
	// 表示中の月の日ならtrue 
	private final boolean inMonth;
	
	// この日のイベント一覧
	private final List<Event> eventList = new ArrayList<>();
	
	public CalendarDay(LocalDate date, boolean inMonth) {
		this.date = date;
		this.inMonth = inMonth;
	}
	
	// 2026-09-30から「30」だけを取り出す
	public int getDay() {
		return date.getDayOfMonth();
	}
	
	private int a = 1;
}
