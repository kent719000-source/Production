package com.example.hogotaro.form;

import com.example.hogotaro.entity.Gender;
import jakarta.validation.constraints.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

/**
 * スタッフの登録・編集フォーム（S-17 / S-18、F-30 / F-32）の入力を受けるクラス【土台】。項目と入力チェックだけ入っている。
 *
 * ■ 使い方
 *   Controller: public String create(@Validated @ModelAttribute("staffForm") StaffForm form, BindingResult result, ...)
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
 *
 * ■ このフォームだけの注意
 *   ログイン ID とパスワードは、新規登録では必須。編集ではログイン ID は変更できず（画面に入力欄を出さない。値が届いても Service が使わない）、
 *   パスワードは「空なら変更しない」。同じ Form を使うので、アノテーションでは形式だけ調べ（空は通す）、
 *   必須かどうかは Service が新規 / 編集を見て調べる。
 *   パスワードは平文で受け、Service が passwordEncoder.encode() でハッシュにしてから保存する。Form や Entity にハッシュ前の値を残さない。
 *   ログイン ID の重複（existsByLoginId）も Service で調べる。
 *   新規登録・編集の画面を開けるのは管理ユーザーだけ（SecurityConfig。決定 2-14）なので、ユーザー種別も含めて全項目を変えられる。
 *   ただし自分自身のユーザー種別だけは、Service が変更を断って userTypeId にエラーを乗せる。
 */
@Data   // Lombok: getter / setter などをまとめて作る。Form は DB と関係ないので @Data でよい（Entity には付けない）
public class StaffForm {

    /** ログインID。新規登録では必須（Service で調べる）。編集では変更できない（画面に文字で出すだけ） */
    @Pattern(regexp = "^$|^[a-zA-Z0-9]{4,30}$", message = "ログインIDは半角英数字4〜30文字で入力してください")  // 正規表現に合わないとエラー。先頭の ^$| は「空ならOK、入っていれば形式を調べる」の意味
    private String loginId;

    /** パスワード。新規登録では必須（Service で調べる）。編集では空なら変更しない。72 文字は BCrypt の上限 */
    @Pattern(regexp = "^$|^.{8,72}$", message = "パスワードは8〜72文字で入力してください")  // 正規表現に合わないとエラー。先頭の ^$| は「空ならOK、入っていれば形式を調べる」の意味
    private String password;

    /** ユーザー種別。プルダウン */
    @NotNull(message = "ユーザー種別を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Integer userTypeId;

    /** 名前 */
    @NotBlank(message = "名前を入力してください")               // 文字列用の必須チェック。null・空文字・空白だけ、を全部エラーにする
    @Size(max = 30, message = "名前は30文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String name;

    /** 性別。ラジオボタン（男性 / 女性 / その他） */
    @NotNull(message = "性別を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Gender gender;

    /** 生年月日 */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)  // チェックではなく変換の指定。<input type="date"> が送る "2026-09-30" を LocalDate にする
    @NotNull(message = "生年月日を入力してください")             // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    @Past(message = "過去の日付を指定してください")               // 昨日までの日付だけ通す（今日と未来はエラー）。未入力は通す
    private LocalDate birthday;

    /** 登録日（団体にスタッフとして登録した日）。任意。DB の created_at（自動）とは別で、画面から入力する */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)  // チェックではなく変換の指定。<input type="date"> が送る "2026-09-30" を LocalDate にする
    @PastOrPresent(message = "未来の日付は指定できません")       // 今日までの日付だけ通す（未来はエラー）。未入力は通す
    private LocalDate joinedDate;

    /** 住所。任意 */
    @Size(max = 100, message = "住所は100文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String address;

    /** 電話番号 */
    @NotBlank(message = "電話番号を入力してください")                                  // 文字列用の必須チェック。null・空文字・空白だけ、を全部エラーにする
    @Size(max = 20, message = "電話番号は20文字以内で入力してください")                     // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    @Pattern(regexp = "^$|^[0-9-]+$", message = "電話番号は数字とハイフンで入力してください")  // 正規表現に合わないとエラー。先頭の ^$| は「空ならOK、入っていれば形式を調べる」の意味
    private String phoneNumber;

    /** メールアドレス。任意 */
    @Size(max = 255, message = "メールアドレスは255文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    @Email(message = "メールアドレスの形式が正しくありません")                 // メールアドレスの形でないとエラー。未入力は通す
    private String email;

    /** 特記事項。任意 */
    @Size(max = 2000, message = "2000文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String notes;

}
