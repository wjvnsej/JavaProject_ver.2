package model;

import java.sql.Date;

/*
DTO객체(Data Transfer Object)
	: 데이터를 저장하기 위한 객체로 멤버변수, 생성자, getter/setter
	메소드를 가지고 있는 클래스로 일반벅인 자바빈(Been)규약을 따른다.
*/
public class MemberDTO {
	
	//멤버변수 : 정보은닉을 위해 private으로 선언함.
	private String num;
	private String id;
	private String pass;
	private String name;
	private String phone;
	private String email;
	private String email_send_ok;
	private String zip;
	private String addr;
	private String grade;
	private Date join_date;
	
		
	//게터/세터
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getEmail_send_ok() {
		return email_send_ok;
	}
	public void setEmail_send_ok(String email_send_ok) {
		this.email_send_ok = email_send_ok;
	}
	public String getZip() {
		return zip;
	}
	public void setZip(String zip) {
		this.zip = zip;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public Date getJoin_date() {
		return join_date;
	}
	public void setJoin_date(Date join_date) {
		this.join_date = join_date;
	}

	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", pass=" + pass + ", name=" + name + ", phone=" + phone + ", email=" + email
				+ ", email_send_ok=" + email_send_ok + ", zip=" + zip + ", addr=" + addr + ", join_date=" + join_date
				+ "]";
	}
	

}












