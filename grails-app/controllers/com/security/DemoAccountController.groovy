package com.security

import com.model.*
import com.helpers.*
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.apache.commons.lang.StringUtils

class DemoAccountController {

	def cryptoService

    //Envia los recursos a admin
	@Secured('permitAll')
    def getRestrictions(){
    	def tokenObject = Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def answer =[restrictions:DemoAccount.list(sort:'id', order: "desc")]
		answer = answer as JSON
		answer = cryptoService.rsaEncrypt(answer.toString())
		render answer
    }

    //Actualiza una restriccion para cuenta demo desde admin
    @Secured('permitAll')
    def updateRestriction(){
    	println params
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def restriction = DemoAccount.get(Integer.parseInt(params.id))
		if(!restriction){
			render status:400
			return
		}

		if(params.name.trim()=='' ){
			render status:400, text:'Nombre vacío'
			return
		}
		if(DemoAccount.countByNameRestrictionAndIdNotEqual(params.name, Integer.parseInt(params.id))>0){
			render status:400, text:'Nombre repetido'
			return
		}
		if(params.amount == '' ){
			render status:400, text:'Cantidad vacía'
			return
		}
		restriction.nameRestriction = params.name
		restriction.valueRestriction = Integer.parseInt(params.amount)
		restriction.state = Boolean.parseBoolean(params.state)
		restriction.save(flush:true, failOnError:true)
		render status:200
    }

    //Elimina un recurso especifico
    @Secured('permitAll')
    def deleteRestriction(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		def restriction = DemoAccount.get(cryptoService.rsaDecrypt(params.id))
		if(!restriction){
			render status:400
			return
		}
		restriction.delete(flush:true, failOnError:true)
		render status:200
	}

	//Agrega un recurso desde admin
	@Secured('permitAll')
    def addRestriction(){
    	def tokenObject= Token.findByTokenAndType(cryptoService.rsaDecrypt(params.token), 5)
		if(!tokenObject){
			render status:401
			return
		}
		if(params.name.trim()=='' ){
			render status:400, text:'Nombre vacío'
			return
		}

		if(params.amount.trim()=='' ){
			render status:400, text:'Cantidad vacía'
			return
		}

		if(DemoAccount.countByNameRestriction(params.name)>0){
			render status:400, text:'Nombre de restricción repetido'
			return
		}

		def restriction = new DemoAccount(params.name,Integer.parseInt(params.amount), Boolean.parseBoolean(params.state)).save(flush:true, failOnError:true)
		render status:200
	}
}
