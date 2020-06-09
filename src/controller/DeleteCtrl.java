package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;
import util.FileUtil;

public class DeleteCtrl extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		String num = req.getParameter("num");
		String bname = req.getParameter("bname");
		String nowPage = req.getParameter("nowPage");
		req.setAttribute("nowPage", nowPage);
		
		BbsDAO dao = new BbsDAO();
		//기존게시물 가져오기
		BbsDTO dto = dao.selectView(num);
		
		//게시물삭제하기
		int sucOrFail = dao.delete(dto);
		//삭제에 성공인 경우
		if(sucOrFail == 1) {
			// 첨부된 파일명을 얻어와서 서버에서 삭제처리한다.
			String fileName = dto.getOfile();
			FileUtil.deleteFile(req, "/Upload", fileName);
		}
		
		//mode가 delete이므로 아래와 같이 처리
		req.setAttribute("WHEREIS", "DELETE");
		req.setAttribute("bname", bname);
		req.setAttribute("SUC_FAIL", sucOrFail);
		
		req.getRequestDispatcher("/community/Message.jsp")
			.forward(req, resp);
	}
	
}
