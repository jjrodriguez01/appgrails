package com.model

import com.security.User

class ValidatorProject {

	String name
	String description 
	Date dateCreated
	Date lastUpdated
	User lastUpdater
	User creator

	public ValidatorProject(String name, String description, User creator){
		this.name = name
		this.description = description
		this.creator = creator
		this.lastUpdater = creator
	}

	static hasMany = [scenarios: ValidationScenario]

    static constraints = {
    	name blank:false
    	description blank:false
    }
    static mapping = {
    	version false
    }
}
