package com.example.hogotaro.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Adopter;
import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.form.AdopterForm;
import com.example.hogotaro.form.AdopterSearchForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.AnimalRepository;
import com.example.hogotaro.repository.EventRepository;
import com.example.hogotaro.repository.OrganizationRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class AdopterService {
	private final AdopterRepository adopterRepository; //Springが管理しているAdopterRepository(の参照値)を受け取る(自分でnewしない)
	private final OrganizationRepository organizationRepository; // 団体を設定するために使う
	private final AnimalRepository animalRepository; // 個体状況を里親詳細と紐づき確認するために使う
	private final EventRepository eventRepository; // イベントを里親詳細と紐づき確認するために使う

	
	// 一覧の検索（F-20）。未入力は空文字にし、電話番号はハイフンを取ってから Repository に渡す
	public List<Adopter> search(Integer organizationId, AdopterSearchForm form){
		String name = form.getName() == null ? "" :form.getName().trim();
		String phone = form.getPhoneNumber() == null ? "" :form.getPhoneNumber().replace("-","").trim();
		return adopterRepository.search(organizationId, name, phone);
	}
	
	// 里親を登録する（F-23）。団体はフォームからではなく、ログイン中の人の団体IDから設定する
	public Integer create(AdopterForm form, Integer organizationId) {
		Adopter adopter = new Adopter();
		adopter.setName(form.getName());
		adopter.setGender(form.getGender());
		adopter.setBirthday(form.getBirthday());
		adopter.setAddress(blankToNull(form.getAddress()));
		adopter.setPhoneNumber(form.getPhoneNumber());
		adopter.setEmail(blankToNull(form.getEmail()));
		adopter.setNotes(blankToNull(form.getNotes()));
		adopter.setOrganization(organizationRepository.getReferenceById(organizationId));
		adopterRepository.save(adopter); // 保存すると、DBが決めた id が adopter に入る
		return adopter.getId();
	}
	
	// 空文字（未入力なら） null にする
	private String blankToNull(String s) {
		return (s == null || s.isBlank()) ? null : s;
	}
	
	//里親IDと団体IDで絞って取得する（F-21）
	public Adopter detail(Integer id,Integer organizationId) {
		return adopterRepository.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() ->
				new ResponseStatusException(HttpStatus.NOT_FOUND));
	}
	
	// この里親のうち、トライアル中・譲渡済みのもの（F-21）
	public List<Animal> findAnimalList(Integer id, Integer organizationId){
		return animalRepository.findByOrganizationIdAndAdopterIdAndStatusInOrderByStatusDesc(organizationId, id, List.of(Status.TRIAL, Status.ADOPTED));
	}
	
	// この里親のイベントを日付の新しい順で（F-21）
	public List<Event> findEventList(Integer id, Integer organizationId){
		return eventRepository.findByOrganizationIdAndAdopterIdOrderByEventDateDescEventTimeDesc(organizationId,id);
	}
	
	// 編集画面用に、今の値をAdopterFormに詰める（F-24）
	public AdopterForm getEditForm(Integer id, Integer organizationId){
		Adopter adopter = detail(id, organizationId); // 他団体の里親ならここで404
		AdopterForm form = new AdopterForm();
		form.setName(adopter.getName());
		form.setGender(adopter.getGender());
		form.setBirthday(adopter.getBirthday());
		form.setAddress(adopter.getAddress());
		form.setPhoneNumber(adopter.getPhoneNumber());
		form.setEmail(adopter.getEmail());
		form.setNotes(adopter.getNotes());
		return form;
	}
	// 里親を更新する（F-25）。団体ID付きで取り直し、フォームの値で上書きして保存する
	public void update(Integer id, AdopterForm form, Integer organizationId) {
		Adopter adopter = detail(id, organizationId); // 他団体の里親なら、ここで404
		adopter.setName(form.getName());
		adopter.setGender(form.getGender());
		adopter.setBirthday(form.getBirthday());
		adopter.setAddress(blankToNull(form.getAddress()));
		adopter.setPhoneNumber(form.getPhoneNumber());
		adopter.setEmail(blankToNull(form.getEmail()));
		adopter.setNotes(blankToNull(form.getNotes()));
		adopterRepository.save(adopter);
	}
	//里親の情報を削除（F-26）
	public boolean delete(Integer id,Integer organizationId) {
		Adopter adopter = detail(id, organizationId);
		if (animalRepository.existsByOrganizationIdAndAdopterId(organizationId, id)
				|| eventRepository.existsByOrganizationIdAndAdopterId(organizationId, id)) {
			return false; //個体かイベントに紐づいているので消さない
		}
		adopterRepository.delete(adopter);
		return true;
	}
}
