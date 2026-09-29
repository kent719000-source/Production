package com.example.hogotaro.form;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdopterSearchForm {
	
	private String name;	// 名前（部分一致・任意）
	private String phoneNumber;		// 電話番号（部分一致・任意）
	
	public String getName() {return name;}
	public void setName(String name) {this.name = name;}
	
	public String getPhoneNumber() {return phoneNumber;}
	public void setPhoneNumber(String phoneNumber) {this.phoneNumber = phoneNumber;}

}
