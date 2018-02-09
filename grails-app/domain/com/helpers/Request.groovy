package com.helpers

import com.model.*
import com.security.User

class Request {

	User user
	Alert associatedAlert
	Boolean pending
	String response
	Integer type //1: dbConnection, 2: Data extraction


	public Request(User user, Alert associatedAlert, Boolean pending, String response, Integer type){
		this.user = user
		this.associatedAlert = associatedAlert
		this.pending = pending
		this.response = response
		this.type = type
	}

    static constraints = {
    	response nullable:true
    }

    static mapping={
    	version false
    }
}
