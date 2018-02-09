package com.model

import com.security.User
import java.util.Date

class Execution {

	User target
	User creator
	Date lastUpdated
	Date dateCreated
	Date executionDate
	Boolean isProgrammed
	Integer state //1. existe pero no ha sido recibida por el target, 2. Recibido por el target (en proceso), 3. finalizado
	Scenario scenarioToExecute
	Integer progress
	String stateMessage
	String cases = null
	String browsers

	public Execution(User target, User creator, Boolean isProgrammed,Date executionDate, Integer state, Scenario scenarioToExecute, String cases, String browsers){
		this.target = target
		this.creator = creator
		this.isProgrammed = isProgrammed
		this.executionDate = executionDate
		this.state = state
		this.scenarioToExecute = scenarioToExecute
		this.progress = 0
		this.stateMessage = "text.created"
		this.cases =""
			def splittedCases = cases.split(',')
		for(def i=0;i<splittedCases.length;i++){
			if(splittedCases[i].contains('-')){
				def splittedRange = splittedCases[i].split('-')
				def init = Integer.parseInt(splittedRange[0])
				def end = Integer.parseInt(splittedRange[1])
				for(def j=init;j<=end;j++){
					if(i==splittedCases.length-1 && j==end){
						this.cases+=j
						}
					else{
						this.cases+=j+','
					}
				}

			}
			else{
				if(i==splittedCases.length-1){
					this.cases+=splittedCases[i]
				}
				else{
					this.cases+=splittedCases[i]+','
				}
				
			}
		}
		println "cases: "+this.cases
		this.browsers = browsers
	}


	public Execution(User target, User creator, Boolean isProgrammed,Date executionDate, Integer state, Scenario scenarioToExecute){
		this.target = target
		this.creator = creator
		this.isProgrammed = isProgrammed
		this.executionDate = executionDate
		this.state = state
		this.scenarioToExecute = scenarioToExecute
		this.progress = 0
		this.stateMessage = "text.created"
		this.cases = null
		this.browsers = scenarioToExecute.browsers
	}

    static constraints = {
    	target nullable:false
    	creator nullable:false
    	isProgrammed nullable:false
    	state nullable:false
    	scenarioToExecute nullable:false
    	cases nullable:true
    }

    static mapping={
    	version false
    }
}
