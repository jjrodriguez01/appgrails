package com.model

class ValidationLog {

	Date executionDate
	String duration
	Integer totalRows
	Integer columnsByRow
	Integer errorCount
	Integer validationsByRow


	static belongsTo = [validationScenario: ValidationScenario]

    static constraints = {
    }
    static mapping = {
    	version:false
    }
}
