package com.example.hogotaro.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.hogotaro.entity.Event;


/**
 * イベント（Entity: Event）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<Event, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 業務テーブルなので、継承した findById() / findAll() は使わない（他団体のデータまで取れてしまう）。
 * 1 件取得は必ず findByIdAndOrganizationId(id, loginUser.getOrganizationId()) を使う（基本設計 8 章「団体の絞り込み」）。
 */
public interface EventRepository extends JpaRepository<Event, Integer> {

    /** 詳細・編集・完了・削除（F-13 / F-16 / F-17 / F-18 / F-19）の 1 件取得。空なら 404 */
    Optional<Event> findByIdAndOrganizationId(Integer id, Integer organizationId);

    /** 団体の全イベントを新しく登録した順で（WHERE organization_id = ? ORDER BY id DESC）。チームの EventService.findAll が使う。カレンダーは下の EventDateBetween を使う */
    List<Event> findByOrganizationIdOrderByIdDesc(Integer organizationId);

    /** イベント一覧のカレンダー（F-12）とトップのミニカレンダー（F-01）。表の左上の日〜右下の日を渡す（EventService.calendar） */
    List<Event> findByOrganizationIdAndEventDateBetweenOrderByEventDateAscEventTimeAsc(
            Integer organizationId, LocalDate from, LocalDate to);

    /** 個体詳細（F-06）に出す、この個体のイベント。新しい順。業務テーブルのメソッドは必ず団体でも絞る（基本設計 8 章） */
    List<Event> findByOrganizationIdAndAnimalIdOrderByEventDateDescEventTimeDesc(Integer organizationId, Integer animalId);

    /** 里親詳細（F-21）に出す、この里親に関係するイベント。新しい順 */
    List<Event> findByOrganizationIdAndAdopterIdOrderByEventDateDescEventTimeDesc(Integer organizationId, Integer adopterId);

    /** スタッフ詳細（F-28）に出す、この人が対応したイベント。新しい順。業務テーブルのメソッドは必ず団体でも絞る（基本設計 8 章） */
    List<Event> findByOrganizationIdAndStaffIdOrderByEventDateDescEventTimeDesc(Integer organizationId, Integer staffId);

    /** 里親削除（F-26）の可否チェック。この里親を指すイベントが 1 件でもあれば true（= 削除できない） */
    boolean existsByOrganizationIdAndAdopterId(Integer organizationId, Integer adopterId);

    // 個体を消したときのイベント削除は DB の ON DELETE CASCADE、スタッフを消したときの staff_id = NULL は ON DELETE SET NULL がやる。
    // そのための削除メソッドは要らない。
}
