package com.helpers

class Resource {

	String name
	String resourceVersion
	String url
	Date dateCreated
	Date lastUpdated
	Boolean state
	Integer type //1.actualización  2. descargas 3. miscelanea 4. Browsers

	public Resource(String name, String resourceVersion, String url, Boolean state, Integer type){
		this.name = name
		this.resourceVersion = resourceVersion
		this.url = url
		this.state = state
		this.type = type
	}

    static constraints = {
    	name blank:false, unique:true
    	resourceVersion blank:false, nullable:true    	
    	url blank:true    	
    	state nullable:true
    	type nullable:true
    }

    static mapping = {
    	url type:'text'
    }
}
