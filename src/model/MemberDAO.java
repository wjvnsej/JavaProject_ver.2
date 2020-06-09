package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

public class MemberDAO {
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	//기본생성자
   public MemberDAO() {
	   System.out.println("MemberDAO 생성자 호출");
   }
   
   public MemberDAO(String driver, String url) {
	   try {
		   Class.forName(driver);
		   String id = "wjvnsej";
		   String pw = "ehdrjs13!";
		   con =DriverManager.getConnection(url, id, pw);
		   System.out.println("DB연결성공");
	   }
	   catch (Exception e) {
		e.printStackTrace();
	   }
   }
   
	//DB자원해제
 	public void close() {
 		try {
 			if(rs != null) rs.close();
 			if(psmt != null) psmt.close();
 			if(con != null) con.close();
 		} 
 		catch (Exception e) {
 			System.out.println("자원반납시 예외발생");
 			e.printStackTrace();
 		}
 	}
   
   //회원가입
   public int insertMember(MemberDTO dto) {
		
	   int affected = 0;
	   try {
		   String query = "INSERT INTO membership ( "
				   + "	id, pass, name, phone, email, email_send_ok, zip, addr) "
				   + "	VALUES ( "
				   + "	?, ?, ?, ?, ?, ?, ?, ?)";
		   
		   psmt = con.prepareStatement(query);
		   psmt.setString(1, dto.getId());
		   psmt.setString(2, dto.getPass());
		   psmt.setString(3, dto.getName());
		   psmt.setString(4, dto.getPhone());
		   psmt.setString(5, dto.getEmail());
		   psmt.setString(6, dto.getEmail_send_ok());
		   psmt.setString(7, dto.getZip());
		   psmt.setString(8, dto.getAddr());
		   
		   affected = psmt.executeUpdate();
	   } 
	   catch (Exception e) {
		   System.out.println("MemberInsert중 예외발생");
		   e.printStackTrace();
	   }
	   return affected;
	}
   
   //아이디 중복확인
   public boolean isMember(String id) {
	   
	   String sql = "SELECT COUNT(*) FROM membership "
	            + " WHERE id=?";
	   int isMember = 0;
	   boolean isFlag = false;
	   
	   try {
		   psmt = con.prepareStatement(sql);
		   psmt.setString(1, id);
		   
		   rs = psmt.executeQuery();
		   rs.next();
		   
		   isMember = rs.getInt(1);
		   System.out.println("affected : " + isMember);
		   if(isMember == 0) {
			   isFlag = false;
		   }		   
		   else {
			   isFlag = true;
		   }
	   }
	   catch (Exception e) {
		isFlag = false;
		e.printStackTrace();
	   }
	   return isFlag;
   }
   
   //아이디 찾기
   public Map<String, String> id_Search(String name, String email){
	   
	   Map<String, String> map = new HashMap<String, String>();
	   
	   String query = "SELECT id, join_date FROM membership "
	            + " WHERE name = ? AND email = ?"
	            + "	AND grade != 'master' AND grade != 'manager'";
	   
	   try {
		   psmt = con.prepareStatement(query);
		   psmt.setString(1, name);
		   psmt.setString(2, email);
		   rs = psmt.executeQuery();
		   
		   System.out.println(query);
		   
		   if(rs.next()) {
			   map.put("id", rs.getString(1));
			   map.put("join_date", rs.getString("join_date"));
		   }
	   }
	   catch (Exception e) {
		   System.out.println("id_Search오류");
		   e.printStackTrace();
	   }
	   return map;
   }
   
   //비밀번호 찾기
   public Map<String, String> pw_Search(String id, String name, String email){
	   
	   Map<String, String> map = new HashMap<String, String>();
	   
	   String query = "SELECT pass, email FROM membership "
	            + " WHERE id = ? AND name = ? AND email = ?"
	            + "	AND grade != 'master' AND grade != 'manager'";
	   
	   try {
		   psmt = con.prepareStatement(query);
		   psmt.setString(1, id);
		   psmt.setString(2, name);
		   psmt.setString(3, email);
		   rs = psmt.executeQuery();
		   
		   System.out.println(query);
		   
		   if(rs.next()) {
			   map.put("pass", rs.getString(1));
			   map.put("email", rs.getString(2));
		   }		   
	   }
	   catch (Exception e) {
		   System.out.println("pw_Search오류");
		   e.printStackTrace();
	   }
	   return map;
   }
   
   
   public Map<String, String> getMemberMap(String id, String pass){
	   
	   Map<String, String> maps = new HashMap<String, String>();
	   
	   String query = "SELECT id, pass, name, grade FROM membership "
	            + " WHERE id=? AND pass=?";
	   
	   try {
		   psmt = con.prepareStatement(query);
		   psmt.setString(1, id);
		   psmt.setString(2, pass);
		   rs = psmt.executeQuery();
		   
		   if(rs.next()) {
			   maps.put("id", rs.getString(1));
			   maps.put("pass", rs.getString("pass"));
			   maps.put("name", rs.getString("name"));
			   maps.put("grade", rs.getString("grade"));
		   }
		   else {
			   System.out.println("결과셋이 없습니다.");
		   }
	   }
	   catch (Exception e) {
		   System.out.println("getMemberMap오류");
		   e.printStackTrace();
	   }
	   
	   return maps;
	   
   }
   
   	public MemberDTO selectView(String id) {
	   MemberDTO dto = new MemberDTO();
	
		String query = "SELECT * FROM membership"
				+ "	WHERE id LIKE ? ";
		
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			while(rs.next()) {
				dto.setNum(rs.getString("num"));
				dto.setId(rs.getString("id"));
				dto.setPass(rs.getString("pass"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setEmail(rs.getString("email"));
				dto.setEmail_send_ok(rs.getString("email_send_ok"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setGrade(rs.getString("grade"));
				dto.setJoin_date(rs.getDate("join_date"));
				
			}
		} 
		catch (Exception e) {
			System.out.println("selectView 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
   
   	public int getTotalRecordCount(Map<String, Object> map) {
		//게시물의 수는 0으로 초기화
		int totalCount = 0;
		
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM membership"
				+ "	WHERE grade LIKE '" + map.get("grade") + "' ";
		
		//JSP페이지에서 검색어를 입력한 경우 where절이 동적으로 추가됨.
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " " 
					+ " LIKE '%" + map.get("Word") + "%'";
		}
		System.out.println("query = " + query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			rs.next();
			//반환한 결과값(레코드 수)을 저장
			totalCount = rs.getInt(1);
		}catch (Exception e) {
			System.out.println("getTotalRecordCount 예외발생");
			e.printStackTrace();
		}
		return totalCount;
	}
   	
   	public List<MemberDTO> selectListPage(Map<String, Object> map) {
		
		List<MemberDTO> bbs = new Vector<MemberDTO>();
		
		String query = "	"
				+ " SELECT * FROM membership "
				+ "	WHERE grade LIKE '" + map.get("grade") + "' ";
		
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " "
				+ " LIKE '%" + map.get("Word") + "%' ";
		}
		query += " "
			+ " 		ORDER BY grade DESC LIMIT ?, ? ";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			
			//JSP에서 계산한 페이지 범위값을 이용해 인파라미터를 설정함.
			psmt.setInt(1, Integer.parseInt(map.get("start").toString()));
			psmt.setInt(2, Integer.parseInt(map.get("end").toString()));
			
			rs = psmt.executeQuery();
			
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				MemberDTO dto = new MemberDTO();

				dto.setNum(rs.getString("num"));
				dto.setId(rs.getString("id"));
				dto.setPass(rs.getString("pass"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setEmail(rs.getString("email"));
				dto.setEmail_send_ok(rs.getString("email_send_ok"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setGrade(rs.getString("grade"));
				dto.setJoin_date(rs.getDate("join_date"));
				
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListPage 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
   	
  //게시물 수정하기
  	public int updateEdit(MemberDTO dto) {
  		int affected = 0;
  		try {
  			String query = "UPDATE membership SET "
  					+ " grade = ? WHERE id = ? ";
  			psmt = con.prepareStatement(query);
  			psmt.setString(1, dto.getGrade());
  			psmt.setString(2, dto.getId());
  			
  			affected = psmt.executeUpdate();
  			
  		} 
  		catch (Exception e) {
  			System.out.println("UPDATE중 예외 발생");
  			e.printStackTrace();
  		}
  		return affected;
  	}
  	
  	//게시물 삭제 처리
  	public int delete(String id) {
  		int affected = 0;
  		try {
  			String query = "DELETE FROM membership WHERE id = ?";
  			
  			psmt = con.prepareStatement(query);
  			psmt.setString(1, id);
  			
  			affected = psmt.executeUpdate();
  		}
  		catch (Exception e) {
  			System.out.println("DELETE중 예외 발생");
  			e.printStackTrace();
  		}
  		return affected;
  	}
   	
}
















