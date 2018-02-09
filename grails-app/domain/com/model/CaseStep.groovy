package com.model

import com.security.User;
import java.util.Date;
import java.lang.StringBuilder

class CaseStep {

    
	Object object
	ActionStep principalAction
	static hasMany =[supportActions:ActionStep]
	User creator
	User lastUpdater
	Date lastUpdated
	Date dateCreated
	Step step


	static belongsTo = [myCase: Case]


	public CaseStep(Step mystep, User creator, Case myCase) {
		super();
		this.step= mystep
		this.object = mystep.object;
		def pa
		if(mystep.isMasive)
		 pa =  new ActionStep(mystep.principalAction, mystep.principalAction.value).save(flush:true,failOnError:true)
		else
		 pa =  new ActionStep(mystep.principalAction, mystep.principalAction.action.defaultValue).save(flush:true,failOnError:true)
		
		
		this.principalAction = pa
		this.creator = creator;
		this.lastUpdater= creator;
		this.myCase =myCase
		
		for(Action action in mystep.supportActions){
			if(mystep.isMasive)
				this.addToSupportActions(new ActionStep(action, action.value).save(flush:true,failOnError:true))
			else
				this.addToSupportActions(new ActionStep(action, action.action.defaultValue).save(flush:true,failOnError:true))
		}
	}


	public CaseStep(Step mystep, User creator, Case myCase, boolean gherkin ) {
		super();
		this.step= mystep
		this.object = mystep.object;
		def pa
		
		 pa =  new ActionStep(mystep.principalAction, mystep.principalAction.value).save(flush:true,failOnError:true)
		
		
		this.principalAction = pa
		this.creator = creator;
		this.lastUpdater= creator;
		this.myCase =myCase
		
		for(Action action in mystep.supportActions){
				this.addToSupportActions(new ActionStep(action, action.value).save(flush:true,failOnError:true))
		}
	}



	public CaseStep(CaseStep model, User creator) {
		super();
		this.step= model.step
		this.object = model.object;
		this.principalAction = new ActionStep(model.step.principalAction, model.principalAction.value).save(flush:true,failOnError:true)
		this.principalAction.setIsActive(model.principalAction.isActive)
		this.creator = creator;
		this.lastUpdater= creator;
		this.myCase =model.myCase
		for(ActionStep action in model.supportActions){
			def curSupAction = new ActionStep(action.action, action.value).save(flush:true,failOnError:true)
			curSupAction.setIsActive(action.isActive)
			this.addToSupportActions(curSupAction)
		}
	}


	public getSupportIds(){
		def StringBuilder rta=new StringBuilder('')
		for( ActionStep supportAction in this.supportActions){
			rta.append(supportAction.id+",")
		}
		if(rta.length()>1){
			rta.setLength(rta.length()-1)
		}
	
		return rta.toString()
	}

	def afterInsert(){
		this.principalAction.setCaseStep(this.id)
		for(ActionStep action in this.supportActions){
			action.setCaseStep(this.id)
		}
	}


	static constraints = {
		object nullable:true
	}

	static mapping ={
		version false
	}

}
