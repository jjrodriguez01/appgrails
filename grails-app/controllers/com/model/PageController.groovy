package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;
import java.util.UUID;
import java.util.TimeZone
import com.helpers.*

class PageController {

	def springSecurityService
	def sessionManagerService
	def notificationsService


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view:'/login/denied'
			return
		}

		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def project = Project.get(params.id)
		if(!(project in user.getProjects())){
			render view:'/login/denied'
			return
		}

		def pages = project.pages
		def pPages = []
		for(Page page in pages){
			if(!(page.isPrivate && page.creator!=user)){
				pPages.push(page)
			}

		}
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000

		def functionality5 = Functionality.findByInternalId(5)
		def functionality6 = Functionality.findByInternalId(6)
		def functionality7 = Functionality.findByInternalId(7)
		def functionality29 = Functionality.findByInternalId(29)

		render view:"index",  model:[associatedProject:project, pages: pPages, projectId:project.id, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), offset:offset, functionality5:functionality5, functionality6:functionality6, functionality7: functionality7, functionality29:functionality29]
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveObjects(){
		try{
			def user = com.security.User.findByUsername(springSecurityService.getPrincipal().getUsername())
			def objects = params.objectsToSave.toString().split(",")
			def page= Page.get(params.id)
			if("" in objects){
				render status:200
				return

			}
			if(page==null){
				render status:200
				return
			}
			for(def i=0; i<objects.size();i++){
				def curObject = Object.get(Long.parseLong(objects[i]))
				page.addToObjects(curObject)
				def associatedMessages = Message.findAllByObjectAndPage(curObject, null)
				for(Message curMessage in associatedMessages){
					curMessage.page=page
					curMessage.save(flush:true, failOnError:true)
					page.addToMessages(curMessage)
				}
			}
			page.save(flush:true, failOnError:true)
			
			render status: 200
			return 
		}
		catch(Exception e){
			e.printStackTrace()
			render status:400, text:g.message(code: "text.error")
		}
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveMessages(){
		try{
			def user = com.security.User.findByUsername(springSecurityService.getPrincipal().getUsername())
			def messages = params.messagesToSave.toString().split(",")
			def page= Page.get(params.id)
			if("" in messages){
				render status:200
				return

			}
			if(page==null){
				render status:200
				return
			}
			for(def i=0; i<messages.size();i++){

				def curMessage = Message.get(Long.parseLong(messages[i]))
				page.addToMessages(curMessage)
				def associatedObject = curMessage.object
				curMessage.page= page
				curMessage.save(flush:true, failOnError:true)
				page.addToObjects(associatedObject)
			}
			page.save(flush:true, failOnError:true)
			render status: 200
			return 
		}
		catch(Exception e){
			e.printStackTrace()
			render status:400, text:g.message(code: "text.error")
		}
	}

	//Creación de página desde stage con objetos
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveWithObjects() {
		def pageInstance=null
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		pageInstance = new Page(params.name, params.description, Boolean.parseBoolean(params.isPrivate),user)
		def project= Project.get(params.projectId)
		if (pageInstance == null) {
			return
		}
		def flag=false

		for(Page page in project.getPages()){
			if(page.name.toLowerCase().equals(params.name.toString().toLowerCase())){
				flag=true
				break;
			}
		}

		if (!pageInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Page page in project.getPages()){
				if(page.name.toLowerCase().equals(pageInstance.name.toString().toLowerCase())){
					errores+="<li>"+g.message(code: 'com.model.page.name.error.unique', args:[params.name])+"</li>"
					break;
				}

			}

			for(error in pageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			
			errores+="</ul>"
			render status:400, text:errores
			return
		}


		def objects = params.objectsToSave.toString().split(",")
		if("" in objects){
			pageInstance.save(flush:true,failOnError:true)
			project.addToPages(pageInstance)
			render status:200
			return
		}
		for(String obj in objects){
			pageInstance.save(flush:true)
			def curObj=Object.get(Long.parseLong(obj))
			def associatedMessages = Message.findAllByObjectAndPage(curObj, null)
				for(Message curMessage in associatedMessages){
					curMessage.page=pageInstance
					curMessage.save(flush:true, failOnError:true)
					curMessage.page = pageInstance
					curMessage.save(flush:true, failOnError:true)
					pageInstance.addToMessages(curMessage)
				}
			curObj.save(flush:true, failOnError:true)
			pageInstance.addToObjects(curObj)
		}
		pageInstance.save(flush:true,failOnError:true)
		project.addToPages(pageInstance)
		render status:200
		return
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def saveWithMessages() {
		def pageInstance=null
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		pageInstance = new Page(params.name, params.description, Boolean.parseBoolean(params.isPrivate),user)
		def project= Project.get(params.projectId)
		if (pageInstance == null) {
			return
		}
		def flag=false

		for(Page page in project.getPages()){
			if(page.name.toLowerCase().equals(params.name.toString().toLowerCase())){
				flag=true
				break;
			}
		}

		if (!pageInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Page page in project.getPages()){
				if(page.name.toLowerCase().equals(pageInstance.name.toString().toLowerCase())){
					errores+="<li>"+g.message(code: 'com.model.page.name.error.unique', args:[params.name])+"</li>"
					break;
				}

			}

			for(error in pageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			
			errores+="</ul>"
			render status:400, text:errores
			return
		}


		def messages = params.messagesToSave.toString().split(",")
		if("" in messages){
			pageInstance.save(flush:true,failOnError:true)
			project.addToPages(pageInstance)
			render status:200
			return
		}
		for(String msg in messages){
			pageInstance.save(flush:true)
			def curMsg=Message.get(Long.parseLong(msg))
			curMsg.save(flush:true, failOnError:true)
			pageInstance.addToMessages(curMsg)
			def associatedObject = curMsg.getObject()
			associatedObject.page=pageInstance
			pageInstance.addToObjects(associatedObject)
		}
		pageInstance.save(flush:true,failOnError:true)
		project.addToPages(pageInstance)
		render status:200
		return
	}




	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def create(){

		def pageInstance=null
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		pageInstance = new Page(params.name, params.description, Boolean.parseBoolean(params.isPrivate),user)
		def project= Project.get(params.projectId)
		if (pageInstance == null) {
			return
		}
		def flag=false

		for(Page page in project.getPages()){
			if(page.name.toLowerCase().equals(params.name.toString().toLowerCase())){
				flag=true
				break;
			}
			
		}

		if (!pageInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Page page in project.getPages()){
				if(page.name.toLowerCase().equals(pageInstance.name.toString().toLowerCase())){
					errores+="<li>"+g.message(code: 'com.model.page.name.error.unique', args:[params.name])+"</li>"
					break;
				}
			}

			for(error in pageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}

			errores+="</ul>"
			render status:400, text:errores
			return
		}
		pageInstance.save(flush:true,failOnError:true)
		project.addToPages(pageInstance)
		render status:200
		return 
	}


	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def update() {
		def errors=[]
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def pageInstance = Page.get(params.id)
		if(pageInstance ==null  ){
			render status:'400', text:'not found'
			return
		}

		pageInstance.setName(params.name);
		pageInstance.setDescription(params.description)
		if(pageInstance.isPrivate){
			pageInstance.setIsPrivate(Boolean.parseBoolean(params.isPrivate))
		}
		def project= Project.get(params.projectId)
		def flag=false

		for(Page page in project.getPages()){
			if(page.name.toLowerCase().equals(params.name.toString().toLowerCase()) && page.id != pageInstance.id){
				flag=true
				break;
			}
		}

		if (!pageInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Page page in project.getPages()){
				if(page.name.toLowerCase().equals(pageInstance.name.toString().toLowerCase()) && page.id !=pageInstance.id){
					errores+="<li>"+g.message(code: 'com.model.page.name.error.unique', args:[params.name])+"</li>"
					break;
				}
			}

			for(error in pageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			errores+="</ul>"
			render status:400, text:errores
			return
		}
		pageInstance.save(flush:true,failOnError:true)
		render status:200
	}



	@Transactional
	@Secured(["ROLE_USER", "ROLE_USER_LEADER"])
	def duplicate(){
		def user = User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def pageInstanceOld = Page.get(params.id)
		def project=Project.get(params.projectId)
		def projectToDuplicate = Project.get(Long.parseLong(params.duplicateProject))
		if(pageInstanceOld==null || project==null || projectToDuplicate==null){
			render view:'/login/denied'
			return
		}
		
		def pageInstance = new Page(params.name, params.description, Boolean.valueOf( params.isPrivate), user)


		def flag=false

		for(Page page in projectToDuplicate.getPages()){
			if(page.name.toLowerCase().equals(params.name.toString().toLowerCase())){
				flag=true
				break;
			}
		}

		if (!pageInstance.validate() || flag ) {

			def errores="<ul>"
			
			for(Page page in projectToDuplicate.getPages()){
				if(page.name.toLowerCase().equals(pageInstance.name.toString().toLowerCase())){
					errores+="<li>"+g.message(code: 'com.model.page.name.error.unique', args:[params.name])+"</li>"
					break;
				}
			}

			for(error in pageInstance.errors.getAllErrors()){
				errores+="<li>"+g.message(error: error)+"</li>"
			}
			errores+="</ul>"
			render status:400, text:errores
			return
		}
		
		pageInstance.save(flush:true, failOnError:true)
		for(Object obj in pageInstanceOld.objects){
			if(!obj.autoGenerated){
				def newObj = new Object(obj, pageInstance,  copyFileUsingFileStreams(obj.getImageUrl()),user).save(flush:true, failOnError:true)
				pageInstance.addToObjects(newObj)
			}

		}
		for(Message msg in pageInstanceOld.messages){
			def newMsg = new Message(msg.object,msg.message, msg.byClueWords, msg.type,String scope, User creator, Page page, User associatedClient)			pageInstance.addToObjects(newObj)
		}

		projectToDuplicate.addToPages(pageInstance)
		projectToDuplicate.save(flush:true)
		render status:200
		return
	}



	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def secureDelete(){

		def page = Page.get(params.id)
		def objects = page.objects
		if(page==null){
			render status:400, text:"page not found"
			return
		}
		for(Object obj in page.objects){
			def steps = Step.findAllByObject(obj)
			if(steps.size()>0){
				render status:400, text: message(code:'text.pageContainsUsedObjects')
				return
			}

		}
		for(Object obj in objects){
			obj.page=null
		}
		page.objects.empty()

		def projectPages=ProjectPage.findAllByPage(page)
		for(ProjectPage pp in projectPages ){
			pp.delete(flush:true)
		}
		page.delete(flush:true)
		for(obj in objects){
			def String objectImagePath ="objImages/"
			File objImage = new File(objectImagePath+obj.getImageUrl())
			objImage.delete()
			obj.delete(flush:true)

		}
		render status:200
		return
	}

	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def secureMasiveDelete(){
		def pagesIds = params.pagesToDelete.toString().split(',')
		def detailsErrors = ''
		for(def i = 0;i < pagesIds.size();i++){
			def page = Page.get(Integer.parseInt(pagesIds[i]))
			def objects = page.objects
			if(page==null){
				detailsErrors = 'page not found'
				break
			}
			for(Object obj in page.objects){
				def steps = Step.findAllByObject(obj)
				if(steps.size()>0){
					detailsErrors = message(code:'text.pageContainsUsedObjects')
					break
				}

			}
			if(detailsErrors != ''){
				break
			}
			for(Object obj in objects){
				obj.page=null
			}
			page.objects.empty()

			def projectPages=ProjectPage.findAllByPage(page)
			for(ProjectPage pp in projectPages ){
				pp.delete(flush:true)
			}
			page.delete(flush:true)
			for(obj in objects){
				def String objectImagePath ="objImages/"
				File objImage = new File(objectImagePath+obj.getImageUrl())
				objImage.delete()
				obj.delete(flush:true)

			}
		}
		if(detailsErrors != ''){
			render status:400, text:detailsErrors
			return
		}
		render status:200
		return
	}
	

	def private String copyFileUsingFileStreams(String imageUrl)
	throws IOException {
		InputStream input = null;
		OutputStream output = null;
		UUID imageID = UUID.randomUUID();
		def String objectImagePath ="objImages/"
		File source = new File(objectImagePath+imageUrl)
		File dest = new File(objectImagePath+imageID)
		try {
			input = new FileInputStream(source);
			output = new FileOutputStream(dest);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
			} finally {
				input.close();
				output.close();
			}

		return imageID
		}
	}
