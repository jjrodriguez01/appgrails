package com.helpers

class Messagei18n {

	String code
 	Locale locale
 	String text

 	public Messagei18n(String code, Locale locale, String text){
 		this.code = code
 		this.locale = locale
 		this.text = text
 	}

    static constraints = {
    }

    static mapping = {
    	text type: "text"
    	version false
		cache true
	}
}
