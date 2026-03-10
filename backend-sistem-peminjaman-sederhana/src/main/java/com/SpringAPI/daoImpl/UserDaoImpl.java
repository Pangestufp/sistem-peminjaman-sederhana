package com.SpringAPI.daoImpl;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.SpringAPI.dao.UserDao;
import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.UsersAccess;
import com.SpringAPI.entities.UsersToken;
import com.SpringAPI.entities.UsersView;

@Repository
@Transactional
public class UserDaoImpl implements UserDao{
	
	@Autowired
	SessionFactory session;

	@SuppressWarnings("unchecked")
	@Override
	public List<Users> list() {
		List<Users> listUsers=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from Users");
			listUsers=query.list();
		} catch (Exception e) {
			listUsers=null;
		}
		return listUsers;
	}
	
	
	

	@SuppressWarnings("unchecked")
	@Override
	public UsersView findUserByUsername(String username) {
		List<UsersView> listUsers=new ArrayList<>();
		UsersView user=new UsersView();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from UsersView where USERNAME ='"+username+"' AND STATUS=1");
			listUsers=query.list();
			user=listUsers.get(0);
		} catch (Exception e) {
			user=null;
		}
		return user;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<UsersView> allUser() {
		List<UsersView> listUsers=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from UsersView");
			listUsers=query.list();
		} catch (Exception e) {
			listUsers=null;
		}
		return listUsers;
	}



	

	@SuppressWarnings("unchecked")
	@Override
	public UsersAccess findUserAccessByuserid(String userid) {
		List<UsersAccess> listUsers=new ArrayList<>();
		UsersAccess user=new UsersAccess();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from UsersAccess where IDUSER ='"+userid+"'");
			listUsers=query.list();
			user=listUsers.get(0);
		} catch (Exception e) {
			user=null;
		}
		return user;
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
	public Users findByUsername(String username) {
		Users user=new Users();
		List<Users> listUsers=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from Users where USERNAME ='"+username+"' AND STATUS=1");
			listUsers=query.list();
			user=listUsers.get(0);
		} catch (Exception e) {
			user=null;
			
		}
		return user;
	}




	@Override
	public void saveAndUpdateUserToken(UsersToken userToken) {
		
		Session querySession=session.getCurrentSession();
		try {
			querySession.saveOrUpdate(userToken);
		} catch (Exception e) {
			System.out.println("Error");
		}
	}




	@Override
	public UsersToken getUserTokenByUsername(String userName) {
		List<UsersToken> listUsersToken=new ArrayList<>();
		UsersToken usersToken=new UsersToken();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from UsersToken where USERNAME ='"+userName+"'");
			listUsersToken=query.list();
			usersToken=listUsersToken.get(0);
		} catch (Exception e) {
			usersToken=null;
		}
		return usersToken;
	}

	
	
	
}
