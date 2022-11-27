package com.spring.domain;
import java.util.Date;
import lombok.Data;

@Data
public class ReplyVO {
	
	//PK
	private Long rno;
	//FK
	private Long bdnum;
	
	//댓글내용
	private String reply;
	//작성자
	private String replyer;
	//작성시간
	private Date replyDate;
	//수정시간
	private Date updateDate;
	
}
