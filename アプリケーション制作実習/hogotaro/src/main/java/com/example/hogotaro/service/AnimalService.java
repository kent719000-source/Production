package com.example.hogotaro.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import com.example.hogotaro.entity.Adopter;
import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.Breed;
import com.example.hogotaro.entity.Event;
import com.example.hogotaro.entity.Organization;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import com.example.hogotaro.form.AnimalForm;
import com.example.hogotaro.form.AnimalSearchForm;
import com.example.hogotaro.repository.AdopterRepository;
import com.example.hogotaro.repository.AnimalRepository;
import com.example.hogotaro.repository.BreedRepository;
import com.example.hogotaro.repository.EventRepository;
import com.example.hogotaro.repository.OrganizationRepository;

import lombok.RequiredArgsConstructor;

@Service //アプリ起動時にSpringが1個だけnewして管理する
@RequiredArgsConstructor //コンストラクタの記述を省略(Requiredはfinal の付いたフィールドを受け取るコンストラクタの意味)、コンストラクタが注入の窓口になる
@Transactional //このクラスのメソッドは、途中で失敗したらDBへの変更を全部取り消す
public class AnimalService {
	private final AnimalRepository animalRepository; //Springが管理しているAnimalRepository(の参照値)を受け取る(自分でnewしない)
	private final OrganizationRepository organizationRepository;
	private final BreedRepository breedRepository;
	private final AdopterRepository adopterRepository;
	private final EventRepository eventRepository;

	//団体ID(OrganizationId)で絞って取得する。他の団体のデータを出さないため、Repository を呼ぶときは必ず団体IDを渡す
	public List<Animal> findAll(Integer organizationId) {
		return animalRepository.findByOrganizationIdOrderByIdDesc(organizationId);
	}
	// 個体一覧の検索
	public List<Animal> search(Integer organizationId, AnimalSearchForm form) {

	    // 犬猫が未選択なら、すべての種別を対象にする
	    List<Species> speciesList = form.getSpecies();
	    if (speciesList == null || speciesList.isEmpty()) {
	        speciesList = List.of(Species.values());
	    }

	    // 保護状況が未選択なら、すべての保護状況を対象にする
	    List<Status> statusList = form.getStatuses();
	    if (statusList == null || statusList.isEmpty()) {
	        statusList = List.of(Status.values());
	    }

	    // 名前が未入力なら空文字にする
	    String name = form.getName();
	    if (name == null) {
	        name = "";
	    }
	    return animalRepository.findByOrganizationIdAndSpeciesInAndStatusInAndNameContainingOrderByIdDesc(organizationId,speciesList,statusList,name);
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
	    //★ P01対応
	    form.setNotes(animal.getNotes());
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
        // 犬猫と品種の組み合わせが正しいかチェック
        if (breed != null && breed.getSpecies() != form.getSpecies()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"犬猫と品種の組み合わせが不正です。");
        }
        if (form.getAdopterId() != null) {
            Adopter adopter = adopterRepository.findByIdAndOrganizationId(form.getAdopterId(),organizationId)
                .orElseThrow(() ->
                    new ResponseStatusException(HttpStatus.NOT_FOUND));
            animal.setAdopter(adopter);
        }
        animal.setBreed(breed);

        // 誕生日
        animal.setBirthday(form.getBirthday());
        animal.setIsBirthdayEstimated(form.getIsBirthdayEstimated());

        // 保護情報
        animal.setIntakeDate(form.getIntakeDate());
        animal.setIntakePlace(form.getIntakePlace());
        animal.setIntakeMethod(form.getIntakeMethod());
        animal.setStatus(form.getStatus());
        // 譲渡・トライアルの場合は里親を必須にする
        if ((form.getStatus() == Status.TRIAL || form.getStatus() == Status.ADOPTED) && form.getAdopterId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"このステータスの場合は里親を選択してください。");
        }
        //里親Idと紐づける
        if (form.getAdopterId() != null) {
            Adopter adopter = adopterRepository.findByIdAndOrganizationId(form.getAdopterId(),organizationId)
                .orElseThrow(() ->
                    new ResponseStatusException(HttpStatus.NOT_FOUND));
            animal.setAdopter(adopter);
        }

        // 避妊去勢・ワクチン
        animal.setNeutered(form.getNeutered());
        animal.setComboVaccine(form.getComboVaccine());
        // 犬の場合は狂犬病ワクチンを必須にする
        if (form.getSpecies() == Species.DOG && form.getRabiesVaccine() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"犬の場合は狂犬病ワクチンを選択してください。");
        }
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
        
        // 画像が選択されていたら保存
        if (form.getPhoto() != null && !form.getPhoto().isEmpty()) {
            animal.setImagePath(savePhoto(form.getPhoto()));
        }
        // DBに登録
        return animalRepository.save(animal);
       }    
    public void update(Integer id, Integer organizationId, AnimalForm form) {
        Animal animal = animalRepository.findByIdAndOrganizationId(id, organizationId)
                .orElseThrow(() ->
                        new ResponseStatusException(HttpStatus.NOT_FOUND));

        // 更新前の古い画像パスを保存しておく
        String oldImagePath = animal.getImagePath();

        animal.setName(form.getName());
        animal.setSpecies(form.getSpecies());
        animal.setSex(form.getSex());

        // 品種
        Breed breed = null; // 品種を入れるための変数を用意

        // 「新しい品種」が入力されている場合はこちらを優先
        if (form.getNewBreedName() != null && !form.getNewBreedName().isBlank()) {
            breed = breedRepository.findBySpeciesAndName(form.getSpecies(),form.getNewBreedName())
            	.orElseGet(() -> {
                Breed newBreed = new Breed();
                newBreed.setSpecies(form.getSpecies());
                newBreed.setName(form.getNewBreedName());
                return breedRepository.save(newBreed);
            });

        // 既存の品種が選択されている場合
        } else if (form.getBreedId() != null) {
            breed = breedRepository.findById(form.getBreedId())
                    .orElseThrow(() ->
                            new ResponseStatusException(HttpStatus.NOT_FOUND));
        }

        // 犬猫と品種の組み合わせが正しいかチェック
        if (breed != null && breed.getSpecies() != form.getSpecies()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"犬猫と品種の組み合わせが不正です。");
        }
        animal.setBreed(breed);

        // 誕生日
        animal.setBirthday(form.getBirthday());
        animal.setIsBirthdayEstimated(form.getIsBirthdayEstimated());

        // 保護情報
        animal.setIntakeDate(form.getIntakeDate());
        animal.setIntakePlace(form.getIntakePlace());
        animal.setIntakeMethod(form.getIntakeMethod());
        animal.setStatus(form.getStatus());

        // 譲渡・トライアルの場合は里親を必須にする
        if ((form.getStatus() == Status.TRIAL || form.getStatus() == Status.ADOPTED) && form.getAdopterId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"このステータスの場合は里親を選択してください。");
        }

        // 里親Idと紐づける
        if (form.getAdopterId() != null) {
            Adopter adopter = adopterRepository.findByIdAndOrganizationId(form.getAdopterId(),organizationId)
                    .orElseThrow(() ->
                            new ResponseStatusException(HttpStatus.NOT_FOUND));
            animal.setAdopter(adopter);
        }

        // 避妊去勢・ワクチン
        animal.setNeutered(form.getNeutered());
        animal.setComboVaccine(form.getComboVaccine());

        // 犬の場合は狂犬病ワクチンを必須にする
        if (form.getSpecies() == Species.DOG && form.getRabiesVaccine() == null) {

            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"犬の場合は狂犬病ワクチンを選択してください。");
        }

        // 猫は狂犬病ワクチン関係ないのでifで分岐
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

        // ★ P-02対応
        // 入力チェックがすべて終わった後に写真を処理する
        if (form.getPhoto() != null && !form.getPhoto().isEmpty()) {

            // 新しい写真を保存
            String newImagePath = savePhoto(form.getPhoto());

            // DB上の画像パスを新しい画像に変更
            animal.setImagePath(newImagePath);

            // 古い写真を削除
            if (oldImagePath != null && !oldImagePath.isBlank()) {

                Path oldPhotoPath = Paths.get("uploads" + oldImagePath);

                try {
                    Files.deleteIfExists(oldPhotoPath);
                } catch (IOException e) {
                    throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,"古い写真を削除できませんでした",e);
                }
            }
        }

        // DBに登録
        animalRepository.save(animal);
    }    // 個体削除時に写真ファイルも削除する
    public void delete(Integer id, Integer organizationId) {

        // 団体IDも指定して個体を取得
        Animal animal = animalRepository.findByIdAndOrganizationId(id, organizationId)
                .orElseThrow(() ->
                        new ResponseStatusException(HttpStatus.NOT_FOUND));

        // 写真のパスを取得
        String imagePath = animal.getImagePath();

        // DBから個体を削除
        animalRepository.delete(animal);

        // 写真が登録されている場合だけファイルを削除
        if (imagePath != null && !imagePath.isBlank()) {

            // imagePath は "/photos/ファイル名" なので
            // 実際の保存先 "uploads/photos/ファイル名" に変換する
            Path photoPath = Paths.get("uploads" + imagePath);

            try {
                Files.deleteIfExists(photoPath);
            } catch (IOException e) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "写真を削除できませんでした", e);
            }
        }
    }    
    // 写真をプロジェクト直下の uploads/photos/ に保存し、画面から見る URL（/photos/ファイル名）を返す。選ばれていなければ null
    private String savePhoto(MultipartFile photo) {
		if (photo == null || photo.isEmpty()) {
			return null; // 写真を選ばなかったとき、中身が空 photo が届く
		}
		String ext = "image/png".equals(photo.getContentType()) ? ".png" : ".jpg"; // 拡張子。JSP の accept で JPEG か PNG に絞っている
		String fileName = UUID.randomUUID() + ext; 
		Path dir = Paths.get("uploads/photos"); // application.properties の file:uploads/ の下。/photos/ファイル名 で表示できる
		try {
			Files.createDirectories(dir); 	Files.copy(photo.getInputStream(), dir.resolve(fileName)); // transferTo に相対パスを渡すと Tomcat の一時フォルダに入るので Files.copy を使う
		} catch (IOException e) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "写真を保存できませんでした", e); // エラー画面（500）を出す
		}
		return "/photos/" + fileName;
	}
    public List<Event> findEventList(Integer animalId, Integer organizationId) {
        return eventRepository.findByOrganizationIdAndAnimalIdOrderByEventDateDescEventTimeDesc(organizationId, animalId);
    }
}
