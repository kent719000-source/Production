package com.example.hogotaro.repository;

import com.example.hogotaro.entity.Organization;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * 団体（Entity: Organization）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<Organization, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 団体は運営が SQL で登録する。画面からは自分の団体を読むだけなので、findById() / getReferenceById() を使ってよい
 * （引数は必ず loginUser.getOrganizationId()）。
 */
public interface OrganizationRepository extends JpaRepository<Organization, Integer> {

    // 追加のメソッドは無し。
    // トップの受入上限: findById(organizationId)
    // 登録時に団体をセットする: getReferenceById(organizationId)（SELECT せずに参照だけ作る）
}
