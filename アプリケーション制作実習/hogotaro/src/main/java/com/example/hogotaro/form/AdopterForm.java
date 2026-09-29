package com.example.hogotaro.form;

import java.time.LocalDate;

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
	@Notnull(message = "性別を選択してください")
	private Gender gender;
	
	// birthday
	@PastOrPresent(message = "未来の日付は指定できません")
	private LocalDate birthday;
	
	// address
	@Size(max = 100, message = "住所は100文字以内で入力してください")
	private String address;
	
	// phoneNumber
	@NotBlank(message = "電話番号を入力してください")
	@Size(max = 20, message = "電話番号は20文字以内で入力してください")
	private String phoneNumber;
	
	// email
	@Size(max = 255, message = "メールアドレスは255文字以内で入力してください")
	private String email;
	
	// notes
	@Size(max = 2000, message = "2000文字以内で入力してください")
	private String notes;

}
