<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@ include file="../validation/isFlag.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/community/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				
				<%@ include file = "../include/community_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/community/<%=boardName %>" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;<%=boardTitle %><p>
				</div>
			
		
				<div class="row">
					<!-- 검색부분 -->
					<form class="form-inline ml-auto" name="searchFrm" method="get">	
						<div class="form-group">
							<select name="searchColumn" class="form-control">
								<option value="title">제목</option>
								<option value="content">내용</option>
							</select>
						</div>
						<div class="input-group">
							<input type="text" name="searchWord"  class="form-control"/>
							<div class="input-group-btn">
								<button type="submit" class="btn btn-warning">
									<i class='fa fa-search' style='font-size:20px'></i>
								</button>
							</div>
						</div>
					</form>	
				</div>
				
				
				<!-- 게시판리스트부분 -->
				<div class="row mt-3">
					<table class="table table-bordered table-hover table-striped" style="table-layout: fixed;">
						<colgroup>
							<col width="60px"/>
							<col width="*"/>
							<col width="120px"/>
							<col width="120px"/>
							<col width="80px"/>
							<col width="60px"/>
						</colgroup>				
						<thead>
							<tr style="background-color: rgb(133, 133, 133); " 
								class="text-center text-white">
								<th width="10%">번호</th>
								<th width="60%">제목</th>
								<th width="10%">작성자</th>
								<th width="10%">작성일</th>
								<th width="10%">조회수</th>
								<th width="10%">첨부</th>
							</tr>
						</thead>				
						<tbody>
							<!-- 
							ListCtrl 서블릿에서 request 영역에 저장한 ResultSet을 JSTL과 EL을
							통해 화면에 내용을 출력한다.
								choose
									when -> lists 컬렉션에 아무값도 없을 때
									otherwise -> ResultSet 결과가 있을 때(즉 출력할 레코드가 있을 때)
							 -->
							<c:choose>
								<c:when test="${empty lists}">
									<tr>
										<td colspan="6" align="center" height="100">
											등록된 게시물이 없습니다.
										</td>
									</tr>
								
								<!-- 리스트반복 start -->
								</c:when>
								<c:otherwise>
									<c:forEach items="${lists}" var="row" varStatus="loop">
										<tr>
											<td class="text-center"> <!-- 가상번호 -->
												${map.totalCount - (((map.nowPage - 1) * map.pageSize) +
												loop.index)}
											</td>
											
											<!-- 제목 -->
											<td class="text-left" style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap;"> 
												<a href="../community/commu_board_view?bname=${row.bname}&num=${row.num}&nowPage=${param.nowPage}&searchColumn=${param.searchColumn}&searchWord=${param.searchWord}">${row.title}</a>
											</td>
											
											<!-- 작성자 -->
											<td class="text-center" style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap;">${row.name}</td> 
											
											<td class="text-center">${row.postDate}</td> <!-- 조회수 -->
											
											<td class="text-center">${row.visitcount}</td> <!-- 작성일 -->
											
											<td class="text-center"> <!-- 첨부파일 -->
												<c:if test="${not empty row.ofile}"> 
													<a href="./commu_board_download?filename=${row.ofile}&num=${row.num}">
														<img src="../images/space/disk.png" width="20" />
													</a>
												</c:if>
											</td>
											
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
							<!-- 리스트반복 end -->
						</tbody>
					</table>
				</div>
				<div class="row">
					<div class="col text-right">
						<!-- 각종 버튼 부분 -->
						<!-- <button type="button" class="btn">Basic</button> -->
						
						<button type="button" class="btn btn-primary" 
							onclick="location.href='../community/commu_board_write?bname=${param.bname}';">글쓰기</button>
					</div>
				</div>
				<div class="row mt-3">
					<div class="col">
						<!-- 페이지 번호 부트스트랩4 적용 --> 
						<ul class="pagination justify-content-center">
							${map.pagingImg }
						</ul>
						
					</div>				
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
