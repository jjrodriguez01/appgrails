package com.model

class ValidationScenario {

	String name
	String description
	Integer initRow
	Integer lastRow
	Integer type //1: Delimited, 2: By size 3. DB
	Date dateCreated
	String separator
	String connectionResource //Path del archivo ó si es DB los datos de conexión separados por #;#

	static hasMany = [logs: ValidationLog, columns:ValidationColumn]
	static belongsTo = [validationProject: ValidatorProject]

	public ValidationScenario(String name, String description, Integer type, String separator, String connectionResource, ValidatorProject project){
		this.name = name
		this.description = description
		this.type = type
		this.separator = separator
		this.connectionResource = connectionResource
		this.validationProject = project
		this.initRow = 0
		this.lastRow = 0
	}

    static constraints = {
    }

    static mapping = {
    	version: false
    	description type:'text'
    }
}
