<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp" %>

<div class="container mt-5">
	<div class="row">
		<div class="col-md-2 mb-2" style="margin-left:1180px;">
		<button type="button" class="btn btn-primary btn-lg" id="regbtn" onclick="doAction()">새글 등록</button>
		</div>
	</div>
    <div class="row">
    <c:forEach items="${list}" var="board">
        <div class="col-md-4 b">
            <div class="card mb-3">
                <h3 class="card-header"><a class='move' href='<c:out value="${board.bdnum}"/>'><c:out value="${board.bdtitle}"/></a></h3>
                
                <div id="uploadResultlist">
                <img src='${path}/resources/img/<c:out value="${board.attachList[0].uploadPath}"/>/<c:out value="${board.attachList[0].uuid}"/>_<c:out value="${board.attachList[0].fileName}"/>' class="d-block user-select-none" width="100%" height="100%" aria-label="Placeholder: Image cap" focusable="false" role="img" preserveAspectRatio="xMidYMid slice" viewBox="0 0 318 180" style="font-size:1.125rem;text-anchor:middle">
                    <rect width="100%" height="100%" fill="#868e96"></rect>
                </img>
                
                
                </div>
                
            </div>
        </div>
        </c:forEach>
       
    </div>
</div>

<!-- 페이지번호 -->

<div class="container mb-5">
    <ul class="pagination float-end">
    
      <li id="prev" class="page-item"> <!-- disabled -->
        <a class="page-link page" href="${pageMaker.startPage -1 }">&laquo;</a>
      </li>
      
      <c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
      <li class="page-item ${pageMaker.cri.pageNum == num ? "active":"" }"> 
      <!-- 클릭한 페이지 클래스추가 active (검은색으로 바뀜)  -->
        <a class="page-link page" href="${num }">${num }</a>
      </li>
      </c:forEach>
      
      <li id="next" class="page-item">
        <a class="page-link page" href="${pageMaker.endPage +1 }">&raquo;</a>
      </li>
    </ul>
</div>

<form id='actionForm' action="/board/list" method='get'>
	<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum }'>
	<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
	<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'>
	<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
</form>

<!-- 모달창 -->

<div class="modal" id="listModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
          <span aria-hidden="true"></span>
        </button>
      </div>
      <div class="modal-body">
        <p>처리가 완료되었습니다.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary">Save changes</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

$(document).ready(function(){
	
	//모달창 글등록
	let result='<c:out value="${result}"/>';
	
	checkModal(result);
	
	history.replaceState({},null,null);
	
	function checkModal(result){
		if(result==='' || history.state){
			return;
		}
		if(parseInt(result)>0){
			$(".modal-body").html(
			"게시글 " + parseInt(result) + "번이 등록되었습니다.");
		}
		$("#listModal").modal("show");
	}
	
	//prev,next버튼 disabled 클래스추가 조건
	const prev='<c:out value="${pageMaker.prev}"/>';
	const next='<c:out value="${pageMaker.next}"/>';
	console.log(prev);
	console.log(next);
	prevcheck(prev);
	nextcheck(next);
	
	//페이지 < 버튼
	function prevcheck(prev){
		if(prev!=='true'){
			$("#prev").addClass('disabled');
		}
	}
	
	//페이지 > 버튼
	function nextcheck(next){
		if(next!=='true'){
			$("#next").addClass('disabled');
		}
	}
	
	//페이지번호 클릭
	const actionForm = $("#actionForm");
	$(".page").on("click",function(e){
		e.preventDefault();
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	//글제목클릭
	$(".move").on("click",function(e){
		e.preventDefault();
		
		actionForm.append("<input type='hidden' name='bdnum' value='" + $(this).attr("href") + "'>");  
		actionForm.attr("action","/board/get");
		actionForm.submit();
	});

});

</script>


</body>
</html>