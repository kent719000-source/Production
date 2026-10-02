package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.hogotaro.entity.Gender;
import com.example.hogotaro.form.AdopterForm;
import com.example.hogotaro.form.AdopterSearchForm;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.AdopterService;

import lombok.RequiredArgsConstructor;

@Controller //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
public class AdopterController {

	private final AdopterService adopterService; //Springが管理しているAdopterService(の参照値)を受け取る(自分でnewしない)
	private final LoginUser loginUser; //同上

	@GetMapping("/adopter") //URLでlocalhost:8080/adopterをリクエストすると呼ばれる。検索は /adopter?name=中村&phoneNumber=0801 の形で届く
	public String list(@ModelAttribute("searchForm") AdopterSearchForm form, Model model) { //@ModelAttribute: URLの name= phoneNumber= をSpringが自動でformに詰め、JSPにもsearchFormという名前で渡す(検索後も入力欄に文字が残る)。Model: JSPに渡すデータを入れる箱
		model.addAttribute("adopterList", adopterService.search(loginUser.getOrganizationId(), form)); //自団体の里親を検索した結果を、adopterListという名前でJSPに渡す。JSPでは${adopterList}で読む
		return "adopter/list"; // /WEB-INF/jsp/adopter/list.jspを表示する
	}
	
	// 新規登録画面を表示する（F-22）。空のフォームと、性別ラジオボタンの選択肢を渡す
	@GetMapping("/adopter/new")
	public String newForm(Model model) {
		model.addAttribute("adopterForm",new AdopterForm());
		model.addAttribute("genderList", Gender.values()); // 男性/女性/その他
		model.addAttribute("mode","new"); // form.jspを新規登録と編集で共用するための目印
		return "adopter/form";
	}
	
	// 登録する（F-23）。@Validatedで入力チェックし、結果は result に入る
	@PostMapping("/adopter/new")
	public String create(@Validated AdopterForm adopterForm, BindingResult result, Model model, RedirectAttributes redirectAttributes) {
		if (result.hasErrors()) { // もし入力エラーがあれば、同じフォームを再表示（入力値とエラーメッセージは adopterForm と result が持っている）
			model.addAttribute("genderList", Gender.values());
			model.addAttribute("mode", "new");
			return "adopter/form";
		}
		Integer id = adopterService.create(adopterForm, loginUser.getOrganizationId());
		redirectAttributes.addFlashAttribute("message", "里親新規登録が完了しました"); // リダイレクト先で1回だけ読めるメッセージ
		return "redirect:/adopter/" + id; // 登録した里親の詳細へリダイレクトする（F-21）
	}
	// 里親詳細ページを表示する（S-12）
	@GetMapping("/adopter/{id}")
	public String detail(@PathVariable Integer id, Model model) {
		model.addAttribute("adopter",adopterService.detail(id,loginUser.getOrganizationId()));
		return "adopter/detail";
	}
	// 里親を削除し、/adopter/{id}へリダイレクト（F-26）
	@PostMapping("/adopter/{id}/delete")
	public String delete(@PathVariable Integer id) {
		adopterService.delete(id,loginUser.getOrganizationId());
		return "redirect:/adopter";
	}
}
