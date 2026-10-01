package com.example.hogotaro.dto;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EventCalendar {
	private int year;
	private int month;
	
	private int prevYear;
	private int prevMonth;
	
	private int nextYear;
	private int nextMonth;
	
	private List<List<CalendarDay>> weeks = new ArrayList<>(); 
}
