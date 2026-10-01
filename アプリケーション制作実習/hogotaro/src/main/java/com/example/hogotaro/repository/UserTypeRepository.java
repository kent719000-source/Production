package com.example.hogotaro.repository;

import com.example.hogotaro.entity.UserType;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * ユーザー種別マスタ（Entity: UserType）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<UserType, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 全団体共通のマスタなので、継承した findById() / findAll() をそのまま使ってよい。
 */
public interface UserTypeRepository extends JpaRepository<UserType, Integer> {

    /** スタッフ登録・編集のプルダウン（F-29 / F-31）。管理ユーザー → 常勤スタッフ → ボランティアの順 */
    List<UserType> findAllByOrderById();

    /** code（ADMIN / STAFF / VOLUNTEER）から引く。data.sql やテストで使う */
    Optional<UserType> findByCode(String code);
}
