package com.model

import com.security.User;
import java.util.Date;

class Scenario {

    String name
	String cycle
	String appVersion 
	String casePrefix
	Date dateCreated
	User creator
	User lastUpdater
	Date lastUpdated
	Boolean enabled 
	Integer type //1. Thunder 2. UFT 3. RFT
	String uftPath
	String rftPath
	static belongsTo=[project:Project]
	static hasMany =[cases:Case, steps:Step, messages:Message]
	String browsers =""
	public void addbrowser(String browser){
		if(browser in ['CH', 'SA', 'FF','IE','OP','ED']){
			if(browsers.length()==0)
				this.browsers+=browser
			else
				this.browsers+=","+browser
		}
		
	}


	public boolean isWeb(){
		for(Step curStep in this.steps){
				if(curStep!=null && curStep.isEnabled )
					if(curStep.pType==1){
						return true
					}
			}
		return false;
	}

 
	public Scenario(String name, String cycle, String appVersion, User creator,Project project,String casePrefix, Integer type, String uftPath, String rftPath) {
		super();
		this.name = name;
		this.cycle = cycle;
		this.appVersion = appVersion;
		this.casePrefix=casePrefix
		this.creator = creator;
		this.project = project;
		this.lastUpdater = creator;
		this.browsers= ""
		this.enabled = true
		this.type = type
		this.uftPath = uftPath
		this.rftPath = rftPath
	}

	public Scenario(String name, String cycle, String appVersion, User creator,Project project,String casePrefix) {
		super();
		this.name = name;
		this.cycle = cycle;
		this.appVersion = appVersion;
		this.casePrefix=casePrefix
		this.creator = creator;
		this.project = project;
		this.lastUpdater = creator;
		this.browsers= ""
		this.enabled = true
		this.type = 1
		this.uftPath = ""
		this.rftPath = ""
	}


	static constraints = {
		name blank:false,nullable:false
		cycle blank:false, nullable:false
		appVersion blank:false, nullable:false
		project blank:false, nullable:false
		creator blank:false, nullable:false	
		casePrefix blank:true	
		enabled nullable:true
		uftPath blank:true, nullable:true
		rftPath blank:true, nullable:true
		type nullable:true
    }

	static mapping = {
		version false
		
	}



}
