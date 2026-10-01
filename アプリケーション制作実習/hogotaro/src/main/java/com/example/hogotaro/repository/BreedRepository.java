package com.example.hogotaro.repository;

import com.example.hogotaro.entity.Breed;
import com.example.hogotaro.entity.Species;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * 品種マスタ（Entity: Breed）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<Breed, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 全団体共通のマスタなので、継承した findById() / findAll() をそのまま使ってよい。
 */
public interface BreedRepository extends JpaRepository<Breed, Integer> {

    /** 個体登録・編集の品種プルダウン（F-07 / F-09）。全品種を犬 → 猫、名前順で。JS で犬猫に合わせて絞る場合もこれを渡す */
    List<Breed> findAllByOrderBySpeciesAscNameAsc();

    /** 個体フォームの「新しい品種」（F-08 / F-10）。同じ犬猫・同じ名前の品種がすでにあればそれを使う（無ければ Service が登録する） */
    Optional<Breed> findBySpeciesAndName(Species species, String name);
}
