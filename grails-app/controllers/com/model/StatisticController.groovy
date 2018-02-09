package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.servlet.support.RequestContextUtils

import grails.converters.JSON

import com.security.User

class StatisticController {

	def springSecurityService
	def notificationsService
	def user
	def locale = RequestContextUtils.getLocale(request)

	@Secured(['ROLE_USER','ROLE_USER_LEADER','ROLE_CLIENT'])
    def index() { 	
		user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def projects = user.getProjects()
		render view:"index",  model:[projects: projects,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0)]
	
    }

    def chooseAProject(){
    	def detail = Integer.parseInt(params.pjDetailId)
    	def projects = user.getProjects()
    	def choosenPj = projects.find { p ->
    		p.id == detail
    	}

    	render view:"details",  model:[projects: projects,choosenPj:choosenPj,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0)]

    }
}
