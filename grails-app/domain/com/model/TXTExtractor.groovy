package com.model

import com.security.User

class TXTExtractor {

	User creator
	User lastUpdater	 
	Txt txtFile
	String cases
	String originalCases
	String fieldsMap
	String name
	Scenario scenario
	Boolean isEnabled
	String fileName
	String delimiter

	public TXTExtractor(User creator, Txt txtFile, String cases, String fieldsMap, String name, Scenario scenario, Boolean isEnabled, String fileName, String delimiter){
		this.creator = creator
		this.lastUpdater = creator
		this.txtFile = txtFile
		this.originalCases  = cases
		this.isEnabled = isEnabled
		this.fileName = fileName
		this.delimiter = delimiter

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

		this.fieldsMap = fieldsMap
		this.name = name
		this.scenario = scenario		
	}


	public int getRemainingData(){
    	return txtFile.getRemainingData()
    }

    static constraints = {
    }

    static mapping ={
    	version false
    }
}

