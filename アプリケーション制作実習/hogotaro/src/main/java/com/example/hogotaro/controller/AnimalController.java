package com.example.hogotaro.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.hogotaro.entity.NeuterStatus;
import com.example.hogotaro.entity.Sex;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.form.AnimalForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.BreedRepository;
import com.example.hogotaro.security.LoginUser;
import com.example.hogotaro.service.AnimalService;

import lombok.RequiredArgsConstructor;

@Controller //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinalの付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
public class AnimalController {

	private final AnimalService animalService; //Springが管理しているAnimalService(の参照値)を受け取る(自分でnewしない)
	private final LoginUser loginUser; //同上
	private final BreedRepository breedRepository;
	private final AdopterRepository adopterRepository;

	@GetMapping("/animal") //URLでlocalhost:8080/animalをリクエストすると呼ばれる
	public String list(Model model) { //Model: JSPに渡すデータを入れる箱。引数に書くだけでSpringが用意して渡してくれる(自分でnewしない)
		model.addAttribute("animalList", animalService.findAll(loginUser.getOrganizationId())); //JSPにanimalListという名前で渡す。JSPでは${animalList}で読む
		return "animal/list"; //		/WEB-INF/jsp/animal/list.jspを表示する
	}
	// 個体新規登録画面
	@GetMapping("/animal/new")
	public String newForm(Model model) {
		AnimalForm animalForm = new AnimalForm();

		// 誕生日は「推定」を初期値にする
		animalForm.setIsBirthdayEstimated(true);

		model.addAttribute("animalForm", animalForm);
		model.addAttribute("mode", "new");

		// 犬・猫
		model.addAttribute("speciesList", Species.values());

		// 性別
		model.addAttribute("sexList", Sex.values());
		
		// 避妊去勢
		model.addAttribute("neuterStatusList", NeuterStatus.values());

		// 保護状況
		model.addAttribute("statusList", Status.values());
		
		// 品種
		model.addAttribute("breedList",breedRepository.findAllByOrderBySpeciesAscNameAsc());

		// 里親
		model.addAttribute("adopterList",adopterRepository.findByOrganizationIdOrderByNameAsc(loginUser.getOrganizationId()));

		return "animal/form";
	}

}
