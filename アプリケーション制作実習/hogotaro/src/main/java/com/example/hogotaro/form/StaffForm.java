package com.example.hogotaro.form;

import java.time.LocalDate;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

import com.example.hogotaro.entity.Gender;

import lombok.Data;

/**
 * スタッフの登録・編集フォーム（S-17 / S-18、F-30 / F-32）。
 * ログインID・パスワードの必須判定は新規登録時にServiceで行い、
 * それ以外の項目はBean Validationでチェックする。
 */
@Data
public class StaffForm {

    /** ログインID。新規登録では必須（Service）。編集では変更しない */
    @Pattern(
            regexp = "^$|^[a-zA-Z0-9]{4,30}$",
            message = "ログインIDは半角英数字4〜30文字で入力してください")
    private String loginId;

    /** パスワード。新規登録ではServiceで必須、編集では空なら変更しない */
    @Pattern(
            regexp = "^$|^[!-~]{8,72}$",
            message = "パスワードは半角の英数字・記号8〜72文字で入力してください")
    private String password;

    /** ユーザー種別 */
    @NotNull(message = "ユーザー種別を選択してください")
    private Integer userTypeId;

    /** 名前 */
    @NotBlank(message = "名前を入力してください")
    @Size(max = 30, message = "名前は30文字以内で入力してください")
    private String name;

    /** 性別 */
    @NotNull(message = "性別を選択してください")
    private Gender gender;

    /** 生年月日 */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @NotNull(message = "生年月日を入力してください")
    @Past(message = "過去の日付を指定してください")
    private LocalDate birthday;

    /** 登録日。任意 */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @PastOrPresent(message = "未来の日付は指定できません")
    private LocalDate joinedDate;

    /** 住所。任意 */
    @Size(max = 100, message = "住所は100文字以内で入力してください")
    private String address;

    /** 電話番号 */
    @NotBlank(message = "電話番号を入力してください")
    @Size(max = 20, message = "電話番号は20文字以内で入力してください")
    @Pattern(
            regexp = "^$|^[0-9-]+$",
            message = "電話番号は数字とハイフンで入力してください")
    private String phoneNumber;

    /** メールアドレス。任意 */
    @Size(max = 255, message = "メールアドレスは255文字以内で入力してください")
    @Email(message = "メールアドレスの形式が正しくありません")
    private String email;

    /** 特記事項。任意 */
    @Size(max = 2000, message = "2000文字以内で入力してください")
    private String notes;
}
