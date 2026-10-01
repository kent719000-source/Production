package com.example.hogotaro.repository;

import com.example.hogotaro.entity.EventType;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * イベント種別マスタ（Entity: EventType）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<EventType, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 全団体共通のマスタなので、継承した findById() / findAll() をそのまま使ってよい。
 */
public interface EventTypeRepository extends JpaRepository<EventType, Integer> {

    /** イベント登録・編集のプルダウン（F-14 / F-16） */
    List<EventType> findAllByOrderById();

    /** code（TRIAL_START など）から引く。テスト用。入力チェックは選ばれた種別の getCode() を見ればよいので、普段は使わない */
    Optional<EventType> findByCode(String code);
}
