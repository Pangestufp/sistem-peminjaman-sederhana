package com.SpringAPI.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "usersview")
public class UsersView {
	
	@Id
	@Column(name = "IDUSER")
	private int idUser;
	
	@Column(name="USERNAME")
	private String userName;
	
	@Column(name = "ROLE")
	private String role;
	
	@Column(name = "STATUS")
	private int status;
	
	public int getIdUser() {
		return idUser;
	}
	public void setIdUser(int idUser) {
		this.idUser = idUser;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
	

}
