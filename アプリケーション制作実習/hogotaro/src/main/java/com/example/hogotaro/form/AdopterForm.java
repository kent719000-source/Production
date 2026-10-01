package com.example.hogotaro.form;

import java.time.LocalDate;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

import com.example.hogotaro.entity.Gender;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdopterForm {
	
	// name
	@NotBlank(message = "名前を入力してください")
	@Size(max = 30, message = "名前は30文字以内で入力してください")
	private String name;
	
	// gender
	@NotNull(message = "性別を選択してください")
	private Gender gender;
	
	// birthday
	@PastOrPresent(message = "未来の日付は指定できません")
	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE) // 「2026-10-01」の形（ISO 形式）で読む
	private LocalDate birthday;
	
	// address
	@Size(max = 100, message = "住所は100文字以内で入力してください")
	private String address;
	
	// phoneNumber
	@NotBlank(message = "電話番号を入力してください")
	@Size(max = 20, message = "電話番号は20文字以内で入力してください")
	@Pattern(regexp = "^$|^[0-9-]+$", message = "電話番号は数字とハイフンで入力してください")
	private String phoneNumber;
	
	// email
	@Size(max = 255, message = "メールアドレスは255文字以内で入力してください")
	@Email(message = "メールアドレスの形式が正しくありません")
	private String email;
	
	// notes
	@Size(max = 2000, message = "2000文字以内で入力してください")
	private String notes;

}
