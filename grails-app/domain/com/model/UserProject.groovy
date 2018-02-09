package com.model

import com.security.Role;
import com.security.User;
import com.security.UserRole;

class UserProject {
	
	User user
	Project project

	
	
	public UserProject(User user, Project project) {
		super();
		this.user = user;
		this.project = project;
	}

	static UserProject create(User user, Project project, boolean flush = false) {
		def instance = new UserProject(user, project)
		instance.save(flush: flush, insert: true)
		instance
	}
	
	
	static constraints = {
	}
	static mapping ={
		version false
	}
	
}
