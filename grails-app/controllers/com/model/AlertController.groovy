package com.model

import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional

//Gestiona el estado de visto de las notificaciones
class AlertController {


    @Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER', 'ROLE_CLIENT'])
    def setViewed() {
		def ids = params.ids.split(",")
		for(String st in ids){
			if(st!=""){
				def curAlert = Alert.get(Long.parseLong(st))
				if(curAlert!=null){
					curAlert.setViewed(true)
					curAlert.save(flush:true)
				}
			}
		}
		render status:200
	}



}
