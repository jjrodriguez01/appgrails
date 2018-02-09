package com.model


import org.springframework.web.servlet.support.RequestContextUtils;

import com.security.Role;
import com.security.User;
import com.helpers.DemoAccount;

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured;
import grails.transaction.Transactional
import java.util.TimeZone

import com.helpers.Functionality


class ProjectController {

	def springSecurityService
	def notificationsService

   @Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000
		def projects = user.getProjects()
		//println "Offset del server: "+offset
		def functionality3 = Functionality.findByInternalId(3)
		def functionality4 = Functionality.findByInternalId(4)
		render view:"index",  model:[projects: projects,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), conditionalRole:"ROLE_USER_LEADER, ROLE_USER", offset:offset, functionality3:functionality3, functionality4:functionality4]
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create() {
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def projectInstance = new Project(params.name.trim(), params.description.trim(), user)
		def flag=false
		if(user.isDemo()){
			def projectsCount = 0;
			for(Project project in user.getProjects()){
				projectsCount++;
				if(project.name.toLowerCase().equals(params.name.toString().toLowerCase())){
					flag=true
					break;
				}
			}
			def demoAccount = DemoAccount.findByNameRestriction("Proyectos")
			if(demoAccount){
					if(projectsCount+1 > demoAccount.valueRestriction){
						render status:403
						return
				}
			}
			
		}else{
			for(Project project in user.getAssociatedClient().getProjects()){
				if(project.name.toLowerCase().equals(params.name.toString().toLowerCase())){
					flag=true
					break;
				}
			}
		}
		if (!projectInstance.validate() || flag ) {
			def errores="<ul>"
			if(flag)
				errores+="<li>"+g.message(code: 'com.model.project.name.error.unique', args:[params.name])+"</li>"
			for(error in projectInstance.errors.getAllErrors()){
				//println "Testing"
				//println error.getCode()
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			errores+="</ul>"
			render status:400, text:errores
			return
		}
		projectInstance.save(flush:true, failOnError:true)
		user.addToProjects(projectInstance)
		user.getAssociatedClient().addToProjects(projectInstance)
		render status:200
		return 
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def update() {
		
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def projectInstance =  Project.get(params.id)
		
		def flag=false
		/*for(Project project in user.getAssociatedClient().getProjects()){
			if(project.name.toLowerCase().equals(params.name.toString().toLowerCase()) && projectInstance.id != project.id)
			{
				render status:400, text:message(code:"com.model.project.name.error.unique")
				return
			}
		}*/
		projectInstance.setName(params.name.trim())
		projectInstance.setDescription(params.description.trim())
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def showInfo() {
		def project =  Project.get(params.id) 
		render project as JSON
	}

	//Le da acceso al proyecto a un miembro del equipo
	@Transactional
	@Secured(['ROLE_CLIENT','ROLE_USER_LEADER'])
	def grantAccess() {

		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def projectToGrant = Project.get(params.id)
		def userToGrant = User.get(params.userId)
		if(!(projectToGrant in user.getProjects()) && !(projectToGrant in user.getAssociatedClient().getProjects())){
			render view:'/login/denied'
			return
		}
		if(params.value=='on' && !(projectToGrant in userToGrant.getProjects())){
			userToGrant.addToProjects(projectToGrant)
		}
		else if(params.value=='off' && (projectToGrant in userToGrant.getProjects())){
			userToGrant.removeFromProjects(projectToGrant)
		}

		render status:200
		return 
	}

	def getPages(){
		
	}

}
