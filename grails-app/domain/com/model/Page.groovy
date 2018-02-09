package com.model

import com.security.User;
import java.util.Date;

class Page {

	String name
	String description
	Boolean isPrivate
	Date dateCreated
	User creator
	Date lastUpdated
	User lastUpdater
	
	
	static hasMany = [objects:Object, messages:Message]

    public Page(String name, String description, Boolean isPrivate, User creator) {
		super();
		this.name = name;
		this.description = description;
		this.isPrivate = isPrivate;
		this.creator = creator;
		this.lastUpdater=creator;
	}


	def afterInsert() {
		def myObj = new Object("CLI", "CLI", "terminal",0, 0, this.creator,3, "",GenericAction.findByName('genericAction.write'), "noHash",this.creator.plan==0?this.creator:this.creator.associatedClient,this, true).save()
	    this.addToObjects(myObj)
		def alert = new Object("ALERT", "Alert", "alert",0, 0, this.creator,1, "",GenericAction.findByName('genericAction.alert'), "noHash",this.creator.plan==0?this.creator:this.creator.associatedClient,this, true).save()
	    this.addToObjects(alert)
	}

	static constraints = {
    		name blank:false,nullable:false
    		description blank:false, nullable:false
    		isPrivate blank:false, nullable:false
		}
	
	
	static mapping = {
		version false
		name  sqlType: "TEXT"
		description  sqlType: "TEXT"
		
	}

}
