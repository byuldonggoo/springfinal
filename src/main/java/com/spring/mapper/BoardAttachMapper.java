package com.spring.mapper;

import java.util.List;

import com.spring.domain.BoardAttachVO;

public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	//게시물의 번호를 이용해서 BoardAttachVO타입으로 변환
	public List<BoardAttachVO> findByBdnum(Long bdnum);

	public void deleteAll(Long bdnum);
	
	//어제등록된 이미지파일의 목록 가져옴
	public List<BoardAttachVO> getOldFiles();
	
}
