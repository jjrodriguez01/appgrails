package com.model

class ValidationColumn {

	String name
	Integer index
	String type
	Integer initPos
	Integer lastPos
	static hasMany = [rules: ValidationRule]
	static belongsTo = [validationScenario: ValidationScenario]

    static constraints = {
    }
    static mapping = {
    	version:false
    }
}
