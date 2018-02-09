package com.model

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;


import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;
import com.helpers.*

class ScenarioController {

	def notificationsService
	def springSecurityService

	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
    def index() { 
		def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view='/login/denied'
			return
		}
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def project = Project.get(params.id)

		if(!(project in user.projects)){
			render view:"/login/denied"
			return
		}
		def scenariosAll = project.scenarios.sort{it.dateCreated}
		def webScenarios = []
		def prefix =""
		def scenarios = []
		for (Scenario scenario in scenariosAll){
			if(scenario.enabled)
			scenarios.push(scenario)
		}
		for (Scenario scenario in scenarios){
			prefix+=scenario.casePrefix
			def curS = scenario.id
			for(Step curStep in scenario.steps){
				if(curStep!=null && curStep.isEnabled )
					if(curStep.pType==1){
						webScenarios.push(curS)
						break;
					}
			}
		}
		def functionality35 = Functionality.findByInternalId(35)
		def functionality36 = Functionality.findByInternalId(36)
		def functionality8 = Functionality.findByInternalId(8)
		def functionality9 = Functionality.findByInternalId(9)
		def functionality17 = Functionality.findByInternalId(17)
		def functionality31 = Functionality.findByInternalId(31)


		render view:"index",  model:[associatedProject:project,projectId: project.id, scenarios:scenarios, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), webScenarios:webScenarios, projects:user.getProjects(), browsers:user.getBrowsers(), showPrefix: false, functionality8:functionality8, functionality9:functionality9, functionality17:functionality17, functionality35:functionality35,functionality36:functionality36,functionality31:functionality31]		
		return
    }



    @Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create(){
		def scenarioInstance=null
		def errors=[]
		def scenariosCount = 0
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def project= Project.get(params.id)
		if(project==null){
			render  view:'/login/denied'
			return
		}
		scenarioInstance = new Scenario(params.name.trim(), params.cycle, params.version, user, project, "", Integer.parseInt(params.type), params.uftRoute, "") 
		if (scenarioInstance == null) {
			return
		}
		def flag = false
		for(Scenario scenario in project.scenarios){
			if(scenario.name.toLowerCase().equals(params.name.trim().toString().toLowerCase())){
				flag = true
				break;
			}
		}

		if (!scenarioInstance.validate() || flag ) {

			def errores="<ul>"
			if(flag)
				errores+="<li>"+g.message(code: 'com.model.scenario.name.error.unique', args:[params.name])+"</li>"

			for(error in scenarioInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"
			render status:400, text:errores
			return
		}
		if(user.isDemo()){
			scenariosCount = project.scenarios.size()
			def demoAccount = DemoAccount.findByNameRestriction("Escenarios");
			if(demoAccount){
					if(scenariosCount+1 > demoAccount.valueRestriction){
					render status:403
					return
				}
			}
			
		}
		scenarioInstance.save(flush:true,failOnError:true)
		def action = new Action(GenericAction.findByName('genericAction.open'),1, "").save(flush:true, failOnError:true)
		def newStep = new Step(null,1,action,false, false,true, user, false, false,false,1).save(flush:true, failOnError:true) 
		scenarioInstance.addToSteps(newStep)
		project.addToScenarios(scenarioInstance)
		project.save(flush:true)
		render status:200
		return 
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def update() {
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def scenarioInstance = Scenario.get(params.id)
		if(scenarioInstance ==null  ){
			render status:'400', text:'not found'
			return
		}

		def oldName= scenarioInstance.getName()
		def oldCycle = scenarioInstance.getCycle()
		def oldVersion = scenarioInstance.getAppVersion()
		def oldPrefix = scenarioInstance.getCasePrefix()
		def oldEnabled = scenarioInstance.getEnabled()

		scenarioInstance.setName(params.name.trim());
		scenarioInstance.setCycle(params.cycle)
		scenarioInstance.setAppVersion(params.version)
		scenarioInstance.setCasePrefix(params.prefix)
		scenarioInstance.setEnabled(oldEnabled)
		//scenarioInstance.setEnabled(params.enabled && params.enabled=="true"?true:false)

		def project= Project.get(params.projectId)
		def flag=false

		for(Scenario scenario in project.scenarios){
			if(scenario.name.toLowerCase().equals(params.name.toString().toLowerCase()) && scenario.id != scenarioInstance.id){
				flag=true
				break;
			}
		}

		if (!scenarioInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Scenario scenario in project.scenarios){
				if(scenario.name.toLowerCase().equals(scenarioInstance.name.toString().toLowerCase()) && scenario.id != scenarioInstance.id){
					errores+="<li>"+g.message(code: 'com.model.scenario.name.error.unique', args:[params.name])+"</li>"
					break;
				}
			}



			scenarioInstance.setName(oldName);
			scenarioInstance.setCycle(oldCycle)
			scenarioInstance.setAppVersion(oldVersion)
			scenarioInstance.setCasePrefix(oldPrefix)
			scenarioInstance.setEnabled(oldEnabled)

			for(error in scenarioInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"
			render status:400, text:errores
			return
		}
		scenarioInstance.save(flush:true,failOnError:true)
		render status:200
		return 
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def secureDelete(){
		def scenarioInstance = Scenario.get(params.id)
		if(scenarioInstance==null){
			render status:400, text:'not found'
			return
		}

		if(ExecutionLog.countByAssociatedScenario(scenarioInstance)>0){
			render status:400, text:message( code:'com.model.scenario.notDeletable.error')
			return
		}

		def allCasesSteps =[]

		def ids = scenarioInstance.steps*.id
		println "llega a pasos"
		for(id in ids){
			def stepInstance = Step.get(id)
			def casesSteps = CaseStep.findAllByStep(stepInstance)*.id.collect().flatten()
			allCasesSteps.addAll(casesSteps)
			for(caseStep in casesSteps){
				CaseStep.get(caseStep).delete(flush:true, failOnError:true)
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
		scenarioInstance.removeFromSteps(stepInstance)
		scenarioInstance.save(flush:true, failOnError:true)
		stepInstance.delete(flush:true, failOnError:true)
		}

		ids = scenarioInstance.messages*.id
		println "llega a mensajes"
		for(id in ids){
			def messageInstance = Step.get(id)
			scenarioInstance.removeFromMessages(messageInstance)
			scenarioInstance.save(flush:true, failOnError:true)
			messageInstance.delete(flush:true, failOnError:true)
			
		}

		ids = TXTExtractor.findAllByScenario(scenarioInstance)*.id
		

		println "llega a txtExtractors"
		for(id in ids){
			def txtExtractorInstance = TXTExtractor.get(id)
			scenarioInstance.save(flush:true, failOnError:true)
			txtExtractorInstance.delete(flush:true, failOnError:true)
			
		}

		ids = BDExtractor.findAllByScenario(scenarioInstance)*.id
		println "llega a dbExtractors"
		for(id in ids){
			def bdExtractorInstance = BDExtractor.get(id)
			scenarioInstance.save(flush:true, failOnError:true)
			bdExtractorInstance.delete(flush:true, failOnError:true)
			
		}

		
		redirect (action:'deleteCases',params:[projectId:params.projectId, scenarioInstance:scenarioInstance.id] )
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def disable(){
		def scenarioInstance = Scenario.get(params.id)
		if(scenarioInstance==null){
			render status:400, text:'not found'
			return
		}
		

		scenarioInstance.enabled = false;
		scenarioInstance.save(flush:true, failOnError:true)
		render status:200, text:'done'
		return
	}




	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteCases(){
		def scenarioInstance = Scenario.get(params.scenarioInstance)
		def ids = scenarioInstance.cases*.id
		for(cid in ids){
			def curCase = Case.get(cid)
			scenarioInstance.removeFromCases(curCase)
			scenarioInstance.save(flush:true)
			curCase.delete(flush:true, failOnError:true)
		}

		ids = Generator.findAllByScenario(scenarioInstance)*.id
		for(cid in ids){
			def generator = Generator.get(cid)
			scenarioInstance.save(flush:true)
			generator.delete(flush:true, failOnError:true)
		}

		def project = Project.get(params.projectId)
		project.removeFromScenarios(scenarioInstance)
		scenarioInstance.delete(flush:true)
		render status:200
	}
}
