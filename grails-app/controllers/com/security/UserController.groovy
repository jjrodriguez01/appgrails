package com.security

import grails.plugin.springsecurity.annotation.Secured
import org.springframework.transaction.annotation.Transactional
import grails.converters.JSON
import org.springframework.web.servlet.support.RequestContextUtils;

import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.Method.GET
import static groovyx.net.http.Method.POST
import static groovyx.net.http.ContentType.TEXT
import grails.converters.JSON
import groovy.json.JsonSlurper

import org.apache.commons.lang.RandomStringUtils;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import javax.servlet.http.HttpSession;

import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.Duration

import com.model.*
import thunder.*
import com.helpers.*

class UserController {

	def springSecurityService
	def sessionManagerService
	def assetResourceLocator
	def mailService
	def notificationsService
	def private int counter =0

	//Carga los datos necesarios para renderizar la vista inicial de thunder
	@Secured('permitAll')
	def renderIndex(){
		def tipo =0//0 no logueado, 1 usuario normal, 2 cliente, 3 Administrador
		def isAdmin = false
		def total = 0;
		def username = springSecurityService.getPrincipal().getUsername()
		def roles =[]
		def users =[]
		def webLoggedInUsers =[]
		def desktopLoggedInUsers =[]
		def notifications 
		def locale = RequestContextUtils.getLocale(request)
		def functionality0 = Functionality.findByInternalId(0)
		def functionality1 = Functionality.findByInternalId(1)
		def functionality2 = Functionality.findByInternalId(2)

		if (!springSecurityService.isLoggedIn()) {
			redirect(controller:'redirect', action:'commercialHome', params:[locale:RequestContextUtils.getLocale(request)])
			return
		}

		def user=com.security.User.findByUsername(username)
		if(!user){
			redirect controller:'logout', action:'index'
			return
		}

		//valida si el usuario sin suscripcion y no demo tienen vencida la licencia
		LocalDate userLicenceExpire = user.licenseExpirationDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
		LocalDate now = LocalDate.now()
		if(!user.suscription && user.plan != 0 && userLicenceExpire.isBefore(now)){
			user.accountExpired = true
			user.save(flush:true,failOnError:true)
			redirect controller:'logout', action:'index'
			return
		}

		roles=user.getAuthorities()

		for(def role in roles)
		{
			if(role.getAuthority() == "ROLE_ADMIN") {
				tipo=4
				break;
			}
			if(role.getAuthority() == "ROLE_CLIENT") {
				tipo=3
				users = com.security.User.findByUsername(username).getBasicUsers().sort{it.id}
				webLoggedInUsers = getWebLoggedInUsers(com.security.User.findByUsername(username).getBasicUsers().sort{it.id}) 
				desktopLoggedInUsers = getDesktopLoggedInUsers(com.security.User.findByUsername(username).getBasicUsers().sort{it.id}) 
				total=(Integer) users.size()%7 ==0?(users.size()/7):(users.size()/7)+1
				notifications = notificationsService.getNotifications(user,locale,request.getSession(),0)
				break;

			}
			if(role.getAuthority() == "ROLE_USER") {
				notifications = notificationsService.getNotifications(user,locale,request.getSession(),0)
				tipo=1
				users = com.security.User.findByUsername(username).getBasicUsersForLeader().sort{it.id}
				webLoggedInUsers = getWebLoggedInUsers(users) 
				desktopLoggedInUsers = getDesktopLoggedInUsers(users) 
			}
			if(role.getAuthority() == "ROLE_USER_LEADER") {
				isAdmin=true
				tipo=2
				if(user.getPlan()!=0){
					users = com.security.User.findByUsername(username).getBasicUsersForLeader().sort{it.id}
					webLoggedInUsers = getWebLoggedInUsers(users) 
					desktopLoggedInUsers = getDesktopLoggedInUsers(users) 
				}
				else{
					users = []
					webLoggedInUsers = []
					desktopLoggedInUsers = [] 
				}
				
				total=(Integer) users.size()%7 ==0?(users.size()/7):(users.size()/7)+1
				notifications = notificationsService.getNotifications(user,locale,request.getSession(),0)
				break;
			}
		}
		def projects = com.security.User.findByUsername(username).getProjects()
		render view: 'index', model: [tipo: tipo, total:(Integer)total, users:users, webLoggedInUsers: webLoggedInUsers, desktopLoggedInUsers:desktopLoggedInUsers, notifications:notifications, projects:projects, properUser:user, functionality0:functionality0, functionality1:functionality1, functionality2:functionality2, isAdmin:isAdmin]
	}

	//Cambia el avatar del usuario
	@Transactional
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT','ROLE_USER'])
	def changeAvatar(){
		println params
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		user.setAvatarFile(params.avatar)
		def alertAction= new Alert('', user, 1, "", "", params.avatar).save(flush:true, failOnError:true)
		alertAction.actionNotification = 'changeAvatar'
		springSecurityService.reauthenticate user.username
		render status:200
	}

	//Modifica el valor en uno de los campos del usuario
	@Transactional
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT','ROLE_USER'])
	def changeField(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def field =params.field
		def value=params.value
		switch(field){
			case 'fullname':
				user.setFullname(value);
				break;
			case 'phone':
				if(!value)
				user.setPhone("");
				else if(value.isNumber() && value.length()>6 && value.length()<21)
				user.setPhone(value);
				break;
			case 'extension':
				try{
					if(!value)
					user.setExtension(null);
					else
					user.setExtension(Integer.parseInt(value));
				} catch(Exception ex){
				//si hay error en el formato no guarda	
				}
				break;	
			case 'mobile':
			if(value.isNumber() && value.length()>9 && value.length()<13)
				user.setMobile(value);
				break;
			case 'address':
				user.setAddress(value);
				break;
			case 'organization':
				user.setOrganization(value);
				break;
		}
		springSecurityService.reauthenticate user.username
		render status:200

	}

	//Cambia la contraseña del usuario logueado
	@Transactional
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT','ROLE_USER'])
	def changePassword(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def errors = '<ul>'

			if(! springSecurityService.passwordEncoder.isPasswordValid(user.getPassword(),params.actualPass,null)){
				errors+="<li>"+message(code:'error.password.notCurrent')+"</li>"
			}
			println passwordValidator(params.newPass, params.name)
			if(passwordValidator(params.newPass, params.name)!="NOERROR"){
				errors+='<li>'+message(code:passwordValidator(params.newPass, params.name))+'</li>'
			}
			if(params.newPass!=params.newPassConfirmation)
				errors+="<li>"+message(code:'error.password2.error.mismatch')+"</li>"
			
			if(errors!='<ul>'){
				errors+="</ul>"
				render status:400, text:errors
				return
			}
			user.setPassword(params.newPass)
			springSecurityService.reauthenticate user.username
			render status:200
	}

	//Muestra el perfil del usuario
	@Transactional
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT','ROLE_USER'])
	def profile(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def locale = RequestContextUtils.getLocale(request)

		def functionality23 = Functionality.findByInternalId(23)
		def projects = user.getProjects()
		render view:'profile', model:[notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), functionality23:functionality23, projects:projects, user:user]
	}

	//Cancelar la suscripción del usario y envío de correo electrónico de notificación
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT','ROLE_USER'])
	def cancelSubscription(){
		//Peticion idSuscripcion a Admin
		def state=200
        def jsonRes
        def ConfigObject config= grailsApplication.config
        //def http = new HTTPBuilder("http://192.168.100.135:8080")
        def http = new HTTPBuilder(config.redirect.url)        
        http.request( POST, JSON ) {
            uri.path = '/admin/recurrentTransaction/getRecurrentByBuyer'
            //uri.path = 'admin/recurrentTransaction/getRecurrentByBuyer'
           // uri.query = params as JSON
            uri.query = [ token:'356ec93c791a43db9282f28fd87d824c', buyerEmail:springSecurityService.getPrincipal().getUsername()]

            headers.Accept = 'application/json'

            response.success = { resp, reader ->                
                assert resp.status == 200
                state=resp.status  
                //println "Got response: ${resp.statusLine}"
               // println "Content-Type: ${resp.headers.'Content-Type'}"
                jsonRes=reader.text                 
            }
            response.'404' = { resp ->
                println 'Not found' 
                state=resp.status
            }
        }
        http.handler.failure = { resp ->
            println "Unexpected failure: ${resp.statusLine}"
            state=resp.status
        }      

        def jsonSlurper = new JsonSlurper()
        def json = jsonSlurper.parseText(jsonRes)
        def plan = json.tr

		//actualiza fecha expiracion usuario
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		LocalDate now = LocalDate.now()
		LocalDate expireDate = now.plusMonths(1)
		Date date = Date.from(expireDate.atStartOfDay(ZoneId.systemDefault()).toInstant());	
		user.licenseExpirationDate = date
		user.cancelationPending = true
		user.save(flush:true, failOnError:true)

		//envio email confirmacion cancelacion
		mailService.sendMail {
			from "no-replay@thundertest.com"
			to springSecurityService.getPrincipal().getUsername()
			subject g.message(code: 'general.mail.title.cancelSubscription')
            html( view:"/comercial/mail/cancelSubscription")
		} 

		//metodo cancelar subsripcion payU
		redirect(controller:"Subscription",action: "cancelSubscription", params: [idSub: plan.idSub])
	}

	//Obtiene los usuarios logueados en web, dada una lista de usuarios base
	def getWebLoggedInUsers(users){
		def webLoggedUsers =[]
		for(secUser in users){
			webLoggedUsers.add(sessionManagerService.isWebLoggedIn(secUser.getUsername(),secUser.getLastWebAction()))
		}
		return webLoggedUsers
	}

	//Obtiene los usuarios logueados en desktop, dada una lista de usuarios base
	def getDesktopLoggedInUsers(users){
		def desktopLoggedInUsers=[]
		for(com.security.User user  in users){
			desktopLoggedInUsers.add(sessionManagerService.isDesktopLoggedIn(user.getUsername(),user.getLastDesktopAction()))
		}
		return desktopLoggedInUsers
	}

	//Obtiene los usuarios conectados (usa los anteriores métodos)
	@Transactional
	@Secured(['ROLE_USER_LEADER', 'ROLE_CLIENT', 'ROLE_USER'])
	def getConnectedUsers(){
		if(request.getHeader('referer').contains('login'))
		{
			redirect action:'renderIndex'
			return
		}
		def username = springSecurityService.getPrincipal().getUsername()
		def user=com.security.User.findByUsername(username)
		def roles=user.getAuthorities()*.authority
		def webLoggedInUsers = []
		def desktopLoggedInUsers =[]
		def users
		if('ROLE_CLIENT' in roles){
			users= user.getBasicUsers().sort{it.id}
			webLoggedInUsers = getWebLoggedInUsers(users) 
			desktopLoggedInUsers = getDesktopLoggedInUsers(users) 
		}
		else if(user.getPlan()!=0){
			users=user.getBasicUsersForLeader().sort{it.id}
			webLoggedInUsers = getWebLoggedInUsers(users) 
			desktopLoggedInUsers = getDesktopLoggedInUsers(users) 
		}
		def respuesta=[desktopLoggedInUsers:desktopLoggedInUsers, webLoggedInUsers:webLoggedInUsers, users:users]
		render text: (respuesta as JSON), contentType:"text/json"
	}

	//Obtiene las notificaciones
	@Secured(['ROLE_CLIENT','ROLE_USER','ROLE_USER_LEADER'])
	def getNotifications(){
		
		counter++
		if(request.getHeader('referer').contains('login'))
		{
			redirect action:'renderIndex'
			return
		}
		if(!springSecurityService.isLoggedIn()){
			render status:401
			return 
		}

		def username = springSecurityService.getPrincipal().getUsername()
		def user=com.security.User.findByUsername(username)
		def locale = RequestContextUtils.getLocale(request)
		if(!user){
			redirect controller:'logout', action:"index"
		}
		if(!sessionManagerService.verifySession(user.getUsername(), request.getSession(),0)){
			redirect controller:'logout', action:"index"
		}

		def answer = notificationsService.getNotifications(user,locale,request.getSession(),0)
		render text:(answer as JSON), contentType: "text/json"
	}

	//Método usado para generar links que se envían al correo
	protected String generateLink(String action, linkParams) {
		createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
			controller: 'register', action: action,
			params: linkParams)
	}

	//Registra un usuario básico desde un líder
	@Secured('ROLE_USER_LEADER')
	@Transactional
	def registerBasicUserForLeader(){

		if(com.security.User.countByUsername(params.username.toString().toLowerCase())>0){
			render status:400, text:g.message(code: "user.username.unique", args:["","",params.username])
			return
		}
		else{
			
			def username = springSecurityService.getPrincipal().getUsername()
			def myUser=com.security.User.findByUsername(username)
			if(myUser.getBasicUsers().size()>=myUser.getNumeroDeLicencias()){
				render status:400, text:g.message(code: "text.error.maxNumberOfLicenses")
			}
			else{
				
				def newUser = new com.security.User(params.username, "--", params.fullname,"--","--","--",myUser.getOrganization(),myUser.getPlan(), myUser.getAssociatedClient(), true, myUser.getLicenseExpirationDate())
				newUser.setAvatarFile(params.avatarFile)
				newUser.setAccountLocked(true)
				newUser.setNumeroDeLicencias(myUser.getNumeroDeLicencias())
				newUser.setNumeroDeImagenesEvidenciaPorCaso(myUser.getNumeroDeImagenesEvidenciaPorCaso())
				def errores="<ul>"
				if(!newUser.validate()){
					for(error in newUser.errors.getAllErrors()){
						errores+="<li>"+g.message(error: error)+"</li>"
					}
					errores+="</ul>"

					render status:400, text:errores
					return
				}
				newUser.save(flush:true, failOnError:true)

				if(params.isAdminUser.equals("true")){
					def roleAdmin = com.security.Role.findByAuthority('ROLE_USER_LEADER');
					def userAdminRole = UserRole.create(newUser, roleAdmin)

					if (!userAdminRole.save(flush:true,failOnError:true) ){
						render status:400, text:g.message(code: 'miscellaneous.miscError')
						return
					}

				}
				else{
					def role = com.security.Role.findByAuthority('ROLE_USER');
					def userRole = UserRole.create(newUser, role)

					if (!userRole.save(flush:true) ){
						render status:400, text:g.message(code: 'miscellaneous.miscError')
						return
					}
				}

				def token= new Token(newUser.getUsername(),4).save(flush:true, failOnError:true)

				String url = generateLink('verifyRegistrationByPass', [t: token.token])


				mailService.sendMail {
					from "no-replay@thundertest.com"
					to newUser.getUsername()
					subject g.message(code: 'general.mail.subject.accountConfirmation')
					html( view:"/comercial/mail/accountConfirmationByPass", 
						model:[username:newUser.getFullname(),url:url, associatedClient:myUser.fullname])
				}
				myUser.getAssociatedClient().addToUsers(newUser)
				myUser.setLastWebAction(new Date())
				myUser.save(flush:true, failOnError:true)
				render status:200
			}
		}
	}

	//Registra un usuario básico desde un usuario con rol de cliente
	@Secured('ROLE_CLIENT')
	@Transactional
	def registerBasicUser(){
		if(com.security.User.countByUsername(params.username.toString().toLowerCase())>0){

			render status:400, text:g.message(code: "user.username.unique", args:["","",params.username])
		}
		else{
			
			def username = springSecurityService.getPrincipal().getUsername()
			def myUser=com.security.User.findByUsername(username)
			if(myUser.getBasicUsers().size()>=myUser.getNumeroDeLicencias()){
				render status:400, text:g.message(code: "text.error.maxNumberOfLicenses")
			}
			else{
				
				def newUser = new com.security.User(params.username, null, params.fullname,"--","--","--",myUser.getOrganization(),myUser.getPlan(), myUser, true, myUser.getLicenseExpirationDate())
				newUser.setAvatarFile(params.avatarFile)
				def errores="<ul>"
				if(!newUser.validate()){
					for(error in newUser.errors.getAllErrors()){
						errores+="<li>"+g.message(error: error)+"</li>"
					}
					errores+="</ul>"

					render status:400, text:errores
					return
				}
				newUser.save(flush:true, failOnError:true)

				if(params.isAdminUser.equals("true")){
					def roleAdmin = com.security.Role.findByAuthority('ROLE_USER_LEADER');
					def userAdminRole = UserRole.create(newUser, roleAdmin)

					if (!userAdminRole.save(flush:true,failOnError:true) ){
						render status:400, text:g.message(code: 'miscellaneous.miscError')
						return
					}

				}
				else{
					def role = com.security.Role.findByAuthority('ROLE_USER');
					def userRole = UserRole.create(newUser, role)

					if (!userRole.save(flush:true) ){
						render status:400, text:g.message(code: 'miscellaneous.miscError')
						return
					}
				}

				def token= new Token(newUser.getUsername(),4).save(flush:true, failOnError:true)
				String url = generateLink('verifyRegistrationByPass', [t: token.token])
				mailService.sendMail {
					from "no-replay@thundertest.com"
					to newUser.getUsername()
					subject g.message(code: 'general.mail.subject.accountConfirmation')
					html( view:"/comercial/mail/accountConfirmationByPass", 
						model:[username:newUser.getFullname(),url:url, associatedClient:myUser.fullname])
				}
				myUser.addToUsers(newUser)
				myUser.setLastWebAction(new Date())
				myUser.save(flush:true, failOnError:true)
				render status:200
			}
		}
	}

	//Muestra la vista de edición del usuario
	//@Secured(['ROLE_CLIENT','ROLE_USER_LEADER'])
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def editUser(){
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def userToEdit = User.get(params.id)
		def isAdmin = false
		def rolesToEdit=userToEdit.getAuthorities()
		for(def role in rolesToEdit)
		{
			if(role.getAuthority() == "ROLE_USER_LEADER") {
				isAdmin = true;
				break;
			}
		}

		def roles=user.getAuthorities()
		for(def role in roles)
		{
			/*if(role.getAuthority() == "ROLE_CLIENT") {
				if(!(userToEdit in user.getBasicUsers())){
					render view:'login/denied'
					return
				}
				render view:'client/editUser', model:[notifications: notificationsService.getNotifications(user,locale,request.getSession(),0), userToEdit:userToEdit, projects:user.getProjects(),  userProjects:userToEdit.getProjects(), isAdmin: isAdmin]
				return;
			}*/
			
			if(role.getAuthority() == "ROLE_USER_LEADER") {
				if(!(userToEdit in user.getBasicUsersForLeader())){
					render view:'login/denied'
					return
				}
				render view:'leader/editUser', model:[notifications: notificationsService.getNotifications(user,locale,request.getSession(),0), userToEdit:userToEdit, projects:user.getProjects(), userProjects:userToEdit.getProjects(), isAdmin: isAdmin]
				return;
			}
		}

		flash.message="${message(code:'general.error.403.message')}"
		redirect action:'renderIndex'
	}

	//Da privilegios de líder a un usuario especifico
	@Secured(['ROLE_CLIENT','ROLE_USER_LEADER'])
	@Transactional
	def grantLeaderPrivileges(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def userToGrant = User.get(params.userId)
		def value = params.value
		def adminRole = Role.findByAuthority('ROLE_USER_LEADER')
		if(value == 'on'){
			def roles = userToGrant.getAuthorities()
			for(def role in roles)
			{
				if(role.getAuthority() == "ROLE_USER_LEADER") {
					render status:200
					return
				}
			}
			UserRole.create userToGrant, adminRole, true
			render status:200
			return
		}
		else if(value=='off'){
			if(UserRole.findByUserAndRole(userToGrant, adminRole)!= null){
				UserRole.findByUserAndRole(userToGrant, adminRole).delete(flush:true)
				render status:200
				return
			}
			render status:200
			return
		}
	}

	//Obtiene los navegadores de un usuario especifico (Se refiere a los navegadores que estén en ese momento activos en thunder client)
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def getBrowsers(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenarioToExecute = Scenario.get(params.id)
		if(Case.countByScenarioAndIsEnabled(scenarioToExecute, true)==0){
			render status:400, text:message(code: 'execution.error.notCases')
			return
		}

		if(sessionManagerService.isDesktopLoggedIn(user.getUsername(),user.getLastDesktopAction())=='true'){
			render text:user.getBrowsers()
			return 
		}
		else{
			render status:400, text:message(code: 'execution.error.notLogged')
			return
		}
	}

	//Elimina un usuario
	@Secured(['ROLE_CLIENT','ROLE_USER_LEADER'])
	def deleteUser(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def userToDelete = User.get(params.id)
		if(!userToDelete){
			render view:"/login/denied"
			return
		}
		def adminRole = Role.findByAuthority('ROLE_USER_LEADER')
		def realUsers =UserRole.countByUserAndRole(user, adminRole) > 0?user.getBasicUsersForLeader():user.getBasicUsers()
		if(! (userToDelete in realUsers )){
			render view:"/login/denied"
			return
		}
		if(Alert.countByTarget(userToDelete) > 0 || Case.countByCreatorOrLastUpdater(userToDelete, userToDelete) >0 || CaseStep.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Execution.countByCreatorOrTarget(userToDelete, userToDelete) > 0 || ExecutionExpression.countByCreator(userToDelete) > 0 || ExecutionExpression.countByTargetsLike('%,'+userToDelete.id+',%') > 0 || ExecutionExpression.countByTargetsLike(userToDelete.id+',%') > 0 || ExecutionExpression.countByTargetsLike('%,'+userToDelete.id) > 0 || Message.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Object.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Page.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Project.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Scenario.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || Step.countByCreatorOrLastUpdater(userToDelete, userToDelete) > 0 || UserProject.countByUser(userToDelete) > 0)
		{
			def allUsers = UserRole.countByUserAndRole(user, adminRole) > 0?user.associatedClient.getBasicUsers():user.getBasicUsers()
			render status:400, text: allUsers as JSON, contentType: "application/json"
			return
		}
		if(UserRole.countByUserAndRole(user, adminRole)>0){
			user.associatedClient.removeFromUsers(userToDelete)	
		}
		else{
			user.removeFromUsers(userToDelete)	
		}

		user.save(flush:true)
		def roles = UserRole.findAllByUser(userToDelete)
		for (UserRole ur in roles){
			ur.delete(flush:true, failOnError:true)
		}
		userToDelete.delete(flush:true, failOnError:true)
		render status:200
	}

	//Reasigna todos los datos de un usuario a otro (casos, pasos, proyectos etc)
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def reasignUser(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def oldUser = User.get(Long.parseLong(params.oldUser))
		def newUser = User.get(Long.parseLong(params.newUser))
		def adminRole = Role.findByAuthority('ROLE_USER_LEADER')
		def realUsers =UserRole.countByUserAndRole(user, adminRole) > 0?user.getBasicUsersForLeader():user.getBasicUsers()
		if(!oldUser || !newUser){
			render view:'/login/denied'
			return
		}
		if(! (oldUser in realUsers)){
			render view:'/login/denied'
			return
		}
		if(!newUser.equals(user) && ! (newUser in realUsers)) {
			render view:'/login/denied'
			return
		}
		//Borrado de alertas
		def alerts = Alert.findAllByTarget(oldUser)
		for(Alert alert in alerts){
			alert.delete(flush:true, failOnError:true)
		}
		
		//Asignación de casos
		def cases = Case.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Case curCase in cases){

			if(curCase.creator.equals(oldUser)){
				curCase.setCreator(newUser)
				curCase.save(flush:true, failOnError:true)
			}
			if(curCase.lastUpdater == oldUser){
				curCase.setLastUpdater(newUser)
				curCase.save(flush:true, failOnError:true)
			}
		}

		//Asignación de pasos de casos
		def caseSteps = CaseStep.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(CaseStep caseStep in caseSteps){
			if(caseStep.creator == oldUser){
				caseStep.setCreator(newUser)
				caseStep.save(flush:true, failOnError:true)
			}
			if(caseStep.lastUpdater == oldUser){
				caseStep.setLastUpdater(newUser)
				caseStep.save(flush:true, failOnError:true)
			}
		}


		//Asignación de ejecuciones
		def executions = Execution.findAllByCreatorOrTarget(oldUser, oldUser)
		for(Execution execution in executions){
			if(execution.creator == oldUser){
				execution.setCreator(newUser)
				execution.save(flush:true, failOnError:true)
			}
			if(execution.target == oldUser){
				execution.setTarget(newUser)
				execution.save(flush:true, failOnError:true)
			}
		}

		//Asignación de ejecuciones programadas
		def executionExpressions = ExecutionExpression.findAllByCreator(oldUser)
		for(ExecutionExpression executionExpression in executionExpressions){
			if(executionExpression.creator == oldUser){
				executionExpression.setCreator(newUser)
				executionExpression.save(flush:true, failOnError:true)
			}
		}


		//Asignacion de targets para ejecuciones programadas primer caso
		def executionExpressionsFirstCase = ExecutionExpression.findAllByTargetsLike('%,'+oldUser.id+',%')
		for(ExecutionExpression executionExpression in executionExpressionsFirstCase){
			executionExpression.targets = executionExpression.targets.replace(','+oldUser.id+',',','+newUser.id+',')
			executionExpression.save(flush:true, failOnError:true)
		}		

		//Asignacion de targets para ejecuciones programadas segundo caso
		def executionExpressionsSecondCase = ExecutionExpression.findAllByTargetsLike(oldUser.id+',%')
		for(ExecutionExpression executionExpression in executionExpressionsSecondCase){
			executionExpression.targets = executionExpression.targets.replaceFirst(oldUser.id+',',newUser.id+',')
			executionExpression.save(flush:true, failOnError:true)
		}	

		//Asignacion de targets para ejecuciones programadas tercer caso
		def executionExpressionsThirdCase = ExecutionExpression.findAllByTargetsLike('%,'+oldUser.id)
		for(ExecutionExpression executionExpression in executionExpressionsThirdCase){
			def originalTargets = executionExpression.targets
			def lastIndexOfTarget = originalTargets.lastIndexOf(','+oldUser.id)
			def firstPartTargets = originalTargets.substring(0,lastIndexOfTarget)
			executionExpression.setTargets(firstPartTargets+","+newUser.id)
			executionExpression.save(flush:true, failOnError:true)
		}

		//Asignacion de mensajes
		def messages = Message.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Message message in messages){
			if(message.creator == oldUser){
				message.setCreator(newUser)
				message.save(flush:true, failOnError:true)
			}
			if(message.lastUpdater == oldUser){
				message.setLastUpdater(newUser)
				message.save(flush:true, failOnError:true)
			}
		}

		//Asignacion de objetos
		def objects = Object.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Object object in objects){
			if(object.creator == oldUser){
				object.setCreator(newUser)
				object.save(flush:true, failOnError:true)
			}
			if(object.lastUpdater == oldUser){
				object.setLastUpdater(newUser)
				object.save(flush:true, failOnError:true)
			}
		}

		//Asignacion de paginas
		def pages = Page.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Page page in pages){
			if(page.creator == oldUser){
				page.setCreator(newUser)
				page.save(flush:true, failOnError:true)
			}
			if(page.lastUpdater == oldUser){
				page.setLastUpdater(newUser)
				page.save(flush:true, failOnError:true)
			}
		}

		//Asignacion de proyectos 
		def projects = Project.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Project project in projects){
			if(project.creator == oldUser){
				project.setCreator(newUser)
				project.save(flush:true, failOnError:true)
			}
			if(project.lastUpdater == oldUser){
				project.setLastUpdater(newUser)
				project.save(flush:true, failOnError:true)
			}
		}

		//Asignacion de scenarios 
		def scenarios = Scenario.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Scenario scenario in scenarios){
			if(scenario.creator == oldUser){
				scenario.setCreator(newUser)
				scenario.save(flush:true, failOnError:true)
			}
			if(scenario.lastUpdater == oldUser){
				scenario.setLastUpdater(newUser)
				scenario.save(flush:true, failOnError:true)
			}
		}

		//Asignacion de pasos de guion 
		def steps = Step.findAllByCreatorOrLastUpdater(oldUser, oldUser)
		for(Step step in steps){
			if(step.creator == oldUser){
				step.setCreator(newUser)
				step.save(flush:true, failOnError:true)
			}
			if(step.lastUpdater == oldUser){
				step.setLastUpdater(newUser)
				step.save(flush:true, failOnError:true)
			}
		}

		user.associatedClient.removeFromUsers(oldUser)
		user.save(flush:true)
		def roles = UserRole.findAllByUser(oldUser)
		for (UserRole ur in roles){
			ur.delete(flush:true, failOnError:true)
		}

		def userProjAscs = UserProject.findAllByUser(oldUser)
		for (UserProject upa in userProjAscs){
			upa.delete(flush:true, failOnError:true)
		}

		
		oldUser.delete(flush:true, failOnError:true)
		render status:200
		return
	}

	//Muestra la vista de pagos
	@Secured(['ROLE_CLIENT'])
	def billing(){
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		render view:'leader/billing',  model:[notifications: notificationsService.getNotifications(user,locale,request.getSession(),0)]
	}

	//Deprecated: Ya no se utiliza
	def preLogin(){
		if(Token.findByUsernameAndType(username,5)==null){
         	token = new Token(username,5).save(flush:true, failOnError:true)
      	}
	    else{
	        Token.findByUsernameAndType(username,5).delete(flush:true, failOnError:true)
	        token = new Token(username,5).save(flush:true, failOnError:true)
	    }
	}


	/**********************************************************/
	/***********Métodos de válidación de contraseña************/
	/**********************************************************/

	def String passwordValidator (password,username) {
		if ( username && username.equals(password)) {
			return 'error.password.error.username'
		}

		if (!checkPasswordMinLength(password) ||
		!checkPasswordMaxLength(password) ||
		!checkPasswordRegex(password)) {
			return 'error.password.error.strength'
		}
		return "NOERROR"
	}

	def boolean checkPasswordMinLength(String password) {
		def conf = springSecurityService.securityConfig
		int minLength = conf.ui.password.minLength instanceof Number ? conf.ui.password.minLength : 8
		password && password.length() >= minLength
	}

	def boolean checkPasswordMaxLength(String password) {
		def conf = springSecurityService.securityConfig
		int maxLength = conf.ui.password.maxLength instanceof Number ? conf.ui.password.maxLength : 64
		password && password.length() <= maxLength
	}

	def boolean checkPasswordRegex(String password) {
		def conf = springSecurityService.securityConfig
		String passValidationRegex = conf.register.password.validationRegex?:'^.*(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&]).*$'
		password && password.matches(passValidationRegex)
	}

}
