<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@include file="../includes/header.jsp"%>

<div class="container w-50">
	<!-- 글제목 -->
	<div class="row">
		<div class="form-group">
			<label style="font-size: 30px;" class="col-form-label mt-4"
				for="inputDefault">Title</label> <input type="text"
				class="form-control" name="bdtitle" value="${board.bdtitle }"
				readonly="readonly">
		</div>
	</div>
	<!-- 첨부이미지 공간 -->
	<div class="row mt-5" id="uploadResult">
	</div>
	<!-- 글내용 -->
	<div class="row">
		<div class="form-group">
			<label style="font-size: 30px;" for="exampleTextarea"
				class="form-label mt-4">Content</label>
			<textarea class="form-control" id="exampleTextarea" rows="10"
				name="content" readonly="readonly">${board.content }</textarea>
		</div>
	</div>



	<!-- 댓글부분 -->
	<div class="row mt-5">
		<div class="mb-1 text-lg-end text-center">
			<button type="button" class="btn btn-primary " style="width: 100px;"
				id='addReplyBtn'>new reply</button>
		</div>
		<ul class="list-group chat">
			<li
				class="list-group-item d-flex justify-content-between align-items-center"
				data-rno='12'>
				<div class="col-md-2">
					<h6></h6>
				</div>
				<div class="col-md-8">댓글이 존재하지 않습니다.</div>
				<div class="col-md-2"></div>
			</li>
		</ul>
	</div>

	<!-- 댓글페이징버튼 -->

	<div class="reply_pagebtn"></div>


	<!-- 버튼부분 -->

	<div class="row mb-5 mt-5">
		<div class="col-md-4 b">
			<button data-oper='modify' class="btn btn-lg btn-primary"
				style="width: 100%" type="button">Modify</button>
		</div>
		<div class="col-md-4 b">
			<button data-oper='remove' class="btn btn-lg btn-primary"
				style="width: 100%" type="button">Delete</button>
		</div>
		<div class="col-md-4 b">
			<button data-oper='list' class="btn btn-lg btn-primary"
				style="width: 100%" type="button">List</button>
		</div>
		<form id='operForm' action="/board/modify" method="get">
			<input type='hidden' id='bdnum' name='bdnum'
				value='<c:out value="${board.bdnum }"/>'> <input
				type='hidden' name='pageNum'
				value='<c:out value="${cri.pageNum }"/>'> <input
				type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'>
			<input type='hidden' name='keyword'
				value='<c:out value="${cri.keyword }"/>'> <input
				type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
		</form>
	</div>
</div>

<!-- 댓글 모달창 -->

<div class="modal" id="myModal">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">REPLY DETAIL</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true"></span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label class="col-form-label mt-4" for="inputDefault">Reply</label>
					<input type="text" class="form-control" placeholder="Default input"
						id="inputDefault" name='reply' value='New Reply!!!'>
				</div>
				<div class="form-group">
					<label class="col-form-label mt-4" for="inputDefault">Reply</label>
					<input type="text" class="form-control" placeholder="Default input"
						id="inputDefault" name='replyer' value='testreplyer'>
				</div>
				<input type="hidden" name="replyDate" value=''>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id='modalModBtn'>Modify</button>
				<button type="button" class="btn btn-secondary" id='modalRemoveBtn'>Remove</button>
				<button type="button" class="btn btn-primary" id='modalRegisterBtn'>Register</button>
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal" id='modalCloseBtn'>Close</button>
			</div>
		</div>
	</div>
</div>



<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
//첨부파일 이미지 가져오는 js
	$(document).ready(function(){
							(function() {
								const bdnum='<c:out value="${board.bdnum}"/>';
								
								$.getJSON("/board/getAttachList",{bdnum:bdnum},function(arr){
									console.log(arr);
									
									//첨부이미지가 여러개일 경우 부트스트랩 이용 이미지 슬라이드 기능 적용
									let str="";
									str+='<div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">';
									str+='<div class="carousel-inner">';
									
									$(arr).each(function(i,attach){
										
										var filePath="${path}/resources/img/" + attach.uploadPath + "\\" + attach.uuid + "_" +attach.fileName;
										console.log(filePath);
										str+='<div class="carousel-item active">';
										str+='<img src="' + filePath + '" class="d-block w-100 rounded img-fluid" alt="...">';
										str+='</div>';
										
									})
										str+='</div>';
										
										//사진이 한개면 화살표 버튼(<,>)이 뜨지않게함
									if(arr.length!==1){
										str+='<button class="carousel-control-prev arrow" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">';
										str+='<span class="carousel-control-prev-icon" aria-hidden="true"></span>';
										str+='<span class="visually-hidden">Previous</span>';
										str+='</button>';
										str+='<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">';
										str+='<span class="carousel-control-next-icon" aria-hidden="true"></span>';
										str+='<span class="visually-hidden">Next</span>';
										str+='</button>';
										str+='</div>';
									}
									console.log(str);
									console.log("arr길이:" + arr.length);
									
									$("#uploadResult").html(str);
								});//end getjson
							})();//end function
	});
</script>

<script type="text/javascript">
	$(document).ready(function() {

						const bdnumValue = '<c:out value="${board.bdnum}"/>';
						const replyUL = $(".chat");
						const replyPageFooter = $(".reply_pagebtn");
						let pageNum = 1;

						showList(1);

						//파라미터로 전달되는 page변수를 이용해서 원하는 댓글페이지를 가져오는 함수
						function showList(page) {

							console.log("show List " + page);

							replyService
									.getList(
											{
												bdnum : bdnumValue,
												page : page || 1
											},
											function(replyCnt, list) {
												console.log("replyCnt : "
														+ replyCnt);
												console.log("list: " + list);
												console.log(list);

												//사용자가 새로운 댓글 추가하면 showList(-1); 을 호출하여 우선 전체댓글의 숫자 파악한 뒤, 마지막 페이지로 이동.
												if (page == -1) {
													//마지막 페이지 호출 (replyCnt->총댓글개수)
													pageNum = Math
															.ceil(replyCnt / 5.0);
													showList(pageNum);
													return;
												}
												let str = "";
												if (list == null
														|| list.length == 0) {
													//댓글이 없으면 댓글창 안보이게 설정
													replyUL.hide();
													//$('#addReplyBtn').hide();
													return;
												}
												for (let i = 0, len = list.length || 0; i < len; i++) {
													str += "<li class='list-group-item d-flex justify-content-between align-items-center' data-rno='" + list[i].rno + "'>";
													str += "<div class='col-md-2'><h6>"
															+ list[i].replyer
															+ "</h6></div>";
													str += "<div class='col-md-9'style='cursor:pointer'>"
															+ list[i].reply
															+ "</div>";
													str += "<div class='col-md-1'>"
															+ replyService
																	.displayTime(list[i].replyDate)
															+ "</div>";
												}
												console.log(str);
												replyUL.html(str);
												showReplyPage(replyCnt);
											});
						}

						//페이징적용한 버튼 보여주기
						function showReplyPage(replyCnt) {

							let endNum = Math.ceil(pageNum / 5.0) * 5;

							//전체댓글개수가 적어서 5페이지가 안나올 것 같은 경우 endNum 조정.
							if (replyCnt < 20) {
								endNum = Math.ceil(replyCnt / 5.0)
							}

							console.log("replyCnt:" + replyCnt);
							console.log(pageNum);
							console.log(endNum);

							let startNum = endNum - 4;

							//전체댓글개수가 적은 경우 startNum도 조정.
							if (endNum < 5) {
								startNum = 1;
							}

							console.log('startNum:' + startNum);

							let prev = startNum !== 1;
							let next = false;

							if (endNum * 5 >= replyCnt) {
								endNum = Math.ceil(replyCnt / 5.0);
							}

							if (endNum * 5 < replyCnt) {
								next = true;
							}

							let str = "<ul class='pagination pagination-sm'>";

							if (prev) {
								console.log("prev: " + prev)
								str += "<li class='page-item' id='prev_btn'><a class='page-link' href='"
										+ (startNum - 1) + "'>&laquo;</a></li>";
							}

							for (let i = startNum; i <= endNum; i++) {
								const active = pageNum === i ? 'active' : '';

								str += "<li class='page-item " + active + " '><a class='page-link' href='" + i + "'>"
										+ i + "</a></li>";
							}

							if (next) {
								console.log("next: " + next)
								str += "<li class='page-item' id='next_replybtn'><a class='page-link' href='"
										+ (endNum + 1) + "'>&raquo;</a></li>";
							}

							str += "</ul></div>";

							console.log(str);

							replyPageFooter.html(str);
						}

						//페이징 버튼 클릭시 이벤트
						replyPageFooter.on("click", "li a", function(e) {
							e.preventDefault(); //a의 본래기능 막기
							console.log("page click");

							let targetPageNum = $(this).attr("href");

							console.log("targetPageNum: " + targetPageNum);

							pageNum = targetPageNum;

							showList(pageNum);
						})

						//댓글모달창
						const modal = $(".modal");
						const modalInputReply = modal
								.find("input[name='reply']");
						const modalInputReplyer = modal
								.find("input[name='replyer']");
						const modalInputReplyDate = modal
								.find("input[name='replyDate']");

						const modalModBtn = $("#modalModBtn");
						const modalRemoveBtn = $("#modalRemoveBtn");
						const modalRegisterBtn = $("#modalRegisterBtn");

						//새댓글등록 버튼클릭
						$("#addReplyBtn").on("click", function(e) {
							modal.find("input").val("");
							modal.find("button[id!='modalCloseBtn']").hide();

							modalRegisterBtn.show();

							$(".modal").modal("show");

						});
						//모달창 안 댓글등록
						modalRegisterBtn.on("click", function(e) {

							const reply = {
								reply : modalInputReply.val(),
								replyer : modalInputReplyer.val(),
								bdnum : bdnumValue
							};

							replyService.add(reply, function(result) {

								//alert창
								Swal.fire({
									icon : 'success',
									title : result,
									showConfirmButton : false,
									timer : 1500
								})

								modal.find("input").val("");
								modal.modal("hide");

								//새댓글 등록하면 마지막 댓글페이지로 이동.
								showList(-1);
							});
						});

						$(".chat").on("click","li",function(e) {
							const rno = $(this).data("rno");
							console.log(rno);

							replyService.get(rno,function(reply) {
										modalInputReply.val(reply.reply);
										modalInputReplyer.val(reply.replyer);
										modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
										modal.data("rno",reply.rno);

										modal.find("button[id!='modalCloseBtn']").hide();
										modalModBtn.show();
										modalRemoveBtn.show();

										$(".modal").modal("show");
												})
											})

						//맨아래 수정,삭제,리스트 버튼들
						const operForm = $("#operForm");

						$("button[data-oper='modify']").on(
								"click",
								function(e) {
									operForm.attr("action", "/board/modify")
											.attr("method", "get").submit();
								});

						$("button[data-oper='list']").on("click", function(e) {
							operForm.find("#bdnum").remove()
							operForm.attr("action", "/board/list");
							operForm.submit();
						});

						$("button[data-oper='remove']").on(
								"click",
								function(e) {
									operForm.attr("action", "/board/remove")
											.attr("method", "post").submit();
								});

						//모달창 댓글수정
						modalModBtn.on("click", function(e) {
							let reply = {
								rno : modal.data("rno"),
								reply : modalInputReply.val()
							};

							replyService.update(reply, function(result) {
								Swal.fire({
									icon : 'success',
									title : result,
									showConfirmButton : false,
									timer : 1500
								})
								modal.modal("hide");
								showList(pageNum);
							});
						});

						//모달창 댓글삭제 버튼 누르면
						modalRemoveBtn.on("click", function(e) {
							const rno = modal.data("rno");

							replyService.remove(rno, function(result) {
								Swal.fire({
									icon : 'success',
									title : result,
									showConfirmButton : false,
									timer : 1500
								})
								modal.modal("hide");
								showList(pageNum);
							});
						});
						

					});
</script>


</body>
</html>