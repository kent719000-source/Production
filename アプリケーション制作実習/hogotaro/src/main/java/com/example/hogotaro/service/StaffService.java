package com.example.hogotaro.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.entity.UserType;
import com.example.hogotaro.form.StaffForm;
import com.example.hogotaro.repository.OrganizationRepository;
import com.example.hogotaro.repository.StaffRepository;
import com.example.hogotaro.repository.UserTypeRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class StaffService {
	private final StaffRepository staffRepository; //Springが管理しているStaffRepository(の参照値)を受け取る(自分でnewしない)
	private final UserTypeRepository userTypeRepository; // ユーザー種別のプルダウンと、選んだ種別を入れるのに使う
	private final OrganizationRepository organizationRepository; // 団体を設定するために使う
	private final PasswordEncoder passwordEncoder; // SecurityConfig の @Bean（BCrypt）が入る。ログインの照合と同じものでハッシュにする

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Staff> findAll(Integer organizationId) {
		return staffRepository.findByOrganizationIdOrderByIdDesc(organizationId);
		

	}
	
	public Staff find(Integer id,Integer organizationId) {
		return staffRepository.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));   // 無ければ 404。Spring Boot が error.jsp を出す
	}

	public List<UserType> findUserTypes() {
		return userTypeRepository.findAllByOrderById();
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

	// F-30 新規登録。保存した id を返す（今の create(Integer, StaffForm, BindingResult) と置き換え）
	public Integer create(StaffForm form, Integer organizationId) {
		Staff staff = new Staff();
		staff.setOrganization(organizationRepository.getReferenceById(organizationId)); // 団体は画面から受け取らず、ログイン中の人の団体
		staff.setLoginId(form.getLoginId());
		staff.setPasswordHash(passwordEncoder.encode(form.getPassword())); // 平文は保存しない。BCrypt のハッシュにしてから入れる
		staff.setUserType(userTypeRepository.getReferenceById(form.getUserTypeId())); // プルダウンは id で届くので、id から UserType にする
		staff.setName(form.getName());
		staff.setGender(form.getGender());
		staff.setBirthday(form.getBirthday());
		staff.setJoinedDate(form.getJoinedDate());
		staff.setAddress(form.getAddress());
		staff.setPhoneNumber(form.getPhoneNumber());
		staff.setEmail(form.getEmail());
		staff.setNotes(form.getNotes());
		staffRepository.save(staff); // 保存すると、DB が決めた id が staff に入る
		return staff.getId();
	}

	// F-32 編集。ログインIDは変えない
	public void update(Integer id, StaffForm form, Integer organizationId) {
		Staff staff = find(id, organizationId); // 他団体・無い id なら 404
		if (form.getPassword() != null && !form.getPassword().isEmpty()) {
			staff.setPasswordHash(passwordEncoder.encode(form.getPassword())); // 空なら今のパスワードのまま
		}
		staff.setUserType(userTypeRepository.getReferenceById(form.getUserTypeId()));
		staff.setName(form.getName());
		staff.setGender(form.getGender());
		staff.setBirthday(form.getBirthday());
		staff.setJoinedDate(form.getJoinedDate());
		staff.setAddress(form.getAddress());
		staff.setPhoneNumber(form.getPhoneNumber());
		staff.setEmail(form.getEmail());
		staff.setNotes(form.getNotes());
		staffRepository.save(staff);
	}

}
