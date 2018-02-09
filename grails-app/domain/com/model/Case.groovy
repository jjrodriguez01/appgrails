package com.model

import com.security.User;
import java.util.Date;

class Case {

    String name
	String description
	Integer execOrder
	Integer stateLastExecution // 1. Success, 2. Error, 0. Not executed
	Boolean isEnabled
	Date dateLastExecution
	User creator
	User lastUpdater
	Date lastUpdated
	Date dateCreated
	Boolean isArchive
	Boolean errorOriented = false
	Step errorStep 
	
	static hasMany =[steps:CaseStep]
	static belongsTo=[scenario:Scenario]



    public Case(String name, String description, Integer execOrder,	Date dateLastExecution, User creator, Scenario scenario) {
		super();
		this.name = name;
		this.description = description;
		this.execOrder = execOrder;
		this.stateLastExecution = 0;
		this.dateLastExecution = null;
		this.creator = creator;
		this.lastUpdater= creator;
		this.isEnabled=true
		this.isArchive = false
		this.scenario=scenario
	}

	static constraints = {
		name blank:false,  nullable:false
		description blank:false,  nullable:false
		creator nullable:false
		dateLastExecution nullable:true
		errorOriented nullable:true
		errorStep nullable:true
    }
	
	static mapping={
		version false
		table 'thunderCase'
		description type:'text'
	}
}
