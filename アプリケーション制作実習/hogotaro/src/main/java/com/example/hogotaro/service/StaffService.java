package com.example.hogotaro.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Event;
import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.entity.UserType;
import com.example.hogotaro.form.StaffForm;
import com.example.hogotaro.form.StaffSearchForm;
import com.example.hogotaro.repository.EventRepository;
import com.example.hogotaro.repository.OrganizationRepository;
import com.example.hogotaro.repository.StaffRepository;
import com.example.hogotaro.repository.UserTypeRepository;

import lombok.RequiredArgsConstructor;

@Service // アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor // finalフィールドを受け取るコンストラクタをLombokが生成する
@Transactional // このクラスのDB処理を1トランザクションで扱う
public class StaffService {

    private final StaffRepository staffRepository;
    private final UserTypeRepository userTypeRepository;
    private final OrganizationRepository organizationRepository;
    private final PasswordEncoder passwordEncoder;
    private final EventRepository eventRepository;

    // 団体IDで絞ってスタッフを取得する
    public List<Staff> findAll(Integer organizationId) {
        return staffRepository.findByOrganizationIdOrderByIdDesc(organizationId);
    }

    // スタッフ一覧検索。名前・電話番号とも部分一致、電話番号はハイフン無視
    public List<Staff> search(Integer organizationId, StaffSearchForm form) {
        String name = form.getName() == null ? "" : form.getName().trim();
        String phone = form.getPhoneNumber() == null
                ? ""
                : form.getPhoneNumber().replace("-", "").trim();

        return staffRepository.search(organizationId, name, phone);
    }

    // スタッフ1件取得。団体IDも条件に含める
    public Staff find(Integer id, Integer organizationId) {
        return staffRepository.findByIdAndOrganizationId(id, organizationId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    }

    // スタッフ詳細に出す、このスタッフが完了にしたイベント
    public List<Event> findEventList(Integer id, Integer organizationId) {
        return eventRepository
                .findByOrganizationIdAndStaffIdOrderByEventDateDescEventTimeDesc(
                        organizationId,
                        id);
    }

    public List<UserType> findUserTypes() {
        return userTypeRepository.findAllByOrderById();
    }

    // Entity → 編集Form
    public StaffForm toForm(Staff staff) {
        StaffForm form = new StaffForm();
        form.setUserTypeId(staff.getUserType().getId());
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

    // F-30 新規登録
    public Integer create(
            StaffForm form,
            BindingResult result,
            Integer organizationId) {

        String loginId = form.getLoginId();

        // ログインIDは新規登録時必須
        if (loginId == null || loginId.isBlank()) {
            result.rejectValue(
                    "loginId",
                    "required",
                    "ログインIDを入力してください");
        }
        // ログインIDは全団体で一意
        else if (staffRepository.existsByLoginId(loginId)) {
            result.rejectValue(
                    "loginId",
                    "duplicate",
                    "既に登録済みのログインIDです");
        }

        // パスワードは新規登録時必須
        if (form.getPassword() == null || form.getPassword().isBlank()) {
            result.rejectValue(
                    "password",
                    "required",
                    "パスワードを入力してください");
        }

        // ユーザー種別の存在確認
        UserType userType = null;
        if (form.getUserTypeId() != null) {
            userType = userTypeRepository.findById(form.getUserTypeId()).orElse(null);
            if (userType == null) {
                result.rejectValue(
                        "userTypeId",
                        "invalid",
                        "ユーザー種別の指定が不正です");
            }
        }

        // エラーがあれば保存しない
        if (result.hasErrors()) {
            return null;
        }

        Staff staff = new Staff();
        staff.setOrganization(
                organizationRepository.getReferenceById(organizationId));
        staff.setLoginId(form.getLoginId());
        staff.setPasswordHash(passwordEncoder.encode(form.getPassword()));
        staff.setUserType(userType);
        staff.setName(form.getName());
        staff.setGender(form.getGender());
        staff.setBirthday(form.getBirthday());
        staff.setJoinedDate(form.getJoinedDate());
        staff.setAddress(blankToNull(form.getAddress()));
        staff.setPhoneNumber(form.getPhoneNumber());
        staff.setEmail(blankToNull(form.getEmail()));
        staff.setNotes(blankToNull(form.getNotes()));

        staffRepository.save(staff);
        return staff.getId();
    }

    // F-32 編集。ログインID・団体は変更しない
    public void update(
            Integer id,
            StaffForm form,
            BindingResult result,
            Integer organizationId,
            Integer loginStaffId) {

        Staff staff = find(id, organizationId);

        // ユーザー種別の存在確認
        UserType userType = null;
        if (form.getUserTypeId() != null) {
            userType = userTypeRepository.findById(form.getUserTypeId()).orElse(null);
            if (userType == null) {
                result.rejectValue(
                        "userTypeId",
                        "invalid",
                        "ユーザー種別の指定が不正です");
            }
        }

        // 自分自身はユーザー種別を変更できない
        if (userType != null
                && id.equals(loginStaffId)
                && !staff.getUserType().getId().equals(userType.getId())) {
            result.rejectValue(
                    "userTypeId",
                    "self",
                    "自分自身のユーザー種別は変更できません");
        }

        // エラーがあればここではEntityを書き換えない
        if (result.hasErrors()) {
            return;
        }

        staff.setUserType(userType);
        staff.setName(form.getName());
        staff.setGender(form.getGender());
        staff.setBirthday(form.getBirthday());
        staff.setJoinedDate(form.getJoinedDate());
        staff.setAddress(blankToNull(form.getAddress()));
        staff.setPhoneNumber(form.getPhoneNumber());
        staff.setEmail(blankToNull(form.getEmail()));
        staff.setNotes(blankToNull(form.getNotes()));

        // パスワードが入力されたときだけ変更
        if (form.getPassword() != null && !form.getPassword().isEmpty()) {
            staff.setPasswordHash(passwordEncoder.encode(form.getPassword()));
        }

        staffRepository.save(staff);
    }

    // F-33 スタッフ削除
    public boolean delete(
            Integer id,
            Integer organizationId,
            Integer loginStaffId) {

        Staff staff = find(id, organizationId);

        // 自分自身は削除できない
        if (id.equals(loginStaffId)) {
            return false;
        }

        // staff_idを参照するイベントはDBのON DELETE SET NULLで対応スタッフが空になる
        staffRepository.delete(staff);
        return true;
    }

    // 任意項目の空文字をnullにする
    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value;
    }
}
