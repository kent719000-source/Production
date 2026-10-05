package com.example.hogotaro.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.Breed;
import com.example.hogotaro.entity.Organization;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.form.AnimalForm;
import com.example.hogotaro.repository.AnimalRepository;
import com.example.hogotaro.repository.BreedRepository;
import com.example.hogotaro.repository.OrganizationRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class AnimalService {
	private final AnimalRepository animalRepository; //Springが管理しているAnimalRepository(の参照値)を受け取る(自分でnewしない)
	private final OrganizationRepository organizationRepository;
	private final BreedRepository breedRepository;

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Animal> findAll(Integer organizationId) {
		return animalRepository.findByOrganizationIdOrderByIdDesc(organizationId);

	}
	public Animal findById(Integer id, Integer organizationId) {
	    return animalRepository.findByIdAndOrganizationId(id, organizationId)
	            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
	}
	//編集画面に表示するため、すでにDBに登録されてる情報を取得
	public AnimalForm getEditForm(Integer id, Integer organizationId) {
	    Animal animal = findById(id, organizationId);
	    AnimalForm form = new AnimalForm();
	    form.setName(animal.getName());
	    form.setSpecies(animal.getSpecies());
	    form.setSex(animal.getSex());
	    if (animal.getBreed() != null) {
	        form.setBreedId(animal.getBreed().getId());
	    }
	    form.setBirthday(animal.getBirthday());
	    form.setIsBirthdayEstimated(animal.getIsBirthdayEstimated());
	    form.setIntakeDate(animal.getIntakeDate());
	    form.setIntakePlace(animal.getIntakePlace());
	    form.setIntakeMethod(animal.getIntakeMethod());
	    form.setStatus(animal.getStatus());
	    if (animal.getAdopter() != null) {
	        form.setAdopterId(animal.getAdopter().getId());
	    }
	    form.setNeutered(animal.getNeutered());
	    form.setComboVaccine(animal.getComboVaccine());
	    form.setRabiesVaccine(animal.getRabiesVaccine());
	    form.setMicrochipNo(animal.getMicrochipNo());
	    form.setHealthNotes(animal.getHealthNotes());
	    return form;
	}

	   // 個体新規登録
    public Animal create(AnimalForm form, Integer organizationId) {
        Animal animal = new Animal(); // 新しいAnimalを作る
        Organization organization = organizationRepository.getReferenceById(organizationId); // 団体を設定
        animal.setOrganization(organization);//上で指定した団体に個体を所属させる

        // 基本情報
        animal.setName(form.getName());
        animal.setSpecies(form.getSpecies());
        animal.setSex(form.getSex());

        // 品種
        Breed breed = null;///品種を入れるための変数を用意(現時点ではnull)

        // 「新しい品種」が入力されている場合はこちらを優先
        if (form.getNewBreedName() != null && !form.getNewBreedName().isBlank()) {
            breed = breedRepository.findBySpeciesAndName(form.getSpecies(),form.getNewBreedName())
                    .orElseGet(() -> {
                        Breed newBreed = new Breed();
                        newBreed.setSpecies(form.getSpecies());
                        newBreed.setName(form.getNewBreedName());
                        return breedRepository.save(newBreed);});

        // 既存の品種が選択されている場合
        } else if (form.getBreedId() != null) {
           breed = breedRepository.findById(form.getBreedId())
                    .orElseThrow(() ->
                            new ResponseStatusException(HttpStatus.NOT_FOUND));}
        animal.setBreed(breed);

        // 誕生日
        animal.setBirthday(form.getBirthday());
        animal.setIsBirthdayEstimated(form.getIsBirthdayEstimated());

        // 保護情報
        animal.setIntakeDate(form.getIntakeDate());
        animal.setIntakePlace(form.getIntakePlace());
        animal.setIntakeMethod(form.getIntakeMethod());
        animal.setStatus(form.getStatus());

        // 避妊去勢・ワクチン
        animal.setNeutered(form.getNeutered());
        animal.setComboVaccine(form.getComboVaccine());
        //猫は狂犬病ワクチン関係ないのでifで分岐
        if (form.getSpecies() == Species.CAT) {
            animal.setRabiesVaccine(false);
        } else {
            animal.setRabiesVaccine(form.getRabiesVaccine());
        }

        // マイクロチップ
        animal.setMicrochipNo(form.getMicrochipNo());

        // 特記事項
        animal.setHealthNotes(form.getHealthNotes());
        animal.setNotes(form.getNotes());

        // DBに登録
        return animalRepository.save(animal);
       }
    
    public void update(Integer id, Integer organizationId, AnimalForm form) {
    	Animal animal = animalRepository.findByIdAndOrganizationId(id, organizationId)
    	        .orElseThrow(() ->
    	                new ResponseStatusException(HttpStatus.NOT_FOUND));
    	
        animal.setName(form.getName());
        animal.setSpecies(form.getSpecies());
        animal.setSex(form.getSex());

        // 品種
        Breed breed = null;///品種を入れるための変数を用意(現時点ではnull)

        // 「新しい品種」が入力されている場合はこちらを優先
        if (form.getNewBreedName() != null && !form.getNewBreedName().isBlank()) {
            breed = breedRepository.findBySpeciesAndName(form.getSpecies(),form.getNewBreedName())
                    .orElseGet(() -> {
                        Breed newBreed = new Breed();
                        newBreed.setSpecies(form.getSpecies());
                        newBreed.setName(form.getNewBreedName());
                        return breedRepository.save(newBreed);});

        // 既存の品種が選択されている場合
        } else if (form.getBreedId() != null) {
           breed = breedRepository.findById(form.getBreedId())
                    .orElseThrow(() ->
                            new ResponseStatusException(HttpStatus.NOT_FOUND));}        
        animal.setBreed(breed);

        // 誕生日
        animal.setBirthday(form.getBirthday());
        animal.setIsBirthdayEstimated(form.getIsBirthdayEstimated());

        // 保護情報
        animal.setIntakeDate(form.getIntakeDate());
        animal.setIntakePlace(form.getIntakePlace());
        animal.setIntakeMethod(form.getIntakeMethod());
        animal.setStatus(form.getStatus());

        // 避妊去勢・ワクチン
        animal.setNeutered(form.getNeutered());
        animal.setComboVaccine(form.getComboVaccine());
      //猫は狂犬病ワクチン関係ないのでifで分岐
        if (form.getSpecies() == Species.CAT) {
            animal.setRabiesVaccine(false);
        } else {
            animal.setRabiesVaccine(form.getRabiesVaccine());
        }

        // マイクロチップ
        animal.setMicrochipNo(form.getMicrochipNo());

        // 特記事項
        animal.setHealthNotes(form.getHealthNotes());
        animal.setNotes(form.getNotes());

        // DBに登録
        animalRepository.save(animal);

    }
}
