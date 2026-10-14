package com.example.hogotaro;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class HogotaroApplication extends SpringBootServletInitializer {

	// 外部 Tomcat に WAR で載せたとき、Tomcat がここからアプリを起動する
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(HogotaroApplication.class);
	}

	// Eclipse から起動するときは今までどおりここから
	public static void main(String[] args) {
		SpringApplication.run(HogotaroApplication.class, args);
	}

}
