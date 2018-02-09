package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;

import java.lang.NumberFormatException
import grails.converters.JSON
import com.helpers.*

class MessageController {

	def springSecurityService
	def notificationsService


//Lista en página
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index(){
    	def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view:'/login/denied'
			return
		}

		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def page = Page.get(params.id)
		if(!(page in user.getProjects()*.pages.flatten())){
			render view:'/login/denied'
			return
		}

		def messages = page.messages.sort{it.dateCreated}
		def associatedProject=Project.get(params.projectId)
		if(!associatedProject){
			render view:'/login/denied'
			return
		}
		def functionality29 = Functionality.findByInternalId(29)
		def functionality30 = Functionality.findByInternalId(30)

		render view:"index",  model:[messages: messages, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(),associatedProject:associatedProject , associatedPage:page, functionality29:functionality29, functionality30:functionality30]
	}


//lista los mensajes incluidos en el escenario
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def scenario(){
    	def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view:'/login/denied'
			return
		}
 
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario = Scenario.get(params.id)
		if(!scenario){
			render view:'/login/denied'
			return
		}
		println scenario.type
		if(scenario.type == 2 || scenario.type == 3){
			render view:"/login/denied"
			return
		}
		def pages = scenario.project.pages
		if(!(scenario in user.getProjects()*.scenarios.flatten())){
			render view:'/login/denied'
			return
		}
 
		def messages = scenario.messages.sort{it.dateCreated}
		def projectId = scenario.project.id

		def functionality31 = Functionality.findByInternalId(31)
		def functionality32 = Functionality.findByInternalId(32)

		render view:"messages",  model:[messages: messages,pages:pages, associatedScenario:scenario, scenarioId:scenario.id,projectId:projectId, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), functionality31:functionality31, functionality32:functionality32]
	}

	//Agrega un mensaje al escenario dado
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def addMessageToScenario() {
		def messages = params.messages.toString().split(",")
		def scenario = Scenario.get(params.id);
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		for(String message in messages){
			def curMsg = Message.get(Long.parseLong(message))
			scenario.addToMessages(curMsg)
			scenario.save(flush:true,failOnError:true)
		}
		render status:200
		return
	}

	//Crea un mensaje desde stage
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def createFromStageObject() {
		def objects = params.objects.toString().split(",")
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def result = []
		for(String obj in objects){
			def Object curObj = Object.get(Long.parseLong(obj))
			def newMessage= new Message(curObj, "",false, 1,"ALL", user, null, user.associatedClient).save(flush:true, failOnError:true)
			result.push([object:curObj.name,imageUrl:curObj.imageUrl,id:newMessage.id, message:newMessage.message, objectId:curObj.id])
		}
		def jsonResult = result as JSON
		render (jsonResult)
		return
	}

//Crea un mensaje desde la página
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def createFromPageObject() {
		def objects = params.objects.toString().split(",")
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		for(String obj in objects){
			def Object curObj = Object.get(Long.parseLong(obj))
			def newMessage= new Message(curObj, "",false, 1,"ALL", user, curObj.page, user.associatedClient).save(flush:true, failOnError:true)
			curObj.page.addToMessages(newMessage)
		}
		render status:200
		return
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteFromScenario( ) {
		def messageInstance = Message.get(params.id)
		if (messageInstance == null) {
			render view:'/login/denied'
			return
		}
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(!(messageInstance in user.getProjects()*.scenarios*.messages.flatten())){
			render view:'/login/denied'
			return
		}

		Scenario.get(params.scenarioId).removeFromMessages(messageInstance)
		render status:200
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteFromStage( ) {
		def messageInstance = Message.get(params.id)
		if (messageInstance == null) {
			render view:'/login/denied'
			return
		}
		messageInstance.delete(flush:true, failOnError:true)
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteFromPage( ) {
		def messageInstance = Message.get(params.id)
		def page = Page.get(Long.parseLong(params.pageId))
		if (messageInstance == null) {
			render view:'/login/denied'
			return
		}
		def messages = ProjectPage.findByPage(page).project.scenarios*.messages.flatten()
		if(messageInstance in messages){
			render status:400, text: message(code:"message.error.notDeletable")
			return
		}
		page.removeFromMessages(messageInstance)
		messageInstance.delete(flush:true,failOnError:true)
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteMasiveFromScenario( ) {
		def messages = params.messagesToDelete.toString().split(',')
		def scenario = Scenario.get(Integer.parseInt(params.scenarioId))
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		for(def i=0;i<messages.size();i++){
			def messageInstance = Message.get(Integer.parseInt(messages[i]))
			if (messageInstance == null) {
				render view:'/login/denied'
				return
			}		
			if(!(messageInstance in user.getProjects()*.scenarios*.messages.flatten())){
				render view:'/login/denied'
				return
			}
			scenario.removeFromMessages(messageInstance)
		}
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteMasiveFromPage() {
		def idsMessages = params.messagesToDelete.toString().split(',')
		def page = Page.get(Long.parseLong(params.pageId))
		def messages = ProjectPage.findByPage(page).project.scenarios*.messages.flatten()
		def detailsErrors = ''
		for(def i=0;i<idsMessages.size();i++){
			def messageInstance = Message.get(Integer.parseInt(idsMessages[i]))		
			if (messageInstance == null) {
				render view:'/login/denied'
				return
			}			
			if(messageInstance in messages){
				render status:400, text: message(code:"message.error.notDeletable")
				return
			}
			page.removeFromMessages(messageInstance)
			messageInstance.delete(flush:true,failOnError:true)
		}
		render status:200
		return
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create(){
		def messageInstance=null
		def errors=[]
		def scenario= Scenario.get(params.id)
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def messageMessage = params.message
		def scope = params.scope
		if(!scope.equals('ALL')){
			if(scope.split('#').length>=2){
				def from = scope.split('#')[0]
				def to = scope.split('#')[1]
				try{
					from = Integer.valueOf(from)
					to = Integer.valueOf(to)
					if(to<from || from<1 || to>=scenario.steps.size()){
						scope="ALL"
					}

				}
				catch(NumberFormatException nfe){
					scope="ALL"
				}
			}
			else{
				scope="ALL"
			}



		}
		def byClueWords = Boolean.parseBoolean(params.byClueWords)
		if(byClueWords){
			messageMessage = messageMessage.replaceAll(" ",'#;#')
		}
		def messageObject = Object.get(params.object)
		messageInstance = new Message(messageObject, messageMessage, byClueWords,Integer.parseInt(params.type),scope,user)
		
		if (messageInstance == null) {
			return
		}
		def flag=false;
		for(Message message in scenario.messages){
			if((message.message.toLowerCase().equals(params.message.toString().toLowerCase())) && (message.object.equals(messageObject))) {
				flag=true
				break;
			}
			
		}

		if (!messageInstance.validate() || flag ) {

			def errores="<ul>"
			
			if(flag)
				errores+="<li>"+g.message(code: 'com.model.message.name.error.unique', args:[params.message])+"</li>"

			for(error in messageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"
			render status:400, text:errores
			return
		}
		messageInstance.save(flush:true,failOnError:true)
		scenario.addToMessages(messageInstance)
		render status:200
		return 
	}

//Cambia el mensaje a palabras clave 
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def changeByClueWords(){		
		def messageInstance=Message.get(params.id)
		if (messageInstance == null) {
			return
		}
		if(params.byClueWords=="true"){
			messageInstance.byClueWords=true;
		}
		else{
			messageInstance.byClueWords=false;
		}
		messageInstance.save(flush:true, failOnError:true)
		render status:200
		return
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateFromScenario(){
		def messageInstance=Message.get(params.id)
		if (messageInstance == null) {
			return
		}
		def errors=[]
		def scenario= Scenario.get(params.scenarioId)
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def messageMessage = params.message
		def scope = params.scope
		if(!scope.equals('ALL')){
			if(scope.split('#').length>=2){
				def from = scope.split('#')[0]
				def to = scope.split('#')[1]
				try{
					from = Integer.valueOf(from)
					to = Integer.valueOf(to)
					if(to<from || from<1){
						scope="ALL"
					}

				}
				catch(NumberFormatException nfe){
					scope="ALL"
				}
			}
			else{
				scope="ALL"
			}



		}
		def byClueWords = Boolean.parseBoolean(params.byClueWords)
		if(byClueWords){
			messageMessage = messageMessage.replaceAll(" ",'#;#')
		}

		def oldMessage = messageInstance.getMessage()
		def oldType = messageInstance.getType()
		def oldScope = messageInstance.getScope()
		def oldByClueWords = messageInstance.getByClueWords()

		messageInstance.setScope(scope)
		messageInstance.setMessage(messageMessage)
		messageInstance.setType(Integer.valueOf(params.type))
		messageInstance.setLastUpdater(user)
		messageInstance.setByClueWords(byClueWords)

		def flag=false;
		for(Message message in scenario.messages){
			if((message.message.toLowerCase().equals(params.message.toString().toLowerCase())) && (message.object.equals(messageInstance.object)) && (message.id != messageInstance.id)) {
				flag=true
				break;
			}
			
		}

		if (!messageInstance.validate() || flag ) {

			def errores="<ul>"
			
			if(flag)
				errores+="<li>"+g.message(code: 'com.model.message.name.error.unique', args:[params.message])+"</li>"

			for(error in messageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"

			messageInstance.setMessage(oldMessage)
			messageInstance.setType(oldType)
			messageInstance.setScope(oldScope)
			messageInstance.setByClueWords(oldByClueWords)

			render status:400, text:errores
			return
		}
		messageInstance.save(flush:true,failOnError:true)
		render status:200
		return 
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateFromStage(){
		def messageInstance=Message.get(params.id)
		if (messageInstance == null) {
			return
		}
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def messageMessage = params.message
		

		def byClueWords = Boolean.parseBoolean(params.byClueWords)
		if(byClueWords){
			
			messageMessage = messageMessage.replaceAll(" ",'#;#')
		}
		def messageObject = Object.get(params.object)

		def oldObject = messageInstance.getObject()
		def oldMessage = messageInstance.getMessage()
		def oldType = messageInstance.getType()
		def oldScope = messageInstance.getScope()
		def oldByClueWords = messageInstance.getByClueWords()

		messageInstance.setMessage(messageMessage)
		messageInstance.setObject(messageObject)
		messageInstance.setType(Integer.valueOf(params.type))
		messageInstance.setLastUpdater(user)
		messageInstance.setByClueWords(byClueWords)
		

		if (!messageInstance.validate()  ) {

			def errores="<ul>"
			
			if(flag)
				errores+="<li>"+g.message(code: 'com.model.message.name.error.unique', args:[params.message])+"</li>"

			for(error in messageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"

			messageInstance.setObject(oldObject)
			messageInstance.setMessage(oldMessage)
			messageInstance.setType(oldType)
			messageInstance.setScope(oldScope)
			messageInstance.setByClueWords(oldByClueWords)

			render status:400, text:errores
			return
		}
		messageInstance.save(flush:true,failOnError:true)
		render status:200
		return 
	}




}
