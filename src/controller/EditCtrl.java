package controller;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.FileUtils;

import com.oreilly.servlet.MultipartRequest;

import model.BbsDAO;
import model.BbsDTO;
import util.FileUtil;

public class EditCtrl extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		//일련번호를 파라미터로 가져옴
		String num = req.getParameter("num");
		
		//서블릿에서 application 내장객체를 얻어오기 위해 메소드 호출
		ServletContext app = this.getServletContext();
		BbsDAO dao = new BbsDAO(app);
		
		//일련번호에 해당하는 게시물 가져오기
		BbsDTO dto = dao.selectView(num);
		req.setAttribute("dto", dto);
		
		req.getRequestDispatcher("/community/commu_board_edit.jsp")
			.forward(req, resp);
		
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		
		String path = req.getServletContext().getRealPath("/Upload");
		
		//첨부파일 업로드
		MultipartRequest mr = FileUtil.upload(req, path);
		
		int sucOrFail;
		
		String bname = mr.getParameter("bname");
		
		//MultipartRequest객체가 정상적으로 생성되면 나머지 폼값을 받아온다.
		if(mr != null) {
			String num = mr.getParameter("num");
			String nowPage = mr.getParameter("nowPage");
			String originalfile = mr.getParameter("originalfile");
			
			//수정 처리 후 상세보기로 이동하므로 영역에 속성을 저장한다.
			req.setAttribute("num", num);
			req.setAttribute("nowPage", nowPage);
			
			String name = mr.getParameter("name");
			String title = mr.getParameter("title");
			String content = mr.getParameter("content");
			
			/*
			만약 수정폼에서 첨부한 파일이 있다면 기존 파일은 삭제해야 하고,
			확인 후 만약 없다면 기존 파일명으로 유지한다.
			*/
			String newfile = mr.getFilesystemName("newfile");
			if(newfile == null) {
				newfile = originalfile;
			}
			
			//폼값을 DTO객체에 저장한다.
			BbsDTO dto = new BbsDTO();
			dto.setOfile(newfile);
			dto.setSfile(path);
			dto.setContent(content);
			dto.setTitle(title);
			dto.setName(name);
			dto.setNum(num);
			
			//DB처리(update)
			ServletContext app = this.getServletContext();
			BbsDAO dao = new BbsDAO(app);
			sucOrFail = dao.updateEdit(dto);
			
			/*
			레코드의 update가 성송이고 동시에 새로운 파일을 업로드 완료했다면
			기존의 파일은 삭제처리한다.
			첨부한 파일이 없다면 기존파일은 유지된다.
			*/
			if(sucOrFail == 1 && mr.getFilesystemName("ofile") != null) {
				FileUtil.deleteFile(req, "/Upload", originalfile);
			}
			
			dao.close();
		}
		//MultipartRequest객체가 생성되지 않았다면 파일업로드 실패로 처리
		else {
			sucOrFail = -1;
		}
		
		//리퀘스트 영역에 메세지 출력을 위한 저장
		req.setAttribute("SUC_FAIL", sucOrFail);
		req.setAttribute("bname", bname);
		req.setAttribute("WHEREIS", "UPDATE");
		
		req.getRequestDispatcher("/community/Message.jsp")
			.forward(req, resp);
	}	
	
}

















