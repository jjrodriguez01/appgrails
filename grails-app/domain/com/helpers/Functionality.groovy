package com.helpers

class Functionality {
	
	Integer internalId
	String functionality
	String description
	String roles 
	String client


	public Functionality(Integer internalId, String functionality, String description, String roles,String client){
		this.internalId = internalId
		this.functionality = functionality
		this.description = description
		this.roles = roles
		this.client = client
	}


	public String asString(String input){
		def out= ""
		for(Byte b in input.bytes){
			out+=b.toString()+","
		}
		return out
	}

    static constraints = {
    	internalId blank:false, unique:true
    	functionality  blank:false
    	description  blank:false
    	roles blank:false
    	client nullable: true
    }

    static mapping={
    	version false
    	description type:'text'
    	client defaultValue: "'WEB'"
    }
}
