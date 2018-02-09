package com.model

import java.util.Date;

class Log {

	Integer stepNumber
	String objectName
	String action
	Boolean isSuccess
	String message
	String imageUrl
	Date dateCreated
	String imageHash
	
	public Log(Integer stepNumber, String objectName, String action, Boolean isSuccess, String message, String imageUrl, String imageHash){
		this.stepNumber = stepNumber
		this.objectName = objectName
		this.action = action
		this.isSuccess = isSuccess
		this.message = message
		this.imageUrl = imageUrl
		this.imageHash = imageHash
	}
	

    static constraints = {
    	objectName nullable:false, blank:true
    	action nullable:false, blank:false
    	isSuccess nullable:false, blanck:false
    	message nullable:false, blank:false
    	imageHash blank:true, nullable:true
    }
	
	static mapping ={
		version false
	}
	
}
