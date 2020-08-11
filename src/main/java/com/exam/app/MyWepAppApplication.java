package com.exam.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages="com.exam")
public class MyWepAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(MyWepAppApplication.class, args);
	}

}
