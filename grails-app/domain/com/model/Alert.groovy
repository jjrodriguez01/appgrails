package com.model

import java.util.Date;

import com.security.User;

class Alert {
	String message
	Date dateCreated
	User target
	Boolean viewed
	String iconClass
	String iconColor
	String  parameters
	Integer type //1. Alert 2. Message 3. Notification
	String actionNotification = ""

	
	
    public Alert(String message, User target,  Integer type, String iconClass, String iconColor, String parameters) {
		super();
		this.message = message;
		this.target = target;
		this.viewed = false
		this.type = type
		this.iconClass = iconClass
		this.iconColor = iconColor
		this.parameters = parameters
		this.actionNotification=''
	}

	static constraints = {
    }
	
	static mapping={
		version false
		parameters column: '`alertParameters`'
		sort dateCreated:"asc"
	}
}
