package com.model

import java.util.Date;

import com.security.User;

class ExecutionExpression {
	Date dateCreated
	User creator
	Date initialDate
	Boolean monday
	Boolean tuesday
	Boolean wednesday
	Boolean thursday
	Boolean friday
	Boolean saturday
	Boolean sunday
	Integer type //1 once, 2 specificDays, 3 daily
	Scenario scenario
	String cases
	String targets
	String browsers

	
    public ExecutionExpression(User creator,Integer type, Date initialDate, Boolean monday,  Boolean tuesday,Boolean wednesday, Boolean thursday, Boolean friday, Boolean saturday, Boolean sunday, Scenario scenario, String cases, String targets, String browsers) {
		this.creator = creator;
		this.type=type
		this.initialDate = initialDate;
		this.monday = monday
		this.tuesday = tuesday
		this.wednesday = wednesday
		this.thursday = thursday
		this.friday = friday
		this.saturday = saturday
		this.sunday = sunday
		this.scenario = scenario
		this.cases = ""
		this.browsers = browsers
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
		this.targets = targets
	}



	static constraints = {
		cases blank:true
		targets blank:false

    }
	
	static mapping={
		version false
		sort dateCreated:"asc"
	}
}
