package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;

import grails.converters.JSON

import java.text.SimpleDateFormat;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.TimeZone;
import com.helpers.*


class ExecutionController {

	def springSecurityService
	def notificationsService
	def sessionManagerService
	def generatorService

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def targets
		if(user.getPlan()==0){
			targets = [user]			
		}
		else{
			targets = user.getAssociatedClient().getBasicUsers()
		}
		def executions = Execution.findAllByTargetAndStateLessThanEquals(user,2).sort{it.executionDate}
		def programmedExecutions = ExecutionExpression.findAllByCreator(user)
		def myProgrammedExecutions =[]
		for(ExecutionExpression ee in programmedExecutions){
			def nExecution = [creator:ee.creator.fullname, scenario:ee.scenario.name, cases: ee.cases, browsers:ee.browsers, id:ee.id]
			def nTargets=[]
			def splittedTargets = ee.targets.split(',') 
			for(String target in splittedTargets ){
				def cTarget = [fullname:User.get(Long.parseLong(target)).fullname,avatarFile:User.get(Long.parseLong(target)).avatarFile]
				nTargets.push(cTarget)
			}
			nExecution.targets = nTargets
			myProgrammedExecutions.push(nExecution)

		}
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000

		def functionality18 = Functionality.findByInternalId(18)
		def functionality19 = Functionality.findByInternalId(19)
		def functionality33 = Functionality.findByInternalId(33)
		
		render view:'index', model:[executions:executions, programmedExecutions:myProgrammedExecutions,targets:targets, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), offset:offset, properUser:user, functionality18:functionality18, functionality19:functionality19, functionality33:functionality33 ]
		return
	}


	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def getExecutions() {

		if(request.getHeader('referer').contains('login'))
		{
			redirect action:'renderIndex'
			return
		}

		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def executions = Execution.findAllByTargetAndStateLessThanEquals(user,2).sort{it.executionDate}
		for(Execution execution in executions){
			execution.stateMessage = message(code:execution.stateMessage)
		}
		render executions as JSON
	}



//Metodos de creación del JSON de ejecucion
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def executeScenario(){
		println 'En executedScenario'
		def forced = Boolean.parseBoolean(params.forced)
		Scenario scenarioToExecute = Scenario.get(params.id)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		scenarioToExecute.browsers = "NONE"
		scenarioToExecute.save(flush:true)
		println "scenarioToExecute"
		if(!(scenarioToExecute in user.getProjects()*.scenarios.flatten())){
			render view:'/login/denied'
			return
		}

		if(Case.countByScenarioAndIsEnabled(scenarioToExecute, true)==0){
			render status:400, text:message(code: 'execution.error.notCases')
			return
		}
		println "Antes if session"
		if(sessionManagerService.isDesktopLoggedIn( user.username, user.lastDesktopAction)=='true'){
				def Calendar calendar = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
				calendar.add(Calendar.SECOND, 35);
				def Calendar calendar2 = Calendar.getInstance();
				calendar2.add(Calendar.MINUTE, 30);
				def pro2 =Execution.findByStateAndTarget(2, user)
				def pro1 =Execution.findByTargetAndStateAndIsProgrammedAndExecutionDateBetween(user,1,true, calendar.getTime(), calendar2.getTime())
				println "Despues de las Consultas de Execution"

				if(pro2==null && pro1==null){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					println "Ejecucion Guardada"
					render status:200, text:"direct"
					return
				}
				else if(pro1!=null){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					println "prod1 Diferente a Null"
					render status:200, text:"queue"
					return
				}
				else if(pro2!=null && !forced){
					println "Aqui..."
					render status:200, text:message(code:'com.model.Execution.error.programmed')
					return 
				}
		}
		else{
			render status:400, text:message(code: 'execution.error.notLogged')
			return
		}
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def executeWebScenario(){		
		def forced = Boolean.parseBoolean(params.forced)
		Scenario scenarioToExecute = Scenario.get(params.id)
		def String [] browsers= params.browsers.split(',')
		if(!scenarioToExecute){
			render view:"/login/denied"
			return
		}
		if(params.browsers ==""){
			render status:400, text:message(code: 'execution.browsers.empty')
			return
		}

		scenarioToExecute.browsers=""
		scenarioToExecute.save(flush:true)
		for(String browser in browsers){
			scenarioToExecute.addbrowser(browser);
		}
		scenarioToExecute.save(flush:true)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(!(scenarioToExecute in user.getProjects()*.scenarios.flatten())){
			return
		}
		if(Case.countByScenarioAndIsEnabled(scenarioToExecute, true)==0){
			println "Error"
			render status:400, text:message(code: 'execution.error.notCases')
			return
		}
		def cases=Case.findAllByScenarioAndIsEnabled(scenarioToExecute, true)
		for(Case curCase in cases){
			println "for de cases"
			def actions = curCase.steps*.principalAction.flatten()
			for(ActionStep curAction in actions.sort{it.dateCreated}.find{it.action.action.name=='genericAction.open'}){
				println curAction.action.action.name+"+++"
				if(curAction.action.action.name == 'genericAction.open' && curAction.value.trim()==''){
					println "error"
					render status:400, text:message(code: 'execution.error.badOpenAction')
					return
				}
			}
		}

		if(sessionManagerService.isDesktopLoggedIn(user.getUsername(),user.getLastDesktopAction())=='true'){
				def Calendar calendar = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
				calendar.add(Calendar.SECOND, 35);
				def Calendar calendar2 = Calendar.getInstance();
				calendar2.add(Calendar.MINUTE, 30);
				def pro1 =Execution.findByStateAndTarget(2,user) //Hay ejecuciones en proceso, creo que pone problema
				def pro2 =Execution.findByTargetAndStateAndIsProgrammedAndExecutionDateBetween(user,1,true, calendar.getTime(), calendar2.getTime()) //Hay alguna ejecución programada cercana
				def pro3 =Execution.findByTargetAndStateAndIsProgrammed(user,1,false)
				def containsExtractors = false
				def containsBDExtractors = false
				def containsGenerators = false
				def request = null
				println "COUNT DE TXT: "+TXTExtractor.countByIsEnabledAndScenario(true,scenarioToExecute)			

				if(BDExtractor.countByEnabledAndScenario(true,scenarioToExecute)>0){
					containsExtractors = true
					containsBDExtractors = true
					def lastExtractorId =null
					if((pro2 && forced) || !pro2){
						for(BDExtractor extractor in (BDExtractor.findAllByEnabledAndScenario(true,scenarioToExecute))){
							def splittedFieldMap = extractor.fieldsMap.split(';')
							def fields =""
							def query=""
							def stepIds=[]
							for(String map in splittedFieldMap){
								fields+=map.substring(map.indexOf(':')+1)+","
								stepIds.push(map.substring(0,map.indexOf(':')))
							}
							switch(extractor.dbGestor){
								case "MySQL":
									query = extractor.query.replaceAll(';', " ")
									if(extractor.burnedData != ""){
										if(query.toLowerCase().contains('where')){
											query += " AND "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										else{
											query += " WHERE "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										
									}
									query+=" LIMIT "
									if(extractor.cases=="ALL"){
										def notAplicableCounter=0
										for(Case curCase in scenarioToExecute.cases){
											def curCounter=0
											for(String stepId in stepIds){
												def curStep = Step.get(Long.parseLong(stepId))
												def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
												if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
													curCounter++;
												} 
											}
											if(curCounter==stepIds.size()){
												notAplicableCounter++;
											}
										}
										if((scenarioToExecute.cases.size()-notAplicableCounter)==0){
											containsExtractors=false
											containsBDExtractors = false


										}
										query+=""+(scenarioToExecute.cases.size()-notAplicableCounter)
									}
									else {
										query+=""+extractor.cases.split(',').size()
									}
								break;
								
								case "Oracle":
									query = extractor.query.replaceAll(';', " ")
									if(extractor.burnedData != ""){
										if(query.toLowerCase().contains('where')){
											query += " AND "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										else{
											query += " WHERE "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										
									}
									query+=" FETCH FIRST "
									if(extractor.cases=="ALL"){
										def notAplicableCounter=0
										for(Case curCase in scenarioToExecute.cases){
											def curCounter=0
											for(String stepId in stepIds){
												def curStep = Step.get(Long.parseLong(stepId))
												def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
												if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
													curCounter++;
												} 
											}
											if(curCounter==stepIds.size()){
												notAplicableCounter++;
											}
										}
										if((scenarioToExecute.cases.size()-notAplicableCounter)==0){
											containsExtractors=false
											containsBDExtractors = false
										}
										query+=""+(scenarioToExecute.cases.size()-notAplicableCounter) + " ROWS ONLY"
									}
									else {
										query+=""+extractor.cases.split(',').size()-notAplicableCounter + " ROWS ONLY"
									}
								break;
								
								case "Postgres":
								query = extractor.query.replaceAll(';', " ")
									if(extractor.burnedData != ""){
										if(query.toLowerCase().contains('where')){
											query += " AND "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										else{
											query += " WHERE "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										
									}
									query+=" LIMIT "
									if(extractor.cases=="ALL"){
										def notAplicableCounter=0
										for(Case curCase in scenarioToExecute.cases){
											def curCounter=0
											for(String stepId in stepIds){
												def curStep = Step.get(Long.parseLong(stepId))
												def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
												if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
													curCounter++;
												} 
											}
											if(curCounter==stepIds.size()){
												notAplicableCounter++;
											}
										}
										if((scenarioToExecute.cases.size()-notAplicableCounter)==0){
											containsExtractors=false
											containsBDExtractors = false

										}
										query+=""+(scenarioToExecute.cases.size()-notAplicableCounter)
									}
									else {
										query+=""+extractor.cases.split(',').size()-notAplicableCounter
									}
									break;
								
								case "DB2":
									query = extractor.query.replaceAll(';', " ")
									if(extractor.burnedData != ""){
										if(query.toLowerCase().contains('where')){
											query += " AND "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										else{
											query += " WHERE "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										
									}
									query+=" FETCH FIRST "
									if(extractor.cases=="ALL"){
										def notAplicableCounter=0
										for(Case curCase in scenarioToExecute.cases){
											def curCounter=0
											for(String stepId in stepIds){
												def curStep = Step.get(Long.parseLong(stepId))
												def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
												if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
													curCounter++;
												} 
											}
											if(curCounter==stepIds.size()){
												notAplicableCounter++;
											}
										}
										if((scenarioToExecute.cases.size()-notAplicableCounter)==0){
											containsExtractors=false
											containsBDExtractors = false

										}
										query+=""+(scenarioToExecute.cases.size()-notAplicableCounter)+" ROWS ONLY"
									}
									else {
										query+=""+extractor.cases.split(',').size()-notAplicableCounter+" ROWS ONLY"
									}
								break;
								
								case "SQL":
									query = extractor.query.replaceAll(';', " ")
									if(!query.toLowerCase().contains(' top ')){
										def replaceable = "SELECT TOP "
										
										if(extractor.cases=="ALL"){
											def notAplicableCounter=0
											for(Case curCase in scenarioToExecute.cases){
												def curCounter=0
												for(String stepId in stepIds){
													def curStep = Step.get(Long.parseLong(stepId))
													def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
													if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
														curCounter++;
													} 
												}
												if(curCounter==stepIds.size()){
													notAplicableCounter++;
												}
											}
											if((scenarioToExecute.cases.size()-notAplicableCounter)==0){
												containsExtractors=false
												containsBDExtractors = false

											}
											replaceable+=""+(scenarioToExecute.cases.size()-notAplicableCounter)
										}
										else {
											replaceable+=""+extractor.cases.split(',').size()-notAplicableCounter
										}

										query = query.replaceFirst("(?i)select", replaceable)
									}
									if(extractor.burnedData != ""){
										if(query.toLowerCase().contains('where')){
											query += " AND "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										else{
											query += " WHERE "+extractor.clueField+" NOT IN ("+extractor.burnedData+")"
										}
										
									}
								break;
							}
							//fin del switch
							if(containsBDExtractors){
								def paramsExtractor = [base:extractor.dbGestor+","+extractor.ip+","+extractor.port+","+extractor.bdName+","+extractor.dbUser+","+extractor.dbPass, query:query, fields:fields, extractorId:extractor.id, scenarioId:scenarioToExecute.id, clueField:extractor.clueField]
								def alertAction= new Alert('', user, 1, "", "", (paramsExtractor as JSON).toString()).save(flush:true, failOnError:true)
								alertAction.actionNotification = 'dbExtraction'
								lastExtractorId = alertAction.id
							}
						}
						if(containsBDExtractors)
							request = new Request(user, Alert.get(lastExtractorId), true, null, 2).save(flush:true, failOnError:true);
					}
				}	
				if(TXTExtractor.countByIsEnabledAndScenario(true,scenarioToExecute)>0){
					containsExtractors = true
					def containsTXTExtractors = true
					def lastTXTExtractorId =null
					println "PRO2: "+pro2
					if((pro2 && forced) || !pro2){
						for(TXTExtractor extractor in (TXTExtractor.findAllByIsEnabledAndScenario(true,scenarioToExecute))){
							def splittedFieldMap = extractor.fieldsMap.split(';')
							def fields =""
							def query=""
							def stepIds=[]
							for(String map in splittedFieldMap){
								fields+=map.substring(map.indexOf(':')+1)+","
								stepIds.push(map.substring(0,map.indexOf(':')))
							}

							println "FIELDS: "+fields
							println "stepids_:"+stepIds
							def notAplicableCounter = 0
							def casesToExtract =[]
							def tempCases = false
							for(Case curCase in scenarioToExecute.cases.sort{it.id}){
								def curCounter=0
								for(String stepId in stepIds){
									def curStep = Step.get(Long.parseLong(stepId))
									def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
									if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
										curCounter++;
									}
									else{
										tempCases = true
										break										
									} 
								}
								if(tempCases){
									casesToExtract.push(curCase)
									tempCases = false
								}
								if(curCounter==stepIds.size()){
									notAplicableCounter++;
								}
							}
							if(notAplicableCounter < scenarioToExecute.cases.size()){								
								def rows = extractor.txtFile.rows.sort{it.id}			
								def i = 0
								def arrayField = fields.split(',')								
								for(Case caseToExtract in casesToExtract){
									try{
										def row = rows[i]
										def newValue = row.dataRow.split(extractor.delimiter)
										println newValue
										def j = 0
										if(rows.size() > i){
											for(String stepId in stepIds){
												def curStep = Step.get(Long.parseLong(stepId))
												def curCaseStep = CaseStep.findByMyCaseAndStep(caseToExtract, curStep)
												def curActionStep = ActionStep.findByCaseStep(curCaseStep.id)
												println "curActionStep: "+curActionStep
												println arrayField[j] + newValue[Integer.parseInt(arrayField[j])-1]										
												curActionStep.value = newValue[Integer.parseInt(arrayField[j])-1]
												curActionStep.save(flush:true,failOnError:true)
												j++
											}											
											extractor.txtFile.removeFromRows(row)
											row.delete(flush:true, failOnError:true)											
										}
										i++
									}catch(Exception ex){
										println ex.getMessage()
										break
									}
								}
							}							
						}
					}
				}

				if(Generator.countByEnabledAndScenario(true,scenarioToExecute)>0){
					containsGenerators = true					
					if((pro2 && forced) || !pro2){
						for(Generator generator in (Generator.findAllByEnabledAndScenario(true,scenarioToExecute))){							
							def stepIds=generator.fieldsMap.split(';')							
							def notAplicableCounter = 0
							def casesToExtract =[]
							def tempCases = false
							for(Case curCase in scenarioToExecute.cases){
								def curCounter=0
								for(String stepId in stepIds){
									def curStep = Step.get(Long.parseLong(stepId))
									def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
									if(!curCaseStep.principalAction.isActive || !curStep.isEnabled || !curCase.isEnabled ){
										curCounter++;
									}
									else{
										tempCases = true
										break										
									} 
								}
								if(tempCases){
									casesToExtract.push(curCase)
									tempCases = false
								}
								if(curCounter==stepIds.size()){
									notAplicableCounter++;
								}
							}
							if(notAplicableCounter < scenarioToExecute.cases.size()){								
								def i = 0								
								for(Case caseToExtract in casesToExtract){
									try{
										def type = generator.type
										def length = generator.length != null?generator.length:0
										def pattern = generator.pattern != ''?generator.pattern:''
										def rangeInit = generator.rangeInit != null?generator.rangeInit:0
										def rangeEnd = generator.rangeEnd != null?generator.rangeEnd:0
										def base = generator.base != ''?generator.base:''
										def ArrayList<String> datos = generateData(type, length, pattern, rangeInit, rangeEnd, base, stepIds.size())
										def j = 0
										for(String stepId in stepIds){											
											def curStep = Step.get(Long.parseLong(stepId))
											def curCaseStep = CaseStep.findByMyCaseAndStep(caseToExtract, curStep)
											def curActionStep = ActionStep.findByCaseStep(curCaseStep.id)															
											curActionStep.value = datos.get(j)
											curActionStep.save(flush:true)
											j++
										}
										i++
									}catch(Exception ex){
										println ex.getMessage()
										break
									}
								}
							}							
						}
					}
				}
				
				if(pro2==null && pro1==null && pro3==null && !containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					render status:200, text:"direct"
					return
				}
				else if((pro1!=null || pro3) && pro2==null && !containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					render status:200, text:"queue"
					return
				}
				else if(pro2!=null && !forced){
					render status:200, text:"confirm"
					return 
				}

				else if(pro2!=null && forced && !containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					render status:200, text:"forced"
					return 
				}

				else if(pro2==null && pro1==null && pro3==null && containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),0,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					request.response = String.valueOf(myExecution.id)
					render status:200, text:"directWithExtractors:"+request.id
					return
				}
				else if((pro1!=null || pro3) && pro2==null && !containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),0,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					request.response = String.valueOf(myExecution.id)
					render status:200, text:"queueWithExtractors"+request.id
					return
				}
				
				else if(pro2!=null && forced && containsBDExtractors){
					def myExecution=new Execution(user,user, false,calendar.getTime(),0,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true)
					request.response = String.valueOf(myExecution.id)
					render status:200, text:"forcedWithExtractors"+request.id
					return 
				}

		}
		else{
			render status:400, text:message(code: 'execution.error.notLogged')
			return
		}
	}


	//Elimina una ejecución pegada (que murio en tramite)
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def delete(){ 
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def curExecution = Execution.get(params.id)
		if(curExecution==null || !curExecution.creator.equals(user) ){
			render view:'/login/denied'
			return 
		}
		curExecution.delete(flush:true)
		def alertAction= new Alert('', user, 1, "", "", curExecution.id.toString()).save(flush:true, failOnError:true)
		alertAction.actionNotification = 'deleteExecution'
		render status:200
	}

	
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteProgrammed(){ 
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def curExecution = ExecutionExpression.get(params.id)
		if(curExecution==null || !curExecution.creator.equals(user)){
			render view:'/login/denied'
			return 
		}
		curExecution.delete(flush:true)
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteMasiveProgrammed(){ 
		def executionsIds = params.executionsToDelete.toString().split(',')		
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		for(def i=0;i<executionsIds.size();i++){
			def curExecution = ExecutionExpression.get(Integer.parseInt(executionsIds[i]))
			if(curExecution==null || !curExecution.creator.equals(user)){
				render view:'/login/denied'
				return 
			}
			curExecution.delete(flush:true)
		}
		render status:200
	}

//Programa una ejecución s
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def programExecution(){
		println params
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def typeOfExecution = params.execType
		def errors = []
		def cases = params.cases
		def localOffset = params.localOffset
		def initialDateString = params.initialDate
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		Date initialDateCandidate = formatter.parse(initialDateString);
		println 'Initial Date ---- '+initialDateCandidate.getTime()
		def difference = (offset+Long.parseLong(localOffset))*60000
		println 'offset ------ ' + offset
		println 'Local Offset ----- ' + localOffset
		Long diferencia = initialDateCandidate.getTime()+difference
		println 'Diferencia ------ '+diferencia
		Date initialDate = new Date(diferencia)
		def browsers = params.browsers.toUpperCase()
		def targets = params.targets
		def projectId
		def project
		def scenarioId
		def scenario
		def daysOfweek = params.daysOfWeek
		try{
		projectId = Long.parseLong(params.project)
		project = Project.get(projectId)
		scenarioId = Long.parseLong(params.scenario)
		scenario = Scenario.get(scenarioId)
		} catch(NumberFormatException ex) {
			render status:400, text:message(code:'execution.error.projectScenario')
			return
		}

		if(typeOfExecution!="1" && typeOfExecution!="2" && typeOfExecution!="3"){			
			errors.push(message(code:'execution.badRequest'))
			render status:400, text:errors
			return
		}
		

		if(!project){			
			errors.push(message(code:'execution.badRequest'))
			render status:400, text:errors
			return
		}

		if(!(project in user.getProjects())){			
			render view:'/login/denied'
			return
		}
		

		if(!scenario || !(scenario in project.scenarios)){			
			errors.push(message(code:'execution.badRequest'))
			render status:400, text:errors
			return
		}
		
		if(targets == ""){			
			errors.push(message(code:'execution.error.targets.empty'))
		}

		
		if( scenario.isWeb() && browsers == ""){			
			errors.push(message(code:'execution.error.browsers.empty'))
		}


		if(typeOfExecution=="2" && daysOfweek=="") {
			errors.push(message(code:'execution.error.daysOfweek.empty'))
		}

		def validationResult= ValidarCadena(cases)
		if(validationResult!=1){
			errors.push(message(code:'execution.error.cases.malformed'))
		}
		if(errors.size()>0){
			def errorP = "<ul>"
			for(def i=0; i<errors.size();i++){
				errorP+="<li>"+errors[i]+"</li>"
			}
			render status:400, text:errorP+'</ul>'
			return
		}
		
		scenario.save(flush:true, failOnError:true)
		if((typeOfExecution=="1"  || typeOfExecution=="3") && isToday(initialDate)){
			println "empieza hoy"
			def targetsSplitted = targets.split(',')
			for(def i=0;i<targetsSplitted.size();i++)
			{
				def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
				if(cTarget){
					try {
						def execution = new Execution(cTarget, user, true, initialDate, 1,  scenario, cases, browsers).save(flush:true,failOnError:true)
					}
					catch(Exception e) {
						render status:500, text:'${message(code:"default.oops")} ExecutionController(752)'
						return
					}
					
					
				}

			}

			if( typeOfExecution=="3"){
				try {
					def pExecution = new ExecutionExpression(user,Integer.valueOf(params.execType), initialDate, true, true, true, true, true, true, true, scenario,cases,targets, browsers).save(flush:true, failOnError:true)
				}
				catch(Exception e) {
					render status:500, text:'${message(code:"default.oops")} ExecutionController(766)'
					return
				}
					
			}

			render status:200
			return
		}
		else if(!isToday(initialDate) && typeOfExecution=="1"){
			try {
				def pExecution = new ExecutionExpression(user,Integer.valueOf(params.execType), initialDate, false, false, false, false, false, false, false, scenario,cases,targets, browsers).save(flush:true, failOnError:true)
				render estaus:200
				return
			}
			catch(Exception e) {
				render status:500, text:'${message(code:"default.oops")} ExecutionController(780)'
				return
			}
			
			
		}
		else if(isToday(initialDate) && typeOfExecution=="2"){
			def c  = Calendar.getInstance();
        	def dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
        	if(daysOfweek.contains(String.valueOf(dayOfWeek))){
        		def targetsSplitted = targets.split(',')
				for(def i=0;i<targetsSplitted.size();i++)
				{
					def cTarget = User.get(Long.parseLong(targetsSplitted[i]))
					if(cTarget){
						try {
							def execution = new Execution(cTarget, user, true, initialDate, 1,  scenario, cases, browsers).save(flush:true,failOnError:true)
						}
						catch(Exception e) {
							render status:500, text:'${message(code:"default.oops")} ExecutionController(801)'
							return
						}				
						
					}
				}
				
        	}

        	try {
        		def pExecution = new ExecutionExpression(user,Integer.valueOf(params.execType), initialDate, daysOfweek.contains('2'),  daysOfweek.contains('3'),daysOfweek.contains('4'),daysOfweek.contains('5'),daysOfweek.contains('6'),daysOfweek.contains('7'),daysOfweek.contains('1'), scenario,cases,targets, browsers).save(flush:true, failOnError:true)
				render status:200
				return
        	}
        	catch(Exception e) {
        		render status:500, text:'${message(code:"default.oops")} ExecutionController(814)'
				return
        	}
        	
        	
		}
		else{
			try {

				def pExecution = new ExecutionExpression(user,Integer.valueOf(params.execType), initialDate, daysOfweek.contains('2'),  daysOfweek.contains('3'),daysOfweek.contains('4'),daysOfweek.contains('5'),daysOfweek.contains('6'),daysOfweek.contains('7'),daysOfweek.contains('1'), scenario,cases,targets, browsers).save(flush:true, failOnError:true)
				render status:200
				return
			}
			catch(Exception e) {
				render status:500, text:'${message(code:"default.oops")} ExecutionController(828)'
				return
			}
			
			
		}
	}

//envía las opciones del select de escenario dado un proyecto en el proceso de programación
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def chooseScenario(){
		def html = '<option value="0"></option>'
        def project = Project.get(params.id)
        if(!project){
            render html
            return
        }
        html = '<option value="" isweb="">-</option>'        
        for(Scenario scenario in project.scenarios.sort{it.name}){
        	if(scenario.enabled)
            html += '<option value="'+scenario.id+'" isWeb="'+scenario.isWeb()+'">'+scenario.name+'</option>'        }
        render html		
	}


//Válida la cadena de casos para garantizar que es consistente
	private int ValidarCadena(String input) {
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
            valida = 0;
        }
        return valida;
    }


//Verifica si dos fechas dadas son del mismo día
	private static boolean isSameDay(Calendar cal1, Calendar cal2) {
	    if (cal1 == null || cal2 == null) {
	        throw new IllegalArgumentException("The dates must not be null");
	    }
	    return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA) &&
	        cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
	        cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR));
	}
    
  //Revisa si la fecha dada es hoy
	private static boolean isToday(Date date) {
	  	Calendar cal = Calendar.getInstance();
       	cal.setTime(date);
	    return isSameDay(cal, Calendar.getInstance());
	}

	//genera datos 
	private ArrayList<String> generateData(int type, int length, String pattern, int rangeInit, int rangeEnd, String base, int cantStep){		
		ArrayList<String> datos = new ArrayList<String>()
		for(def i=0;i<cantStep;i++){
			switch(type) {
				case 1:
					if(length > 0){						
						datos.add(generatorService.alfabeticGenerationByLength(length))
					} else {
						datos.add(generatorService.alfabeticGenerationByPattern(pattern))
					}
					break
				case 2:
					if(length > 0){
						datos.add(generatorService.numericGenerationByLength(length))
					} else {
						datos.add(generatorService.numericGenerationByRange(rangeInit, rangeEnd))
					}
					break
			}
		}
		return datos
	}


}
