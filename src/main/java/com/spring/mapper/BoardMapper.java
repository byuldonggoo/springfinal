package com.spring.mapper;

import java.util.List;

//import org.apache.ibatis.annotations.Select;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardMapper {
	
	public List<BoardVO> getList();

	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public void insert(BoardVO board);
	
	public void insertSelectKey(BoardVO board);
	
	public BoardVO read(Long bno);
	
	
	public int delete(Long bno);
	
	//몇개의 데이터가 수정되었는가를 처리할 수 있게
	//리턴타입은 int
	public int update(BoardVO board);
	
	public int getTotalCount(Criteria cri);
	
	

}
