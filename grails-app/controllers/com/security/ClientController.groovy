package com.security

import com.helpers.*
import grails.converters.JSON

import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional
import com.model.*

import groovy.json.JsonSlurper
import java.awt.Image
import java.awt.image.BufferedImage

import java.awt.Graphics2D
import javax.imageio.ImageIO;
import javax.imageio.ImageReader
import javax.imageio.stream.ImageInputStream
import javax.imageio.ImageReadParam

import org.springframework.web.servlet.support.RequestContextUtils

import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date

import javax.imageio.ImageIO;
import java.io.File
import java.io.ByteArrayOutputStream
import java.awt.image.BufferedImage

import java.net.URL

import java.security.*;
import java.math.*;


@Secured('permitAll')
class ClientController {
	def springSecurityService
	def sessionManagerService
	def notificationsService
	def generatorService


	//Autenticación desde cliente
	@Transactional
	def auth(){
		def passwordEnconder = springSecurityService.passwordEncoder
		def username=params.username.toLowerCase()
		def password=params.password

		def user=User.findByUsername(username)
		if(user==null){
			render status:400
			return
		}


		if(!passwordEnconder.isPasswordValid(user.getPassword(),password,null)){
			render status:400;
			return;
		}

		def oldToken = Token.findByUsernameAndType(username,3)
		if(oldToken!=null){
			oldToken.delete(flush:true)
		}
		def token= new Token(username,3).save(flush:true)

		user.setLastDesktopAction(new Date())
		user.save(flush:true)
		def response=[token:token.getToken(), fullname:user.fullname, avatarFile:user.getAvatarFile(), plan:user.plan]
		render text:(response as JSON), contentType:"text/json"
		return
	}

	//Petición desde cliente para conseguir los navegadores compatibles
	@Transactional
	def getCompatibleBrowsers(){
		println params

		def tokenObject= Token.findByTokenAndType(params.token,3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		if(!user){
			render status:401
			return
		}

		def browsers = Resource.findByName("browsers")
		//println "Browsers: "+browsers.getUrl()
		if(browsers && browsers.state){
			render browsers.getUrl()
		} else {
			println "Found no resources"
			render status:404
			return
		}
		return
	}

	//Verifica que la cuenta exista, se usa en el proceso de instalación
	def verifyAccount(){
		def passwordEnconder = springSecurityService.passwordEncoder
		def username=params.data1.toLowerCase()
		def password=params.data2

		def user=User.findByUsername(username)
		if(user==null){
			render status:400
			return
		}

		if(!passwordEnconder.isPasswordValid(user.getPassword(),password,null)){
			println "password not valid"
			render status:400;
			return;
		}
		def downloader = Resource.findByName("downloader")
		if(downloader.state){
			render downloader.getUrl()
		} else {
			println "Found no resources"
			render status:404
			return
		}
		return
	}

	//Capta la respuesta de la prueba de conexión a la base de datos desde extractores
	@Transactional
	def responseDbConnection(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def json = jsonSlurper.parseText(params.json)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		if(!user){
			render status:401
			return
		}

		def alert = Alert.get(Long.parseLong(json.alertId))
		def request = Request.findByAssociatedAlertAndTypeAndUser(alert, 1, user)
		if(!request){
			render status:400
			return
		}
		if(request.pending){
			request.setResponse(json.state)
			request.setPending(false)
			request.save(flush:true)
		}
		render status:200
		return
	}

	//Error en la extracción en la base de datos
	@Transactional
	def responseDbExtractionError(){
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def alert = Alert.get(Long.parseLong(params.alertId))
		def request = Request.findByAssociatedAlertAndTypeAndUser(alert, 2, user)
		request.setResponse("ERROR: "+params.error)
		request.setPending(false)
		request.save(flush:true)
		render status:200
	}

	//Retorna los valores de la extracción para ponerlos en los casos de prueba antes de la ejecución
	@Transactional
	def responseDbExtraction(){
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def json = jsonSlurper.parseText(params.json)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def alert = Alert.get(Long.parseLong(json.alertId))
		def request = Request.findByAssociatedAlertAndTypeAndUser(alert, 2, user)
		def scenario = Scenario.get(Long.parseLong(json.scenarioId))
		if(!request){
			//Hay mas extractores asociados al scenario
			def curExtractor = BDExtractor.get(Long.parseLong(json.extractorId))
			if(curExtractor){
				def cases = curExtractor.cases.split(',')
				if(curExtractor.cases =="ALL"){
					cases =""
					for(Case cCase in curExtractor.scenario.cases){
						cases+=cCase.name+","
					}
				}
				cases = cases.split(',')
				
				def splittedFieldMap = curExtractor.fieldsMap.split(';')
				def stepIds =[]
				def casesCount = 0
				for(String map in splittedFieldMap){
					stepIds.push(map.substring(0,map.indexOf(':')))
				}

				def notAplicableCases=[]
				for(Case curCase in scenarioToExecute.cases){
					def curCounter=0
					for(String stepId in stepIds){
						def curStep = Step.get(Long.parseLong(stepId))
						def curCaseStep =CaseStep.findByMyCaseAndStep(curCase, curStep)
						if(!curCaseStep.principalAction.isActive || !curStep.isEnabled){
							curCounter++;
						} 
					}
					if(curCounter==stepIds.size()){
						cases.remove(curCase.id)
					}
				}

				for(String name in cases){
					def values = json.extraction[casesCount].split('#;#')
					def curCase = Case.findByNameAndScenario(name, scenario)
					def stepCount =0
					for(String stepId in stepIds){
						def curStep = Step.get(Long.parseLong(stepId))
						def curCaseStep = CaseStep.findByMyCaseAndStep(curCase, curStep)
						if(curCaseStep.principalAction.isActive && curStep.isEnabled){
							curCaseStep.principalAction.value=values[stepCount]
							curCaseStep.save(flush:true)
						}
						stepCount++
						if(stepCount>=stepIds.size())
							break;
					}
					casesCount++;
					if(casesCount>=cases.size())
						break;
				}
			}


			if(curExtractor.burnedData==""){
				curExtractor.burnedData+=json.burnedData
			}
			else{
				curExtractor.burnedData+=","+json.burnedData
			}
			curExtractor.save(flush:true)
			alert.delete(flush:true, failOnError:true)
			render status:200
			return
		}

		if(request.pending){
			def curExtractor = BDExtractor.get(Long.parseLong(json.extractorId))
			if(curExtractor){
				def cases = curExtractor.cases.split(',')
				if(curExtractor.cases =="ALL"){
					cases =""
					for(Case cCase in curExtractor.scenario.cases){
						cases+=cCase.name+","
					}
				}
				if(curExtractor.cases =="ALL"){
					cases = cases.split(',')
				}
				
				
				def splittedFieldMap = curExtractor.fieldsMap.split(';')
				def stepIds =[]
				def casesCount = 0
				for(String map in splittedFieldMap){
					stepIds.push(map.substring(0,map.indexOf(':')))
				}
				for(String name in cases){
					def flag=false
					if(casesCount>=cases.size())
						break;
					def values = json.extraction[casesCount].split('#;#')
					def curCase = Case.findByNameAndScenario(name, scenario)
					def stepCount =0
					for(String stepId in stepIds){
						if(stepCount>=stepIds.size())
							break;
						def curStep = Step.get(Long.parseLong(stepId))
						def curCaseStep = CaseStep.findByMyCaseAndStep(curCase, curStep)
						if(curCaseStep.principalAction.isActive && curStep.isEnabled && curCase.isEnabled){
							curCaseStep.principalAction.value=values[stepCount]
							curCaseStep.save(flush:true)
							flag=true
						}
						stepCount++
					}
					if(flag)
						casesCount++;

				}
			}
			if(curExtractor.burnedData==""){
				curExtractor.burnedData+=json.burnedData
			}
			else{
				curExtractor.burnedData+=","+json.burnedData
			}
			curExtractor.save(flush:true)
			def execution = Execution.get(Long.parseLong(request.response))
			execution.setState(1)
			request.setPending(false)
			request.save(flush:true)
		}
		render status:200
		return
	}

	//Recibe los objetos de tipo THUNDER que se suban al stage
	@Transactional
	def uploadObjects(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def json = jsonSlurper.parseText(params.json)
		def objetos = json.objects
		def uuid
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		for(int i=0;i<objetos.size();i++){
			def target=objetos[i].get('allTarget');
			def action =  GenericAction.findByName("genericAction.click");
			if(objetos[i].get('command').toLowerCase().startsWith('type')){
				action = GenericAction.findByName("genericAction.write");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('click')){
				action = GenericAction.findByName("genericAction.click");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('wait')){
				action = GenericAction.findByName("genericAction.wait");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('check')){
				action = GenericAction.findByName("genericAction.check");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('contextmenu')){
				action = GenericAction.findByName("genericAction.rigthClick");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('doubleclick')){
				action = GenericAction.findByName("genericAction.doubleClick");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('goback')){
				action = GenericAction.findByName("genericAction.goBack");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('focus')){
				action = GenericAction.findByName("genericAction.hover");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('select')){
				action = GenericAction.findByName("genericAction.select");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('draganddrop')){
				action = GenericAction.findByName("genericAction.dragAndDrop");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('verifyValue')){
				action = GenericAction.findByName("genericAction.verifyValue");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('verifyValue')){
				action = GenericAction.findByName("genericAction.verifyValue");
			}
			def newObject = new com.model.Object(target, objetos[i].get('nameObject'), objetos[i].get('image'), Integer.parseInt(objetos[i].get('x')), Integer.parseInt(objetos[i].get('y')), user, Integer.parseInt(objetos[i].get('class')), String.valueOf(json.nameTC), action, objetos[i].get('hash'),user.associatedClient,null)
			newObject.save(flush:true,failOnError:true)
		}

		if(json.notification.equals('true'))
		def alert= new Alert("notification.objects.uploaded", user, 3, "fa-check", "green", "").save(flush:true, failOnError:true)
		render status:200
	}

	//Recibe objetos y gherkin para generar todo el script de ejecución incluyendo casos y pasos
	@Transactional
	def uploadObjectsAndGherkin(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3) 
		def user
		def json = jsonSlurper.parseText(params.json)
		def objetos = json.objects
		def gherkin = json.gherkin
		def String[] bytes
		def uuid

		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}

		//creación del proyecto y de la página
		def project = Project.findByNameAndCreator(gherkin.name,user)
		if(!project){
			project = new Project(gherkin.name, gherkin.description, user).save(flush:true, failOnError:true)
			user.addToProjects(project)
		}
		def page = Page.findByNameAndCreator(gherkin.name,user)
		if(!page){
			page = new Page(gherkin.name, gherkin.name , false, user).save(flush:true, failOnError:true)
			project.addToPages(page)
		}
		def scenarios = gherkin.scenarios


		for(int i=0;i<objetos.size();i++){
			def target=objetos[i].get('allTarget');

			def action =  GenericAction.findByName("genericAction.click");

			if(objetos[i].get('command').toLowerCase().startsWith('type')){
				action = GenericAction.findByName("genericAction.write");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('click')){
				action = GenericAction.findByName("genericAction.click");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('wait')){
				action = GenericAction.findByName("genericAction.wait");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('check')){
				action = GenericAction.findByName("genericAction.check");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('contextmenu')){
				action = GenericAction.findByName("genericAction.rigthClick");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('doubleclick')){
				action = GenericAction.findByName("genericAction.doubleClick");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('goback')){
				action = GenericAction.findByName("genericAction.goBack");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('focus')){
				action = GenericAction.findByName("genericAction.hover");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('select')){
				action = GenericAction.findByName("genericAction.select");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('draganddrop')){
				action = GenericAction.findByName("genericAction.dragAndDrop");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('verifyValue')){
				action = GenericAction.findByName("genericAction.verifyValue");
			}
			else if(objetos[i].get('command').toLowerCase().startsWith('verifyValue')){
				action = GenericAction.findByName("genericAction.verifyValue");
			}
			def newObject = new com.model.Object(target, objetos[i].get('nameObject'), objetos[i].get('image'), Integer.parseInt(objetos[i].get('x')), Integer.parseInt(objetos[i].get('y')), user, Integer.parseInt(objetos[i].get('class')), String.valueOf(json.nameTC), action, objetos[i].get('hash'),user.associatedClient,page)
			newObject.save(flush:true,failOnError:true)
		}



		if(json.notification.equals('true')){

			def alert= new Alert("notification.objects.uploaded", user, 3, "fa-check", "green", "").save(flush:true, failOnError:true)
			def scenario 
			for(int i=0; i<scenarios.size();i++){
				scenario = new Scenario(scenarios[i].name, "1", "1.0", user, project, "").save(flush:true, failOnError:true)
				def steps = scenarios[i].steps
				for(int j=0;j<steps.size();j++){
					def curStep =null
					if(j==0){
						if(steps[j].object=="" && isURL(steps[j].value)){
							 curStep= new Step(null,j+1, new Action(GenericAction.findByName('genericAction.open'), 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false,1).save(flush:true, failOnError:true)
						}
						else if(steps[j].object==""){

						}
						else{
							def object = Object.findByNameIlikeAndPage(steps[j].object,page)
							if(object){
								 curStep= new Step(object,j+1, new Action(object.defaultAction, 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false).save(flush:true, failOnError:true)
							}
						}
					}
					else if(j==steps.size()-1){
						if(steps[j].object=="" && isURL(steps[j].value)){
							 curStep= new Step(null,j+1, new Action(GenericAction.findByName('genericAction.open'), 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false,1).save(flush:true, failOnError:true)
						}
						else if(steps[j].object==""){

						}
						else{
							def object = Object.findByNameIlikeAndPage(steps[j].object,page)
							if(object){
								if(steps[j].value=="")
								 	curStep= new Step(object,j+1, new Action(object.defaultAction, 1, object.defaultAction.defaultValue).save(flush:true, failOnError:true), false, false, true, user, false, false, false).save(flush:true, failOnError:true)
								else
									curStep= new Step(object,j+1, new Action(object.defaultAction, 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false).save(flush:true, failOnError:true)
								

							}	
						}
					}
					else{
						if(steps[j].object==""){
							curStep= new Step(null,j+1, new Action(GenericAction.findByName('genericAction.open'), 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false,1).save(flush:true, failOnError:true)
						}
						else if(steps[j].value==""){
							def object = Object.findByNameIlikeAndPage(steps[j].object,page)
							if(object)
								curStep= new Step(object,j+1, new Action(object.defaultAction, 1, object.defaultAction.defaultValue).save(flush:true, failOnError:true), false, false, true, user, false, false, false).save(flush:true, failOnError:true)
						
						}
						else{
							def object = Object.findByNameIlikeAndPage(steps[j].object,page)
							if(object)
								curStep= new Step(object,j+1, new Action(object.defaultAction, 1, steps[j].value).save(flush:true, failOnError:true), false, false, true, user, false, false, false).save(flush:true, failOnError:true)
						
						}

					}
					if(curStep)
						scenario.addToSteps(curStep)
				}
				def order = (int)Case.countByScenario(scenario)
				order++
				def caseInstance = new Case(scenario.casePrefix+order, scenario.casePrefix+order , order,null,user,scenario).save(flush:true, failOnError:true)
				for(Step currentStep in scenario.steps){
					def curCaseStep = new CaseStep(currentStep, user, caseInstance, true).save(flush:true, failOnError:true)
					caseInstance.addToSteps(curCaseStep)
				}
				caseInstance.save(flush:true)
				scenario.addToCases(caseInstance)
				scenario.save(flush:true, failOnError:true)
				project.addToScenarios(scenario)
			}
			
		}
		



		render status:200
	}

	//Método de validación de URLS
	def boolean isURL(String someString) {
	   try { 
	      new URL(someString)
	   } catch (MalformedURLException e) {
	      false
	   }
	}

	//Deprecated: Convierte un arreglño de bytes en una imagen y la almacena
	@Transactional
	def boolean bytesToImage( bytes, rutaSalida,uuid) {
		boolean salida = true;
		try {
			ByteArrayInputStream bis = new ByteArrayInputStream(bytes);
			Iterator<?> readers = ImageIO.getImageReadersByFormatName("png");
			ImageReader reader = (ImageReader) readers.next();
			java.lang.Object source = bis;
			ImageInputStream iis = ImageIO.createImageInputStream(source);
			reader.setInput(iis, true);
			ImageReadParam param = reader.getDefaultReadParam();
			Image image = reader.readAll(0, param).image
			BufferedImage bufferedImage = new BufferedImage(image.getWidth(null), image.getHeight(null), BufferedImage.TYPE_INT_RGB);
			Graphics2D g2 = bufferedImage.createGraphics();
			g2.drawImage(image, null, null);
			File imageFile = new File(rutaSalida+"/"+uuid);
		//	println "BufferedImage: "+bufferedImage+",  imageFile: "+imageFile
			ImageIO.write(bufferedImage, "png", imageFile);
			} catch (IOException ex) {
				//ex.printStackTrace()
				//System.out.println(ex.getMessage());
				//salida=false
			}
			return salida;
		}



		@Transactional
		def logout(){
			def tokenObject= Token.findByTokenAndType(params.token,3)
			def user
			if(tokenObject!=null){
				user= User.findByUsername(tokenObject.getUsername())
			}
			else{
				render status:401
				return
			}
			
			tokenObject.delete(flush:true)
			sessionManagerService.desktopLogout(user.getUsername())
			render status:200
			return
		}


		def getNotifications(){
			
			def locale = RequestContextUtils.getLocale(request)
			def tokenObject= Token.findByTokenAndType(params.token, 3)
			def user
			if(tokenObject!=null){
				user= User.findByUsername(tokenObject.getUsername())
			}
			else{
				render status:401
				return
			}
			def answer = notificationsService.getNotifications(user,locale, request.getSession(),1)
			user.setLastDesktopAction(new Date())
			user.save(flush:true)
			render text:(answer as JSON), contentType: "text/json"

		}




		@Transactional
		def setAlertsViewed(){
			def tokenObject= Token.findByTokenAndType(params.token,3)
			def user
			if(tokenObject!=null){
				user= User.findByUsername(tokenObject.getUsername())
			}
			else{
				render status:401
				return
			}
			
			def ids = params.ids.split(",")
			for(String st in ids){
				if(st!=""){
					def curAlert = Alert.get(Long.parseLong(st))
					if(curAlert!=null){
						curAlert.setViewed(true)
						curAlert.save(flush:true)
					}
				}
			}
			render status:200
		}



		def sync(){
			def tokenObject= Token.findByTokenAndType(params.token,3)
			def user
			if(tokenObject!=null){
				user= User.findByUsername(tokenObject.getUsername())
			}
			else{
				render status:401
				return
			}

			def projects=["count":user.getProjects().size()]
			def allProjects =[]
			//Sin UFT y RFT
			for(Project project in user.getProjects()){
				def curProject = ["name":project.name, "id":project.id]
				def scenarios =[]
				for(Scenario scenario in project.scenarios.findAll{it.type == 1}){
					def curScenario=["name": scenario.name, "id":scenario.id]
					def objects =[]
					for(Step myStep in scenario.steps.sort{it.execOrder}){
						if(myStep.object !=null)
							if(myStep.object.imageHash!="noHash"){
								def curObj =["name":myStep.object.name,"image":myStep.object.imageUrl, "hash":myStep.object.imageHash, "id":myStep.object.id,"type":myStep.object.pType, "allTargets": myStep.object.allTargets, "x": myStep.object.xCordinate, "y": myStep.object.yCordinate]
								objects.push(curObj)
							}
					}
					curScenario.objects = objects
					scenarios.push(curScenario)
				}
				curProject.scenarios = scenarios
				allProjects.push(curProject)
			}
			projects.projects = allProjects
			render projects as JSON
		}

	//Envia datos necesarios para la sincronización de UFT al cliente
	def uftSync(){
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def uftProjects = []
		def uftPages = user.getProjects()*.getPages()*.objects.flatten().findAll{it.pType==4}*.page.flatten()
		for(page in uftPages){
			def projects = ProjectPage.findAllByPage(page)*.project.flatten()
			for(project in projects){
				uftProjects.push(project)
			}
		}
		uftProjects = uftProjects.unique()
		println uftProjects
		def projects=["count":uftProjects.size()]
		def allProjects =[]		
		for(Project project in uftProjects){
			def curProject = ["name":project.name, "id":project.id]
			def pages =[]
			for(Page page in project.getPages()){
				def curPage=["name": page.name, "id":page.id]
				def objects =[]
				for(Object object in page.objects.findAll{!it.autoGenerated}){
					if(object){
						def curObj =["name":object.name, "id":object.id,"type":object.pType, "allTargets": object.allTargets, "x": object.xCordinate, "y": object.yCordinate]
						objects.push(curObj)
					}
				}
				curPage.objects = objects
				pages.push(curPage)
			}
			curProject.pages = pages
			allProjects.push(curProject)
		}
		projects.projects = allProjects
		render projects as JSON
	}

	//Envia una imagen como un arreglo de bytes al cliente
	def getImage(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def obj = Object.get(params.id)
		if(obj==null){
			render status:400, text:"Object not found"
			return
		}
		def conf = springSecurityService.securityConfig
		String imagesDir= conf.imagesDir
		String image  = obj.imageUrl 

		if(image!="")
		{
			File imageFile =new File(imagesDir+image);
			BufferedImage originalImage=ImageIO.read(imageFile);
			ByteArrayOutputStream baos=new ByteArrayOutputStream();
			ImageIO.write(originalImage, "png", baos );
			byte[] imageInByte=baos.toByteArray();
			StringBuilder sb = new StringBuilder("");
			for(def i=0;i<imageInByte.length;i++){
				sb.append(imageInByte[i]).append(",")
			}
			sb.setLength(sb.length()-1);
			def bytes= ["bytes":sb.toString()]
			render bytes as JSON
		}
	}

	//Actualiza la referencia de imagen de objetos especificos 
	@Transactional
	def updateImages(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def  json = jsonSlurper.parseText(params.joPendientes)
		def objetos = json.Objects
		def uuid
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		for(int i=0;i<objetos.size();i++){
			def currentObject = Object.get(Long.parseLong(objetos[i].id.toString()))
			if(currentObject!=null){
				def conf = springSecurityService.securityConfig
				uuid =currentObject.imageUrl
				currentObject.imageHash = objetos[i].get("hash")
				currentObject.imageUrl = objetos[i].get("uuid") 
				currentObject.save(flush:true,failOnError:true)
			}
		}
		render status:200
	}

	//Actualiza objetos de tipo THUNDER
	@Transactional
	def updateObjects(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		def jsonSlurper = new JsonSlurper()
		def json = jsonSlurper.parseText(params.joPendientes)
		def objetos = json.Objects
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		for(int i=0;i<objetos.size();i++){
			def currentObject = Object.get(Long.parseLong(objetos[i].id.toString()))
			if(currentObject!=null){
				currentObject.setName(objetos[i].get("name"))
				currentObject.setxCordinate(Integer.parseInt(objetos[i].get("x")))
				currentObject.setyCordinate(Integer.parseInt(objetos[i].get("y")))
				currentObject.setAllTargets(objetos[i].get("allTargets"))
				currentObject.save(flush:true)
			}

		}
		render status:200
	}

	//Le dice al cliente si hay o no algo pendiente para él
	def isSomethingForMe(){
		def tokenObject= Token.findByTokenAndType(params.token,3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}

		def criteria=Execution.createCriteria()
		def Calendar now = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
		now.add(Calendar.MINUTE, 1);
		def Date nowPlus1=now.getTime()
		now.add(Calendar.MINUTE,-2);
		def Date nowMinus1=now.getTime()
		def programmedExecutions = criteria.list{
			eq('target',user)
			eq('isProgrammed', true)
			between('executionDate',nowMinus1,nowPlus1)
			eq('state',1)
		}
		def criteria1=Execution.createCriteria()
		def executions = criteria1.list{
			eq('target', user)
			eq('isProgrammed', false)
			eq('state',1)
		}
		def executionsToDelete=Execution.findAllByTargetAndState(user,3);
		for(Execution execution in executionsToDelete){
			execution.delete(flush:true)
		}

		if(executions.size()>0 || programmedExecutions.size()>0){
			render "yes"
			return
		}
		render "No"
		return
	}

	//Envia al cliente los datos necesarios para la ejecución que está pendiente
	def whatIsForMe(){
		def locale= new Locale("es")
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def Calendar now = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
		now.add(Calendar.MINUTE, 1);
		def Date nowPlus1=now.getTime()
		now.add(Calendar.MINUTE,-2);
		//def Date nowMinus1=now.getTime()

		def criteria = Execution.createCriteria();
		def criteria1 = Execution.createCriteria();
		def programmedExecutions = criteria.list{
			eq('target',user)
			between('executionDate', now.getTime(),nowPlus1)
			eq('state',1)
			eq('isProgrammed', true)
			order('dateCreated','asc')
		}
		def executions = criteria1.list{
			eq('target', user)
			eq('isProgrammed', false)
			eq('state',1)
			order('dateCreated','asc')
		}
		def finalExecutions=[]
		def result =["executionsCount":1]
		if(programmedExecutions.size()>0){
			def Execution execution=programmedExecutions.get(0);
			def splittedCases = execution.cases.split(',')
			def usedCases =[]
			def exec=[dateCreated:execution.dateCreated, id:execution.id, executorId:execution.creator.id, executor: execution.creator.fullname]
			def finalScenarios=[]

			def scenariosToExecute =[]
			def allScenarios=[execution.scenarioToExecute]
			for(Scenario scenario in allScenarios){
				scenariosToExecute.add(scenario)
			}
			exec.scenariosCount=scenariosToExecute.size()
			for(Scenario scenario in scenariosToExecute.sort{it.dateCreated}){
				exec.projectName = scenario.project.name
				exec.projectId = scenario.project.id
				def casesCount =0;
				for(Case ca in scenario.cases.sort{it.execOrder}){
					if(ca.isEnabled && ca.name in splittedCases)
						casesCount++
				}
				def curScenario=[name:scenario.name, testCasesCount: casesCount, cycle:scenario.cycle, version:scenario.getAppVersion(), id:scenario.id, browsers:execution.browsers, type:scenario.type, pathUFT:scenario.uftPath, pathRFT:scenario.rftPath]
				def testCases=[]

				for(Case caseInstance in scenario.cases.sort{it.execOrder}){
					if((caseInstance.name in splittedCases || execution.cases=="") && !(caseInstance.name in usedCases)){
						usedCases.push(caseInstance.name)
						def casoJson=[ID:String.valueOf(caseInstance.id), name:caseInstance.name, errorOriented:caseInstance.errorOriented?"true":"false", idErrorStep:caseInstance.errorStep?String.valueOf(caseInstance.errorStep.id):"" ]
						def steps=[]
						for(CaseStep caseStepInstance in caseInstance.steps.sort{it.step.execOrder}){
							if(caseStepInstance.step.isEnabled){
								if(caseStepInstance.principalAction.isActive){
									def caseToAdd
									if(caseStepInstance.object == null)
										caseToAdd=[object:"",image:"",screenshot:caseStepInstance.step.mustTakeScreenShot,localScreenshot:caseStepInstance.step.mustTakeLocalScreenShot,key:"",  pType:caseStepInstance.step.pType,x:0, y:0, forceCoordinates:false]
									else
										caseToAdd=[object:caseStepInstance.object.name,image:caseStepInstance.object.imageUrl,screenshot:caseStepInstance.step.mustTakeScreenShot,localScreenshot:caseStepInstance.step.mustTakeLocalScreenShot,key:caseStepInstance.object.allTargets,pType:caseStepInstance.step.pType,x:caseStepInstance.object.xCordinate, y:caseStepInstance.object.yCordinate,forceCoordinates:caseStepInstance.step.forceCoordinates]

									def actions=[]
									def actionInstance
									if(caseStepInstance.principalAction.isActive)
									{
										actionInstance=[name:g.message(code:caseStepInstance.principalAction.action.action.name , locale:locale), value:caseStepInstance.principalAction.value.replaceAll('#;#','')]
										actions.add(actionInstance)
									}
									for(ActionStep action in caseStepInstance.supportActions){
										if(action.isActive){
											actionInstance=[name:g.message(code:action.action.action.name , locale:locale), value:action.value.replaceAll('#;#','')]
											actions.add(actionInstance)
										}
									}
									caseToAdd.id = caseStepInstance.step.id

									def aplicableMessages = scenario.messages.findAll{it.scope=="ALL"}
									def aplicableMessagesNonFullScope = scenario.messages.findAll{it.scope!="ALL" && it.scope.split('#')[0]<=caseStepInstance.step.execOrder && it.scope.split('#')[1]>=caseStepInstance.step.execOrder}
									
									aplicableMessages.addAll(aplicableMessagesNonFullScope);
									caseToAdd.messages=aplicableMessages;
									caseToAdd.actions=actions;
									steps.add(caseToAdd)
								}
							}
							casoJson.steps=steps
						}
						testCases.add(casoJson)
					}
				}
				curScenario.cases=testCases
				finalScenarios.add(curScenario)
			}
			exec.scenarios=finalScenarios
			finalExecutions.add(exec)
			result.executions = finalExecutions
			execution.state=2
			execution.save(flush:true,failOnError:true)
			render result as JSON
			return
		}
		else if(executions.size()>0){
			def Execution execution=executions.get(0);
			def exec=[dateCreated:execution.dateCreated, id:execution.id, , executorId:execution.creator.id, executor:execution.creator.fullname]
			def finalScenarios=[]
			def scenariosToExecute =[]
			def allScenarios=[execution.scenarioToExecute]
			for(Scenario scenario in allScenarios){
				scenariosToExecute.add(scenario)
			}
			exec.scenariosCount=scenariosToExecute.size()
			for(Scenario scenario in scenariosToExecute.sort{it.dateCreated}){
				exec.projectName = scenario.project.name
				exec.projectId = scenario.project.id
				def casesCount =0;
				for(Case ca in scenario.cases.sort{it.execOrder}){
					if(ca.isEnabled )
						casesCount++
				}
				def curScenario=[name:scenario.name, testCasesCount: casesCount, cycle:scenario.cycle, version:scenario.getAppVersion(),  id:scenario.id, browsers:execution.browsers, type:scenario.type, pathUFT:scenario.uftPath, pathRFT:scenario.rftPath]
				def testCases=[]
				println 'Despues de curScenario'
				for(Case caseInstance in scenario.cases.sort{it.execOrder}){
						if(caseInstance.isEnabled){
							def casoJson=[ID:String.valueOf(caseInstance.id), name:caseInstance.name, errorOriented:caseInstance.errorOriented?"true":"false", idErrorStep:caseInstance.errorStep?String.valueOf(caseInstance.errorStep.id):"" ]
							def steps=[]
							for(CaseStep caseStepInstance in caseInstance.steps.sort{it.step.execOrder}){
								if(caseStepInstance.step.isEnabled){
									if(caseStepInstance.principalAction.isActive){
										def caseToAdd
										if(caseStepInstance.object == null)
											caseToAdd=[object:"",image:"",screenshot:caseStepInstance.step.mustTakeScreenShot,localScreenshot:caseStepInstance.step.mustTakeLocalScreenShot,key:"",  pType:caseStepInstance.step.pType,x:0, y:0, forceCoordinates:false]
										else
											caseToAdd=[object:caseStepInstance.object.name,image:caseStepInstance.object.imageUrl,screenshot:caseStepInstance.step.mustTakeScreenShot,localScreenshot:caseStepInstance.step.mustTakeLocalScreenShot,key:caseStepInstance.object.allTargets,pType:caseStepInstance.step.pType,x:caseStepInstance.object.xCordinate, y:caseStepInstance.object.yCordinate,forceCoordinates:caseStepInstance.step.forceCoordinates]
										def actions=[]
										def actionInstance
										if(caseStepInstance.principalAction.isActive)
										{
											actionInstance=[name:g.message(code:caseStepInstance.principalAction.action.action.name , locale:locale), value:caseStepInstance.principalAction.value.replaceAll('#;#','')]
											actions.add(actionInstance)
										}
										for(ActionStep action in caseStepInstance.supportActions){
											if(action.isActive){
												actionInstance=[name:g.message(code:action.action.action.name , locale:locale), value:action.value.replaceAll('#;#','')]
												actions.add(actionInstance)
											}
										}

										caseToAdd.id = caseStepInstance.step.id
										def aplicableMessages = scenario.messages.findAll{it.scope=="ALL"}

										def aplicableMessagesNonFullScope = scenario.messages.findAll{it.scope!="ALL" && Integer.parseInt(it.scope.split('#')[0])<=caseStepInstance.step.execOrder && Integer.parseInt(it.scope.split('#')[1])>=caseStepInstance.step.execOrder}
										aplicableMessages.addAll(aplicableMessagesNonFullScope);
										
										caseToAdd.messages=aplicableMessages;
										caseToAdd.actions=actions;
										steps.add(caseToAdd)
									}
								}
								casoJson.steps=steps
							}
							testCases.add(casoJson)
						
					}
				}
				curScenario.cases=testCases
				finalScenarios.add(curScenario)
			}
			exec.scenarios=finalScenarios
			finalExecutions.add(exec)
			result.executions = finalExecutions
			execution.state=2
			println 'Antes de enviar el JSON  de Ejecucion'
			execution.save(flush:true,failOnError:true)
			render result as JSON
			return
		}
		else{
			render:200
			return
		}
	}

	//Guarda logs de ejecución enviados desde el cliente
	@Transactional
	def saveLog(){
		def DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def jsonSlurper = new JsonSlurper()
		def json = jsonSlurper.parseText(params.json)
		def executionLogs = json.executionLog
		def caseLogs = json.caseLogs
		def stepLogs = json.stepLogs
		
		for(executionLog in executionLogs){
			def project = Scenario.get(Long.parseLong(String.valueOf(executionLog.scenarioId))).project
			def associatedScenario = Scenario.get(Long.parseLong(String.valueOf(executionLog.scenarioId)))
			def cycle = String.valueOf(executionLog.cycle)
			def version = executionLog.version
			def caseCount = Integer.valueOf(executionLog.caseCount)
			def caseFailedCount =  Integer.valueOf(executionLog.caseFailedCount)
			def duration = executionLog.duration
			def executionDate = dateFormat.parse(executionLog.executionDate)
			def target = user.getFullname()
			def executor = executionLog.executor
			def currentExecutionLog =new ExecutionLog( associatedScenario,  cycle,  version,  caseCount,  caseFailedCount,  duration,  executionDate,  target, executor)
			currentExecutionLog.project = project
			currentExecutionLog.save(flush:true, failOnError:true)
			project.addToLogs(currentExecutionLog)
			for(caseLog in executionLog.caseLogs){
				def caseName = caseLog.caseName
				def browser =  caseLog.browser
				def stepCount = Integer.valueOf(caseLog.stepCount)
				def executedStepCount =  Integer.valueOf(caseLog.executedStepCount)
				def caseExecutionDate = dateFormat.parse(executionLog.executionDate)
				def executorId = Long.parseLong(String.valueOf(executionLog.idExecutor))
				def caseLogSuccess = caseLog.isSuccess
				def currentCaseLog = new CaseLog( caseName,  browser,  stepCount,  executedStepCount,  caseExecutionDate, executorId, caseLogSuccess, caseLog.duration? caseLog.duration : "0:0:0")
				currentCaseLog.execLog = currentExecutionLog;
				currentExecutionLog.addToLogs(currentCaseLog.save(flush:true, failOnError:true))
				for(stepLog in caseLog.stepLogs){
					def stepNumber =Integer.parseInt(stepLog.stepNumber)
					def objectName = stepLog.objectName 
					def action = "text.message"
					if(stepLog.message.indexOf('.')>0){
							if(stepLog.message.contains('action')){
								action = 'genericAction'+stepLog.message.substring(stepLog.message.lastIndexOf('.'))
							}
							else{
								action = stepLog.message
							}
					 	}
					def isSuccess = stepLog.isSuccess
					def message = stepLog.message
					def uuid = stepLog.image
					def imageHash = stepLog.hash
					def currentStepLog = new Log ( stepNumber, objectName,  action,  isSuccess,  message,  uuid, imageHash).save(flush:true, failOnError:true)
					currentCaseLog.addToLogs(currentStepLog)
					currentStepLog.dateCreated = new Date()
					currentStepLog.save(flush:true)
				}
			}
		}
		render status:200
	}

	// Asigna el progreso a la ejecución indicada desde el cliente
	def setExecutionProgress(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def execution = Execution.get(params.id)
		if(execution==null){
			render status:400, text:'Not found'
			return
		}
		println "Progress: "+params.progress
		execution.setProgress(Integer.parseInt(params.progress.toString()))
		execution.setStateMessage(params.message)
		execution.save(flush:true)
		if(execution.getProgress()==100){
			execution.delete(flush:true)
		}
		render status:200
		return
	}

	//Recibe un error del framework desde cliente, sirve para informar al cliente del error
	def sendErrorFW(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def alert= new Alert(params.error.trim(), user, 1, "fa-times", "red", "").save(flush:true, failOnError:true)
		render status:200
		return
	}

	//Renderiza la imagen desde un archivo a la vista enviandola como un arreglo de bytes 
	def renderImage(){
		try{
			String objectImagePath ="logImages/"
			String image  = params.idOb // or whatever name you saved in your db
				if(image!="")
				{
					File imageFile =new File(objectImagePath+image);
					if(!imageFile.exists()){
						imageFile =new File(objectImagePath+"noImage");
					}
					BufferedImage originalImage=ImageIO.read(imageFile);
					ByteArrayOutputStream baos=new ByteArrayOutputStream();
					ImageIO.write(originalImage, "png", baos );
					byte[] imageInByte=baos.toByteArray();
					response.setHeader('Content-length', imageInByte.length.toString())
					response.contentType = 'image/png' // or the appropriate image content type
					response.outputStream << imageInByte
					response.outputStream.flush()
				}
		}
		catch(Exception e){
			println e.getMessage()
		}
	}

	//Elimina una alerta de acción porque se completo el proceso en el cliente
	def deleteAlert(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		def curAlert = Alert.get(Long.parseLong(params.idAlert.toString()))
		if(curAlert!=null){
			curAlert.delete(flush:true)
		}
		render status:200
	}

	//Recibe los navegadores que el cliente tiene instalados
	def setBrowsers(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}

		user.setBrowsers(params.browsers)
		user.save(flush:true)
		render status:200
		return
	}

	//Not implemented yet
	def uploadMessages(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
	}

	//Ejecuta recibiendo parametros desde java desde el cliente (Aplica para el gherkin)
	def executeByConsole(){
		if(!params.username || !params.projectName || !params.scenarioName || !params.browsers){
			println "Parametros incompletos"
			render status:400, text: "Parametros incomplenos o nulos"
			return
		}
		def user= User.findByUsername(params.username.toLowerCase())
		if(!user){
			println "Usuario no encontrado"
			render status:400, text: "Usuario no encontrado"
			return
		}
		def posibleProjects = user.getProjects()
		def executionProject
		if(posibleProjects.size()==0){
			println "No hay proyectos"
			render status:400, text: "No hay proyectos"
			return
		}
		for(Project project in posibleProjects){
			if(project.name.toLowerCase()==params.projectName.toLowerCase()){
				executionProject = project
				break;
			}
		}
		if(!executionProject){
			println "No se encontr{o el proyecto"
			render status:400, text: "No se encontró el proyecto de nombre: "+params.projectName
			return
		}
		def scenarioToExecute
		for(Scenario scenario in executionProject.scenarios){
			println "DB: "+scenario.name.toLowerCase()+" PARAMS: "+params.scenarioName.toLowerCase()
			if(scenario.name.toLowerCase() == params.scenarioName.toLowerCase() ){
				scenarioToExecute = scenario
			}
		}
		if(!scenarioToExecute){
			println "No se encontr{o el escenario"
			render status:400, text: "No se encontró el escenario de nombre: "+params.scenarioName
			return
		}

		if(params.browsers.trim()==""){
			println "No se encontr{o el navegador"
			render status:400, text: "Se debe indicar al menos un navegador: "
			return
		}

		def String [] browsers= params.browsers.split(',')
		if(params.browsers ==""){
			println "No se encontr{o el browsers"
			render status:400, text:message(code: 'execution.browsers.empty')
			return
		}
		scenarioToExecute.browsers=""
		scenarioToExecute.save(flush:true)
		for(String browser in browsers){
			scenarioToExecute.addbrowser(browser);
		}
		scenarioToExecute.save(flush:true)
		
		if(!(scenarioToExecute in user.getProjects()*.scenarios.flatten())){
			return
		}
		if(Case.countByScenarioAndIsEnabled(scenarioToExecute, true)==0){
			println "No se encontr{o el caso"
			render status:400, text:message(code: 'execution.error.notCases')
			return
		}
		if(sessionManagerService.isDesktopLoggedIn(user.getUsername(),user.getLastDesktopAction())=='true'){
				def Calendar calendar = Calendar.getInstance(); // gets a calendar using the default time zone and locale.
				calendar.add(Calendar.SECOND, 35);
				def Calendar calendar2 = Calendar.getInstance();
				calendar2.add(Calendar.MINUTE, 30);
				def pro1 =Execution.findByState(2)
				def pro2 =Execution.findByTargetAndStateAndIsProgrammedAndExecutionDateBetween(user,1,true, calendar.getTime(), calendar2.getTime())
				def pro3 =Execution.findByTargetAndStateAndIsProgrammed(user,1,false)

				if(pro2==null && pro1==null && pro3==null){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true, failOnError:true)
					render status:200, text:"direct"
					return
				}
				else if((pro1!=null || pro3) && pro2==null ){
					def myExecution=new Execution(user,user, false,calendar.getTime(),1,scenarioToExecute).save(flush:true,failOnError:true)
					myExecution.save(flush:true, failOnError:true)
					render status:200, text:"queue"
					return
				}
				else if(pro2!=null && !forced){
					render status:200, text:"confirm"
					return 
				}
		}
		else{
			println "No se encontr{o el client"
			render status:400, text:message(code: 'execution.error.notLogged')
			return
		}
	}


	//Autentica al cliente en thundertest web cuando le dan click en el logo en cliente
	def webAuth(){
		def tokenObject= Token.findByTokenAndType(params.token, 3)
		def user
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		 springSecurityService.reauthenticate user.username
		 redirect controller:"user", action:"renderIndex"
	}

	//Retorna los recursos de actualización que se tengan registrados
	def getUpdate(){			
		def answer =[resources:Resource.findAllByType(1)]
		render answer as JSON			
	}

	//recibe los proyectos uft y genera un proyecto asociado
	@Transactional
	def uploadObjectsAndUft(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)	
		def user
		def json = jsonSlurper.parseText(params.json)
		def objetos = json.objects
		def browsers = json.browsers
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		//creación del proyecto y de la página
		def project = new Project(json.projectName, json.projectName, user).save(flush:true, failOnError:true)
		user.addToProjects(project)

		for(browser in browsers){
			for(page in browser.pages){
				def curPage = Page.findByNameAndCreator(page.name,user)
				if(!curPage || !(curPage in project.pages)){
					curPage = new Page(page.name, page.name , false, user).save(flush:true, failOnError:true)
					project.addToPages(curPage)
				}
				for(object in page.pageObjects){
					def action =  GenericAction.findByName("genericAction.click");
					def newObject = new com.model.Object(browser.name+"#;#"+page.name+"#;#"+object.frameName+"#;#"+object.type, object.name, "noImage", 0, 0, user, 4, project.name, action, "noHash",user.associatedClient,curPage)
					newObject.save(flush:true,failOnError:true)
				}
			}
		}
		/*def scenario = Scenario.findByNameAndProject(project.name,project)
		if(!scenario){
			scenario = new Scenario(project.name, "1", "1.0", user, project, "", 2, json.projectPath, "").save(flush:true, failOnError:true)	
			project.addToScenarios(scenario)
		}*/
		def alert= new Alert("notification.objects.uploaded", user, 3, "fa-check", "green", "").save(flush:true, failOnError:true)
		render status:200
	}

	//recibe los objetos rft y genera un proyecto asociado
	@Transactional
	def uploadObjectsAndRft(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)	
		def user
		def json = jsonSlurper.parseText(params.json)
		def objects = json.objects
		def pathRft = json.nameTC.split("#;#")[0]+"#;#"+json.nameTC.split("#;#")[2]
		def name = json.nameTC.split("#;#")[1]

		//def user = User.findByUsername('diego@tester.com')
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		//creación del proyecto y de la página
		def project = Project.findByNameAndCreator(name,user)
		if(!project){
			project = new Project(name, name, user).save(flush:true, failOnError:true)
			user.addToProjects(project)
		}
		def curPage = project.getPages().find{it.name == page.name}

		if(!curPage){
			curPage = new Page(name, name , false, user).save(flush:true, failOnError:true)
			project.addToPages(curPage)
		}
		for(object in objects){
			def action =  GenericAction.findByName("genericAction.click")
			def allTarget = object.allTarget?object.allTarget:" "
			def newObject = new com.model.Object(allTarget+"#;#"+object.hash, object.nameObject, "noImage", Integer.parseInt(object.x), Integer.parseInt(object.y), user, 5, name, action, "noHash",user.associatedClient,curPage)
			newObject.save(flush:true,failOnError:true)
		}
		def scenario = Scenario.findByNameAndProject(name,project)
		if(!scenario){
			scenario = new Scenario(name, "1", "1.0", user, project, "", 3,"", pathRft).save(flush:true, failOnError:true)	
			project.addToScenarios(scenario)
		}
		def alert= new Alert("notification.objects.uploaded", user, 3, "fa-check", "green", "").save(flush:true, failOnError:true)
		render status:200
	}

	//Actualiza los objetos UFT en un proyecto
	@Transactional
	def updateUFTObjects(){
		def locale= new Locale("es")
		def jsonSlurper = new JsonSlurper()
		def tokenObject= Token.findByTokenAndType(params.token,3)	
		def user
		def json = jsonSlurper.parseText(params.json)
		def objetos = json.objects
		def browsers = json.browsers
		//def user = User.findByUsername('diego@tester.com')
		if(tokenObject!=null){
			user= User.findByUsername(tokenObject.getUsername())
		}
		else{
			render status:401
			return
		}
		//creación del proyecto y de la página
		def project = Project.get(json.idProject.toLong())
		//def project = new Project(json.projectName, json.projectName, user).save(flush:true, failOnError:true)
		//user.addToProjects(project)
		if(!project){
			render status:400, text:"Project not found"
			return
		}
		for(browser in browsers){
			for(page in browser.pages){
				def curPage = project.getPages().find{it.name == page.name}
				if(!curPage){
					curPage = new Page(page.name, page.name , false, user).save(flush:true, failOnError:true)
					project.addToPages(curPage)
				}
				for(object in page.pageObjects){
					if(Object.countByNameAndPage(object.name,curPage)==0){
						def action =  GenericAction.findByName("genericAction.click");
						def newObject = new com.model.Object(browser.name+"#;#"+page.name+"#;#"+object.type, object.name, "noImage", 0, 0, user, 4, project.name, action, "noHash",user.associatedClient,curPage)
						newObject.save(flush:true,failOnError:true)
					}
				}
			}
		}
		def alert= new Alert("notification.objects.uploaded", user, 3, "fa-check", "green", "").save(flush:true, failOnError:true)
		render status:200
	}
}