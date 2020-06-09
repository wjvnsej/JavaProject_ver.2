<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- EditProc.jsp --%>

<%@include file="../validation/isLogin.jsp" %>


<!-- 필수 파라미터 체크 로직 -->
<!-- 해당 파일내에서 bname에 대한 폼값을 받고있음. -->
<%@ include file="../validation/isFlag.jsp" %>

<% 
request.setCharacterEncoding("UTF-8");

if(bname.equals("freeboard")) {

	
	//폼값 받기
	String num = request.getParameter("num");
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	//폼값을 DTO객체에 저장
	BbsDTO dto = new BbsDTO();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setContent(content);
	
	BbsDAO dao = new BbsDAO(application);
	
	//DTO객체를 DAO로 전달하여 게시물 업데이트(수정)
	int affected = dao.updateEdit(dto);
	if(affected == 1) {
		//정상적으로 수정되었다면 수정된 내용의 확인을 위해 상세보기로 이동
		response.sendRedirect("board_view.jsp?bname=" + bname + "&num=" + dto.getNum());
	}
	else {

		System.out.println("파일업로드오류");
		request.getRequestDispatcher("board_view.jsp?bname=" + bname)
			.forward(request, response);
	}
}
else {
	//1. 파일을 업로드 할 서버의 물리적 경로 가져오기
	/*
		운영체제 별로 서버의 물리적 경로는 달라질 수 있으므로 파일이
		업로드되는 정확한 위치를 알기 위해서 반드시 필요한 정보이다.
	*/
	String saveDirectory = application.getRealPath("/Upload");
	System.out.println(saveDirectory);
	//2. 업로드할 파일의 최대용량 설정(바이트단위)
	/*
		만약 파일으 ㄹ여러개 업로드 한다면 각각의 용량을 합친
		용량이 최대용량이 된다.
		Ex) 500kb * 2 = 1000kb
	*/
	int maxPostSize = 1024 * 8000;
	
	//3. 인코딩 타입 설정
	String encoding = "UTF-8";
	
	//4. 파일명 중복 처리
	/*
		파일명이 중복되는 경우 자동인덱스를 부여하여 파일명을 수정해준다.
		Ex) apple.png, apple1.png, apple2.png ... 와 같은 
			형태로 이름을 부여한다
	*/
	FileRenamePolicy policy = new DefaultFileRenamePolicy();
	
	//전송된 폼값을 저장하기 위한 변수생성
	MultipartRequest mr = null;
	String num = null; //게시물번호
	String title = null; //제목
	String content = null; //내용
	//저장된 파일명을 변경하기 위한 객체 생성
	File oldFile = null;
	File newFile = null;
	String realFileName = null;
	String name = (String)session.getAttribute("name");
	String id = (String)session.getAttribute("id");
	
	try {
		/* 
		1~4번까지 준비한 인자를 이용하여 MultipartRequest객체를 생성한다.
		객체가 정상적으로 생성되면 파일업로드는 완료된다.
		만약 예외가 발생한다면 주로 최대용량 초과 혹은 디렉토리 경로가
		잘못된 경우가 대부분이다.
		*/
		mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
		
		/* 
			서버에 저장된 파일명 변경하기
			: 객체를 생성함과 동시에 업로드는 완료되므로 이미 저장된
			파일에 대해 파일명을 변경한다.
			이유는 한글이나 다른 언어 즉 유니코드로 구성된 파일명은
			서버에서 문제가 될 소지가 있으므로 숫자 혹은 영문으로 
			변경하는 것이 좋다.
		*/
		//추가부분 start//
		
		//서버에 저정된 파일명 가져오기
		String fileName = mr.getFilesystemName("insert_file");
		
		
		
		
		
		//파일명을 변경하기 위해 현재시간을 가져온다.
		/* 
			아래 서식문자 중 대문자 S는 초를 1/1000단위로 가져옴
		*/
		/* 
		String nowTime = new SimpleDateFormat("yyyy_MM_dd_H_m_s_S").format(new Date());
		 */
		//파일의 확장자를 가져옴
		/* 
			파일명에 (.)닷이 2개이상 포함될 수 있으므로 lastIndexOf()로
			마지막에 있는 점을 찾아온다. 해당 인덱스를 통해 확장자를
			가져온다.
		*/
		
		
		
		realFileName = saveDirectory + "\\";
		
		/* 
		서버의 물리적 경로와 생성된 파일명을 통해 FIle객체를 생성한다.
		※ 파일객체.separator : 파일경로를 나타낼 때 윈도우는 역슬러쉬(\)
			리눅스는 슬러쉬(/)를 사용하게 되는데 OS에 따라 구분기호를
			자동으로 변환하여 설정해주는 역할을 한다.
		*/
		oldFile = new File(saveDirectory + oldFile.separator + fileName);
		newFile = new File(saveDirectory + oldFile.separator + realFileName);
		
		//저장된 파일명을 변경한다.
		oldFile.renameTo(newFile);
		
		//추가부분 end//
		
		//파일을 제외한 나머지 폼값을 받아온다.
		/* 
			폼값은 request 내장객체를 통해서가 아니라 MultipartRequest 객체를
			통해서 받는다.
		*/
		num = mr.getParameter("num");
		title = mr.getParameter("title");
		content = mr.getParameter("content");
			
		//////////////////////////////////////////
		BbsDTO dto = new BbsDTO();
		dto.setNum(num);
		dto.setId(id);
		dto.setName(name);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setOfile(mr.getOriginalFileName("insert_file"));
		dto.setSfile(realFileName);
		dto.setBname(bname);
		
		
		BbsDAO dao = new BbsDAO(application);
		dao.updateEdit(dto);
		
		System.out.println("id : " + dto.getId());
		System.out.println("name : " + dto.getName());
		System.out.println("title : " + dto.getTitle());
		System.out.println("ofile : " + dto.getOfile());
		System.out.println("sfile : " + dto.getSfile());
		System.out.println("bname : " + dto.getBname());
		
		
		System.out.println("파일업로드성공");
		
		response.sendRedirect("board_view.jsp?bname=" + bname  + "&num=" + dto.getNum());
		//////////////////////////////////////////
		
	}
	catch(Exception e) {
		System.out.println("파일업로드오류");
		request.getRequestDispatcher("board_view.jsp?bname=" + bname)
			.forward(request, response);
	}
}
%>

