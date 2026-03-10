package com.SpringAPI.servicesImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.SpringAPI.dao.UserDao;
import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.UsersAccess;
import com.SpringAPI.entities.UsersToken;
import com.SpringAPI.entities.UsersView;
import com.SpringAPI.services.UserServices;

@Service
public class UserServiceImpl implements UserServices{

	@Autowired
	UserDao userDao;
	
	@Override
	public List<Users> list() {
		return userDao.list();
	}
	
	

	@Override
	public Users findByUsername(String username) {
		return userDao.findByUsername(username);
	}

	


	@Override
	public UsersView findUserByUsername(String username) {
		return userDao.findUserByUsername(username);
	}



	@Override
	public List<UsersView> allUser() {
		return userDao.allUser();
	}

	
	


	@Override
	public UsersAccess findUserAccessByuserid(String userid) {
		return userDao.findUserAccessByuserid(userid);
	}



	@Override
	public boolean delete(Users users) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean saveOrUpdate(Users users) {
		// TODO Auto-generated method stub
		return false;
	}



	@Override
	public void saveAndUpdateUserToken(UsersToken userToken) {
		userDao.saveAndUpdateUserToken(userToken);
		
	}



	@Override
	public UsersToken getUserTokenByUsername(String userName) {
		// TODO Auto-generated method stub
		return userDao.getUserTokenByUsername(userName);
	}

	
	
}
