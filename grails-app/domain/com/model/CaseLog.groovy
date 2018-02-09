package com.model

import java.util.Date;

class CaseLog {
	
	String caseName
	String browser
	Integer stepCount
	Integer executedStepCount
	Date executionDate
	Date dateCreated
	Long executorId
	Boolean isSuccess
	String duration

	static hasMany = [logs:Log]
	static belongsTo = [execLog: ExecutionLog]

	public CaseLog(String caseName, String browser, Integer stepCount, Integer executedStepCount, Date executionDate, Long executorId, 	Boolean isSuccess, String duration){
		this.caseName = caseName
		this.browser = browser
		this.stepCount = stepCount
		this.executedStepCount = executedStepCount
		this.executionDate = executionDate
		this.executorId = executorId
		this.isSuccess = isSuccess
		this.duration = duration

	}


    static constraints = {
    	caseName nullable:false, blank:false
    	browser nullable:false, blank:true
    	stepCount nullable:false, blank:false
    	executedStepCount nullable:false, blank:false
    	executionDate nullable:false, blank:false
    	duration nullable:false, blank:true

    }
    static mapping={
    	version false
    }
}
