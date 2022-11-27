package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.mapper.BoardAttachMapper;
//import com.spring.domain.Criteria;
import com.spring.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service																						
public class BoardServiceImpl implements BoardService {
	
	@Setter(onMethod_=@Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;

	@Transactional
	@Override
	public void register(BoardVO board) {
		
		log.info("register......." + board);
		//먼저 main_board에 게시물 등록
		mapper.insertSelectKey(board);
		
		if(board.getAttachList()==null|| board.getAttachList().size()<=0) {
			return;
		}
		
		board.getAttachList().forEach(attach->{
			
			//게시물 번호 세팅
			attach.setBdnum(board.getBdnum());
			log.info(board.getBdnum());
			//tbl_attach테이블에 데이터 추가
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bdnum) {
		log.info("get......" + bdnum);
		
		return mapper.read(bdnum);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.........."+board);
		
		//일단 첨부이미지 다 지우고
		attachMapper.deleteAll(board.getBdnum());
		
		//board 내용 업데이트
		boolean modifyResult = mapper.update(board)==1;
		log.info(modifyResult);
		
		
		//지우지 않은 첨부이미지 다시 insert
		if(modifyResult && board.getAttachList()!=null && board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach->{
				attach.setBdnum(board.getBdnum());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	public boolean remove(Long bdnum) {
		log.info("remove......" + bdnum);
		attachMapper.deleteAll(bdnum);
		return mapper.delete(bdnum)==1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("get List with criteria: " + cri);
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		
		//첨부이미지 BoardVO 에 삽입
		list.forEach(board->{
			Long bdnum=board.getBdnum();
			List<BoardAttachVO> attachlist=attachMapper.findByBdnum(bdnum);
			board.setAttachList(attachlist);
		});
		
		return list;
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bdnum) {
		log.info("get Attach list by bdnum" + bdnum);
		return attachMapper.findByBdnum(bdnum);
	}
	
	

	
	
	
}
