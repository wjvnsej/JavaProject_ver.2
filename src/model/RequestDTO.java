package model;

import java.sql.Date;

/*
DTO객체(Data Transfer Object)
	: 데이터를 저장하기 위한 객체로 멤버변수, 생성자, getter/setter
	메소드를 가지고 있는 클래스로 일반벅인 자바빈(Been)규약을 따른다.
*/
public class RequestDTO {
	
	//멤버변수 : 정보은닉을 위해 private으로 선언함.
	private String num;
	private String name;
	private String disabled;
	private String equip;
	private String cake;
	private String cookie;
	private String bread;
	private String phone1;
	private String phone2;
	private String email;
	private String zip;
	private String addr;
	private String cleankind;
	private String area;
	private Date applydate;
	private String recep_type;
	private String etc;
	private String bname;
	
	//게터/세터

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDisabled() {
		return disabled;
	}

	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}

	public String getEquip() {
		return equip;
	}

	public void setEquip(String equip) {
		this.equip = equip;
	}

	public String getCake() {
		return cake;
	}

	public void setCake(String cake) {
		this.cake = cake;
	}

	public String getCookie() {
		return cookie;
	}

	public void setCookie(String cookie) {
		this.cookie = cookie;
	}

	public String getBread() {
		return bread;
	}

	public void setBread(String bread) {
		this.bread = bread;
	}

	public String getPhone1() {
		return phone1;
	}

	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}

	public String getPhone2() {
		return phone2;
	}

	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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

	public String getCleankind() {
		return cleankind;
	}

	public void setCleankind(String cleankind) {
		this.cleankind = cleankind;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public Date getApplydate() {
		return applydate;
	}

	public void setApplydate(Date applydate) {
		this.applydate = applydate;
	}

	public String getRecep_type() {
		return recep_type;
	}

	public void setRecep_type(String recep_type) {
		this.recep_type = recep_type;
	}

	public String getEtc() {
		return etc;
	}

	public void setEtc(String etc) {
		this.etc = etc;
	}

	public String getBname() {
		return bname;
	}

	public void setBname(String bname) {
		this.bname = bname;
	}
	
	

}












