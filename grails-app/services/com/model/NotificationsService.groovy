package com.model

import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.servlet.support.RequestContextUtils;

import org.springframework.context.MessageSource
import org.springframework.context.NoSuchMessageException
import java.util.TimeZone

@Transactional
class NotificationsService {

	def springSecurityService
	def sessionManagerService
	def MessageSource messageSource

	@Transactional
	def private getNotifications(user,locale, session, type){
		//println "Impresion de session: "+session.getId()
		
		def alertsCriteria = Alert.createCriteria()

		def alerts = Alert.findAll("from Alert as b where b.type=:type and b.target=:user",
             [type: 1, user:user], [max: 20, sort: "dateCreated",order: "desc"])



		def alertsCount = Alert.countByTypeAndTargetAndViewedAndActionNotification(1,user,false,'')>20?20:Alert.countByTypeAndTargetAndViewedAndActionNotification(1,user,false,'')
		def alertsToSend = []
		for(Alert alert in alerts){
			
			def curAlert= [id:alert.id,message:alert.message, type:alert.type, iconClass:alert.iconClass, iconColor:alert.iconColor, parameters:alert.parameters, viewed:alert.viewed, dateCreated: alert.dateCreated.toString(), actionNotification:alert.actionNotification.trim()]
			def arguments = []
			def splitted = alert.parameters.split(',')
			try{
				curAlert.message=messageSource.getMessage(alert.message, splitted,locale)
			}
			catch(NoSuchMessageException nsme){
				curAlert.message=alert.message
			}
			alertsToSend.push(curAlert)
		}


		def messages = Alert.findAll("from Alert as b where b.type=:type and b.target=:user",
             [type: 2, user:user], [max: 20, sort: "dateCreated",order: "desc"])


		def messagesCount = Alert.countByTypeAndTargetAndViewedAndActionNotification(2,user,false,'')>20?20:Alert.countByTypeAndTargetAndViewed(2,user,false)
		def messagesToSend =[]
		for(Alert alert in messages){
			
			def curMessage= [id:alert.id,message:alert.message,  type:alert.type, iconClass:alert.iconClass, iconColor:alert.iconColor, parameters:alert.parameters, viewed:alert.viewed,dateCreated: alert.dateCreated.toString(), actionNotification:alert.actionNotification]
			def arguments = []
			def splitted = alert.parameters.split(',')
			try{
				curMessage.message=messageSource.getMessage(alert.message, splitted,locale)
			}
			catch(NoSuchMessageException nsme){
				curMessage.message=alert.message
			}
		
			messagesToSend.push(curMessage)
		}

		
		def notifications = Alert.findAll("from Alert as b where b.type=:type and b.target=:user",
             [type: 3, user:user], [max: 20, sort: "dateCreated",order: "desc"])


		def notificationsCount = Alert.countByTypeAndTargetAndViewedAndActionNotification(3,user,false,'')>20?20:Alert.countByTypeAndTargetAndViewed(3,user,false)
		def notificationsToSend =[]
		for(Alert alert in notifications){
			def curNotification= [id:alert.id,message:alert.message, type:alert.type, iconClass:alert.iconClass, iconColor:alert.iconColor, parameters:alert.parameters, viewed: alert.viewed,dateCreated: alert.dateCreated.toString(),  actionNotification:alert.actionNotification]
			def arguments = []
			def splitted = alert.parameters.split(',')
			try{
				curNotification.message=messageSource.getMessage(alert.message, splitted,locale)
			}
			catch(NoSuchMessageException nsme){
				curNotification.message=alert.message
			}
			notificationsToSend.push(curNotification)
		}
		
		def activeSession = sessionManagerService.verifySession(user.getUsername(), session,type)
		
		if(type==0)
			//println "La respuesta del session manager para "+session.getId()+" es: "+activeSession
			if(activeSession){
				if(type==0)
					user.setLastWebAction(new Date())
				else if(type==1)
					user.setLastDesktopAction(new Date())
				user.save(flush:true,failOnError:true)
			}
		
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def answer = [alerts:alertsToSend,alertsCount:alertsCount,messages:messagesToSend,messagesCount:messagesCount,notifications:notificationsToSend,notificationsCount:notificationsCount, activeSession:activeSession.toString(), offset:(tz.getRawOffset()/60000)]

		return answer
	}


}
