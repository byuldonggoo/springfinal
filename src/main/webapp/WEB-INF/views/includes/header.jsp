<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setHeader("Expires", "0"); // Proxies.
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${path}/resources/css/bootstrap.min.css">
     <script type="text/javascript" src="${path}/resources/js/jquery-3.6.0.min.js"></script>
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<style>

@import url('https://fonts.googleapis.com/css2?family=Poor+Story&display=swap');

html{
        font-family: 'Poor Story', sans-serif;
  }

 h3{
        font-family: 'Poor Story', sans-serif;
        font-size:27px;
  }
 #regbtn{
 font-family: 'Poor Story', sans-serif;
 font-size:20px;
 }
 #regbtn:hover{
 opacity:0.7;
 }
 
 a{
 	text-decoration: none;
 }
 
 a:hover{
 	text-decoration:underline;
 }

textarea {
    width: 100%;
    height: 6.25em;
    border: none;
    resize: none;
  }

</style>  

<script type="text/javascript">

function doAction() {
	const registerButton = document.getElementById("regbtn");
	registerButton.addEventListener('click', () => {
		location.href ='/board/register';
	    });
  };

</script>

    
</head>
<body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.min.js" integrity="sha384-IDwe1+LCz02ROU9k972gdyvl+AESN10+x7tBKgc9I5HFtuNz0wWnPclzo6p9vxnk" crossorigin="anonymous"></script>
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
        <!-- 홈페이지이름, 누르면 메인화면으로 이동 -->
          <a class="navbar-brand" href="/board/list">Navbar</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarColor01">
            <ul class="navbar-nav me-auto">
              <li class="nav-item">
                <a class="nav-link active" href="#">Home
                  <span class="visually-hidden">(current)</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Features</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">Pricing</a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">About</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Dropdown</a>
                <div class="dropdown-menu">
                  <a class="dropdown-item" href="#">Action</a>
                  <a class="dropdown-item" href="#">Another action</a>
                  <a class="dropdown-item" href="#">Something else here</a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item" href="#">Separated link</a>
                </div>
              </li>
            </ul>
            
            <!-- 검색 -->
            <form class="d-flex" id='searchForm' action="/board/list" method='get'>
	            <div class="form-group">
			      <select style="width:150px;" class="form-select" id="exampleSelect1" name='type'>
			        <option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':'' }"/>>Title</option>
			        <option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':'' }"/>>Content</option>
			        <option value="W" <c:out value="${pageMaker.cri.type eq 'W'?'selected':'' }"/>>Writer</option>
			        <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':'' }"/>>Title or Content</option>
			        <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW'?'selected':'' }"/>>Title or Writer</option>
			        <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC'?'selected':'' }"/>>All</option>
			      </select>
			    </div>
			    
              <input class="form-control me-sm-2" type="text" placeholder="Search" name='keyword' value='<c:out value="${pageMaker.cri.keyword }"/>'/>
              <input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum }"/>'>
              <input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount }"/>'>
              <button id="searchButton" class="btn btn-secondary my-2 my-sm-0" type="submit">Search</button>
            </form>
            <!-- 검색끝 -->
            
          </div>
        </div>
      </nav>
      
      <script type="text/javascript"src="${path}/resources/js/searchForm.js"></script>