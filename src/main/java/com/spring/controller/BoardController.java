package com.spring.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.domain.PageDTO;
import com.spring.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	
	//메인 게시판 화면불러오기
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list: "+cri);
		//모델에 저장된 게시글 리스트 List<BoardVO> 저장
		model.addAttribute("list",service.getList(cri));
		
		//전체 게시글의 개수
		int total=service.getTotal(cri);
		
		log.info("total: " + total);
		
		
		model.addAttribute("pageMaker",new PageDTO(cri, total));
		
	}
	
	@GetMapping("/register")
	public void register() {
		//입력페이지를 보여주는 역할만을 하기 때문에 별도의 처리가 필요하지 않음.
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("=========================");
		log.info("register:" + board);
		//첨부파일 이미지 출력
		if(board.getAttachList()!=null) {
			board.getAttachList().forEach(attach->log.info(attach));
		}
		log.info("=========================");
		service.register(board);
		//글번호 넘겨주기(모달창)
		rttr.addFlashAttribute("result",board.getBdnum());
		return "redirect:/board/list";
	}
	
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bdnum")Long bdnum, @ModelAttribute("cri") Criteria cri, Model model) {
		
		log.info("/get or modify");
		model.addAttribute("board",service.get(bdnum));
	}
	
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify=" + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result","success");
		}
		
		
		
		return "redirect:/board/list"+ cri.getListLink();
	}
	
	@PostMapping("/remove")
	public String remove(@RequestParam("bdnum") Long bdnum, @ModelAttribute("cri") Criteria cri ,RedirectAttributes rttr) {
		log.info("remove..." + bdnum);
		
		List<BoardAttachVO> attachList = service.getAttachList(bdnum);
		
		if(service.remove(bdnum)) {//delete 성공하면
			
			//이미지 지우는 메소드
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result","success");
		}
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	
	//특정게시물 번호를 이용해 첨부파일관련 데이터를 JSON으로 반환
	@GetMapping(value="/getAttachList",
			produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
		@ResponseBody
		public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bdnum){
		
		log.info("getAttachList " + bdnum);
		
		return new ResponseEntity<>(service.getAttachList(bdnum),HttpStatus.OK);
	}
	
	//첨부 이미지 지우기
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList==null||attachList.size()==0) {
			return;
		}
		
		log.info("delete attach files..................");
		log.info(attachList);
		
		attachList.forEach(attach->{
			try {
				//이미지 지우기
				Path file = Paths.get("D:\\Final\\finalproject\\src\\main\\webapp\\resources\\img\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				System.out.println(file);
				//섬네일 이미지도 지우기
				Path thumbNail = Paths.get("D:\\Final\\finalproject\\src\\main\\webapp\\resources\\img\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				Files.delete(thumbNail);
			
		}catch(Exception e) {
			log.error("delete file error" + e.getMessage());
		}
		});
	}

}
