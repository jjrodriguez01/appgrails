package com.model

import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.Method.GET
import static groovyx.net.http.Method.POST
import static groovyx.net.http.ContentType.TEXT
import grails.converters.JSON
import groovy.json.JsonSlurper


import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.servlet.support.RequestContextUtils
import com.security.User

import com.payu.sdk.PayU
import com.payu.sdk.PayUCreditCard
import com.payu.sdk.PayUSubscription
import com.payu.sdk.exceptions.ConnectionException
import com.payu.sdk.exceptions.InvalidParametersException
import com.payu.sdk.exceptions.PayUException
import com.payu.sdk.model.Language
import com.payu.sdk.paymentplan.model.PaymentPlanCreditCard
import com.payu.sdk.paymentplan.model.Subscription
import java.util.HashMap
import java.util.Map

@Secured('permitAll')
class SubscriptionController {

	def springSecurityService
    def notificationsService
    def plans = getLicencesSys()
    def locale = RequestContextUtils.getLocale(request)

    def index() { }

    def updateSubscription(){

        def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
        def actualPlan = getActualPlan(user.username)

        def estado = (!user.accountExpired)?"Vigente":"Expirada"

		render (view:'updateSubscription', model: [user:user.username, fullname:user.fullname, 
            planesSys:plans, actualPlan:actualPlan, accountState:estado,
            notifications:notificationsService.getNotifications(user, locale, request.getSession(),0)])
	}

    def cancelSubscription(){
        println "PARAM: " + params.idSub
        Map<String, String> parameters = new HashMap<String, String>();
        // Ingresa aquí el identifcador de la subscripción.
        parameters.put(PayU.PARAMETERS.SUBSCRIPTION_ID, params.idSub);
        boolean response = PayUSubscription.cancel(parameters);
        LoggerUtil.info("{0}", response);
        render status:200
    }

	def updateCC(){

        initPAYU()

        Map<String, String> parameters = new HashMap<String, String>()
        // Ingresa aquí el identificador del pagador.
        parameters.put(PayU.PARAMETERS.CUSTOMER_ID, params.customerId)//pendiente
        // Ingresa aquí el número de la tarjera.
        parameters.put(PayU.PARAMETERS.CREDIT_CARD_NUMBER, params.numberCC)
        // Ingresa aquí la fecha de expiración de la tarjeta.
        parameters.put(PayU.PARAMETERS.CREDIT_CARD_EXPIRATION_DATE, params.ccYear + "/" + params.ccMonth)
        // Ingresa aquí el tipo de la tarjeta.
        parameters.put(PayU.PARAMETERS.PAYMENT_METHOD, params.typeCC)
        // Ingresa aquí el nombre del pagador.
        parameters.put(PayU.PARAMETERS.PAYER_NAME, params.nameCC)
        // Ingresa aquí el documento de identificación asociado a la tarjeta.
        parameters.put(PayU.PARAMETERS.CREDIT_CARD_DOCUMENT, params.documentCC)

        def PaymentPlanCreditCard response

        def nuevoToken = ""

        try {

            response = PayUCreditCard.create(parameters)

            nuevoToken = (response != null) ? response.getToken() : ""

            //println "-------------------------------"
            //println "nuevoToken " + nuevoToken

        } catch (PayUException | InvalidParametersException | ConnectionException ex) {
            println params
        }

        //actualizar tarjeta de suscripción
        Map<String, String> parametersSubs = new HashMap<String, String>()
        // Ingresa aquí el ID de la suscripción.
        parametersSubs.put(PayU.PARAMETERS.SUBSCRIPTION_ID, params.subscriptionID)
        // Ingresa aquí el identificador del token de la tarjeta.
        parametersSubs.put(PayU.PARAMETERS.TOKEN_ID, nuevoToken)

        def Subscription responseSubs

        try {
            responseSubs = PayUSubscription.update(parametersSubs)

            if (responseSubs != null) {

                //println "*************************"
                //println "nueva tarjeta " + responseSubs.getCreditCardToken()

                try{
                //envio parametros admin
                def state=200
                def jsonRes
                def ConfigObject config= grailsApplication.config
                println config.redirect.url
                //def http = new HTTPBuilder('http://192.168.100.135:8080')
                def http = new HTTPBuilder(config.redirect.url)        
                http.request( POST, JSON ) {
                    uri.path = '/admin/recurrentTransaction/updateCC'
                   // uri.query = params as JSON
                    uri.query = [ token:'356ec93c791a43db9282f28fd87d824c', buyerEmail:params.buyerEmail , tokenCC:responseSubs.getCreditCardToken()]

                     headers.Accept = 'application/json'

                    response.success = { resp, reader ->                
                        assert resp.status == 200
                        state=resp.status  
                        //println "Got response: ${resp.statusLine}"
                       // println "Content-Type: ${resp.headers.'Content-Type'}"
                        jsonRes=reader.text                 
                    }
                    response.'404' = { resp ->
                        println 'Not found' 
                        state=resp.status
                    }
                }
                http.handler.failure = { resp ->
                    println "Unexpected failure: ${resp.statusLine}"
                    state=resp.status
                   // render status:400

                   // return
                }      
                //println jsonRes
                //render jsonRes
               }catch(Exception e){
                println e.getMessage()
                } 

            }

            def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
            def actualPlan = getActualPlan(user.username)


        render (view:'updateSubscription', model: [user:user.username, fullname:user.fullname, planesSys:plans, actualPlan:actualPlan, notifications:notificationsService.getNotifications(user, locale, request.getSession(),0)])

        } catch (InvalidParametersException | ConnectionException | PayUException ex) {
            println ex.getMessage()
            ex.printStackTrace()
        }

	}


    def getActualPlan(p_username){

        println "p_username--> " + p_username

        def state=200
        def jsonRes
        def ConfigObject config= grailsApplication.config
        println config.redirect.url
        //def http = new HTTPBuilder("http://192.168.100.135:8080")
        def http = new HTTPBuilder(config.redirect.url)        
        http.request( POST, JSON ) {
            uri.path = '/admin/recurrentTransaction/getRecurrentByBuyer'
           // uri.query = params as JSON
            uri.query = [ token:'356ec93c791a43db9282f28fd87d824c', buyerEmail:p_username]

            headers.Accept = 'application/json'

            response.success = { resp, reader ->                
                assert resp.status == 200
                state=resp.status  
                //println "Got response: ${resp.statusLine}"
               // println "Content-Type: ${resp.headers.'Content-Type'}"
                jsonRes=reader.text                 
            }
            response.'404' = { resp ->
                println 'Not found' 
                state=resp.status
            }
        }
        http.handler.failure = { resp ->
            println "Unexpected failure: ${resp.statusLine}"
            state=resp.status
        }      

        def jsonSlurper = new JsonSlurper()
        def json = jsonSlurper.parseText(jsonRes)
        def plan = json.tr

        println plan

        return plan

    }

    def getLicencesSys(){

        def state=200
        def jsonRes
        def ConfigObject config= grailsApplication.config
        println config.redirect.url
        //def http = new HTTPBuilder("http://192.168.100.135:8080")
        def http = new HTTPBuilder(config.redirect.url)        
        http.request( GET, JSON ) {
            uri.path = '/admin/licencia/getLicences'
           // uri.query = params as JSON
            uri.query = [ token:'356ec93c791a43db9282f28fd87d824c']

            headers.Accept = 'application/json'

            response.success = { resp, reader ->                
                assert resp.status == 200
                state=resp.status  
                //println "Got response: ${resp.statusLine}"
               // println "Content-Type: ${resp.headers.'Content-Type'}"
                jsonRes=reader.text                 
            }
            response.'404' = { resp ->
                println 'Not found' 
                state=resp.status
            }
        }
        http.handler.failure = { resp ->
            println "Unexpected failure: ${resp.statusLine}"
            state=resp.status
        }      

        def jsonSlurper = new JsonSlurper()
        def json = jsonSlurper.parseText(jsonRes)
        def plans = json.licences

        return plans

    }

    def initPAYU(){

        def state=200
        def jsonRes
        def ConfigObject config= grailsApplication.config
        println config.redirect.url
        //def http = new HTTPBuilder("http://192.168.100.135:8080")
        def http = new HTTPBuilder(config.redirect.url)        
        http.request( POST, JSON ) {
            uri.path = 'admin/paramsPAYU/getKeys'
           // uri.query = params as JSON
            uri.query = [ token:'356ec93c791a43db9282f28fd87d824c']

            headers.Accept = 'application/json'

            response.success = { resp, reader ->                
                assert resp.status == 200
                state=resp.status  
                //println "Got response: ${resp.statusLine}"
               // println "Content-Type: ${resp.headers.'Content-Type'}"
                jsonRes=reader.text                 
            }
            response.'404' = { resp ->
                println 'Not found' 
                state=resp.status
            }
        }
        http.handler.failure = { resp ->
            println "Unexpected failure: ${resp.statusLine}"
            state=resp.status
        }      

        def jsonSlurper = new JsonSlurper()
        def json = jsonSlurper.parseText(jsonRes)
        def keysPAYU = json.paramsPAYU


        PayU.apiKey = keysPAYU.apiKey //Ingresa aquí tu apiKey.
        PayU.apiLogin = keysPAYU.apiLogin //Ingresa aquí tu apiLogin.

        PayU.language = Language.es //Ingresa aquí el idioma que prefieras.
        PayU.isTest = keysPAYU.isTest //Dejarlo verdadero cuando sean pruebas.
        PayU.paymentsUrl = keysPAYU.urlPagos
        PayU.reportsUrl = keysPAYU.urlReportes
    }
}
