package com.spring.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	//화면에 보여지는 페이지의 시작번호
	private int startPage;
	//화면에 보여지는 페이지의 끝번호
	private int endPage;
	//이전과 다음으로 이동 가능한 화살표 
	//눌러지는지 여부
	private boolean prev, next;
	
	private int total;
	private Criteria cri;
	
	public PageDTO(Criteria cri,int total) {
		this.total = total;
		this.cri = cri;
		
		//페이지번호는 5개씩 보여줄 것.
		this.endPage = (int)(Math.ceil(cri.getPageNum()/5.0))*5;
		//5개씩 보여줄 거니까 4를 뺀다.
		this.startPage=this.endPage-4;
		
		//전체데이터수를 이용해서 진짜끝페이지가 몇번까지인지 계산
		int realEnd=(int)(Math.ceil((total*1.0)/cri.getAmount()));
		
		//만일 realEnd가 더 작다면 realEnd가 endPage가 되게함.
		if(realEnd <this.endPage) {
			this.endPage=realEnd;
		}
		
		//<화살표는 startPage가 1보다 크다면 활성화
		this.prev=this.startPage>1;
		//<화살표는 realEnd가 endPage보다 큰 경웅만 활성화
		this.next=this.endPage<realEnd;
	}
}
