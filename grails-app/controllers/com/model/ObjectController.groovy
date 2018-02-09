package com.model

import org.springframework.security.access.annotation.Secured
import org.springframework.transaction.annotation.Transactional;

import com.security.User
import org.springframework.web.servlet.support.RequestContextUtils;



import java.io.FileInputStream;
import java.io.IOException;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.apache.commons.lang.StringUtils
import com.helpers.*

class ObjectController {

	def springSecurityService
	def notificationsService

	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def index() {
		//println params
		def locale = RequestContextUtils.getLocale(request)
		if(params.id==null){
			render view='/login/denied'
			return
		}

		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def page = Page.get(params.id)

		if(!(page in user.projects*.pages.flatten())){
			render view:"/login/denied"
			return
		}
		def objects = page.objects.sort{it.dateCreated}

		def associatedProject = Project.get(params.projectId)
		if(!associatedProject){
			def project = ProjectPage.findByPage(page).project
			if(!project){
				redirect controller:'project', action:'index'
				return	
			}
			redirect controller:'page', action:'index', id:project.id
			return
		}
		def functionality27 = Functionality.findByInternalId(27)
		def functionality28 = Functionality.findByInternalId(28)

		render view:"index",  model:[associatedProject:associatedProject ,associatedPage:page,pageId: page.id, objects:objects, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), projects:user.getProjects(), functionality27:functionality27, functionality28:functionality28]
		return
	}


	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def save() {
		def allTargets = null
		if(params.allTargets.length()>4){
			allTargets = new StringBuilder(params.allTargets)
			allTargets.setLength(allTargets.length()-3)
		}
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def page = Page.get(params.id)
		if(!page){
			render view:'/login/denied'
			return
		}
		if(!(page in user.getProjects()*.pages.flatten())){
			render view:'/login/denied'
			return
		}

		def errors = "<ul>"	
		def file
		try{
			file = request.getFile('referenceImage')		
		}catch(Exception e){
			redirect action:'index', id:page.id, params: [projectId:params.projectId]
			return
		}
				
		if(file.getContentType() != "image/png" && !file.isEmpty()){
				errors += "<li>"+message(code:'error.object.badImageFormat')+"</li>"
		}
		
		def name = params.name
		if(name.trim() == ""){
			errors += "<li>"+message(code:'error.object.nullName')+"</li>"
		}
		
		if(Object.countByNameAndPage(name, page) > 0){
			//println message(code:'error.object.duplicateName', args:[name])
			errors += "<li>"+message(code:'error.object.duplicateName', args:[name])+"</li>"
		}
		
		if(!allTargets ){
			errors += "<li>"+message(code:'error.object.nullIdVal')+"</li>"
		}

		def xCoordinate = params.xCoordinate
		if(xCoordinate.trim() == "" || !StringUtils.isNumeric(xCoordinate)){
			errors += "<li>"+message(code:'error.object.nullXCoordinate')+"</li>"
		}		

		def yCoordinate = params.yCoordinate
		if(yCoordinate.trim() == "" || !StringUtils.isNumeric(yCoordinate)){
			errors += "<li>"+message(code:'error.object.nullYCoordinate')+"</li>"
		}

		def imageID = "noImage"
		def String objectImagePath ="objImages/"
		File dest = new File(objectImagePath+imageID)
		def imageHash = md5(dest.getAbsolutePath())
		if(!file.isEmpty()){
			imageID = UUID.randomUUID().toString();
			dest = new File(objectImagePath+imageID)
			file.transferTo(new File(dest.getAbsolutePath()))
			imageHash = md5(dest.getAbsolutePath())
		}
		
		def newObj = new Object(allTargets.toString(), params.name , imageID, Integer.parseInt(params.xCoordinate), Integer.parseInt(params.yCoordinate),  user, Integer.parseInt(params.pType),"",GenericAction.findByName('genericAction.click'),  imageHash,user.getAssociatedClient(),page)
		
		errors+="</ul>"

		if(errors!='<ul></ul>' || !newObj.validate()){
			flash.message = errors
			redirect action:'index', id:page.id, params:[projectId:params.projectId ]
			return
		}


		newObj.save(flush:true, failOnError:true)
		page.addToObjects(newObj)
		redirect action:'index', id:page.id, params:[projectId:params.projectId]
		return
		
	}


	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def updateObj(){
		println params
		def allTargets = new StringBuilder(params.allTargets)
		allTargets.setLength(allTargets.length()-3)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def page = Page.get(params.pageId)
		def objToEdit = Object.get(params.id)

		if(!page || !objToEdit){
			render view:'/login/denied'
			return
		}
		if(!(page in user.getProjects()*.pages.flatten())){
			render view:'/login/denied'
			return
		}

		if(!(objToEdit in user.getProjects()*.pages.flatten()*.objects.flatten())){
			render view:'/login/denied'
			return
		}

		def errors = "<ul>"	
		def file
		try{
			file = request.getFile('editReferenceImage')		
		}catch(Exception e){
			println e.getMessage()
			redirect action:'index', id:page.id, params: [projectId:params.projectId]
			return
		}
				
		if(file.getContentType() != "image/png" && !file.isEmpty()){
				errors += "<li>"+message(code:'error.object.badImageFormat')+"</li>"
		}
		
		def name = params.name
		if(name.trim() == ""){
			errors += "<li>"+message(code:'error.object.nullName')+"</li>"
		}
		def objectIdVal = params.allTargets
		if(objectIdVal.trim() == ""){
			errors += "<li>"+message(code:'error.object.nullIdVal')+"</li>"
		}

		if(Object.countByNameAndPage(name, page) > 0 && name!= objToEdit.name){
			//println message(code:'error.object.duplicateName', args:[name])
			errors += "<li>"+message(code:'error.object.duplicateName', args:[name])+"</li>"
		}
		def xCoordinate = params.xCoordinate
		if(xCoordinate.trim() == "" || !StringUtils.isNumeric(xCoordinate) ){
			errors += "<li>"+message(code:'error.object.nullXCoordinate')+"</li>"
		}		

		def yCoordinate = params.yCoordinate
		if(yCoordinate.trim() == "" || !StringUtils.isNumeric(yCoordinate)){
			errors += "<li>"+message(code:'error.object.nullYCoordinate')+"</li>"
		}

		def imageID = objToEdit.imageUrl
		def String objectImagePath ="objImages/"
		File dest = new File(objectImagePath+imageID)
		def imageHash = objToEdit.imageHash
		if(!file.isEmpty()){
			imageID = UUID.randomUUID().toString();
			dest = new File(objectImagePath+imageID)
			file.transferTo(new File(dest.getAbsolutePath()))
			imageHash = md5(dest.getAbsolutePath())
		}
		
	
		errors+="</ul>"

		if(errors!='<ul></ul>'){
			flash.error = errors
			println "***********errores"
			redirect action:'index', id:page.id, params:[projectId:params.projectId]
			return
		}
	
	println imageID
		objToEdit.name = name
		objToEdit.allTargets = allTargets
		objToEdit.imageUrl = imageID
		objToEdit.xCordinate = Integer.parseInt(xCoordinate)
		objToEdit.yCordinate = Integer.parseInt(yCoordinate)
		objToEdit.save(flush:true, failOnError:true)
		redirect action:'index', id:page.id, params:[projectId:params.projectId]
		return
	}



	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def updateName(){
		def object = Object.get(params.id)
		if(object!=null){
			object.name = params.value
			object.save(flush:true)
		}
		render status:200
	}


	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def updateIdType(){
		def object = Object.get(params.id)

		if(object!=null){
			def allParts =  object.allTargets.split("#;#")
			def StringBuilder sb = new StringBuilder(allParts[0]+"#;#"+params.value+"#;#")
			if(allParts.size()>2){
				for(def i=2;i<allParts.size();i++){
					sb.append(allParts[i]+"#;#")

				}
			}
			sb.setLength(sb.length()-1)
			object.allTargets = sb.toString()
			object.save(flush:true)
		}
		render status:200
	}


	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def updateObjectId(){
		def object = Object.get(params.id)
		if(object!=null){
			def allParts =  object.allTargets.split("#;#")
			def StringBuilder sb = new StringBuilder(params.value+"#;#"+allParts[1]+"#;#")
			if(allParts.size()>2){
				for(def i=2;i<allParts.size();i++){
					sb.append(allParts[i]+"#;#")
				}

			}
			sb.setLength(sb.length()-1)
			object.allTargets = sb.toString()
			object.save(flush:true)
		}
		render status:200

	}

	@Transactional
	@Secured(['ROLE_USER', 'ROLE_USER_LEADER'])
	def updateFromStep(){
		def object = Object.get(params.id)
		if(object!=null){
			object.name = params.name
			def allParts =  object.allTargets.split("#;#")
			def StringBuilder sb = new StringBuilder(params.objId+"#;#"+params.typeOfMap+"#;#")
			if(allParts.size()>2){
				for(def i=2;i<allParts.size();i++){
					sb.append(allParts[i]+"#;#")
				}
			}
			sb.setLength(sb.length()-1)
			object.allTargets = sb.toString()
			object.save(flush:true, failOnError:true)
		}
		render status:200
	}

	@Transactional
	def secureDelete() {

		def objectInstance = Object.get(params.id)

		if (objectInstance == null) {
			render status: 400, text:'not found'
			return
		}
		if(Step.findAllByObject(objectInstance).size()>0){
			render status: 400, text: '<li>'+message(code: 'error.object.notDeletable')+'</li>'
			return
		}
		def page=objectInstance.page
		page.removeFromObjects(objectInstance)
		page.save(flush:true)
		objectInstance.delete(flush:true)
		render status:200
		return 
	}

	@Transactional
	def secureMasiveDelete() {
		def objects = params.objectsToDelete.toString().split(',')		
		def detailsErrors = ""
		for(def i = 0;i < objects.size();i++){
			def objectInstance = Object.get(Integer.parseInt(objects[i]))
			if (objectInstance == null) {
				detailsErrors = 'not found'
				break
			}
			if(Step.findAllByObject(objectInstance).size()>0){
				detailsErrors = '<li>'+message(code: 'error.object.notMasiveDeletable', args: [objectInstance.name])+'</li>'
				break
			}
			def page=objectInstance.page
			page.removeFromObjects(objectInstance)
			page.save(flush:true)
			objectInstance.delete(flush:true)
		}
		if(detailsErrors != ""){
			render status: 400, text: detailsErrors
			return
		}
		render status:200
		return		
	}

 	def private String md5(String archivo) {
        try {
            // Carga el archivo
            FileInputStream archi = new FileInputStream(archivo);
            // se le indica que tipo de hash se realizara
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            String res;
            //buffer para almacenar la informacion del archivo
            DigestInputStream dis = new DigestInputStream(archi, md5)
                //Creo un buffer para almacenar la info del archivo
                byte[] b = new byte[32 * 1024];
                int i;
                 i = dis.read(b, 0, 32 * 1024);
                 while (i == 32 * 1024){
                 	i = dis.read(b, 0, 32 * 1024);
                 }
                //se genera el hash por el metodo  digest()
                res = byteArrayToHexString(md5.digest());
            

            //Retorna el resultado del hash 
            return res;
        } catch (IOException | NoSuchAlgorithmException e) {
            System.out.println("Error!");
        }
        return null;
    }



 	private static String byteArrayToHexString(byte[] b) {
        StringBuilder sb = new StringBuilder(b.length * 2);
        for (int i = 0; i < b.length; i++) {
            int v = b[i] & 0xff;
            if (v < 16) {
                sb.append("0");
            }
            sb.append(Integer.toHexString(v));
        }
        return sb.toString();
    }











	
}
