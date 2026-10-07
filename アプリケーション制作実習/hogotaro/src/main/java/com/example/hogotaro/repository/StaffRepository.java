package com.example.hogotaro.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.hogotaro.entity.Staff;

/**
 * スタッフ（Entity: Staff）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<Staff, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 * JpaRepository の説明と、継承しただけで使えるメソッドの一覧は AnimalRepository の冒頭にまとめてある。
 * 業務テーブルなので、継承した findById() / findAll() は使わない（他団体のデータまで取れてしまう）。
 * 1 件取得は必ず findByIdAndOrganizationId(id, loginUser.getOrganizationId()) を使う（基本設計 8 章「団体の絞り込み」）。
 */
public interface StaffRepository extends JpaRepository<Staff, Integer> {

    /** ログイン時に LoginUserDetailsService と LoginUser が使う。ログイン ID は全団体で一意なので団体で絞らない */
    Optional<Staff> findByLoginId(String loginId);

    /** スタッフ新規登録（F-30）のログイン ID 重複チェック。全団体で一意なので団体で絞らない */
    boolean existsByLoginId(String loginId);

    /** 詳細・編集・削除（F-28 / F-31 / F-32 / F-33）の 1 件取得。空なら 404 */
    Optional<Staff> findByIdAndOrganizationId(Integer id, Integer organizationId);


    /**
     * スタッフ一覧のキーワード検索（F-27）。名前・電話番号とも部分一致。電話番号はハイフンを無視して比べる。
     * name / phone は null 不可。空文字なら全件に当たる。phone はハイフンを取り除いてから渡す（Service がやる）。
     * replace() を使うのでメソッド名だけでは書けず、@Query を使う。@Query を付けたメソッドは、名前を自由に付けられる（ここでは search）。
     */
    @Query("select s from Staff s"                                                  // @Query: このメソッドで実行する検索文（JPQL）を自分で書く。Staff はテーブル名ではなく Entity のクラス名、s は別名
            + " where s.organization.id = :organizationId"                          // 列名（organization_id）ではなく、Entity のフィールドを辿って書く。:organizationId には下の @Param("organizationId") の値が入る
            + " and s.name like concat('%', :name, '%')"                            // 名前の部分一致。concat で前後に % を付けて LIKE '%名前%' にする。:name が空文字なら全件に当たる
            + " and replace(s.phoneNumber, '-', '') like concat('%', :phone, '%')"  // DB 側の電話番号からハイフンを消してから、部分一致で比べる
            + " order by s.id desc")                                                // 新しく登録した順
    List<Staff> search(@Param("organizationId") Integer organizationId,             // @Param("名前"): この引数を JPQL の :名前 の所に入れる。名前がずれていると起動時にエラーになる
                       @Param("name") String name,
                       @Param("phone") String phone);
}
