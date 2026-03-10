package com.SpringAPI.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "usersaccess")
public class UsersAccess {
	
	@Id
	@Column(name = "IDUSER")
	private int idUser;
	
	@Column(name = "APPROVE")
	private int approve;
	
	@Column(name = "REJECT")
	private int reject;
	
	@Column(name = "PAY")
	private int pay;
	
	@Column(name = "VIEWALL")
	private int viewAll;

	public int getIdUser() {
		return idUser;
	}

	public void setIdUser(int idUser) {
		this.idUser = idUser;
	}

	public int getApprove() {
		return approve;
	}

	public void setApprove(int approve) {
		this.approve = approve;
	}

	public int getReject() {
		return reject;
	}

	public void setReject(int reject) {
		this.reject = reject;
	}
	
	

	public int getPay() {
		return pay;
	}

	public void setPay(int pay) {
		this.pay = pay;
	}

	public int getViewAll() {
		return viewAll;
	}

	public void setViewAll(int viewAll) {
		this.viewAll = viewAll;
	}
	
	
	
	
	

}
