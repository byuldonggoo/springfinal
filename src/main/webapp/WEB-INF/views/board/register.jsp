<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp" %>

    <div class="container mt-5">
    <h1 class="text-center" style="font-size:50px;">Register</h1>
    </div>
    <form role="form" action="/board/register" method="post" id="registerform">
    <div class="container w-50">
        <div class="row">
            <div class="form-group">
                <label style="font-size:30px;" class="col-form-label mt-4" for="inputDefault">Title</label>
                <input type="text" class="form-control" placeholder="" name="bdtitle">
              </div>
              <div class="form-group">
                <label style="font-size:30px;" for="exampleTextarea" class="form-label mt-4">Content</label>
                <textarea class="form-control" id="exampleTextarea" rows="10" name="content"></textarea>
              </div>
              
              <!-- 파일 첨부 -->
              
              <div class="row mt-5 uploadResult">
				</div>
              
              <div class="form-group">
			      <label for="formFile" class="form-label mt-4" style="font-size:30px;">Image attach</label>
			      <!-- accept는 이미지파일 올리도록 유도 설정 -->
			      <input class="form-control" type="file" id="formFile" name='uploadFile' multiple="multiple" accept="image/*" required>
			  </div>
			  
			  
              
              <input type="hidden" name="writer" value="나중에"/><!-- 로그인하면 닉네임으로 작성자넣기 -->
              <input type="hidden" name="delcheck" value="N"/>
              <div class="mt-5">
                <div class="d-grid gap-2">
                    <button class="btn btn-lg btn-primary" type="submit">Submit</button>
                </div>
            </div>
        </div>
    </div>
    </form>
    
    <script>
    
    	$(document).ready(function(e){
    		const formObj=$("form[role='form']");
    		
    		$("button[type='submit']").on("click",function(e){
    			e.preventDefault();
    			console.log("submit clicked");
    			
    			let str="";
    			
    			//첨부파일 정보를 hidden input에 넣어서 폼태그가 submit될 때 같이 전송
    			$(".uploadResult li").each(function(i, obj){
    				let jobj=$(obj);
    				console.dir(jobj);
    				
    				str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
    				str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
    				str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
    			});
    			formObj.append(str).submit();
    		}); //end buttontype submit click
    		
    		var regex = new RegExp("(.*?)\.(jpg|png)$");
    	 	const maxSize=5242880; //5MB
    	 	
    	 	//파일사이즈 체크
    	 	function checkExtension(fileName,fileSize){
    	 		
    	 		if(!regex.test(fileName)){
        	 		alert("jpg와 png파일만 업로드 가능합니다.");
        	 		return false;
        	 	}
    	 		
    	 		if(fileSize>=maxSize){
    	 			alert('파일 사이즈 초과');
    	 			return false;
    	 		}
    	 		return true;
    	 	}
    	 	
    	 	//첨부파일전송
    	 	$("input[type='file']").change(function(e){
    	 		const formData = new FormData();
    	 		const inputFile=$("input[name='uploadFile']");
    	 		const files=inputFile[0].files;
    	 		
    	 		for(let i = 0; i<files.length; i++){
    	 			//파일사이즈 체크
    	 			if(!checkExtension(files[i].name, files[i].size)){
    	 				return false;
    	 			}
    	 			//파일데이터를 formData에 추가한 뒤에 ajax를 통해서
    	 			//formData자체를 전송할 것
    	 			formData.append("uploadFile",files[i]);
    	 		}
    	 	
    			$.ajax({
    				url: '/uploadAjaxAction',
    				processData:false,
    				contentType:false,
    				data:formData,
    				type:'POST',
    				dataType:'json',
    				success:function(result){ //result는 list
    					console.log(result);
    					showUploadResult(result); //업로드 결과 처리 함수
    				}
    			});//$.ajax
    	 	});
    	 	
    	 	//list를 받음.
    	 	function showUploadResult(uploadResultArr){
    	 		if(!uploadResultArr || uploadResultArr.length===0) {return;}
    	 		
    	 		const uploadUL=$(".uploadResult");
    	 		
    	 		let str="";
    	 		
    	 		$(uploadResultArr).each(function(i,obj){
    	 			
    	 			//이미지 타입
    	 			//if(obj.image){
    	 				const fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName); //섬네일 이미지 경로
    	 				console.log(fileCallPath);
    	 				
    	 				str+="<li style='list-style:none;' data-path='"+obj.uploadPath+"'";
    	 				str+=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'";
    	 				str+=" ><div>";
    	 				str+="<span> "+obj.fileName + "</span>";
    	 				str+="<span><button type='button' class='btn btn-primary' data-file=\'"+ fileCallPath +"\' data-type='image'>X</button></span>";
    	 				str+="<img src='/display?fileName="+fileCallPath+"' class='img-thumbnail' style='width:130px; height:100px;'>";
    	 				str+="</div>";
    	 				str+="</li>";
    	 			//}
    	 		});
    	 		uploadUL.append(str);
    	 	}
    	 	
    	 	$(".uploadResult").on("click","button",function(e){
    	 		console.log("delete file");
    	 		
    	 		const targetFile=$(this).data("file");
    	 		const type=$(this).data("type");
    	 		
    	 		const targetLi = $(this).closest("li");
    	 		
    	 		$.ajax({
    	 			url:'/deleteFile',
    	 			data:{fileName:targetFile, type:type},
    	 			dataType:'text',
    	 			type:'POST',
    	 			success:function(result){
    	 				alert(result);
    	 				targetLi.remove();
    	 			}
    	 		})//$.ajax
    	 	})//uploadResult click
    	 	
    	});
    
    </script>
    
    </body>
