package model;

public class OrderDTO {
	
	//멤버변수 : 정보은닉을 위해 private으로 선언함.
	private String idx;
	private String order_record;
	private String name1;
	private String addr1;
	private String phone1;
	private String email1;
	private String name2;
	private String addr2;
	private String phone2;
	private String email2;
	private String msg;
	private String pay_kind;
	
	//게터 세터
	public String getIdx() {
		return idx;
	}
	public void setIdx(String idx) {
		this.idx = idx;
	}
	public String getOrder_record() {
		return order_record;
	}
	public void setOrder_record(String order_record) {
		this.order_record = order_record;
	}
	public String getName1() {
		return name1;
	}
	public void setName1(String name1) {
		this.name1 = name1;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getPhone1() {
		return phone1;
	}
	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}
	public String getEmail1() {
		return email1;
	}
	public void setEmail1(String email1) {
		this.email1 = email1;
	}
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getPhone2() {
		return phone2;
	}
	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}
	public String getEmail2() {
		return email2;
	}
	public void setEmail2(String email2) {
		this.email2 = email2;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getPay_kind() {
		return pay_kind;
	}
	public void setPay_kind(String pay_kind) {
		this.pay_kind = pay_kind;
	}
	
}












