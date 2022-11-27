package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;
import com.spring.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{
		
	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;
		
	@Override	
	public int register(ReplyVO vo) {
		log.info("register........." + vo);
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("get........" + rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("modify......." + vo);
		return mapper.update(vo);    
	}

	@Override
	public int remove(Long rno) {
		log.info("remove......" + rno);
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bdnum) {
		log.info("get Reply List of a Board " + bdnum);
		return mapper.getListWithPaging(cri, bdnum);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bdnum) {
		return new ReplyPageDTO(mapper.getCountByBdnum(bdnum), mapper.getListWithPaging(cri, bdnum));
	}

}
