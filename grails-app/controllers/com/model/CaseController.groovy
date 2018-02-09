package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;
import grails.converters.JSON
import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;
import com.helpers.*

//Gestiona los casos de prueba
class CaseController {
	
	def springSecurityService
	def notificationsService

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def scenario = Scenario.get(params.id)
		if(scenario==null){
			render view:'/login/denied'
			return
		}
		def project = scenario.project
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
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
		def functionality14 = Functionality.findByInternalId(14)
		def functionality15 = Functionality.findByInternalId(15)
		def functionality16 = Functionality.findByInternalId(16)
		def functionality17 = Functionality.findByInternalId(17)
		def functionality20 = Functionality.findByInternalId(20)
		def functionality21 = Functionality.findByInternalId(21)
		def functionality22 = Functionality.findByInternalId(22)


		def txtExts = TXTExtractor.findAllByScenario(scenario)
		for(extractor in txtExts){
			println txtExts.fieldsMap+"*********************"
		}

		render view:'index', model:[isWebScenario:isWebScenario,steps:steps,cases:cases,associatedScenario:scenario,scenarioId:scenario.id, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0),projects:user.getProjects(), browsers:user.getBrowsers(), bdExtractors:BDExtractor.findAllByScenario(scenario), txtExtractors:TXTExtractor.findAllByScenario(scenario), generators:Generator.findAllByScenario(scenario), additionalJS: "", functionality16:functionality16, functionality14:functionality14, functionality15:functionality15, functionality17:functionality17, functionality20:functionality20, functionality21: functionality21, functionality22:functionality22]
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create(){

		def caseInstance=null
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario = Scenario.get(params.id)
		if(scenario==null){
			render view:'/login/denied'
			return
		}
		def order = scenario.cases.size()+1

		caseInstance = new Case(scenario.casePrefix+order, params.description.trim(), order,null,user,scenario)
		if (caseInstance == null) {
			return
		}
		

		if (!caseInstance.validate()  ) {

			def errores="<ul>"
			for(error in caseInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"
			render status:400, text:errores
			return
		}
		caseInstance.save(flush:true,failOnError:true)
		for(Step curStep in scenario.steps){
			def curCaseStep = new CaseStep(curStep, user, caseInstance).save(flush:true)
			caseInstance.addToSteps(curCaseStep)
		}
		caseInstance.save(flush:true)
		scenario.addToCases(caseInstance)
		render status:200
		return 
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def saveOrder(){
		try{
			def order= params.order.split(",")
			def scenario = Scenario.get(params.id)
			scenario.cases.clear()
			for(def i=0;i<order.size();i++){
				def curCase= Case.get(Long.parseLong(order[i]))
				curCase.setExecOrder(i+1)
				scenario.addToCases(curCase)
			}
			scenario.save(flush:true)
			render status:200
			return
		}catch(Exception e){
			e.printStackTrace()
			render status:400
		}

	}


	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def changeEnabled(){
		def caseInstance = Case.get(params.id)
		if(caseInstance==null){
			render view:'/login/denied'
			return
		}
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(!caseInstance in user.getProjects()*.scenarios*.cases.flatten()){
			render view:'/login/denied'
			return
		}
		caseInstance.isEnabled = Boolean.parseBoolean(params.active)
		caseInstance.save(flush:true)
		render status:200
		return

	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def changeActionState(){
		def actionInstance = ActionStep.get(Long.parseLong(params.id))
		if(!actionInstance){
			render view:'/login/denied'
			return
		}
		if(params.state=="true"){
			actionInstance.setIsActive(true)
			actionInstance.save(flush:true,failOnError:true)
		}
		else{
			actionInstance.setIsActive(false)
			actionInstance.save(flush:true,failOnError:true)
		}
		render status:200
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def changeValue(){
		def splittedIds = params.ids.split('#;#')
		def splittedValues = params.values.split('#;#')
		//def splittedStateIds = params.stateIds.split('#;#')
		//def splittedStates = params.states.split('#;#')
		def actionInstance



		/*for(def i=0;i<splittedStateIds.length;i++){
			if(!splittedStateIds[i].contains('R'))
				actionInstance = ActionStep.get(Long.parseLong(splittedStateIds[i]))
			else
				actionInstance = ActionStep.get(Long.parseLong(splittedStateIds[i].substring(1)))
			if(actionInstance==null){
				render status:400, text:'Action not found'
				return
			}
			if(splittedStates[i]=='true'){
				actionInstance.setIsActive(true)
				actionInstance.save(flush:true,failOnError:true)
			}
			else{
				actionInstance.setIsActive(false)
				actionInstance.save(flush:true,failOnError:true)
			}
		}
*/
		
		for(def i=0;i<splittedIds.length;i++){
			if(!splittedIds[i].contains('R'))
				actionInstance = ActionStep.get(splittedIds[i])
			else{
				actionInstance = ActionStep.get(splittedIds[i].substring(1))
			}
			if(actionInstance==null){
				render status:400, text:'Action not found'
				return
			}
			if(!(actionInstance.getValue()=='replaceForCode' || actionInstance.getAction().getAction().name =="genericAction.click") ){

			
				 if(i>=splittedValues.length){
					actionInstance.setValue("")
				}
				else{
					if(splittedIds[i].contains('R')){
						actionInstance.setValue(actionInstance.getValue()+"#;#"+splittedValues[i])
					}
					else
						actionInstance.setValue(splittedValues[i])
				}
			}
		}
		def stepInstance = CaseStep.get(actionInstance.caseStep)
		stepInstance.save(flush:true)
		def newContent = '<h5><b>'+message(code:'text.principalAction')+
		':</b></h5><div style="border-radius: 5px; border: 1px solid #D0D7D9; padding-bottom:5px; padding-right:10px; margin-top:5px"><div class="row" style="margin: 0px 0px 0px 2px"><div class="col-md-5"><h5><b>'+message(code:stepInstance.principalAction.action.action.name)+
		'</b></h5></div> <label style="padding-top:6px;" class="pull-right col-md-7">'
		if(stepInstance.principalAction.isActive){
			newContent+='<input id="check'+stepInstance.principalAction.id+'" type="checkbox" class="ios-switch actionCheck " onclick=" changeSmallColor(this);" step="'+stepInstance.id+'" checked>'
		}
		else{
			newContent+='<input id="check'+stepInstance.principalAction.id+'" type="checkbox" class="ios-switch actionCheck " onclick=" changeSmallColor(this);" step="'+stepInstance.id+'">'
		}
		newContent+='<div class="switch"></div></label></div>'+ stepInstance.principalAction.getHtml().replace('replaceForCode', message(code:stepInstance.principalAction.action.action.name))+'</div>'
		if(stepInstance.supportActions.size()>0){
			newContent+='<h5><b>'+message(code:'text.supportActions')+':</b></h5>'
		}
		for(ActionStep curSupAction in stepInstance.supportActions.sort{it.execOrder}){
			newContent+='<div style="border-radius: 5px; border: 1px solid #D0D7D9; padding-bottom:5px; padding-right:10px; margin-top:5px"><div class="row" style="margin: 0px 0px 0px 2px;"><div class="col-md-5"><h5><b>'+message(code:curSupAction.action.action.name)+
			'</b></h5></div> <label style="padding-top:6px;" class="pull-right col-md-7">'
			if(curSupAction.isActive){
				newContent+='<input id="check'+curSupAction.id+'" type="checkbox" class="ios-switch actionCheck" onclick="changeActionState(this)" checked >'
			}
			else{
				newContent+='<input id="check'+curSupAction.id+'" type="checkbox" class="ios-switch actionCheck" onclick="changeActionState(this)" >'
			}
			newContent+='<div class="switch"></div></label></div>'+ curSupAction.getHtml().replace('replaceForCode', message(code:curSupAction.action.action.name))+'</div>'
		}
		def rta = [text:newContent, idTd:'td'+stepInstance.id] as JSON
		render rta
		return
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def duplicate(){
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def qty=Integer.valueOf(params.qty)
		def modelCase = Case.get(params.id)
		def order=modelCase.scenario.cases.size()
		for( def i in 1..qty){
			order++
			def newCase = new Case( modelCase.scenario.casePrefix+order, modelCase.description, order,	null, user, modelCase.scenario).save(flush:true, failOnError:true)
			for(CaseStep curStep in modelCase.steps){
				newCase.addToSteps(new CaseStep(curStep,user).save(flush:true, failOnError:true))
			}
		}
		render status:200
		return 
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def delete(){
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def curCase = Case.get(params.id)
		def scenario =  Scenario.get(Long.parseLong(params.scenarioId))

		if(curCase ==null || scenario==null || !(curCase in user.getProjects()*.scenarios*.cases.flatten())){
			render view:'/login/denied'
			return
		}

		def totalPasos = curCase.steps*.id
		for( id in totalPasos){
			
			def actions = ActionStep.findAllByCaseStep(id)*.id
			def curCaseStep  = CaseStep.get(id)
			actions.add(curCaseStep.principalAction.id)
			curCaseStep.save(flush:true, failOnError:true)
			
			curCase.removeFromSteps(curCaseStep)
			curCaseStep.delete(flush:true, failOnError:true)
			for(action in actions){
				ActionStep.get(action)?.delete(flush:true, failOnError:true)
			}
		}

		scenario.removeFromCases(curCase)
		scenario.save(flush:true)
		curCase.delete(flush:true, failOnError:true)
		render status:200
		return 
	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def update(){

		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def curCase = Case.get(params.id)

		if(!curCase || !(curCase in user.getProjects()*.scenarios*.cases.flatten())){
			render view:'/login/denied'
			return
		}
		if(params.errorOriented=="true"){
			println "Lo va a intentar"
			def stepError = Step.get(Long.parseLong(params.stepErrorId))
			if(!stepError){
				render status:400, text:message(code:"text.error.nullStepError")
				return
			}
			curCase.setErrorOriented(true)
			curCase.setErrorStep(stepError)
			println curCase.errorStep.principalAction.action.name
		}
		else{
			curCase.setErrorOriented(false)
			curCase.setErrorStep(null)
		}
		curCase.setName(params.name.trim())
		curCase.setDescription(params.description)
		render status:200

	}

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def masiveDelete(){
		def cases = params.casesToDelete.toString().split(',')
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario =  Scenario.get(Long.parseLong(params.scenarioId))
		for(def i=0;i<cases.size();i++){
			def curCase = Case.get(Integer.parseInt(cases[i]))			
			if(curCase ==null || scenario==null || !(curCase in user.getProjects()*.scenarios*.cases.flatten())){
				render view:'/login/denied'
				return
			}
			def totalPasos = curCase.steps*.id
			for(id in totalPasos){
				curCase.removeFromSteps(CaseStep.get(id))
				CaseStep.get(id).delete(flush:true, failOnError:true)
			}
			scenario.removeFromCases(curCase)
			scenario.save(flush:true)
			curCase.delete(flush:true, failOnError:true)			
		}
		render status:200
		return 
	}


}
