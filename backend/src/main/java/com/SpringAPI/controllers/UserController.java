package com.SpringAPI.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.SpringAPI.config.JwtTokenUtil;
import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.UsersAccess;
import com.SpringAPI.entities.UsersView;
import com.SpringAPI.services.UserServices;

@Controller
public class UserController {
	
	@Autowired
	UserServices userServices;
	
	@Autowired
    private JwtTokenUtil jwtTokenUtil;

	@RequestMapping(value = "/users/getAll",method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getAllUsers() {
		Map<String, Object> map = new HashMap<String,Object>();
		List<UsersView> list=userServices.allUser();
		
		if(list !=null) {
			map.put("status", "200");
			map.put("message", "Data found");
			map.put("data", list);
		}else {
			map.put("status", "404");
			map.put("message", "Data not found");
		}
		return map;
	}
	
	@RequestMapping(value = "/users/getUserData", method = RequestMethod.GET)
    public @ResponseBody Map<String, Object> getUserByUsername(HttpServletRequest requestHeader) {
        
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
        
                
        UsersView userview=userServices.findUserByUsername(userNameKey);
        
        if(userview != null) {
            map.put("status", "200");
            map.put("message", "User found");
            map.put("data", userview);
        } else {
            map.put("status", "404");
            map.put("message", "User not found");
        }
        return map;
    }
	
	
	@RequestMapping(value = "/users/getUserAccess", method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getUserAccessByUsername(HttpServletRequest requestHeader) {
	    Map<String, Object> map = new HashMap<>();

	    
	    final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
	    

	    UsersAccess user = new UsersAccess();
	    UsersView userview = new UsersView();
	    
	    try {
			userview=userServices.findUserByUsername(userNameKey);
			user = userServices.findUserAccessByuserid(Integer.toString(userview.getIdUser()));
		} catch (Exception e) {
			user=null;
		}
	    
	    
       	    
	    if (user != null) {
	        map.put("status", "200");
	        map.put("message", "User found");
	        map.put("data", user);
	    } else {
	        map.put("status", "404");
	        map.put("message", "User not found");
	    }
	    return map;
	}

	
	
	
	
	
}
