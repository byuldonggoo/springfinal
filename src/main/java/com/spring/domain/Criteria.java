package com.spring.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	
	private int pageNum; //페이지번호
	private int amount; //한 페이지당 몇개의 데이터를 보여줄 것인지
	
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1,6);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum=pageNum;
		this.amount=amount;
	}
	
	public String[] getTypeArr() { //검색조건을 배열로 만들어서 한번에 처리하기 위한 것.
		return type==null ? new String[] {} : type.split("");
	}
	
	public String getListLink() {
		//UriComponentsBuilder는 쿼리스트링을 손쉽게 처리할 수 있는 클래스
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		
		return builder.toUriString();
	}
	

}
