package com.model

import com.security.User;

class GenericAction {
	
	String name
	Date dateCreated
	Date lastUpdated
	String html
	String defaultValue
	Boolean needsObject
	String platform
	
    public GenericAction(String name, String html, String defaultValue, Boolean needsObject, String platform) {
		super();
		this.name = name
		this.html= html
		this.defaultValue = defaultValue
		this.needsObject = needsObject
		this.platform = platform
		
	}

	static constraints = {
		name unique:true, blank:false
		platform blank:false
    }
	
	static mapping ={
		html type: 'text'
		version false		
	}
}
