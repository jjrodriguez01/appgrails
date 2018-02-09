package com.model

import com.security.User;
import java.util.Date;

class Step {

    Object object
	Integer execOrder
	Action principalAction
	static hasMany =[supportActions:Action]
	Boolean mustTakeScreenShot
	Boolean mustTakeLocalScreenShot
	Boolean isEnabled
	Boolean forceCoordinates
	Boolean isMasive
	Boolean isHidden
	User creator
	User lastUpdater
	Date lastUpdated
	Date dateCreated
	Integer pType //1. WEB 2. GUI 3.CLI 4.UFT 5.RFT
	Boolean isScenario= false
	Scenario associatedScenario = null


	public Step(Object object,Integer order, Action principalAction,
	Boolean mustTakeScreenShot,Boolean mustTakeLocalScreenShot, Boolean isEnabled, User creator, Boolean isMasive,Boolean isHidden, Boolean forceCoordinates) {
		super();
		this.object = object;
		this.execOrder = order
		this.principalAction = principalAction
		this.mustTakeScreenShot = mustTakeScreenShot;
		this.mustTakeLocalScreenShot = mustTakeLocalScreenShot;
		this.isEnabled = isEnabled;
		this.creator = creator;
		this.lastUpdater = creator;
		this.isMasive = isMasive;
		this.isHidden = isHidden
		this.forceCoordinates = forceCoordinates;
		this.pType = object.pType
	}
	
	
	public Step(Object object,Integer order, Action principalAction,
		Boolean mustTakeScreenShot, Boolean mustTakeLocalScreenShot,Boolean isEnabled, User creator, Boolean isMasive, Boolean isHidden,Boolean forceCoordinates,Integer pType) {
			super();
			this.object = object;
			this.execOrder = order
			this.principalAction = principalAction
			this.mustTakeScreenShot = mustTakeScreenShot;
			this.mustTakeLocalScreenShot = mustTakeLocalScreenShot;
			this.isEnabled = isEnabled;
			this.creator = creator;
			this.lastUpdater = creator;
			this.isMasive = isMasive;
			this.isHidden = isHidden
			this.forceCoordinates = forceCoordinates;
			this.pType = pType
		}
	
	


	public Set getSupportActionsByOrder(){
		return this.supportActions.sort{it.execOrder}*.action
	}
	public Set getSupportActionsByOrderOriginal(){
		return this.supportActions.sort{it.execOrder}
	}
	

	def getSupportActionsValue(){
		if(!this.isMasive){
			return null
		}

		def supportCode =""
		for(Action action in this.supportActions.sort{it.execOrder}){
			supportCode+=action.value+"&&"
		}
		return supportCode
	}

	static constraints = {
		object nullable:true
		associatedScenario nullable:true
	}

	static mapping = {
		version false;
		sort execOrder: "asc"
	}
}
