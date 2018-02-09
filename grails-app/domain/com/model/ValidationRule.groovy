package com.model

class ValidationRule {

	String value
	ValidationAction action 
	static belongsTo = [validationColumn: ValidationColumn]

    static constraints = {
    }
    static mapping = {
    	version:false
    }
}
