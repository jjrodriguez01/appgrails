package com.model
import com.security.User

class Generator {

	User creator
	Date dateCreated
	String name
	String fieldsMap
	String cases
	Integer type //1. string, 2.numerico, 3. por formato
	Integer length
	String pattern
	Integer rangeInit
	Integer rangeEnd
	String base
	Scenario scenario
	Boolean enabled

	Generator(User creator, String name, String fieldsMap, String cases, Integer type, Integer length, String pattern, Integer rangeInit, Integer rangeEnd, String base, Scenario scenario, Boolean enabled){
		this.creator = creator
		this.name = name
		this.fieldsMap = fieldsMap
		this.cases = cases
		this.type = type
		this.length = length
		this.pattern = pattern
		this.rangeInit = rangeInit
		this.rangeEnd = rangeEnd
		this.base = base
		this.scenario = scenario
		this.enabled = enabled
		this.dateCreated = new Date()
	}

    static constraints = {
    	name nullable:false, blank:false
    	fieldsMap nullable:false, blank:false
    	cases nullable:false, blank:false
    	type nullable:false, blank:false, validator: { value, obj ->            
            if(value){            	
            	//String:1 Number:2
            	if((value == 1) && (obj.base == 'genLength')){
            		if(obj.length == null){            		
	            		return "generator.length.blank.error"	                
	            	}
            	} else if((value == 1) && (obj.base == 'genPattern')){
            		if(obj.pattern == ''){            		
	            		return "generator.pattern.blank.error"	                
	            	}
            	}

            	if((value == 2) && (obj.base == 'genLength')){
            		if(obj.length == null){
	            		return "generator.length.blank.error"
	            	}
	            } else if((value == 2) && (obj.base == 'genPattern')){
            		if(obj.rangeInit == null || obj.rangeEnd == null){
	            		return "generator.range.blank.error"
	            	}
	            }
            }
        }
    	length nullable:true
    	pattern nullable:true, blank:true
    	rangeInit nullable:true
    	rangeEnd nullable:true, validator: { value, obj ->            
            if(value != null){
            	if(value < obj.rangeInit){
            		return "generator.range.less.error"
            	}
            }
        }
        base nullable:false, blank:false
    }
}
