package com.helpers

class DemoAccount {

	String nameRestriction
	Integer valueRestriction
	Boolean state

	public DemoAccount(String nameRestriction,Integer valueRestriction,Boolean state){
		this.nameRestriction = nameRestriction
		this.valueRestriction = valueRestriction
		this.state = state
	}

    static constraints = {
    	nameRestriction blank:false, unique:true
    	valueRestriction nullable:false
    }
}
