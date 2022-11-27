package com.spring.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {

	@Setter(onMethod_ = { @Autowired })
	private BoardService service;

	@Test
	public void testExist() {

		log.info(service);
		assertNotNull(service);
	}
	
	@Test
	public void testRegister() {

		BoardVO board = new BoardVO();
		board.setBdtitle("새로 작성하는 제목");
		board.setContent("새로 작성하는 내용");
		board.setWriter("newbie");
		board.setDelcheck("N");

		service.register(board);

		log.info("생성된 게시물의 번호: " + board.getBdnum());
	}
	
	@Test
	public void testGet() {

		log.info(service.get(1L));
	}

	@Test
	public void testGetList() {

		//service.getList().forEach(board -> log.info(board));
		service.getList(new Criteria(2, 6)).forEach(board -> log.info(board));
	}
	
	@Test
	public void testDelete() {

		log.info("REMOVE RESULT: " + service.remove(2L));

	}

	@Test
	public void testUpdate() {

		BoardVO board = service.get(4L);

		if (board == null) {
			return;
		}

		board.setBdtitle("제목 수정합니다.");
		log.info("MODIFY RESULT: " + service.modify(board));
	}


}
