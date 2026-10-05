package com.example.hogotaro.controller;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.NeuterStatus;
import com.example.hogotaro.entity.Sex;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.form.AnimalForm;
import com.example.hogotaro.form.AnimalSearchForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.AnimalRepository;
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
	private final AnimalRepository animalRepository;

	@GetMapping("/animal") //URLでlocalhost:8080/animalをリクエストすると呼ばれる
	public String list( @ModelAttribute("searchForm") AnimalSearchForm form,@org.springframework.web.bind.annotation.RequestParam(value = "search",required = false) String search,Model model) { //Model: JSPに渡すデータを入れる箱。引数に書くだけでSpringが用意して渡してくれる(自分でnewしない)
		// 初めて一覧を開いたときだけ、
	    // 保護状況を「保護中・入院中・トライアル中」の4つにする
	    if (search == null && (form.getStatuses() == null || form.getStatuses().isEmpty())) {
	        form.setStatuses(Status.inCare());
	    }
	    model.addAttribute("animalList",animalService.search(loginUser.getOrganizationId(),form));

	    // 犬猫の選択肢
	    model.addAttribute("speciesList", Species.values());

	    // 保護状況の選択肢
	    model.addAttribute("statusList", Status.values());
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
		
		//ユーザーの権限
		model.addAttribute("loginUser", loginUser);

		return "animal/form";
	}
	// 個体新規登録処理
	@PostMapping("/animal/new")
	public String create(@Validated @ModelAttribute("animalForm") AnimalForm form,BindingResult result,Model model) {
	    if (result.hasErrors()) {
	    	setFormModel(model);
	    	model.addAttribute("mode","new");
	        return "animal/form";
	    }
	    try {
		    Animal animal = animalService.create(form,loginUser.getOrganizationId());
		    return "redirect:/animal/" + animal.getId();
	    }catch(ResponseStatusException e) {
	        if (e.getStatusCode() == HttpStatus.BAD_REQUEST) {
<<<<<<< HEAD
	            result.rejectValue("breedId","breed.speciesMismatch",e.getReason());
=======
	            if ("犬猫と品種の組み合わせが不正です。".equals(e.getReason())) {
	                result.rejectValue("breedId","breed.speciesMismatch",e.getReason());
	            } else {
	            	// トライアル・譲渡で里親を選択しなかった時にエラー
	                result.rejectValue("adopterId","adopter.required",e.getReason());
	            }
>>>>>>> origin/kubota
	            setFormModel(model);
	            model.addAttribute("mode", "new");
	            return "animal/form";
	        }
	        throw e;
<<<<<<< HEAD
=======

>>>>>>> origin/kubota
	    }
	}
	// 個体詳細画面
	@GetMapping("/animal/{id}")
	public String detail(@PathVariable Integer id,Model model) {

	    // 詳細表示する個体を取得
	    Animal animal = animalService.findById(id,loginUser.getOrganizationId());

	    // JSPにanimalという名前で渡す
	    model.addAttribute("animal", animal);
	    model.addAttribute("loginUser", loginUser);
	    return "animal/detail";
	}

	//個体編集ページ
	@GetMapping("/animal/{id}/edit")
	public String editForm(@PathVariable Integer id, Model model) {
	    Integer organizationId = loginUser.getOrganizationId();
	    AnimalForm animalForm = animalService.getEditForm(id, organizationId);

	    model.addAttribute("animalForm", animalForm);
	    model.addAttribute("animalId", id);
	    model.addAttribute("mode", "edit");
	    model.addAttribute("speciesList", Species.values());
	    model.addAttribute("sexList", Sex.values());
	    model.addAttribute("neuterStatusList", NeuterStatus.values());
	    model.addAttribute("statusList", Status.values());
	    model.addAttribute("breedList",breedRepository.findAllByOrderBySpeciesAscNameAsc());
	    model.addAttribute("adopterList",adopterRepository.findByOrganizationIdOrderByNameAsc(organizationId));
	    Animal animal = animalService.findById(id, organizationId);
	    model.addAttribute("animal", animal);
	    model.addAttribute("imagePath", animal.getImagePath());
	    model.addAttribute("loginUser", loginUser);
	    return "animal/form";
	}
	// 個体編集処理
	@PostMapping("/animal/{id}/edit")
	public String update(@PathVariable Integer id,@Validated @ModelAttribute("animalForm") AnimalForm form,BindingResult result,Model model) {
	    Integer organizationId = loginUser.getOrganizationId();

	    // 犬・猫の品種の選択に間違いがあれば編集画面に戻る
	    if (result.hasErrors()) {
	        setFormModel(model);
	        model.addAttribute("animalId", id);
	        model.addAttribute("mode", "edit");
	        Animal animal = animalService.findById(id, organizationId);
	        model.addAttribute("animal", animal);
	        model.addAttribute("imagePath", animal.getImagePath());
	        return "animal/form";
	    }
	    try {
		    // 個体を更新
		    animalService.update(id, organizationId, form);

		    // PRGパターン：更新後は詳細画面へリダイレクト
		    return "redirect:/animal/" + id;	
		    
	    }catch(ResponseStatusException e) {
	        if (e.getStatusCode() == HttpStatus.BAD_REQUEST) {
<<<<<<< HEAD
	            result.rejectValue("breedId","breed.speciesMismatch",e.getReason());
=======
	            if ("犬猫と品種の組み合わせが不正です。".equals(e.getReason())) {
	                // 品種エラー
	                result.rejectValue("breedId","breed.speciesMismatch",e.getReason());
	            } else {
	                // トライアル・譲渡で里親を選択しなかった時にエラー
	                result.rejectValue("adopterId","adopter.required",e.getReason());
	            }
>>>>>>> origin/kubota
	            setFormModel(model);
	            model.addAttribute("animalId", id);
	            model.addAttribute("mode", "edit");
	            Animal animal = animalService.findById(id, organizationId);
	            model.addAttribute("animal", animal);
	            model.addAttribute("imagePath", animal.getImagePath());
	            return "animal/form";
	        }
	        throw e;
	    }
	}
	//個体IDと団体IDで絞って取得する
	public Animal detail(Integer id,Integer organizationId) {
		return animalRepository.findByIdAndOrganizationId(id,organizationId)
				.orElseThrow(() ->
				new ResponseStatusException(HttpStatus.NOT_FOUND));
	}
	//個体の情報を削除
	@PostMapping("/animal/{id}/delete")
	public String delete(@PathVariable Integer id) {

	    // 管理ユーザーのみ削除可能
	    if (!"ADMIN".equals(loginUser.getRole())) {
	        throw new ResponseStatusException(HttpStatus.FORBIDDEN, "権限がありません");
	    }

	    Animal animal = detail(id, loginUser.getOrganizationId());
	    animalRepository.delete(animal);

	    // 削除後は一覧へ
	    return "redirect:/animal";
	}
	private void setFormModel(Model model) {
	    Integer organizationId = loginUser.getOrganizationId();
	    model.addAttribute("speciesList", Species.values());
	    model.addAttribute("sexList", Sex.values());
	    model.addAttribute("neuterStatusList", NeuterStatus.values());
	    model.addAttribute("statusList", Status.values());
	    model.addAttribute("breedList",breedRepository.findAllByOrderBySpeciesAscNameAsc());
	    model.addAttribute("adopterList",adopterRepository.findByOrganizationIdOrderByNameAsc(organizationId));
	    model.addAttribute("loginUser", loginUser);
	}
}
