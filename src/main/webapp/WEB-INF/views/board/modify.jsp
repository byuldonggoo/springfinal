<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../includes/header.jsp" %>

    <div class="container mt-5">
    <h1 class="text-center" style="font-size:50px;">Modify</h1>
    </div>
    <form action="/board/modify" method="post" id="modifyform">
    <div class="container w-50">
        <div class="row">
             <div class="form-group">
                <label style="font-size:30px;" class="col-form-label mt-4" for="inputDefault">Title</label>
                <input type="text" class="form-control" name="bdtitle" value="${board.bdtitle }">
              </div>
              <div class="form-group">
                <label style="font-size:30px;" for="exampleTextarea" class="form-label mt-4">Content</label>
                <textarea class="form-control" id="exampleTextarea"rows="10" name="content">${board.content }</textarea>
              </div>
              
              <div class="row mt-5 uploadResult">
             
				</div>
              
              <div class="form-group">
			      <label for="formFile" class="form-label mt-4" style="font-size:30px;">Image attach</label>
			      <!-- accept는 이미지파일 올리도록 유도 설정 -->
			      <input class="form-control" type="file" id="formFile" name='uploadFile' multiple="multiple" accept="image/*">
			  </div>
              
              <input type="hidden" name="writer" value="나중에"/><!-- 로그인하면 닉네임으로 작성자넣기 -->
              <input type="hidden" name="delcheck" value="N"/>
              <input type="hidden" name="bdnum" value='<c:out value ="${board.bdnum }"/>'/>
              <input type="hidden" name="pageNum" value='<c:out value ="${cri.pageNum }"/>'/>
              <input type="hidden" name="amount" value='<c:out value ="${cri.amount }"/>'/>
              <input type="hidden" name="type" value='<c:out value ="${cri.type }"/>'/>
              <input type="hidden" name="keyword" value='<c:out value ="${cri.keyword }"/>'/>
              
              <div class="row mt-5">
            <div class="col-md-4 b">
            	<div class="d-grid gap-2">
                    <button data-oper='modify' class="btn btn-lg btn-primary modbtn" type="submit">Modify</button>
                </div>
			</div>
            <div class="col-md-4 b">
            	<div class="d-grid gap-2">
                    <button data-oper='remove' class="btn btn-lg btn-primary modbtn" type="submit">Delete</button>
                </div>
            </div>
            <div class="col-md-4 b">
            	<div class="d-grid gap-2">
                    <button data-oper='list' class="btn btn-lg btn-primary modbtn" type="submit">List</button>
                </div>
            </div>
        	</div>
              
        </div>
    </div>
    </form>
   
  	<script type="text/javascript">
  	
  		$(document).ready(function(){
  			
			const formObj = $("#modifyform");
  			
  			//버튼 클릭 (modify, remove, list)
  			$('button').on("click",function(e){
  				e.preventDefault(); 
  			
  			let operation=$(this).data("oper");
  			
  			console.log(operation);
  			
  			if(operation==='remove'){
  				formObj.attr("action","/board/remove");
  			
  			}else if(operation==='list'){
  				formObj.attr("action","/board/list").attr("method","get");
  				
  				const pageNumTag = $("input[name='pageNum']").clone();
  				const amountTag = $("input[name='amount']").clone();
  				const keywordTag = $("input[name='keyword']").clone();
  				const typeTag = $("input[name='type']").clone();
  				
  				formObj.empty();
  				
  				formObj.append(pageNumTag);
  				formObj.append(amountTag);
  				formObj.append(keywordTag);
  				formObj.append(typeTag);
  			
  			}else if(operation==='modify'){
  				console.log("submit clicked");
  				
  				let str="";
  				
  				$(".uploadResult li").each(function(i,obj){
  					
  					let jobj=$(obj);
  					console.dir(jobj);
  					
  					str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
    				str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
    				str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
    				
    				console.log(str);
  				});
  				formObj.append(str).submit();
  			}
  			formObj.submit();
  			});
  			
  			//이미지 첨부파일 띄워주는 부분
  			(function(){
  				let bdnum='<c:out value="${board.bdnum}"/>';
  				
  				//이미지 첨부파일 json으로 받아옴.
  				$.getJSON("/board/getAttachList",{bdnum:bdnum},function(arr){
  					console.log(arr);
  					
  					let str="";
  					
  					$(arr).each(function(i,attach){
  					
  	    	 				const fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName); //섬네일 이미지 경로
  	    	 				console.log(fileCallPath);
  	    	 				
  	    	 				str+="<li style='list-style:none;' data-path='"+attach.uploadPath+"'";
  	    	 				str+=" data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.image+"'";
  	    	 				str+=" ><div>";
  	    	 				str+="<span> "+attach.fileName + "</span>";
  	    	 				str+="<span><button type='button' class='btn btn-primary' data-file=\'"+ fileCallPath +"\' data-type='image'>X</button></span>";//x버튼
  	    	 				str+="<img src='/display?fileName="+fileCallPath+"' class='img-thumbnail' style='width:130px; height:100px;'>";
  	    	 				str+="</div>";
  	    	 				str+="</li>";
  						
  					});
  					$(".uploadResult").html(str);
  				});
  			})();//end function
  			
  			//x버튼 누르면 일단 화면에서만 사라지게(나중에 modify누르면 진짜로 삭제되게 하려고)
  			$(".uploadResult").on("click","button",function(e){
  				console.log("delete file");
  				
  				if(confirm("Remove this file?")){
  					var targetLi=$(this).closest("li");
  					targetLi.remove();
  				}
  			});
  			
  			var regex = new RegExp("(.*?)\.(jpg|png)$");
    	 	const maxSize=5242880; //5MB
    	 	
    	 	//확장자 체크
    	 	
    	 
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
    	 	
    	 	$("input[type='file']").change(function(e){
    	 		const formData = new FormData();
    	 		const inputFile=$("input[name='uploadFile']");
    	 		const files=inputFile[0].files;
    	 		
    	 		for(let i = 0; i<files.length; i++){
    	 			if(!checkExtension(files[i].name, files[i].size)){
    	 				return false;
    	 			}
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
  		
  			
  			
  			
  			
  		});
  	</script>
    </body>
