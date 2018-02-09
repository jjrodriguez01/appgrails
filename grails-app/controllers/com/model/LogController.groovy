package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;


import javax.imageio.ImageIO;
import java.io.File
import java.io.ByteArrayOutputStream
import java.awt.image.BufferedImage
import java.util.TimeZone;

import com.helpers.*

//Gestiona las evidencias
class LogController {

	def springSecurityService
	def notificationsService

	//Nivel de ejecucion
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def index() {
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def logs = user.getProjects()*.logs.flatten()
		TimeZone tz = Calendar.getInstance().getTimeZone();
		def offset = tz.getRawOffset()/60000
		
		def functionality24 = Functionality.findByInternalId(24)		
		def functionality25 = Functionality.findByInternalId(25)		

		render view:"index",  model:[ logs:logs, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), offset:offset, functionality24:functionality24, functionality25:functionality25]
	}


//Nivel de casos
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def caseLogs(){
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def caseLogs = ExecutionLog.get(params.id).logs
		def functionality24 = Functionality.findByInternalId(24)	
		def functionality25 = Functionality.findByInternalId(25)
		def functionality26 = Functionality.findByInternalId(26)
		render view:'caseLogs',  model:[ associatedLog:ExecutionLog.get(params.id),logs:caseLogs, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), functionality24:functionality24, functionality25:functionality25, functionality26:functionality26]
		return
	}

//Nivel de pasos
	@Transactional
	@Secured(['ROLE_USER','ROLE_USER_LEADER'])
	def stepLogs(){
		def locale = RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def stepLogs = CaseLog.get(params.id).logs.sort{it.dateCreated}
		def functionality24 = Functionality.findByInternalId(24)	
		def functionality25 = Functionality.findByInternalId(25)
		def functionality26 = Functionality.findByInternalId(26)

		render view:'stepLogs',  model:[associatedLog:CaseLog.get(params.id), logs:stepLogs, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(),functionality24:functionality24, functionality25:functionality25, functionality26:functionality26]
		return
	}


//Renderiza la imagen del log
	@Transactional
	@Secured('permitAll')
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
			}catch(Exception e){
				println e.getMessage()
			}
		
		}
	
}
