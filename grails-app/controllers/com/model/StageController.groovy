package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.imageio.ImageIO;
import java.io.File
import java.io.ByteArrayOutputStream
import java.awt.image.BufferedImage
import java.util.TimeZone
import com.helpers.*

class StageController {

	def springSecurityService
	def sessionManagerService
	def notificationsService

	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {		
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def stageObjects
		def stageMessages
		if(user.isDemo()){
			stageObjects = Object.findAllByPageAndCreator(null, user).sort{it.dateCreated}
			stageMessages = Message.findAllByPageAndCreator(null, user).sort{it.dateCreated}
		}
		else{
			stageObjects = Object.findAllByPageAndAssociatedClient(null, user.getAssociatedClient()).sort{it.dateCreated}
			stageMessages = Message.findAllByPageAndAssociatedClient(null, user.getAssociatedClient()).sort{it.dateCreated}
		}
		def projects = user.getProjects()
		def pPages = []
		def gPages = []
		for(Project project in projects){
			def pageGroup =project.getPages()
			gPages=[]
			for(Page page in pageGroup){
				if(!(page.isPrivate && page.creator!=user)){
					gPages.push(page);
				}
			}
			pPages.push(gPages)
		}
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000

		def functionality10 = Functionality.findByInternalId(10)
		def functionality11 = Functionality.findByInternalId(11)

		render view:"index", model:[objects:stageObjects,messages:stageMessages, projects:projects, pagesGroups:pPages, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), curUsername: user.username, offset:offset, functionality10:functionality10, functionality11:functionality11 ]
	}


	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def deleteObject(){
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def objToDelete = Object.get(params.id)
		if(objToDelete==null || objToDelete.creator!=user ){
			render view:"/login/denied"
			return
		}
		objToDelete.delete(flush:true)
		render status:200
		return
	}


	def renderImage(){
		try{
			ConfigObject config = grailsApplication.config
			String objectImagePath ="objImages/"
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
				File imageFile =new File(objectImagePath+"noImage");
				BufferedImage originalImage=ImageIO.read(imageFile);
				ByteArrayOutputStream baos=new ByteArrayOutputStream();
				ImageIO.write(originalImage, "png", baos );
				byte[] imageInByte=baos.toByteArray();
				response.setHeader('Content-length', imageInByte.length.toString())
				response.contentType = 'image/png' // or the appropriate image content type
				response.outputStream << imageInByte
				response.outputStream.flush()
			}catch(Exception e){
				println e.getMessage()
			}
		}

	def deleteObjects(){		
		try{
			def user = com.security.User.findByUsername(springSecurityService.getPrincipal().getUsername())			
			def objects = params.objectsToDelete.toString().split(",")			
			for(def i=0; i<objects.size();i++){
				def curObject = Object.get(Long.parseLong(objects[i]))				
				def associatedMessages = Message.findAllByObjectAndPage(curObject, null)
				for(Message curMessage in associatedMessages){					
					curMessage.delete(flush:true, failOnError:true)					
				}
				curObject.delete(flush:true, failOnError:true)
			}			
			render status: 200
			return 
		}
		catch(Exception e){
			e.printStackTrace()
			render status:400, text:g.message(code: "text.error")
		}
	}


	}
