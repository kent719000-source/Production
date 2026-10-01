package com.example.hogotaro.form;

import com.example.hogotaro.entity.NeuterStatus;
import com.example.hogotaro.entity.Sex;
import com.example.hogotaro.entity.Species;
import com.example.hogotaro.entity.Status;
import jakarta.validation.constraints.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

/**
 * 個体の登録・編集フォーム（S-05 / S-06、F-08 / F-10）の入力を受けるクラス【土台】。項目と入力チェックだけ入っている。
 *
 * ■ 使い方
 *   Controller: public String create(@Validated @ModelAttribute("animalForm") AnimalForm form, BindingResult result, ...)
 *     @Validated を付けると、下のアノテーションのチェックが自動で走り、結果が BindingResult に入る。
 *     if (result.hasErrors()) { return "xxx/form"; } で同じ画面を再表示する（入力値は残る）。
 *   JSP: <form:input path="name"/> <form:errors path="name"/> のように、path にフィールド名を書く。
 *        message に書いた文が <form:errors> の場所に出る。
 *
 * ■ Entity をそのまま使わず Form を分ける理由
 *   画面から送られた値を Entity に直接入れると、organization のような「画面から変えさせたくない項目」まで書き換えられてしまう。
 *   Form には画面で入力させる項目だけを持たせ、Service が Entity に詰め替える。団体は loginUser から入れる。
 *
 * ■ プルダウンで選ぶ相手（品種・里親など）は Integer の id で受ける
 *   Service が findByIdAndOrganizationId で引き直してから Entity にセットする（他団体の id を送られても弾ける）。
 *   品種は全団体共通のマスタなので findById で引く。
 *
 * ■ このフォームだけの注意
 *   写真を送るので、JSP の <form:form> に enctype="multipart/form-data" が要る（無いとファイルの中身が届かない）。
 *   次の 4 つはアノテーションで書けないので AnimalService.check() で調べる:
 *   犬の狂犬病ワクチンの必須、里親の必須（トライアル中・譲渡済のとき）、品種と犬猫の組み合わせ、写真の種類（JPEG / PNG）。
 *   年齢は入力させない（誕生日から計算する）。
 */
@Data   // Lombok: getter / setter などをまとめて作る。Form は DB と関係ないので @Data でよい（Entity には付けない）
public class AnimalForm {

    /** 名前 */
    @NotBlank(message = "名前を入力してください")               // 文字列用の必須チェック。null・空文字・空白だけ、を全部エラーにする
    @Size(max = 10, message = "名前は10文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String name;

    /** 犬猫。ラジオボタン。"DOG" / "CAT" が Species に自動で変換される */
    @NotNull(message = "犬猫を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Species species;

    /** 性別。ラジオボタン（オス / メス / 不明） */
    @NotNull(message = "性別を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Sex sex;

    /** 品種。プルダウン。任意（先頭の「不明」を選ぶと null） */
    private Integer breedId;

    /** 新しい品種。プルダウンに無いときだけ入力する。入力されていれば breedId より優先（Service が breeds に登録してから個体に付ける） */
    @Size(max = 50, message = "品種は50文字以内で入力してください")  // 文字数の上限。breeds.name が VARCHAR(50)
    private String newBreedName;

    /** 誕生日。任意 */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)  // チェックではなく変換の指定。<input type="date"> が送る "2026-09-30" を LocalDate にする
    @PastOrPresent(message = "未来の日付は指定できません")       // 今日までの日付だけ通す（未来はエラー）。未入力は通す
    private LocalDate birthday;

    /** 誕生日が推定かどうか。チェックボックス。初期値は true（推定）にして画面を出す */
    private Boolean isBirthdayEstimated;

    /** 保護日 */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)  // チェックではなく変換の指定。<input type="date"> が送る "2026-09-30" を LocalDate にする
    @NotNull(message = "保護日を入力してください")              // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    @PastOrPresent(message = "未来の日付は指定できません")       // 今日までの日付だけ通す（未来はエラー）。未入力は通す
    private LocalDate intakeDate;

    /** 保護場所 */
    @NotBlank(message = "保護場所を入力してください")               // 文字列用の必須チェック。null・空文字・空白だけ、を全部エラーにする
    @Size(max = 50, message = "保護場所は50文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String intakePlace;

    /** 保護方法 */
    @NotBlank(message = "保護方法を入力してください")               // 文字列用の必須チェック。null・空文字・空白だけ、を全部エラーにする
    @Size(max = 30, message = "保護方法は30文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String intakeMethod;

    /** 保護状況。プルダウン（8 つ） */
    @NotNull(message = "保護状況を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Status status;

    /** 里親。プルダウン。保護状況がトライアル中・譲渡済のときだけ必須（Service で調べる）。それ以外の状況では Service が null にして保存する */
    private Integer adopterId;

    /** 避妊去勢。ラジオボタン（済 / 未 / 不明）。"DONE" などが NeuterStatus に自動で変換される */
    @NotNull(message = "避妊去勢を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private NeuterStatus neutered;

    /** 混合ワクチン。ラジオボタン（済 / 未） */
    @NotNull(message = "混合ワクチンを選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Boolean comboVaccine;

    /** 狂犬病ワクチン。ラジオボタン（済 / 未）。犬のときだけ表示する。猫なら未入力でよく、Service が false にして保存する（決定 2-5） */
    private Boolean rabiesVaccine;

    /** マイクロチップ番号。任意 */
    @Pattern(regexp = "^$|^[0-9]{15}$", message = "マイクロチップ番号は15桁の数字で入力してください")  // 正規表現に合わないとエラー。先頭の ^$| は「空ならOK、入っていれば形式を調べる」の意味
    private String microchipNo;

    /** 健康に関する特記事項。任意 */
    @Size(max = 2000, message = "2000文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String healthNotes;

    /** その他の特記事項。任意 */
    @Size(max = 2000, message = "2000文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String notes;

    /** 写真。任意。ファイルを選ばなければ変更しない。種類は Service で調べる。5MB を超えると Spring が 413 エラーにする（application.properties） */
    private MultipartFile photo;

}
