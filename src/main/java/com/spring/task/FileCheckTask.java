//잘못업로드된 파일 체크 클래스
package com.spring.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.domain.BoardAttachVO;
import com.spring.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_= {@Autowired})
	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal=Calendar.getInstance();
		//어제날짜 가져오기
		cal.add(Calendar.DATE, -1);
		String str=sdf.format(cal.getTime());
		//File.separator->실행 중인 OS에 해당하는 구분자를 리턴.
		return str.replace("-", File.separator);
	}
	
	//매일 새벽 2시에 동작
	@Scheduled(cron="0 0 2 * * *")
	public void checkFiles() throws Exception{
		log.warn("파일 체크 run............");
		log.warn(new Date());
		
		//DB 파일목록(어제등록파일)
		List<BoardAttachVO> fileList= attachMapper.getOldFiles();
		
		//(어제)이미지파일 목록 java.nio.Paths목록으로 변환 
		List<Path> fileListPaths=fileList.stream().map(vo->Paths.get("D:\\Final\\finalproject\\src\\main\\webapp\\resources\\img",vo.getUploadPath(),vo.getUuid()+"_"+vo.getFileName()))
				.collect(Collectors.toList());
		log.warn(fileListPaths);
		
		//섬네일
		fileList.stream().map(vo->Paths.get("D:\\Final\\finalproject\\src\\main\\webapp\\resources\\img",vo.getUploadPath(),"s_"+vo.getUuid()+"_"+vo.getFileName()))
		.forEach(p->fileListPaths.add(p));
		
		log.warn("=============================================");
		
		fileListPaths.forEach(p->log.warn(p));
		
		//어제날짜폴더(실제 폴더에 있는 파일들 목록)
		File targetDir=Paths.get("D:\\Final\\finalproject\\src\\main\\webapp\\resources\\img",getFolderYesterDay()).toFile();
		
		//실제폴더파일목록에서 DB에 없는 파일들을 찾아서 목록으로 준비
		File[] removeFiles=targetDir.listFiles(file->fileListPaths.contains(file.toPath())==false);
		
		log.warn("--------------------------------------");
		//삭제
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
	}
	

}
