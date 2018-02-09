package com.helpers

import org.springframework.context.support.AbstractMessageSource
import com.helpers.Messagei18n
import java.text.MessageFormat
import grails.transaction.Transactional


class DatabaseMessageSource extends AbstractMessageSource {

    def messageBundleMessageSource
    def static HashMap<String, String> messages = new HashMap<String, String>()



	@Transactional
	protected MessageFormat resolveCode(String code, Locale locale) {   
		def format
        def instance = messages.get(code+locale.toString().substring(0,2).toLowerCase())
        if(code=="text.referenceImage"){
            println "***"
        }
        if(instance){

            return new MessageFormat(instance, locale);
        }
        Messagei18n message = Messagei18n.findByCodeAndLocaleLike(code, locale.toString().substring(0,2).toLowerCase());        
        if (message) {
            format = new MessageFormat(message.text, message.locale);
        } else {
            format = messageBundleMessageSource.resolveCode(code, locale);           
        }
        return format;
	}

    public static loadMessages(){
        def messagesList = Messagei18n.list()
        for(message in messagesList){
            messages.put(message.code+message.locale, message.text)
        }
    }


}
