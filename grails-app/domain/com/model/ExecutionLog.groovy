package com.model

import java.util.Date;

class ExecutionLog {

    String scenario
    Scenario associatedScenario
    String cycle
    String appVersion
    Integer caseCount
    Integer caseFailedCount
    String duration
    Date executionDate
    String target
    String executor
    Date dateCreated

    static hasMany = [logs:CaseLog]
    static belongsTo= [project:Project]

    public ExecutionLog(Scenario associatedScenario, String cycle, String appVersion, Integer caseCount, Integer caseFailedCount, String duration, Date executionDate, String target, String executor){
        this.associatedScenario = associatedScenario
        this.cycle = cycle
        this.appVersion = appVersion
        this.caseCount = caseCount
        this.caseFailedCount = caseFailedCount
        this.duration = duration
        this.executionDate = executionDate
        this.target = target
        this.executor = executor
        this.scenario = associatedScenario.name
    }

    static constraints = {
        associatedScenario nullable:true
        scenario nullable:false, blank:false
        cycle nullable:false, blank:false
        appVersion nullable:false, blank:false
        caseCount nullable:false, blank:false
        caseFailedCount nullable:false, blank:false
        duration nullable:false, blank:false
        executionDate nullable:false, blank:false
        target nullable:false, blank:false
        executor nullable:false, blank:false
    }

    static mapping={
        version false
    }
}
