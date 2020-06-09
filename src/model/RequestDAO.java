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

public class RequestDAO {
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	//기본생성자
   public RequestDAO() {
	   System.out.println("RequestDAO 생성자 호출");
   }
   
   public RequestDAO(String driver, String url) {
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
   
 	//블루크리닝 견적서 저장
   	public int blue_insert(Map<String, String> param){
   		
   		int affected = 0;
   		String query = "INSERT INTO request_form "
   				+ "(name, phone1, phone2, email, zip, addr, cleankind, area, applydate, recep_type, etc, bname) "
   				+ " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
   		
   		try {
   			psmt = con.prepareStatement(query);
   			psmt.setString(1, param.get("name").toString());
   			psmt.setString(2, param.get("phone1").toString());
   			psmt.setString(3, param.get("phone2").toString());
   			psmt.setString(4, param.get("email").toString());
   			psmt.setString(5, param.get("zip").toString());
   			psmt.setString(6, param.get("addr").toString());
   			psmt.setString(7, param.get("cleankind").toString());
   			psmt.setString(8, param.get("area").toString());
   			psmt.setString(9, param.get("datepicker").toString());
   			psmt.setString(10, param.get("recep_type").toString());
   			psmt.setString(11, param.get("etc").toString());
   			psmt.setString(12, param.get("bname").toString());
   			
   			affected = psmt.executeUpdate();
   			System.out.println(query);
   		}
   		catch (Exception e) {
   			System.out.println("blue_insert오류");
   			e.printStackTrace();
   		}
   		return affected;
   	}
	
   	//체험학습 저장
   	public int experience_insert(Map<String, String> param){
   		
   		int affected = 0;
   		String query = "INSERT INTO request_form "
   				+ "(name, disabled, equip, phone1, email, cake, cookie, bread, applydate, etc, bname) "
   				+ " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
   		
   		try {
   			psmt = con.prepareStatement(query);
   			psmt.setString(1, param.get("name").toString());
   			psmt.setString(2, param.get("disabled").toString());
   			psmt.setString(3, param.get("equip").toString());
   			psmt.setString(4, param.get("phone1").toString());
   			psmt.setString(5, param.get("email").toString());
   			psmt.setString(6, param.get("cake").toString());
   			psmt.setString(7, param.get("cookie").toString());
   			psmt.setString(8, param.get("bread").toString());
   			psmt.setString(9, param.get("datepicker").toString());
   			psmt.setString(10, param.get("etc").toString());
   			psmt.setString(11, param.get("bname").toString());
   			
   			affected = psmt.executeUpdate();
   			System.out.println(query);
   		}
   		catch (Exception e) {
   			System.out.println("experience_insert오류");
   			e.printStackTrace();
   		}
   		return affected;
   	}  	
   	
   	
   	public int getTotalRecordCount(Map<String, Object> map) {
		//게시물의 수는 0으로 초기화
		int totalCount = 0;
		
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM request_form"
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
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
	
	/*
	게시판 리스트에서 조건에 맞는 레코드를 select하여 ResultSet(결과셋)을
	List컬렉션에 저장 후 반환하는 메소드
	*/
	public List<RequestDTO> selectList(Map<String, Object> map) {
		
		List<RequestDTO> bbs = new Vector<RequestDTO>();
		//기본쿼리문
		String query = "SELECT * FROM request_form "
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
		//검색어가 있는 경우 조건절 동적 추가
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " " 
					+ " LIKE '%" + map.get("Word") + "%'";
		}
		
		//최근게시물이  항상 위로 노출되야 하므로 작성된 순서의 역순으로 정렬한다.
		query += " ORDER BY num DESC";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				RequestDTO dto = new RequestDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setName(rs.getString("name"));
				dto.setDisabled(rs.getString("disabled"));
				dto.setEquip(rs.getString("equip"));
				dto.setCake(rs.getString("cake"));
				dto.setCookie(rs.getString("cookie"));
				dto.setBread(rs.getString("bread"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail(rs.getString("email"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setCleankind(rs.getString("cleankind"));
				dto.setArea(rs.getString("area"));
				dto.setApplydate(rs.getDate("applydate"));
				dto.setRecep_type(rs.getString("recep_type"));
				dto.setEtc(rs.getString("etc"));
				dto.setBname(rs.getString("bname"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectList 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	//게시판 리스트 페이지 처리
	public List<RequestDTO> selectListPage(Map<String, Object> map) {
		
		List<RequestDTO> bbs = new Vector<RequestDTO>();
		
		String query = "	"
				+ " SELECT * FROM request_form "
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " "
				+ " LIKE '%" + map.get("Word") + "%' ";
		}
		query += " "
			+ " 		ORDER BY num DESC LIMIT ?, ? ";
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
				RequestDTO dto = new RequestDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setName(rs.getString("name"));
				dto.setDisabled(rs.getString("disabled"));
				dto.setEquip(rs.getString("equip"));
				dto.setCake(rs.getString("cake"));
				dto.setCookie(rs.getString("cookie"));
				dto.setBread(rs.getString("bread"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail(rs.getString("email"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setCleankind(rs.getString("cleankind"));
				dto.setArea(rs.getString("area"));
				dto.setApplydate(rs.getDate("applydate"));
				dto.setRecep_type(rs.getString("recep_type"));
				dto.setEtc(rs.getString("etc"));
				dto.setBname(rs.getString("bname"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListPage 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	public RequestDTO selectView(String num) {
		RequestDTO dto = new RequestDTO();
	
		String query = "SELECT * FROM request_form"
				+ "	WHERE num LIKE ? ";
		
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			rs = psmt.executeQuery();
			while(rs.next()) {
				dto.setNum(rs.getString("num"));
				dto.setName(rs.getString("name"));
				dto.setDisabled(rs.getString("disabled"));
				dto.setEquip(rs.getString("equip"));
				dto.setCake(rs.getString("cake"));
				dto.setCookie(rs.getString("cookie"));
				dto.setBread(rs.getString("bread"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail(rs.getString("email"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setCleankind(rs.getString("cleankind"));
				dto.setArea(rs.getString("area"));
				dto.setApplydate(rs.getDate("applydate"));
				dto.setRecep_type(rs.getString("recep_type"));
				dto.setEtc(rs.getString("etc"));
				dto.setBname(rs.getString("bname"));
				
			}
		} 
		catch (Exception e) {
			System.out.println("selectView 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
	
	public int delete(String num, String bname) {
  		int affected = 0;
  		try {
  			String query = "DELETE FROM request_form "
  					+ "WHERE num = ? AND bname = ?";
  			
  			psmt = con.prepareStatement(query);
  			psmt.setInt(1, Integer.parseInt(num));
  			psmt.setString(2, bname);
  			
  			System.out.println("query : " + query);
  			
  			affected = psmt.executeUpdate();
  			
  			System.out.println("affected : " + affected);
  		}
  		catch (Exception e) {
  			System.out.println("DELETE중 예외 발생");
  			e.printStackTrace();
  		}
  		return affected;
  	}
   
}
















