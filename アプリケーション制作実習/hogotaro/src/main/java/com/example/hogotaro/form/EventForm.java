package com.example.hogotaro.form;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * イベントの登録・編集フォーム（S-09 / S-10、F-15 / F-17）の入力を受けるクラス。項目と入力チェックだけ入っている。
 *
 * ■ 使い方
 *   Controller: public String create(@Validated @ModelAttribute("eventForm") EventForm form, BindingResult result, ...)
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
 *   未 / 済（done）と対応スタッフ（staff）は入力させない。変えるのは完了（F-18）と未対応に戻す（F-34）だけ。
 *   次の 2 つは「ほかの項目の値によって決まる」チェックなので、アノテーションでは書けない。EventService で調べる。
 *     ・種別がトライアル開始・譲渡のときは里親が必須（決定 1-9）
 *     ・個体が猫なら、種別に狂犬病ワクチンは選べない（決定 2-5）
 *   イベントを登録・編集・完了にしても、個体の情報は変わらない（決定 2-18）。
 */
@Data   // Lombok: getter / setter などをまとめて作る。Form は DB と関係ないので @Data でよい（Entity には付けない）
public class EventForm {

    /** 日付。予定なので未来の日付でよい */
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)  // チェックではなく変換の指定。<input type="date"> が送る "2026-09-30" を LocalDate にする
    @NotNull(message = "日付を入力してください")               // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private LocalDate eventDate;

    /** 時刻。任意 */
    @DateTimeFormat(pattern = "HH:mm")  // チェックではなく変換の指定。<input type="time"> が送る "10:00" を LocalTime にする
    private LocalTime eventTime;

    /** 個体。プルダウン（選択肢は今世話をしている子 = Status.inCare() の 4 つ。決定 1-10） */
    @NotNull(message = "個体を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Integer animalId;

    /** 種別。プルダウン（通院・混合ワクチン・譲渡など 11 種類。選択肢は event_types テーブルの行） */
    @NotNull(message = "種別を選択してください")  // 必須チェック。null をエラーにする。ラジオ・プルダウン・日付・数値に使う（文字列は @NotBlank）
    private Integer eventTypeId;

    /** 場所。任意 */
    @Size(max = 100, message = "場所は100文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String place;

    /** 里親。プルダウン。種別がトライアル開始・譲渡のときだけ必須（Service で調べる） */
    private Integer adopterId;

    /** 費用（円）。任意 */
    @PositiveOrZero(message = "費用は0以上で入力してください")  // 0 以上の数だけ通す（負の数はエラー）。未入力は通す
    private Integer cost;

    /** 特記事項。任意 */
    @Size(max = 2000, message = "2000文字以内で入力してください")  // 文字数の上限。未入力（null・空文字）は通す。上限は DB の列の長さに合わせる
    private String notes;

}
