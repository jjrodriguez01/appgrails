package com.model

import com.security.User

class BDExtractor {

	User creator
	User lastUpdater
	Date dateCreated 
	String dbUser
	String dbPass
	String query
	String port
	String bdName
	String ip
	String dbGestor
	String cases
	String originalCases
	String fieldsMap
	String name
	String burnedData
	Scenario scenario
	String clueField
	Boolean enabled

	public BDExtractor(User creator, String name, String dbGestor,String bdName, String port, String dbUser, String dbPass, String query, String ip, String fieldsMap, String cases,  String clueField, Scenario scenario, Boolean enabled){

		this.creator = creator
		this.lastUpdater = creator
		this.name = name
		this.dbGestor = dbGestor
		this.bdName = bdName
		this.port = port
		this.dbUser = dbUser
		this.dbPass = dbPass
		this.query = query
		this.ip = ip
		this.fieldsMap = fieldsMap
		this.cases = ""
		this.originalCases = cases

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
		this.ip = ip
		this.clueField = clueField
		this.scenario = scenario
		this.enabled = enabled
		this.burnedData = ""

	}


    static constraints = {
    	name blank:false
    	dbGestor blank:false
    	bdName blank:false
    	port blank:false
    	dbUser blank:false
    	query blank:false
    	ip blank:false
    	fieldsMap blank:false
    	cases blank:false
    	clueField blank:false
    	originalCases blank:true
    }

    static mapping ={
    	version false
    }
}
