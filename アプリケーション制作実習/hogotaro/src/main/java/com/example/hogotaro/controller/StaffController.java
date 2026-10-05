package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.hogotaro.entity.Gender;
import com.example.hogotaro.entity.Staff;
import com.example.hogotaro.form.StaffForm;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.StaffService;

import lombok.RequiredArgsConstructor;

@Controller //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
public class StaffController {

	private final StaffService staffService; //Springが管理しているStaffService(の参照値)を受け取る(自分でnewしない)
	private final LoginUser loginUser; //同上

	@GetMapping("/staff") //URLでlocalhost:8080/staffをリクエストすると呼ばれる
	public String list(Model model) { //Model: JSPに渡すデータを入れる箱。引数に書くだけでSpringが用意して渡してくれる(自分でnewしない)
		model.addAttribute("staffList", staffService.findAll(loginUser.getOrganizationId())); //JSPにstaffListという名前で渡す。JSPでは${staffList}で読む
		return "staff/list"; // /WEB-INF/jsp/staff/list.jspを表示する
	}

	@GetMapping("/staff/{id}")
	public String detail(@PathVariable Integer id, Model model) {
		Integer organizationId = loginUser.getOrganizationId();
		Staff staff = staffService.find(id, organizationId);

		model.addAttribute("staff", staff);
		return "staff/detail";
	}

	@GetMapping("/staff/new")
	public String newForm(Model model) {
		model.addAttribute("staffForm", new StaffForm());
		model.addAttribute("mode", "new");
		model.addAttribute("userTypeList", staffService.findUserTypes());
		model.addAttribute("genderList", Gender.values()); // 性別のラジオボタン（男性 / 女性 / その他）

		return "staff/form";
	}

	@PostMapping("/staff/new")
	public String create(StaffForm staffForm) { // 送られた値は name 属性と同じ名前のフィールドに自動で入る
		Integer id = staffService.create(staffForm, loginUser.getOrganizationId());
		return "redirect:/staff/" + id; // リダイレクトにすると、再読み込みで二重登録されない
	}

	@GetMapping("/staff/{id}/edit")
	public String editForm(@PathVariable Integer id, Model model) {
		Staff staff = staffService.find(id, loginUser.getOrganizationId());
		model.addAttribute("staffForm", staffService.toForm(staff));
		model.addAttribute("mode", "edit");
		model.addAttribute("staff", staff); // ログインIDの表示・キャンセルの戻り先・自分かどうかの判定に使う
		model.addAttribute("userTypeList", staffService.findUserTypes());
		model.addAttribute("genderList", Gender.values());
		return "staff/form";
	}

	@PostMapping("/staff/{id}/edit")
	public String update(@PathVariable Integer id, StaffForm staffForm) {
		staffService.update(id, staffForm, loginUser.getOrganizationId());
		return "redirect:/staff/" + id;
	}

	@PostMapping("/staff/{id}/delete")
	public String delete(Model model) {
		model.addAttribute("staffForm", new StaffForm());
		return "redirect:/staff";
	}

}
