package com.example.hogotaro.repository;

import com.example.hogotaro.entity.Animal;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * 個体（Entity: Animal）の Repository。
 * interface を書くだけで、中身は Spring Data JPA が起動時に自動で作る。
 * JpaRepository<Animal, Integer> を継承しているので、save() / delete() / findById() / getReferenceById() などは書かなくても使える。
 * 下に並べたメソッドは、メソッド名から Spring Data が SQL を組み立てる（findBy〜And〜OrderBy〜）。@Query 付きのものは JPQL を自分で書いている。
 *
 * ■ JpaRepository<Animal, Integer> とは
 *   Spring Data JPA が用意している「DB 操作の基本セット」。継承（extends）するだけで、下の表のメソッドが使えるようになる。
 *   <Animal, Integer> は「Animal という Entity を扱い、主キー（id）の型は Integer」の意味。
 *   interface に @Repository は付けなくてよい。JpaRepository を継承した interface は、Spring が自動で見つけて注入できるようにする。
 *
 * ■ 継承しただけで使えるメソッド（よく使う物）
 *   save(animal)           登録と更新の両方。id が null なら INSERT、id が入っていれば UPDATE。戻り値は保存後の Entity（採番された id が入っている）
 *   delete(animal)         削除。先に findByIdAndOrganizationId で取った Entity を渡す
 *   getReferenceById(id)   SELECT せずに「id だけ入った参照」を作る。登録時に animal.setOrganization(...) へ渡す相手を作るときに使う
 *   findById(id)           主キーで 1 件取得。団体で絞れないので、業務テーブルでは使わない（マスタと団体では使ってよい）
 *   findAll()              全件取得。全団体のデータが取れてしまうので、業務テーブルでは使わない
 *   deleteById(id)         id を指定して削除。団体の確認ができないので、業務テーブルでは使わない
 *   count()                全件数。業務テーブルでは countByOrganizationId〜 のように団体で絞った物を使う
 *   existsById(id)         その id の行があるか（true / false）
 *
 * ■ Optional とは
 *   「あるかもしれないし、無いかもしれない」を表す入れ物。1 件取得の戻り値に使う。
 *   animalRepository.findByIdAndOrganizationId(id, orgId)
 *           .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
 *   と書くと、あれば Animal が取れ、無ければ 404 になる。
 *
 * ■ 更新のときの save() について
 *   Service のクラスに @Transactional が付いていれば、取得した Entity の setter を呼ぶだけで、メソッドを抜けるときに UPDATE が流れる。
 *   save() を呼んでも害は無いが、呼ばなくても更新される。新規登録（new Animal()）のときだけは save() が必要。
 *
 * ■ メソッド名の読み方（Spring Data がメソッド名から SQL を作る）
 *   findBy / countBy / existsBy   取得 / 件数 / あるかどうか
 *   OrganizationId                organization.id = ?（@ManyToOne の相手を辿る。Organization の Id）
 *   And                           AND
 *   In                            IN (...)。引数は List などのコレクション
 *   Containing                    LIKE '%値%'（部分一致）
 *   Between                       BETWEEN ? AND ?（引数を 2 つ取る）
 *   DoneFalse                     done = false（引数は取らない）
 *   OrderByIdDesc                 ORDER BY id DESC（Asc なら昇順）
 *   引数は、メソッド名に出てくる条件の順に並べる。メソッド名の綴りが Entity のフィールド名と 1 文字でも違うと、起動時にエラーになる。
 *
 * 業務テーブルなので、継承した findById() / findAll() は使わない（他団体のデータまで取れてしまう）。
 * 1 件取得は必ず findByIdAndOrganizationId(id, loginUser.getOrganizationId()) を使う（基本設計 8 章「団体の絞り込み」）。
 */
public interface AnimalRepository extends JpaRepository<Animal, Integer> {

    /** 詳細・編集・削除（F-06 / F-09 / F-10 / F-11）と、イベント登録で選ばれた個体の引き直しの 1 件取得。空なら 404 */
    Optional<Animal> findByIdAndOrganizationId(Integer id, Integer organizationId);

    /** 団体の全個体を新しい順で（WHERE organization_id = ? ORDER BY id DESC）。チームの AnimalService.findAll が使う。一覧の絞り込みは下の findByOrganizationIdAndSpeciesIn... を使う */
    List<Animal> findByOrganizationIdOrderByIdDesc(Integer organizationId);

    /**
     * 個体一覧の絞り込み（F-05）。@Query は要らない。メソッド名から Spring Data が SQL を作る:
     *   WHERE organization_id = ? AND species IN (...) AND status IN (...) AND name LIKE '%名前%' ORDER BY id DESC
     * species / statuses は 1 つ以上入れて呼ぶ（空なら Service が呼ばずに 0 件を返す）。name は null 不可、空文字なら全件に当たる
     */
    List<Animal> findByOrganizationIdAndSpeciesInAndStatusInAndNameContainingOrderByIdDesc(
            Integer organizationId, Collection<Species> species, Collection<Status> statuses, String name);

    /** トップページの保護頭数（F-01）。statuses には Status.inCare() を渡す */
    long countByOrganizationIdAndStatusIn(Integer organizationId, Collection<Status> statuses);

    /**
     * イベント登録・編集の個体プルダウン（F-14 / F-16）。statuses には Status.inCare() を渡し、今世話をしている子だけを名前順で出す（決定 1-10）。
     * 編集のときに今の個体がこの中にいなければ、Service が選択肢に足す
     */
    List<Animal> findByOrganizationIdAndStatusInOrderByNameAsc(Integer organizationId, Collection<Status> statuses);

    /**
     * 里親詳細（F-21）に出す「この里親の個体」。statuses には List.of(Status.TRIAL, Status.ADOPTED) を渡す。
     * 並びは status の降順（文字列比較で TRIAL → ADOPTED の順になる）
     */
    List<Animal> findByOrganizationIdAndAdopterIdAndStatusInOrderByStatusDesc(
            Integer organizationId, Integer adopterId, Collection<Status> statuses);

    /** 里親削除（F-26）の可否チェック。保護状況に関係なく、この里親を指す個体が 1 頭でもいれば true（= 削除できない） */
    boolean existsByOrganizationIdAndAdopterId(Integer organizationId, Integer adopterId);
}
