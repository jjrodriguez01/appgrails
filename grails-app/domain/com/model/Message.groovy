package com.model

import com.security.User;
import java.util.Date;

class Message {
	Object object
	String message
	Integer type //1. Pending 2. Error  3. Success
	Boolean byClueWords
	String scope // ALL: TODOS;  3#8 DEL 3 AL 8
	User lastUpdater
	User creator
	Date lastUpdated
	Date dateCreated
	User associatedClient
	Page page


	public Message(Object object,String message, Boolean byClueWords, Integer type,String scope, User creator, Page page, User associatedClient){
		this.object = object
		this.message = message
		this.byClueWords = byClueWords
		this.type = type
		this.scope = scope
		this.creator = creator
		this.lastUpdater = creator
		this.associatedClient = associatedClient
	}


    static constraints = {
    	object nullable:false
    	message nullable:false, blank:true
    	type nullable:false, blank:true
    	scope nullable:false, blank:false
    	byClueWords nullable:false, blank:true
    	creator nullable:false, blank:true
    	page nullable:true
    }

    static mapping ={
    	version:false
    }
}
