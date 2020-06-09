<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<ul class="sidebar navbar-nav">
      <li class="nav-item active" id="active1">
        <a class="nav-link" href="index.jsp" id="admin">
	        <i class="fas fa-fw fa-tachometer-alt"></i>
	        <span>관리</span>
        </a>
      </li>
      <li class="nav-item dropdown" id="active3">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        <i class="fas fa-user-cog"></i>
	        <span>회원관리</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
		<a class="dropdown-item" href="member_List.jsp?grade=admin" name="officer" value="Nuser">직원관리</a>
		<a class="dropdown-item" href="member_List.jsp?grade=user" name="member" value="user">일반관리</a>

        </div>
      </li>
      
      <li class="nav-item dropdown" id="active3">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	        <i class="fas fa-store"></i>
	        <span>주문관리(신청서)</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
        <h6 class="dropdown-header">열린장터:</h6>
		<a class="dropdown-item" href="order_List.jsp">수아밀 제품 주문</a>
		<div class="dropdown-divider"></div>
		<a class="dropdown-item" href="request_List.jsp?bname=request">블루클리닝 견적 의뢰</a>
		<a class="dropdown-item" href="request_List.jsp?bname=apply">체험학습 신청서</a>

        </div>
      </li>
      
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		    <i class="fas fa-fw fa-table"></i>
		    <span>게시물 관리</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
	        <h6 class="dropdown-header">열린공간:</h6>
	        <a class="dropdown-item" href="board_List.jsp?bname=notice">공지사항</a>
	        <a class="dropdown-item" href="board_List.jsp?bname=calenboard">프로그램일정</a>
	        <a class="dropdown-item" href="board_List.jsp?bname=freeboard">자유게시판</a>
	        <a class="dropdown-item" href="board_List.jsp?bname=photoboard">사진게시판</a>
	        <a class="dropdown-item" href="board_List.jsp?bname=infoboard">정보자료실</a>
	        <div class="dropdown-divider"></div>
	        <h6 class="dropdown-header">커뮤니티:</h6>
	        <a class="dropdown-item" href="board_List.jsp?bname=bohojaboard">보호자자료실</a>
	        <a class="dropdown-item" href="board_List.jsp?bname=staffboard">직원자료실</a>
        </div>
      </li>
    </ul>