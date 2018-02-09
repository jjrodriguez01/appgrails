package com.helpers

import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.servlet.support.RequestContextUtils;
import com.security.*
import grails.converters.JSON

//Controlador que se encarga de gestionar los videos tutoriales de uso
class HelpController {

	def springSecurityService
	def notificationsService
    def cryptoService

    @Secured('permitAll')
    def index() {
    	def locale = RequestContextUtils.getLocale(request)
    	def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
    	def language = 'en'
    	println "langugae: "+locale.getISO3Language()
    	if(locale.getISO3Language()=='spa'){    		 
    		language = 'es'
    	}
    	render view:'index', model:[tutoriales:Tutorial.list(),notifications:notificationsService.getNotifications(user, locale, request.getSession(),0), language:language]
    }

    @Secured('permitAll')
    def getTutorials(){    
    println "asdfasdf"    
        def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
        if(!tokenObject){
            render status:401
            return
        }
        def tutorials = Tutorial.list()        
        def answer = [tutorials:tutorials] as JSON
        render cryptoService.rsaEncrypt(answer.toString())
    }

    @Secured('permitAll')
    def createTutorial(){
        def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
        if(!tokenObject){
            render status:401
            return
        }
        def tutorial = new Tutorial(params.title, params.englishTitle, params.html, params.englishHtml, params.url)
        if(!tutorial.validate()){
            def errores="<ul>"            
            for(error in tutorial.errors.getAllErrors()){
                errores+="<li>"+g.message(error: error)+"</li>"
            }
            errores+="</ul>"
            render status:400, text:errores
            return          
        }
        tutorial.save(flush:true, failOnError:true)
        render status:200
    }

    @Secured('permitAll')
    def updateTutorial(){
        println params
        def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
        if(!tokenObject){
            render status:401
            return
        }
        def tutorial = Tutorial.get(params.id)
        if(!tutorial){
            render status:404, text:'Not Found'
            return
        }
        tutorial.url = params.url
        tutorial.html = params.html
        tutorial.englishHtml = params.englishHtml
        tutorial.englishTitle = params.englishTitle
        tutorial.title = params.title
        if(!tutorial.validate()){
            def errores="<ul>"            
            for(error in tutorial.errors.getAllErrors()){
                errores+="<li>"+g.message(error: error)+"</li>"
            }
            errores+="</ul>"

            println errores
            render status:400, text:errores
            return          
        }
        tutorial.save(flush:true, failOnError:true)
        render status:200
    }

    @Secured('permitAll')
    def deleteTutorial(){
        def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
        if(!tokenObject){
            render status:401
            return
        }
        def tutorial = Tutorial.get(params.id)
        if(!tutorial){
            render status:404, text:'Not Found'
            return
        }
        tutorial.delete(flush:true, failOnError:true)
        render status:200
    }

}
