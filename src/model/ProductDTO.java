package model;

public class ProductDTO {
	
	//멤버변수
	private String num;
	private String p_name;
	private String p_price;
	private int p_acc;
	private String p_ofile;
	private String p_sfile;
	private String p_introduce;
	private String u_id;
	private int p_cnt;
	private int p_total_price;
	private String bname;

	//getter/setter
	public String getU_id() {
		return u_id;
	}
	public void setU_id(String u_id) {
		this.u_id = u_id;
	}
	public int getP_cnt() {
		return p_cnt;
	}
	public void setP_cnt(int p_cnt) {
		this.p_cnt = p_cnt;
	}
	public int getP_total_price() {
		return p_total_price;
	}
	public void setP_total_price(int p_total_price) {
		this.p_total_price = p_total_price;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getP_price() {
		return p_price;
	}
	public void setP_price(String p_price) {
		this.p_price = p_price;
	}
	public int getP_acc() {
		return p_acc;
	}
	public void setP_acc(int p_acc) {
		this.p_acc = p_acc;
	}
	public String getP_ofile() {
		return p_ofile;
	}
	public void setP_ofile(String p_ofile) {
		this.p_ofile = p_ofile;
	}
	public String getP_sfile() {
		return p_sfile;
	}
	public void setP_sfile(String p_sfile) {
		this.p_sfile = p_sfile;
	}
	public String getP_introduce() {
		return p_introduce;
	}
	public void setP_introduce(String p_introduce) {
		this.p_introduce = p_introduce;
	}
	public String getBname() {
		return bname;
	}
	public void setBname(String bname) {
		this.bname = bname;
	}
	public String getP_name() {
		return p_name;
	}
	public void setP_name(String p_name) {
		this.p_name = p_name;
	}
	
	
}
