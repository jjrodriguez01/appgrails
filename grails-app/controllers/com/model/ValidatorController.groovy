package com.model

import org.springframework.web.servlet.support.RequestContextUtils;

import com.security.Role;
import com.security.User;

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured;
import grails.transaction.Transactional
import java.util.TimeZone

import com.helpers.Functionality

//Maneja los proyectos de validacion
@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
class ValidatorController {

	def springSecurityService
	def notificationsService


	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000
		def projects = user.getValidatorProjects()
		//println "Offset del server: "+offset
		def functionality3 = Functionality.findByInternalId(3)
		def functionality4 = Functionality.findByInternalId(4)
		def functionality35 = Functionality.findByInternalId(35)
		render view:"index",  model:[projects: user.getProjects(), vProjects:projects,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), conditionalRole:"ROLE_USER_LEADER, ROLE_USER", offset:offset, functionality35:functionality35]
	}


	def create() {
		def user = springSecurityService.currentUser
		def errors = "<ul>"
		def newValidatorProject = new ValidatorProject(params.name, params.description, user)
		if(newValidatorProject.name in user.getValidatorProjects()*.name){
			errors+="<li>"+message(code:"error.ValidatorProject.name.unique", args:[params.name])+"</li>"
		}
		if(!newValidatorProject.validate() || errors!="<ul>"){
			def fields = grailsApplication.getDomainClass('com.model.ValidatorProject').persistentProperties.collect { it.name }
    		for(field in fields){
    			if(message(error: newValidatorProject.errors.getFieldError(field))!="")
    				errors+= "<li>"+message(error: newValidatorProject.errors.getFieldError(field))+"</li>"
    		}
    		errors+="</ul>"
    		render status:400, text:errors
    		return
		}
		newValidatorProject.save(flush:true, failOnError:true)
		user.addToVProjects(newValidatorProject)
		render status:200 
	}


	@Transactional
	def update() {
		println params
		
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
	
		def projectInstance =  ValidatorProject.get(params.id)
		if(!projectInstance){
			render status:400, text:message(code:"error.ValidatorProject.notFound")
			return
		}
		

		def flag=false

		/*for(ValidatorProject project in user.getValidatorProjects()){
			println project.name.trim().equals(params.name.toString().trim())
			if(project.name.trim().equals(params.name.toString().trim()) && projectInstance.id != project.id)
			{
				render status:400, text:message(code:"error.ValidatorProject.name.unique")
				return
			}
		}*/
		projectInstance.setName(params.name.trim())
		projectInstance.setDescription(params.description.trim())
		render status:200
	}
}
