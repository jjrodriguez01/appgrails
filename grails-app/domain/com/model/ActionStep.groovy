package com.model

import java.util.Date;

class ActionStep {
	
	Action action
	Integer execOrder
	String value
	Date dateCreated
	Date lastUpdated
	Boolean isActive
	Long caseStep=null
	
	
    public ActionStep(Action action, String value) {
	
		super();
		this.action = action;
		this.execOrder = action.execOrder;
		this.value = value;
		this.isActive=true
	
	}

	def public getHtml(){
		def total = this.action.action.html.split('value=""').length
		//println "nombre: "+this.action.action.name +",    total: "+total
		def values = this.value.split('#;#') 
		def actualHtml=""

		for(def i=0; i<total; i++){
			if(i==0 ){
				if(values.length>i)
					actualHtml=this.action.action.html.replaceFirst('value=""','value="'+values[i]+'"').replace('id=""','id="action'+this.id+'"')
				else{
					actualHtml=this.action.action.html.replace('id=""','id="action'+this.id+'"')
				}
			}
			else{
				if(values.length>i)
					actualHtml=actualHtml.replaceFirst('value=""','value="'+values[i]+'"')
			}
		
		}
		return actualHtml
	}

	static constraints = {
		caseStep nullable:true
    }
	
	static mapping ={
		version false
	}
}
