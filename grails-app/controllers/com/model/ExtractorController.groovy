package com.model


import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;
import com.helpers.Request
import com.security.User

import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.web.servlet.support.RequestContextUtils;
import com.helpers.*

class ExtractorController {

	def springSecurityService
	def sessionManagerService
	def notificationsService
    def index() { }


//Prueba la conexión
    @Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def testDbConection(){ 
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(sessionManagerService.isDesktopLoggedIn(user.getUsername(),user.getLastDesktopAction())=='true'){
			def alertAction= new Alert('', user, 1, "", "", params.manager+","+params.ip+","+params.port+","+params.name+","+params.user+","+params.pass).save(flush:true, failOnError:true)
			alertAction.actionNotification = 'testConection'
			def request = new Request(user, alertAction, true, null, 1).save(flush:true, failOnError:true);
			render request.id
			return 
		}
		else{
			render status:400, text:message(code: 'extractor.dbConection.error.notLogged')
			return
		}
	}

//Revisa la respuesta de la alerta que se envió previamente al cliente y las elimina (se consulta desde ajax, sirve para extraer datos)
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def checkExecutionResponse(){
		def request = Request.get(params.id)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(request.user!=user){
			render status:401
			return
		}
		if(request.pending){
			render "pending"
			return
		} 
		def r = request.response.toString()
		def alert = request.associatedAlert
		request.delete(flush:true, failOnError:true)
		alert.delete(flush:true, failOnError:true)
		if(!r.contains('ERROR')){
			r="true"
		}
		render r
		return
	}


//Revisa la respuesta de la alerta que se envió previamente al cliente y las elimina (se consulta desde ajax, sirve para probar conexion)
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def checkConectionResponse(){
		def request = Request.get(params.id)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(request.user!=user){
			render status:401
			return
		}
		if(request.pending){
			render "pending"
			return
		} 
		def r = request.response.toString()
		def alert = request.associatedAlert
		request.delete(flush:true, failOnError:true)
		alert.delete(flush:true, failOnError:true)
		render r
		return
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveDbExtractor(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario = Scenario.get(params.id)
		def newExtractor = new BDExtractor( user, params.name.trim(), params.manager, params.dbName.trim(), params.port.trim(), params.dbUser.trim(), params.dbPass.trim(), params.query.trim(), params.ip.trim(), params.fieldsMap, params.cases.trim(), params.clueField.trim(), scenario, Boolean.parseBoolean(params.enabled))
		def validationResult= validarCadena(params.cases.trim())
		def errores="<ul>"
		if(validationResult!=1){
			errores+='<li>'+message(code:'execution.error.cases.malformed')+'</li>'
		}
		if(!newExtractor.validate() || (BDExtractor.countByNameAndScenario(params.name.trim(), scenario)>0) || validationResult!=1){
		
			if(BDExtractor.countByNameAndScenario(params.name.trim(), scenario)>0){
				errores+="<li>"+g.message(code: "com.model.BDExtractor.name.duplicate.error", args:[params.name])+"</li>"
			}
			for(error in newExtractor.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
		
			errores+="</ul>"
			render status:400, text:errores
			return
		}
		newExtractor.save(flush:true)
		render newExtractor.id
		return
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateDbExtractor(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def extractor = BDExtractor.get(params.id)
		extractor.setName(params.name)
		extractor.setDbGestor(params.manager)
		extractor.setDbUser(params.dbUser)
		extractor.setDbPass(params.dbPass)
		extractor.setQuery(params.query)
		extractor.setPort(params.port)
		extractor.setBdName(params.dbName)
		extractor.setIp(params.ip)
		extractor.setFieldsMap(params.fieldsMap)
		extractor.setClueField(params.clueField)
		extractor.setOriginalCases(params.cases)
		println params
		def splittedCases = params.cases.split(',')
		def newCases =""
		for(def i=0;i<splittedCases.length;i++){
			if(splittedCases[i].contains('-')){
				def splittedRange = splittedCases[i].split('-')
				def init = Integer.parseInt(splittedRange[0])
				def end = Integer.parseInt(splittedRange[1])
				for(def j=init;j<=end;j++){
					if(i==splittedCases.length-1 && j==end){
						newCases+=j
						}
					else{
						newCases+=j+','
					}
				}

			}
			else{
				if(i==splittedCases.length-1){
					newCases+=splittedCases[i]
				}
				else{
					newCases+=splittedCases[i]+','
				}
			}
		}
		if(!extractor.validate()){
			def errores="<ul>"
			if(BDExtractor.countByNameAndScenarioAndIdNotEquals(params.name, extractor.scenario, extractor.id)>0){
				errores+="<li>"+g.message(code: "com.model.BDExtractor.name.duplicate.error", args:[params.name])+"</li>"
			}
			for(error in extractor.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			errores+="</ul>"
			render status:400, text:errores
			return
		}

		extractor.save(flush:true, failOnError:true)
		render extractor.id
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateDBenabled(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def extractor = BDExtractor.get(params.id)
		def scenario = Scenario.get(Long.parseLong(params.scenarioId))
		if(!extractor || !scenario || !(extractor in BDExtractor.findAllByScenario(scenario))){
			render status:400
			return
		}
		def checked = Boolean.parseBoolean(params.checked)
		extractor.enabled = checked
		extractor.save(flush:true, failOnError:true)
		render status:200
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteDBExtractor(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def extractor = BDExtractor.get(params.id)
		if(extractor.scenario in user.getProjects()*.scenarios.flatten()){
			render view:"/login/denied"
			return
		}
		extractor.delete(flush:true, failOnError:true)
		render status:200
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteTXTExtractor(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def extractor = TXTExtractor.get(params.id)
		if(extractor.scenario in user.getProjects()*.scenarios.flatten()){
			render view:"/login/denied"
			return
		}
		def txtFile = extractor.txtFile		
		def rows = txtFile.rows
		def idsRows = ''
		for(def i=0;i<rows.size();i++){
			idsRows += rows[i].id + ";"
		}
		txtFile.rows.clear()
		def idsRowsSplit = idsRows.split(';')
		if(rows.size() > 0){
			for(def i=0;i<idsRowsSplit.size();i++){
				def row = Row.get(Integer.parseInt(idsRowsSplit[i]))
				row.delete(flush:true, failOnError:true)
			}	
		}
		extractor.delete(flush:true, failOnError:true)
		txtFile.delete(flush:true, failOnError:true)
		render status:200
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateTxtEnabled(){		
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def extractor = TXTExtractor.get(params.id)
		def scenario = Scenario.get(Long.parseLong(params.scenarioId))		
		if(!extractor || !scenario || !(extractor in TXTExtractor.findAllByScenario(scenario))){			
			render status:400
			return
		}		
		def checked = Boolean.parseBoolean(params.checked)		
		extractor.isEnabled = checked
		extractor.save(flush:true, failOnError:true)		
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveTxtExtractor(){		
		try{
			def functionality16 = Functionality.findByInternalId(16)
			def functionality14 = Functionality.findByInternalId(14)			
			def functionality15 = Functionality.findByInternalId(15)
			def functionality17 = Functionality.findByInternalId(17)
			def functionality20 = Functionality.findByInternalId(20)
			def functionality21 = Functionality.findByInternalId(21)
			def functionality22 = Functionality.findByInternalId(22)
			def scenario = Scenario.get(params.id)			
			if(!scenario){
				render view:'/login/denied'
				return
			}
			def file= request.getFile('txtFile')
			def errors = "<ul>"			
			if(!file){
				render view:'/login/denied'
				return
			}
			if(file.getContentType() != "text/plain"){
				errors += "<li>"+message(code:'extractor.file.notPlain')+"</li>"
			}		
			def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())			
			def name = params.name
			def txtFile = new Txt(user, name)
			if(!txtFile.validate() || name.trim()==""){
				println txtFile.errors.getAllErrors()
				errors += "<li>"+message(code:'extractor.name.blank')+"</li>"
			}

			if(TXTExtractor.countByNameAndScenario(name, scenario)>0){
				errors += "<li>"+message(code:'extractor.name.duplicate')+"</li>"
			}
			if(params.delimiter==""){
				errors += "<li>"+message(code:'extractor.delimiter.blank')+"</li>"
			}			
			if(errors != "<ul>"){
				errors += "</ul>" 
				def locale = RequestContextUtils.getLocale(request)
				def project = scenario.project			
				if(!(scenario in user.getProjects()*.scenarios.flatten())){
					render view:'/login/denied'
					return
				}
				def steps = scenario.steps.sort{it.execOrder}
				def cases = scenario.cases.sort{it.execOrder}				
				for(Case curCase in cases){
					if(curCase.isArchive){
						cases.remove(curCase)
					}
				}				
				def projectId = scenario.project.id
				def isWebScenario = false

				for(Step curStep in scenario.steps){
					if(curStep!=null && curStep.isEnabled )
						if(curStep.pType==1){
							isWebScenario=true;
							break;
						}
				}
				render view:'/case/index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "mmm('#generatorsTab').trigger('click');mmm('#executionErrorMessage').html('"+errors+"');mmm('#executionErrorModal').modal('show')", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21:functionality21, functionality22:functionality22]			
				return
			}

			if(params.realCases != 'ALL' && validarCadena(params.realCases) != 1){
				errors += "<li>"+message(code:'extractor.cases.error')+"</li>"
			}
			def stream = file.getInputStream()
			def counter = 0
			stream.eachLine{ line->
				if( line.trim() ) {
			     //println line
			     counter++
			    }
			}

			if(counter == 0){
				errors += "<li>"+message(code:'extractor.file.empty')+"</li>"
			}

			if(params.fieldMap == ""){
				errors += "<li>"+message(code:'extractor.objects.empty')+"</li>"	
			}

			if(errors != "<ul>"){
				errors += "</ul>" 
				def locale = RequestContextUtils.getLocale(request)
				def project = scenario.project
				println !(scenario in user.getProjects()*.scenarios.flatten())
				println scenario
				println user.getProjects()*.scenarios.flatten()
				if(!(scenario in user.getProjects()*.scenarios.flatten())){
					render view:'/login/denied'
					return
				}
				def steps = scenario.steps.sort{it.execOrder}
				def cases = scenario.cases.sort{it.execOrder}				
				for(Case curCase in cases){
					if(curCase.isArchive){
						cases.remove(curCase)
					}
				}				
				def projectId = scenario.project.id
				def isWebScenario = false
				for(Step curStep in scenario.steps){
					if(curStep!=null && curStep.isEnabled )
						if(curStep.pType==1){
							isWebScenario=true;
							break;
						}
				}
		//('#generatorsTab').trigger('click')
				render view:'/case/index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "mmm('#generatorsTab').trigger('click');mmm('#executionErrorMessage').html('"+errors+"');mmm('#executionErrorModal').modal('show')", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21:functionality21, functionality22:functionality22]			
				return
			}
			txtFile.save(flush:true, failOnError:true)
			def auxStream = file.getInputStream()
			def lineFile
			auxStream.eachLine{ line->
				if( line.trim() ) {
					lineFile = new Row(line)
			     	txtFile.addToRows(lineFile)			     	
			    }
			}
			txtFile.save(flush:true)
			def txtExtractor = new TXTExtractor(user, txtFile, params.realCases, params.fieldMap, params.name, scenario, Boolean.parseBoolean(params.isEnabled), file.getName(), params.delimiter).save(flush:true, failOnError:true)
			def locale = RequestContextUtils.getLocale(request)
			def project = scenario.project
			if(!(scenario in user.getProjects()*.scenarios.flatten())){
				render view:'/login/denied'
				return
			}
			def steps = scenario.steps.sort{it.execOrder}
			def cases = scenario.cases.sort{it.execOrder}				
			for(Case curCase in cases){
				if(curCase.isArchive){
					cases.remove(curCase)
				}
			}
			def projectId = scenario.project.id
			def isWebScenario = false
			for(Step curStep in scenario.steps){
				if(curStep!=null && curStep.isEnabled )
					if(curStep.pType==1){
						isWebScenario=true;
						break;
					}
			}
		//('#generatorsTab').trigger('click')
			render view:'/case/index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "mmm('#generatorsTab').trigger('click');", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21:functionality21, functionality22:functionality22]			
			return
		}catch(IOException ioe){
			 ioe.printStackTrace()
		}catch(MissingMethodException miss){
			println 'Exception'
			redirect controller:'case', action:'index', id:params.id
			return
		}		
		render status:200
		return
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateTxtExtractor(){	
		try{
			println params
			def functionality16 = Functionality.findByInternalId(16)
			def functionality14 = Functionality.findByInternalId(14)
			def functionality15 = Functionality.findByInternalId(15)
			def functionality17 = Functionality.findByInternalId(17)
			def functionality20 = Functionality.findByInternalId(20)
			def functionality21 = Functionality.findByInternalId(21)
			def functionality22 = Functionality.findByInternalId(22)
			def txtExtractor = TXTExtractor.get(Integer.parseInt(params.idTxt))
			def errors = "<ul>"
			if(!txtExtractor){
				errors += '<li>'+message(code:'extractor.txtExtractor.notExist')+'</li>'
			}
			def scenario = Scenario.get(params.id)			
			if(!scenario){
				errors += '<li>'+message(code:'extractor.scenario.notExist')+'</li>'				
			}
			def file= request.getFile('txtFile')			
			if(!file){				
				errors += "<li>"+message(code:'extractor.file.error')+"</li>"
			}
			if(file.getContentType() != "text/plain"){
				errors += "<li>"+message(code:'extractor.file.notPlain')+"</li>"
			}		
			def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
			def name = params.name
			def txtFile = new Txt(user, name)
			if(!txtFile.validate() || name.trim()==""){				
				errors += "<li>"+message(code:'extractor.name.blank')+"</li>"
			}

			if(TXTExtractor.countByNameAndScenarioAndIdNotEqual(name, scenario, txtExtractor.id)>0){
				errors += "<li>"+message(code:'extractor.name.duplicate')+"</li>"
			}
			if(params.delimiter==""){
				errors += "<li>"+message(code:'extractor.delimiter.blank')+"</li>"
			}			
			if(params.realCases != 'ALL' && validarCadena(params.realCases) != 1){
				errors += "<li>"+message(code:'extractor.cases.error')+"</li>"
			}
			def stream = file.getInputStream()
			def counter = 0
			stream.eachLine{ line->
				if(line.trim()) {
			    	//println line
			    	counter++
			    }
			}
			if(counter == 0){
				errors += "<li>"+message(code:'extractor.file.empty')+"</li>"
			}
			if(params.fieldMap == ""){
				errors += "<li>"+message(code:'extractor.objects.empty')+"</li>"	
			}
			if(errors != "<ul>"){				
				errors += "</ul>" 
				def locale = RequestContextUtils.getLocale(request)
				def project = scenario.project
				if(!(scenario.id in user.getProjects()*.scenarios.flatten()*.id)){
					render view:'/login/denied'
					return
				}
				def steps = scenario.steps.sort{it.execOrder}
				def cases = scenario.cases.sort{it.execOrder}				
				for(Case curCase in cases){
					if(curCase.isArchive){
						cases.remove(curCase)
					}
				}				
				def projectId = scenario.project.id
				def isWebScenario = false
				for(Step curStep in scenario.steps){
					if(curStep!=null && curStep.isEnabled )
						if(curStep.pType==1){
							isWebScenario=true;
							break;
						}
				}
		//('#generatorsTab').trigger('click')
				render view:'/case/index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "mmm('#generatorsTab').trigger('click');mmm('#executionErrorMessage').html('"+errors+"');mmm('#executionErrorModal').modal('show')", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21:functionality21, functionality22:functionality22]			
				return
			}
			txtFile.save(flush:true, failOnError:true)
			def auxStream = file.getInputStream()
			def lineFile
			auxStream.eachLine{ line->
				if( line.trim() ) {
					lineFile = new Row(line)
			     	txtFile.addToRows(lineFile)			     	
			    }
			}
			txtFile.save(flush:true)
			//Borrar las filas almacenadas del txtExtractor
			def txtFileOld = txtExtractor.txtFile		
			def idsRows = txtFileOld.rows*.id
			txtFileOld.rows.clear()
			for(id in idsRows){
				def row = Row.get(id)
				row.delete(flush:true, failOnError:true)
			}
			//Actualizar TXTExtractor
			txtExtractor.creator = user
			txtExtractor.txtFile = txtFile
			txtExtractor.cases = params.realCases
			txtExtractor.fieldsMap = params.fieldMap
			txtExtractor.name = params.name
			txtExtractor.scenario = scenario
			txtExtractor.isEnabled = Boolean.parseBoolean(params.isEnabled)
			txtExtractor.fileName = file.getName()
			txtExtractor.delimiter = params.delimiter
			txtExtractor.save(flush:true, failOnError:true)

			//Variables de Carga para la vista
			def locale = RequestContextUtils.getLocale(request)
			def project = scenario.project			
			def steps = scenario.steps.sort{it.execOrder}
			def cases = scenario.cases.sort{it.execOrder}				
			for(Case curCase in cases){
				if(curCase.isArchive){
					cases.remove(curCase)
				}
			}
			def projectId = scenario.project.id
			def isWebScenario = false
			for(Step curStep in scenario.steps){
				if(curStep!=null && curStep.isEnabled )
					if(curStep.pType==1){
						isWebScenario=true;
						break;
					}
			}
		//('#generatorsTab').trigger('click')
			render view:'/case/index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "mmm('#generatorsTab').trigger('click');", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21:functionality21, functionality22:functionality22]			
			return
		}catch(IOException ioe){
			 ioe.printStackTrace()
		}catch(MissingMethodException miss){
			println 'Exception'
			redirect controller:'case', action:'index', id:params.id
			return
		}		
		render status:200
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateGeneratorEnabled(){		
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def generator = Generator.get(params.id)
		def scenario = Scenario.get(Long.parseLong(params.scenarioId))		
		if(!generator || !scenario || !(generator in Generator.findAllByScenario(scenario))){			
			render status:400
			return
		}		
		def checked = Boolean.parseBoolean(params.checked)		
		generator.enabled = checked
		generator.save(flush:true, failOnError:true)		
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveGenerator(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario = Scenario.get(params.id)
		//println '***************************'
		def name = params.name?params.name.trim():''
		def fieldMap = params.fieldMap
		def cases = params.cases?params.cases.trim():''
		def type = Integer.parseInt(params.type)
		def length = params.length?Integer.parseInt(params.length.trim()):null
		def pattern = params.pattern?params.pattern.trim():''
		def rangeInit = params.rangeInit?Integer.parseInt(params.rangeInit.trim()):null
		def rangeEnd = params.rangeEnd?Integer.parseInt(params.rangeEnd.trim()):null
		def base = params.base?params.base.trim():''
		def enabled = Boolean.parseBoolean(params.enabled)		
		//println name + '---' + fieldMap + '---' + cases + '---' + type + '---' + length + '---' + pattern + '---' + rangeInit + '---' + rangeEnd + '---' + base
		//println '***************************'
		def generator = new Generator(user, name, fieldMap, cases, type, length, pattern, rangeInit, rangeEnd, base, scenario, enabled)
		def validationResult= validarCadena(cases)
		def errores="<ul>"
		if(validationResult!=1){
			errores+='<li>'+message(code:'execution.error.cases.malformed')+'</li>'
		}
		if(!generator.validate() || (Generator.countByNameAndScenario(name, scenario)>0) || validationResult!=1){		
			if(Generator.countByNameAndScenario(name, scenario)>0){
				errores+="<li>"+g.message(code: "com.model.Generator.name.duplicate.error", args:[name])+"</li>"
			}
			for(error in generator.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
		
			errores+="</ul>"
			render status:400, text:errores
			return
		}
		generator.save(flush:true)
		render generator.id		
		return
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def updateGenerator(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def generator = Generator.findById(params.id, [lock: true])
		//println '***************************'
		generator.name = params.name?params.name.trim():''
		generator.fieldsMap = params.fieldMap
		generator.cases = params.cases?params.cases.trim():''
		generator.type = Integer.parseInt(params.type)
		generator.length = params.length?Integer.parseInt(params.length.trim()):null
		generator.pattern = params.pattern?params.pattern.trim():''
		generator.rangeInit = params.rangeInit?Integer.parseInt(params.rangeInit.trim()):null
		generator.rangeEnd = params.rangeEnd?Integer.parseInt(params.rangeEnd.trim()):null
		generator.base = params.base?params.base.trim():''
		generator.enabled = Boolean.parseBoolean(params.enabled)		
		//println name + '---' + fieldMap + '---' + cases + '---' + type + '---' + length + '---' + pattern + '---' + rangeInit + '---' + rangeEnd + '---' + base
		//println '***************************'		
		def validationResult= validarCadena(params.cases)
		def errores="<ul>"
		if(validationResult!=1){
			errores+='<li>'+message(code:'execution.error.cases.malformed')+'</li>'
		}
		if(!generator.validate() || (Generator.countByNameAndScenarioAndIdNotEqual(params.name.trim(), generator.scenario, params.id)>0) || validationResult!=1){					
			if(Generator.countByNameAndScenarioAndIdNotEqual(params.name.trim(), generator.scenario, params.id)>0){
				errores+="<li>"+g.message(code: "com.model.Generator.name.duplicate.error", args:[params.name.trim()])+"</li>"
			}
			for(error in generator.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			errores+="</ul>"
			render status:400, text:errores
			return
		}		
		generator.save(flush:true, failOnError:true)
		render generator.id		
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteGenerator(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def generator = Generator.get(params.id)
		if(generator.scenario in user.getProjects()*.scenarios.flatten()){
			render view:"/login/denied"
			return
		}
		generator.delete(flush:true, failOnError:true)
		render status:200
		return
	}

//Valida la cadena de casos
private int validarCadena(String input) {
	if(input.equals('ALL')){
		return 1
	}
        int valida = 0;
        Pattern p = Pattern.compile("^[1-9]+-{1}[1-9]+\$");
        Matcher m = p.matcher(input);
        Pattern p2 = Pattern.compile("^[1-9]+(,[1-9]+)+\$");
        Matcher m2 = p2.matcher(input);
        Pattern p3 = Pattern.compile("[1-9]+");
        Matcher m3 = p3.matcher(input);
        Pattern p4 = Pattern.compile('^[1-9]+((,|-)[1-9]+)+\$')
        Matcher m4 = p4.matcher(input)
        if (m.matches()) {
            String[] rango = input.split("-");
            if (Integer.parseInt(rango[0]) > Integer.parseInt(rango[1])) {
                //System.out.println("Mayor >:(");
                valida = 2;
            } else {
                //System.out.println("Menor :)");
                valida = 1;
            }
        } else if (m2.matches()) {
            String[] comas = input.split(",");
            int count = 0;
            for (int i = 0; i < comas.length; i++) {
                int comp1 = Integer.parseInt(comas[i]);
                for (int j = 0; j < comas.length; j++) {
                    int comp2 = Integer.parseInt(comas[j]);
                    if (comp1 == comp2) {
                        count++;
                    }
                }
            }
            if (count > comas.length) {
                //System.out.println("hay repetidos casos >:(");
                valida = 2;
            } else {
                valida = 1;
            }
        }
        else if(m4.matches()){
        	valida=1
        }
        else if (m3.matches()) {
            valida = 1;
        } else {
            //System.out.println("No es valido para comas ni rango ni numero. >:(");
            valida = 3;
        }
        if (input.equals("")) {
            valida = 1;
        }
        return valida;
    }





}
