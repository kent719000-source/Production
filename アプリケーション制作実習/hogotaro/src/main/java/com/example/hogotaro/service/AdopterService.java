package com.example.hogotaro.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.hogotaro.entity.Adopter;
import com.example.hogotaro.form.AdopterForm;
import com.example.hogotaro.form.AdopterSearchForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.OrganizationRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class AdopterService {
	private final AdopterRepository adopterRepository; //Springが管理しているAdopterRepository(の参照値)を受け取る(自分でnewしない)
	private final OrganizationRepository organizationRepository; // 団体を設定するために使う

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Adopter> findAll(Integer organizationId) {
		return adopterRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}
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
}
