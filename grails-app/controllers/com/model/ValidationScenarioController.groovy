package com.model

import com.security.Role;
import com.security.User;
import grails.plugin.springsecurity.annotation.Secured;
import org.springframework.web.servlet.support.RequestContextUtils;


//Maneja los escenarios de validador (de un proyecto de validacion)
@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
class ValidationScenarioController {
	def springSecurityService
	def notificationsService

    def index() {
    	println params
		def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view='/login/denied'
			return
		}
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def project = ValidatorProject.get(params.id)

		if(!(project in user.getValidatorProjects())){
			render view:"/login/denied"
			return
		}
		def scenarios = project.scenarios.sort{it.dateCreated}
		def webScenarios = []
		def prefix =""
		render view:"index",  model:[associatedProject:project,projectId: project.id, scenarios:scenarios, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0)]
		return
	}

	def create(){
		println params
		def errors = "<ul>"
		def user = springSecurityService.currentUser
		def curProject = ValidatorProject.get(params.id)
		if(!params.type  || !curProject || !(curProject in user.getValidatorProjects())){
			render status:400, text:message(code:"not found")
		}

		switch(params.type){
			case "1":
				if(!params.name){
					errors+="<li>"+message(code:"com.model.ValidationScenario.name.blank.error")+"</li>"
				}
				if(params.name in curProject.scenarios*.name){
					errors+="<li>"+message(code:"com.model.ValidationScenario.name.duplicate.error")+"</li>"
				}
				def newValidator = new ValidationScenario(params.name, params.description, Integer.parseInt(params.type), params.separator, params.filePath, curProject)
				
				if(!newValidator.validate() || errors!="<ul>"){
					def fields = grailsApplication.getDomainClass('com.model.ValidationScenario').persistentProperties.collect { it.name }
		    		for(field in fields){
		    			if(message(error: newValidator.errors.getFieldError(field))!="")
		    				errors+= "<li>"+message(error: newValidator.errors.getFieldError(field))+"</li>"
		    		}
		    		errors+="</ul>"
		    		render status:400, text:errors
		    		return
				}
				newValidator.save(flush:true, failOnError:true)
				render status:200
				return
			break;
			case "2":
			break;
			case "3":
			break;
			default:
				render status:400, text:"Unrecognized type"
			break;
		}


		render sttus:200
	}
}
