package com.SpringAPI.dao;

import java.util.List;

import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.UsersAccess;
import com.SpringAPI.entities.UsersToken;
import com.SpringAPI.entities.UsersView;

public interface UserDao {

	public List<Users> list();
	
	public Users findByUsername(String username);//buat authentifikasi
	
	public UsersView findUserByUsername(String username);
	
	public UsersAccess findUserAccessByuserid(String userid);
	
	public List<UsersView> allUser();
	
	public boolean delete(Users users);
	
	public boolean saveOrUpdate(Users users);
	
	public void saveAndUpdateUserToken(UsersToken userToken);
	
	public UsersToken getUserTokenByUsername(String userName);
	
}
