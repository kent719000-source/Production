package com.example.hogotaro.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.hogotaro.entity.Event;
import com.example.hogotaro.repository.EventRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class EventService {
	private final EventRepository eventRepository; //Springが管理しているEventRepository(の参照値)を受け取る(自分でnewしない)

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Event> findAll(Integer organizationId) {
		return eventRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}

}
