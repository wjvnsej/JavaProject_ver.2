package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;
import util.PagingUtil;

public class ListCtrl extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		//DAO객체 생성 및 커넥션 풀을 통한 DB연결
		BbsDAO dao = new BbsDAO();
		
		//컨트롤러(서블릿) 및 View(JSP)로 전달할 파라미터를 저장하기 위한 맵
		Map<String, Object> param = new HashMap<String, Object>();
		
		String bname = req.getParameter("bname");

		param.put("bname", bname);
		
		//쿼리스트링의 파라미터를 저장하기 위한 문자열
		String addQueryString = "bname=" + bname + "&";
		
		
		String searchColumn = req.getParameter("searchColumn");
		String searchWord = req.getParameter("searchWord");
		if(!(searchWord == null || searchWord.equals(""))) {
			
			//검색어가 있는 경우 파라미터를 Map에 저장 및 쿼리스트링 저장
			addQueryString += 
					String.format("searchColumn=%s&searchWord=%s&",
							searchColumn, searchWord);
			param.put("Column", searchColumn);
			param.put("Word", searchWord);
		}
		
		//테이블의 전체 레코드수를 카운트
		int totalRecordCount = dao.getTotalRecordCount(param);
		//전체 카운트수를 Map저장함. 차후 View로 전달할 예정임.
		param.put("totalCount", totalRecordCount);
		
		
		/////////////////////////////////////////////////////
		//페이지 수 계산을 위한 페이지 설정 값 가져오기
		ServletContext application = this.getServletContext();
		int pageSize = 
				Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
		int blockPage = 
				Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));
		
		//전체 페이지 수 계산하기
		int totalPage = 
				(int)Math.ceil((double)totalRecordCount / pageSize);
		System.out.println("전체 레코드 수 : " + totalRecordCount);
		System.out.println("전체 페이지 수" + totalPage);
		
		//현재페이지 번호에 대한 파라미터 처리. 첫 진입시 무조건 1페이지로 지정함.
		int nowPage = (req.getParameter("nowPage") == null
				|| req.getParameter("nowPage").equals(""))
				?
				1 : Integer.parseInt(req.getParameter("nowPage"));
		
		//페이지의 구간을 경정하기 위한 계산
		int start = (nowPage - 1) * pageSize;
		int end = pageSize;
		
		System.out.println("start" + start);
		System.out.println("end" + end);
		
		//Map 컬렉션에 데이터 저장
		param.put("start", start);
		param.put("end", end);
		param.put("totalPage", totalPage);
		param.put("nowPage", nowPage);
		param.put("totalCount", totalRecordCount);
		param.put("pageSize", pageSize);
		
		
		String pagingImg = PagingUtil.pagingBS4(totalRecordCount, 
				pageSize, blockPage, nowPage, 
				"../community/commu_board_list?" + addQueryString);
		param.put("pagingImg", pagingImg);
		////////////////////////////////////////////////////
		
		
		//테이블의 전체 ResultSet을 가져옴.(페이지 처리 x)
		//List<DataroomDTO> lists = dao.selectList(param);
		
		//테이블에서 해당 페이지 구간의 ResultSet을 가져옴.(페이지 처리 o)
		List<BbsDTO> lists = dao.selectListPage(param);
		
		//커넥션풀에 커넥션 객체 반납.
		dao.close();
		
		if(lists.isEmpty()) {
			System.out.println("리스트 비었음");
		}
		else {
			System.out.println("리스트 안비었음");
		}
		
		
		//컬렉션에 저장된 데이터를 View로 전달하기 위해 Request영역에 속성저장
		req.setAttribute("lists", lists);
		req.setAttribute("map", param);
		req.getRequestDispatcher("/community/commu_board_list.jsp")
			.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		/*
		만약 게시판 리스트쪽에서 POST방식으로 요청이 등어오더라도
		처리는 doGet()메소드에서 처리할 수 있도록 모든 요청을 토스한다.
		*/
		doGet(req, resp);
	}
	
}
