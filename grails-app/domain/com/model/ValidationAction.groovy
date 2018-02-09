package com.model

class ValidationAction {

	String name
	String description

    static constraints = {
    }
    static mapping = {
    	version:false
    	description type:'text'
    }
}
