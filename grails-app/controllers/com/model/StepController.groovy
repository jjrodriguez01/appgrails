package com.model

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;


import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import org.springframework.context.NoSuchMessageException
import grails.converters.JSON
import com.helpers.*

class StepController {


	def notificationsService
	def springSecurityService
	def messageSource


	@Transactional
    @Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario = Scenario.get(params.id)
		if(scenario==null){
			render view:'/login/denied'
			return
		}
		def pages = scenario.project.pages
		def actions = GenericAction.list()
		if(!(scenario in user.getProjects()*.scenarios.flatten())){
			render view:'/login/denied'
			return
		}
		def steps = scenario.steps.sort{it.execOrder}

		def projectId = scenario.project.id
		def scenarios = Project.get(projectId).scenarios

		def isWebScenario = false

		for(Step curStep in scenario.steps){
			if(curStep!=null && curStep.isEnabled )
				if(curStep.pType==1){
					isWebScenario=true;
					break;
				}
		}
		
		def functionality12 = Functionality.findByInternalId(12)
		def functionality13 = Functionality.findByInternalId(13)
		def functionality17 = Functionality.findByInternalId(17)		
		render view:"index",  model:[isWebScenario:isWebScenario, associatedScenario:scenario,steps: steps, scenarioId:scenario.id, pages:pages,actions:actions,scenarios:scenarios, projectId:projectId,notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), browsers:user.getBrowsers(), functionality12:functionality12, functionality13:functionality13, functionality17:functionality17]
	}





	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def createFromObject() {
		def objects = params.objects.toString().split(",")
		def scenario = Scenario.get(params.id);
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		for(String obj in objects){
			def Object curObj = Object.get(Long.parseLong(obj))
			def order=scenario.steps.size()+1
			def action = new Action(curObj.defaultAction, 1,"").save(flush:true, failOnError:true)			
			def newStep= new Step(curObj, order, action, false,false, true, user,false, false,false).save(flush:true, failOnError:true)
			scenario.addToSteps(newStep)
			for(Case curCase in scenario.cases){
				def newCaseStep = new CaseStep( newStep, user, curCase).save(flush:true,failOnError:true)
				curCase.addToSteps(newCaseStep)
				curCase.save(flush:true,failOnError:true)
			}
			scenario.save(flush:true,failOnError:true)
		}
		render status:200
		return
	}





	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def delete( ) {
		def stepInstance = Step.get(params.id)
		if (stepInstance == null) {
			render view:'/login/denied'
			return
		}
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(!(stepInstance in user.getProjects()*.scenarios*.steps.flatten())){
			render view:'/login/denied'
			return
		}
		if(Case.countByErrorStep(stepInstance) > 0){
			render status:400, text:message(code:'text.step.delete.error.stepError')
			return
		}
		Scenario.get(params.scenarioId).removeFromSteps(stepInstance)
		def caseSteps = CaseStep.findAllByStep(stepInstance)
		for(CaseStep caseStep in caseSteps){
			caseStep.myCase.removeFromSteps(caseStep)
			caseStep.delete(flush:true)
		}
		if(BDExtractor.countByFieldsMapLike('%'+stepInstance.id+":%")>0){
			for(BDExtractor extractor in BDExtractor.findAllByFieldsMapLike('%'+stepInstance.id+":%")){
				def originalStr = extractor.fieldsMap
				def index = extractor.fieldsMap.indexOf(stepInstance.id+":")
				if(index==0){
					def isUnique = originalStr.indexOf(';')==originalStr.length()-1?true:false
					if(isUnique){
						BDExtractor.delete(flush:true)
					}
					else{
						def newStr = originalStr.substring(originalStr.indexOf(';')+1)
						extractor.setFieldsMap(newStr)

					}
				}
				else{

					def firstPart = originalStr.substring(0,index-1)
					def leftOver = originalStr.substring(index)
					def secondPart=""
					if(leftOver.contains(';')){
						secondPart = leftOver.substring(leftOver.indexOf(';'))
					}
					extractor.setFieldsMap(firstPart+secondPart)
				}
				extractor.save(flush:true)
			}
		}

		stepInstance.delete(flush:true, failOnError:true)

		render status:200

	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteSteps() {
		def steps = params.stepsToDelete.toString().split(',')
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())		
		for(def i=0;i<steps.size();i++){
			def stepInstance = Step.get(Long.parseLong(steps[i]))
			if (stepInstance == null) {
				render view:'/login/denied'
				return
			}
			if(!(stepInstance in user.getProjects()*.scenarios*.steps.flatten())){
				render view:'/login/denied'
				return
			}
			Scenario.get(params.scenarioId).removeFromSteps(stepInstance)
			def caseSteps = CaseStep.findAllByStep(stepInstance)
			for(CaseStep caseStep in caseSteps){
				caseStep.myCase.removeFromSteps(caseStep)
				caseStep.delete(flush:true)
			}
			if(BDExtractor.countByFieldsMapLike('%'+stepInstance.id+":%")>0){
				for(BDExtractor extractor in BDExtractor.findAllByFieldsMapLike('%'+stepInstance.id+":%")){
					def originalStr = extractor.fieldsMap
					def index = extractor.fieldsMap.indexOf(stepInstance.id+":")
					if(index==0){
						def isUnique = originalStr.indexOf(';')==originalStr.length()-1?true:false
						if(isUnique){
							BDExtractor.delete(flush:true)
						}
						else{
							def newStr = originalStr.substring(originalStr.indexOf(';')+1)
							extractor.setFieldsMap(newStr)
						}
					}
					else{
						def firstPart = originalStr.substring(0,index-1)
						def leftOver = originalStr.substring(index)
						def secondPart=""
						if(leftOver.contains(';')){
							secondPart = leftOver.substring(leftOver.indexOf(';'))
						}
						extractor.setFieldsMap(firstPart+secondPart)
					}
					extractor.save(flush:true)
				}
			}
			stepInstance.delete(flush:true, failOnError:true)
		}
		render status:200
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def update() {
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def editingStep = Step.get(params.id)
		if(params.object!='null' && params.object!=null){
			editingStep.setObject(Object.get(Long.parseLong(params.object)))
		}
		else{
			editingStep.setObject(null)
		}
		def pType = Integer.valueOf(params.pType)
		def isMasive = Boolean.parseBoolean(params.isMasive)
		def isHidden = Boolean.parseBoolean(params.isHidden)
		def mustTakeLocalScreenShot = Boolean.parseBoolean(params.mustTakeLocalScreenShot)
		def forceCoordinates = Boolean.parseBoolean(params.forceCoordinates)
		def principalValue = isMasive?params.principalValue:""
		if(editingStep.principalAction.action.name=='replaceForCode'){
			principalValue = message(code:editingStep.principalAction.action.name)
		}
		def supportValues = isMasive?params.supportValues.toString().split('&&'):""
		def principalAction = new Action(GenericAction.get(Long.parseLong(params.principalAction)), 1,principalValue).save(flush:true)
		editingStep.setPrincipalAction(principalAction)
		editingStep.supportActions.clear()
		def supportActions =params.supportActions.toString().split(",")
		
		if(params.supportActions.toString().length()>0){
			for(def i=0;i<supportActions.size();i++){
				if(isMasive){
					editingStep.addToSupportActions(new Action(GenericAction.get(Long.parseLong(supportActions[i])),i+1,supportValues.size()> i+1?supportValues[i+1]:"").save(flush:true))
					if(supportValues.size()<=i){
						editingStep.addToSupportActions(new Action(GenericAction.get(Long.parseLong(supportActions[i])),i+1,"").save(flush:true))
					}
				}
				else
					editingStep.addToSupportActions(new Action(GenericAction.get(Long.parseLong(supportActions[i])),i+1,"").save(flush:true))
			}
		}
		editingStep.setForceCoordinates(Boolean.parseBoolean(params.forceCoordinates))
		editingStep.setLastUpdater(user)
		editingStep.setMustTakeScreenShot(Boolean.parseBoolean(params.mustTakeScreenShot))
		editingStep.setMustTakeLocalScreenShot(mustTakeLocalScreenShot)
		editingStep.setIsEnabled(Boolean.parseBoolean(params.isEnabled))
		editingStep.setIsMasive(isMasive)
		editingStep.setIsHidden(isHidden)
		editingStep.setpType(pType)


		try{
			editingStep.save(flush:true,failOnError:true)
			def cases = CaseStep.findAllByStep(editingStep)
			for(CaseStep cs in cases){
				cs.supportActions.clear()
				if(editingStep.isMasive){
					cs.principalAction = new ActionStep(editingStep.principalAction,editingStep.principalAction.value).save(flush:true,failOnError:true)
					}
				else{
						if(cs.principalAction.action.action.name == editingStep.principalAction.action.name){
							cs.principalAction = new ActionStep(editingStep.principalAction, cs.principalAction.value).save(flush:true,failOnError:true)
						}
						else{
							cs.principalAction = new ActionStep(editingStep.principalAction, editingStep.principalAction.action.defaultValue).save(flush:true,failOnError:true)
						
						}
					}
				cs.principalAction.caseStep = cs.id
				cs.principalAction.save(flush:true)
				for(Action action in editingStep.supportActions){
					def curSupportAction = new ActionStep(action, "").save(flush:true,failOnError:true)
					curSupportAction.setCaseStep(cs.id)
					cs.addToSupportActions(curSupportAction)
				}
				cs.save(flush:true,failOnError:true)
			}

			def result =["supportActions": editingStep.getSupportActionsByOrder().encodeAsJSON().toString(),"supportValues":editingStep.getSupportActionsValue(), "principalValue":editingStep.principalAction.value]
			render text:result.encodeAsJSON()
			return 
		}catch(Exception e){
			println e.printStackTrace()
			render status:400
		}
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def setEnabled() {
		def step = Step.get(params.id)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		if(step ==null || !(step in user.getProjects()*.scenarios*.steps.flatten())){
			render view:'/login/denied'
			return
		}
		step.setIsEnabled(Boolean.parseBoolean(params.state))
		render status:200
	}




	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create() {

		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenario =Scenario.get(params.id)
		if(scenario==null){
			render view:'/login/denied'
			return 
		}
		def object =null
		if(params.object!='null'){
			object= Object.get(Long.parseLong(params.object))
		}
		def pType = Integer.valueOf(params.pType)
		def order = scenario.steps.size()+1
		def isMasive = Boolean.parseBoolean(params.isMasive)
		def isHidden = Boolean.parseBoolean(params.isHidden)
		def mustTakeScreenShot = Boolean.parseBoolean(params.mustTakeScreenShot)
		def mustTakeLocalScreenShot = Boolean.parseBoolean(params.mustTakeLocalScreenShot)
		def forceCoordinates = Boolean.parseBoolean(params.forceCoordinates)
		def principalValue = isMasive?params.principalValue:""
		def supportValues = isMasive?params.supportValues.toString().split('&&'):""
		def isEnabled = Boolean.parseBoolean(params.isEnabled)

		//This action must be deleted in case on validation errors
		def principalAction = new Action(GenericAction.get(Long.parseLong(params.principalAction)), 1,principalValue).save(flush:true)
		
		def stepInstance = new Step(object, order,  principalAction,mustTakeScreenShot, mustTakeLocalScreenShot, isEnabled, user, isMasive,  isHidden, forceCoordinates, pType)
		if(!stepInstance.validate()){
			def errores="<ul>"
			
			for(error in stepInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			principalAction.delete(flush:true)
			errores+="</ul>"
			render status:400, text:errores
			return
		}


		def supportActions =params.supportActions.toString().split(",")
		
		if(params.supportActions.toString().length()>0){
			for(def i=0;i<supportActions.size();i++){
				if(isMasive)
					stepInstance.addToSupportActions(new Action(GenericAction.get(Long.parseLong(supportActions[i])),i+1,supportValues[i+1]).save(flush:true))
				else
					stepInstance.addToSupportActions(new Action(GenericAction.get(Long.parseLong(supportActions[i])),i+1,"").save(flush:true))
			}
		}

		try{
			stepInstance.save(flush:true,failOnError:true)
			scenario.addToSteps(stepInstance)
			scenario.save(flush:true)
			def cases = scenario.cases
			for(Case curCase in cases){
				curCase.addToSteps(new CaseStep(stepInstance, user,  curCase).save(flush:true,failOnError:true))
			}
			render status:200
			return
		}catch(Exception e){
			println e.printStackTrace()
			render status:400
		}
	}





	@Transactional
	@Secured(['permitAll'])
	def findMessage(){
		def message=params.name
		try{
			message=messageSource.getMessage(params.name,null,RequestContextUtils.getLocale(request))
		}
		catch(NoSuchMessageException nsme){
			message=params.name
		}
		render  message
	}



	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	@Transactional
	def saveOrder(){
		try{
			def order= params.order.split(",")
			def scenario = Scenario.get(params.id)
			scenario.steps.clear()
			for(def i=0;i<order.size();i++){
				def curStep= Step.get(Long.parseLong(order[i]))
				curStep.setExecOrder(i+1)
				scenario.addToSteps(curStep)
			}
			scenario.save(flush:true)
			render status:200
			return
		}catch(Exception e){
			e.printStackTrace()
			render status:400
		}

	}
}