package com.spring.domain;

import lombok.Data;

@Data
public class AttachFileDTO {

	private String fileName;//파일이름
	private String uploadPath;//업로드경로
	//중복파일이름은 방지하기 위한 uuid
	private String uuid;
	private boolean image;

}
