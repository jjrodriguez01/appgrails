package com.security

import com.model.*
import com.helpers.*
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.apache.commons.lang.StringUtils
import java.time.LocalDate
import java.time.ZoneId

class AdminController {

	def sessionManagerService
	def cryptoService
	def springSecurityService

	//Envia los datos principales a admin
	@Secured('permitAll')
    def getData(){    	
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def projectCount = Project.count()
		def scenarioCount = Scenario.count()
		def pageCount = Page.count()
		def casesCount = Case.count()
		def usersCount = User.countByUsernameNotEqual("superclient@qvision.com")
		def executionsCount = ExecutionLog.count()
		def stepCount = Step.count()
		def objImagesCount = Object.countByImageHashNotEqual("noHash")
		def logImageCount = Log.countByImageUrlNotEqual('noImage')

		def users = User.findAllByUsernameNotEqual("superclient@qvision.com", [max: 100, offset:Integer.valueOf(params.offset)*100])
		def answer =[projectCount:projectCount, scenarioCount:scenarioCount, pageCount:pageCount, casesCount:casesCount,usersCount:usersCount,executionsCount:executionsCount, objImagesCount:objImagesCount, logImageCount:logImageCount, stepCount:stepCount, users:users]
		answer = answer as JSON
		answer = answer.toString()
		render answer
    }

    //Envia los recursos a admin
	@Secured('permitAll')
    def getResources(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def answer =[resources:Resource.list(sort:'id', order: "desc")]
		answer = answer as JSON
		answer = cryptoService.rsaEncrypt(answer.toString())
		render answer
    }

    //Actualiza un recurso especifico desde admin
    @Secured('permitAll')
    def updateResource(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def resource = Resource.get(Long.parseLong(params.id))
		if(!resource){
			render status:400
			return
		}

		if(params.name.trim()=='' ){
			render status:400, text:'Nombre vacío'
			return
		}
		if(Resource.countByNameAndIdNotEqual(params.name, Long.parseLong(params.id))>0){
			render status:400, text:'Nombre repetido'
			return
		}
		if(params.url.trim()=='' ){
			render status:400, text:'URL vacía'
			return
		}
		if(params.type.trim()=='' ){
			render status:400, text:'Tipo vacío'
			return
		}
		resource.name = params.name
		resource.resourceVersion = params.resourceVersion	
		resource.url = params.url
		resource.type = Integer.parseInt(params.type)
		resource.state = Boolean.parseBoolean(params.state)
		resource.save(flush:true, failOnError:true)
		render status:200
    }

    //Elimina un recurso especifico
    @Secured('permitAll')
    def deleteResource(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def resource = Resource.get(cryptoService.rsaDecrypt(params.id))
		if(!resource){
			render status:400
			return
		}
		resource.delete(flush:true, failOnError:true)
		render status:200
	}

	//Agrega un recurso desde admin
	@Secured('permitAll')
    def addResource(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		if(params.name.trim()=='' ){
			render status:400, text:'Nombre vacío'
			return
		}
		if(Resource.countByName(params.name)>0){
			render status:400, text:'Nombre repetido'
			return
		}
		if(params.url.trim()=='' ){
			render status:400, text:'URL vacía'
			return
		}	
		if(params.type.trim()=='' ){
			render status:400, text:'Tipo vacío'
			return
		}		
		def resource = new Resource(params.name, params.resourceVersion, params.url, Boolean.parseBoolean(params.state), Integer.parseInt(params.type)).save(flush:true, failOnError:true)
		render status:200
	}

	//retorna las funcionalidades por perfil
	@Secured('permitAll')
	def getFunctionalities(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def answer = Functionality.list() as JSON
		render answer.toString()
	}

	@Secured('permitAll')
	def getClientFunctionalities(){
		def answer = Functionality.findAllByClient("CLIENT") as JSON
		if(!answer){
			render status:400
		}
		render answer
	}

	//Miscelanea
	def bytesToString(String bytesT){        
	    def dato=bytesT.split(',')
	    def byte[] data = new byte[dato.length]
	        for (int j=0;j<dato.length;j++) {
	            data[j]= new Byte(dato[j]);
	        }
	    return  (new String(data))  
	}

	//Actualiza los perfiles de una funcionalidad especifica
	@Secured('permitAll')
	def updateFunctionality(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def functionality = Functionality.get(params.id)
		functionality.roles = params.roles
		functionality.functionality = params.functionality
		functionality.description = params.description
		functionality.client = params.client
		if(!functionality.validate()){
			render status:400, text:"Hay errores"
			return
		}
		functionality.save(flush:true, failOnError:true)
		render status:200
	}

	//Agrega una funcionalidad
	@Secured('permitAll')
	def addFunctionality(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def internalId = Functionality.executeQuery("select max(internalId) from Functionality")[0]
		internalId++
		def errors = "<ul>"
		if(!internalId){
			errors+='<li>El id interno debe ser un número</li>'
		}
		if(Functionality.countByInternalId(internalId) >0 ){
			errors+="<li>Ya existe una funcionalidad asociada a el idInterno que se envió</li>"
		}


		def functionality = new Functionality(internalId, params.functionality, params.description, params.roles,params.client)
		if(!functionality.validate() || errors!="<ul>"){
			render status:400, text:errors
			return
		}
		functionality.save(flush:true, failOnError:true)
		render status:200
	}

	//Retorna los usuarios que hay en el sistema
	@Secured('permitAll')
	def getUsers(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}		
		def users = User.findAllByUsernameNotEqual("superclient@qvision.com", [max: 100, offset:Integer.valueOf(params.offset)*100])
		def answer = [users:users, total:User.count()-1] as JSON
		answer = answer.toString().replaceAll("í","i")	
		render (text:answer, contentType: "application/json", encoding: "UTF-8")
	}

	//Retorna informacion basica de un usuario
	@Secured('permitAll')
	def getUsersBasicInfo(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}	
		//def users = User.findAllByUsernameNotEqual("superclient@qvision.com", [max: 100, offset:Integer.valueOf(params.offset)*100])
		def users = User.executeQuery("select id,fullname,organization,username,plan,numeroDeLicencias,address from User where username<>'superclient@qvision.com'")

		def jsonBuilder = new groovy.json.JsonBuilder()

		jsonBuilder {
		    accounts users.collect { 
		        [ 
		            id: it[0], 
		            fullname: it[1],
		            organization: it[2],
		            username: it[3],
		            plan: it[4],
		            numeroDeLicencias: it[5],
		            addres: it[6]
		        ] 
		    }
		}
		render (text:jsonBuilder, contentType: "application/json", encoding: "UTF-8")
	}

	//Obtiene un usuario especifico
	@Secured('permitAll')
	def getUser(){
	   	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}		
		def user = User.findById(Long.parseLong(cryptoService.rsaDecrypt(params.id)))
		def answer = [user:user] as JSON
		render answer
	}

	//Actualiza un usuario especifico
	@Secured('permitAll')
	def updateUser(){		
		//Validación del Token
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		//Validación de Username
		if(User.countByUsernameAndIdNotEqual(params.username.toString().toLowerCase(), params.id)>0){
			render status:400, text:g.message(code: "user.username.unique", args:["","",username])
			return
		}
		//Obtener Usuario
		def user = User.findById(Long.parseLong(params.id))
		def oldUsername = user.username
		//Captura de Variables
		user.fullname = params.fullname
		user.address = params.address
		user.username = params.username
		user.mobile = params.mobile
		user.accountExpired = Boolean.parseBoolean(params.accountExpired)
		user.accountLocked = Boolean.parseBoolean(params.accountLocked)
		//Actualizar Usuario
		user.save(flush:true, failOnError:true)
		//Roles
		def goldRole = Role.findByAuthority('ROLE_GOLD')
		def platinumRole = Role.findByAuthority('ROLE_PLATINUM')
		def demoRole = Role.findByAuthority('ROLE_DEMO')
		if(user.plan != Integer.parseInt(params.plan)){
			user.plan = Integer.parseInt(params.plan)
			switch(params.plan) {
					case "0":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, demoRole) == 0){
							def newRole = new UserRole(user, demoRole).save(flush:true, failOnError:true)
						}
						break;
					case "1":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, goldRole) == 0){
							def newRole = new UserRole(user, goldRole).save(flush:true, failOnError:true)
						}
						user.associatedClient = user
						break;
					case "2":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, platinumRole) == 0){
							def newRole = new UserRole(user, platinumRole).save(flush:true, failOnError:true)
						}
						user.associatedClient = user
						break;
			}
			sessionManagerService.logoutUser(oldUsername)
			user.save(flush:true, failOnError:true)
		}		
		render status:200
	}

	//Actualiza la expiracion de licencia y el numero de licencias de un usuario especifico
	@Secured('permitAll')
	def updateUserLicence(){	
		println "updateUserLicence"+params	
		//Validación del Token
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		if(!params.username){
			render status:400
			return
		}
		try {
			//Obtener Usuario
		def user = User.findByUsername(params.username)
		println "cantidad->"+params.cantidadLics
		user.numeroDeLicencias = params.int("cantidadLics")
		LocalDate userLicenceExpire = user.licenseExpirationDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
		LocalDate now = LocalDate.now()
		if(user.firstPay && userLicenceExpire.isAfter(now)){
			userLicenceExpire = userLicenceExpire.plusMonths(Integer.parseInt(params.mesesLics))
		}else{
			userLicenceExpire = now.plusMonths(Integer.parseInt(params.mesesLics))
		}
		user.licenseExpirationDate = Date.from(userLicenceExpire.atStartOfDay(ZoneId.systemDefault()).toInstant())
		//ahora es la primera vez q paga
		user.firstPay = true
		//Roles
		def goldRole = Role.findByAuthority('ROLE_GOLD')
		def platinumRole = Role.findByAuthority('ROLE_PLATINUM')
		def demoRole = Role.findByAuthority('ROLE_DEMO')
			if(user.plan != Integer.parseInt(params.plan)){
				user.plan = Integer.parseInt(params.plan)
				//cuando cambia de licencia se le asocia su mismo id para no ver proyectos de demo

				user.associatedClient = user
				switch(params.plan) {
						case "0":
							def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							if(UserRole.countByUserAndRole(user, demoRole) == 0){
								def newRole = new UserRole(user, demoRole).save(flush:true, failOnError:true)
							}
							break;
						case "1":
							def rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							if(UserRole.countByUserAndRole(user, goldRole) == 0){
								def newRole = new UserRole(user, goldRole).save(flush:true, failOnError:true)
							}
							break;
						case "2":
							def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
							for(role in rolesToDelete){
								role.delete(flush:true, failOnError:true)
							}
							if(UserRole.countByUserAndRole(user, platinumRole) == 0){
								def newRole = new UserRole(user, platinumRole).save(flush:true, failOnError:true)
							}
							break;
				}

				sessionManagerService.logoutUser(user.username)
				user.save(flush:true, failOnError:true)
			}	
		}
		catch(Exception e) {
			e.printStackTrace()
			render status:400, text:e.getMessage()
		}
		render status:200
	}

	@Secured('permitAll')
	def updateRole(){
		//Validación del Token
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}

		try {
			//Obtener Usuario
		def user = User.findByUsername(params.username)
		user.firstPay = true
		user.suscription = true
		user.associatedClient = user

		def goldRole = Role.findByAuthority('ROLE_GOLD')
		def platinumRole = Role.findByAuthority('ROLE_PLATINUM')
		def demoRole = Role.findByAuthority('ROLE_DEMO')
		if(user.plan != Integer.parseInt(params.plan)){
			user.plan = Integer.parseInt(params.plan)
			switch(params.plan) {
					case "0":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, demoRole) == 0){
							def newRole = new UserRole(user, demoRole).save(flush:true, failOnError:true)
						}
						break;
					case "1":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, goldRole) == 0){
							def newRole = new UserRole(user, goldRole).save(flush:true, failOnError:true)
						}
						break;
					case "2":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, platinumRole) == 0){
							def newRole = new UserRole(user, platinumRole).save(flush:true, failOnError:true)
						}
						break;
			}
			
			sessionManagerService.logoutUser(params.username)
			user.save(flush:true, failOnError:true)
		}
		
		}
		catch(Exception ex) {
			render status:400
		}
		render status:200
	}

	//Retorna la lista de acciones genericas
	@Secured('permitAll')
	def getFunctions(){
		def actionList = GenericAction.list()
		if(!actionList){
			render status:401
			return
		}
		def answer = actionList as JSON
		render answer
	}

	//Crea una nueva acción generica
	@Secured('permitAll')
	def createGenericAction(){
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render text:"Accion No Permitida"
			return
		}	
		def name = params.name
		def html = params.html
		def defaultValue = params.defaultValue
		def needsObject = Boolean.parseBoolean(params.needsObject)
		def platform = params.platform		
		def textSpanish = params.textSpanish
		def textEnglish = params.textEnglish
		def GenericAction newAction = new GenericAction(name, html, defaultValue, needsObject, platform)
		if(!newAction.validate()){
			render text:"Hay errores en el Action"
			return
		}
		//Creación de GenericAction y los Mensajes de Internacionalización
		if(newAction.save(flush:true, failOnError:true)){			
			Messagei18n newMessagei18nEs = new Messagei18n(name, new Locale('es'), textSpanish)
			Messagei18n newMessagei18nEn = new Messagei18n(name, new Locale('en'), textEnglish)
			if(!newMessagei18nEs.validate() || !newMessagei18nEn.validate()){
				render text:"Hay errores en el Message"
				return
			}
			newMessagei18nEs.save(flush:true, failOnError:true)
			newMessagei18nEn.save(flush:true, failOnError:true)
			render text:"OK"
		} else {
			render text:"Error al Guardar la Accion"
		}
	}

	//Actualiza una acción generica especifica
	@Secured('permitAll')
	def updateGenericAction(){
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render text:"Acción no permitida"
			return
		}
		def id = params.id
		def name = params.name
		def html = params.html
		def defaultValue = params.defaultValue
		def needsObject = Boolean.parseBoolean(params.needsObject)
		def platform = params.platform		
		def textSpanish = params.textSpanish
		def textEnglish = params.textEnglish
		def newAction = GenericAction.findById(id)
		def oldName = newAction.name
		newAction.name = name
		newAction.html = html
		newAction.defaultValue = defaultValue
		newAction.needsObject = needsObject
		newAction.platform = platform		
		if(!newAction.validate()){			
			def errors ="<ul>"
			def fields = grailsApplication.getDomainClass('com.model.GenericAction').persistentProperties.collect { it.name }
			for(field in fields){
				if(message(error: newAction.errors.getFieldError(field))!="")
			    errors+= "<li>"+message(error: newAction.errors.getFieldError(field))+"</li>"
			}
			errors+="</ul>"
			render text:errors
			return			
		}
		//Creación o Actualización de GenericAction y los Mensajes de Internacionalización
		if(newAction.save(flush:true, failOnError:true)){	
			def newMessagei18nEs = Messagei18n.findByCodeAndLocale(oldName, new Locale('es'))
			if(!newMessagei18nEs){
				newMessagei18nEs = new Messagei18n(name, new Locale('es'), textSpanish)
			} else {
				newMessagei18nEs.code = name
				newMessagei18nEs.text = textSpanish
			}
			def newMessagei18nEn = Messagei18n.findByCodeAndLocale(oldName, new Locale('en'))
			if(!newMessagei18nEn){
				newMessagei18nEn = new Messagei18n(name, new Locale('en'), textEnglish)
			} else {
				newMessagei18nEn.code = name
				newMessagei18nEn.text = textEnglish
			}
			if(!newMessagei18nEs.validate() || !newMessagei18nEn.validate()){
				render text:"Hay errores en el Message"
				return
			}
			newMessagei18nEs.save(flush:true, failOnError:true)
			newMessagei18nEn.save(flush:true, failOnError:true)
			render text:"OK"
		} else {
			render text:"Error al Actualizar la Accion"
		}
	}

	//Elimina una acción generica especifica
	@Secured('permitAll')
	def deleteGenericAction(){
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render text:"Acción no Permitida"
			return
		}
		def id = params.id
		def deleteAction = GenericAction.findById(id)		
		if(deleteAction){
			if(Action.countByAction(deleteAction) == 0 && Object.countByDefaultAction(deleteAction) == 0){
				def codeToDelete = deleteAction.name
				def newMessagei18n = Messagei18n.findAllByCode(codeToDelete)
				if(newMessagei18n.size() > 1){
					for(messagei18n in newMessagei18n){
						messagei18n.delete(flush:true, failOnError:true)
					}				
				}
				try {
					deleteAction.delete(flush:true, failOnError:true)				
					render text:"OK"
				} catch (Exception ex) {
					render text:ex.getMessage()
				}
			} else {
				render text:"No es posible eliminar la accion esta es utilizada aún."
			}
		} else {
			render text:"Error al buscar la accion"
		}
	}

	//Hae que un usuario esté activo (activa su cuenta)
	@Secured('permitAll')
	def enabledUser(){
		def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render text:"Acción no Permitida"
			return
		}
		def user = User.findById(Long.parseLong(params.id))
		//Actualizar Usuario
		user.enabled = true
		user.save(flush:true, failOnError:true)
		//Roles
		def goldRole = Role.findByAuthority('ROLE_GOLD')
		def platinumRole = Role.findByAuthority('ROLE_PLATINUM')
		def demoRole = Role.findByAuthority('ROLE_DEMO')
		if(user.plan != Integer.parseInt(cryptoService.rsaDecrypt(params.plan))){
			user.plan = Integer.parseInt(cryptoService.rsaDecrypt(params.plan))
			switch(cryptoService.rsaDecrypt(params.plan)) {					
					case "1":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, platinumRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, goldRole) == 0){
							def newRole = new UserRole(user, goldRole).save(flush:true, failOnError:true)
						}
						break;
					case "2":
						def rolesToDelete = UserRole.findAllByUserAndRole(user, goldRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						rolesToDelete = UserRole.findAllByUserAndRole(user, demoRole)
						for(role in rolesToDelete){
							role.delete(flush:true, failOnError:true)
						}
						if(UserRole.countByUserAndRole(user, platinumRole) == 0){
							def newRole = new UserRole(user, platinumRole).save(flush:true, failOnError:true)
						}
						break;
			}
			sessionManagerService.logoutUser(oldUsername)
			user.save(flush:true, failOnError:true)
		}
		render status:200
	}

}