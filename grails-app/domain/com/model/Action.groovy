package com.model

import java.util.Date;
import com.security.User;

class Action {

	GenericAction action
	Integer execOrder
	Date lastUpdated
	Date dateCreated
	String value

	public Action(GenericAction action,Integer order, String value) {
		super();
		this.action = action;
		this.execOrder = order;
		this.value=value
		if(value==null)
			this.value=action.defaultValue
	}

	static constraints = {
	}
	static mapping = {
		sort "execOrder"

	}

}
