package com.example.hogotaro.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.entity.UserType;
import com.example.hogotaro.form.StaffForm;
import com.example.hogotaro.repository.StaffRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class StaffService {
	private final StaffRepository staffRepository; //Springが管理しているStaffRepository(の参照値)を受け取る(自分でnewしない)

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Staff> findAll(Integer organizationId) {
		return staffRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}
	
	public Staff find(Integer id,Integer organizationId) {
		return staffRepository.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));   // 無ければ 404。Spring Boot が error.jsp を出す
	}

	public List<UserType> findUserTypes() {
		// TODO 自動生成されたメソッド・スタブ
		return null;
	}

	public StaffForm toForm(Staff staff) {
		StaffForm form = new StaffForm();
        form.setUserTypeId(staff.getUserType().getId());   // プルダウンは id で選ぶので、UserType から id を取り出して入れる
        form.setName(staff.getName());
        form.setGender(staff.getGender());
        form.setBirthday(staff.getBirthday());
        form.setJoinedDate(staff.getJoinedDate());
        form.setAddress(staff.getAddress());
        form.setPhoneNumber(staff.getPhoneNumber());
        form.setEmail(staff.getEmail());
        form.setNotes(staff.getNotes());
        return form;
	}

	public Staff create(Integer organizationId, StaffForm form, BindingResult result) {
		
		return null;
	}

}
