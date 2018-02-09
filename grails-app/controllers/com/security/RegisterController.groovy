package com.security


import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.SpringSecurityUtils
import com.helpers.Token
import java.lang.NullPointerException


import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.Method.POST
import static groovyx.net.http.ContentType.TEXT
import grails.converters.JSON
import groovy.json.JsonSlurper
import org.springframework.web.servlet.support.RequestContextUtils;

@Secured('permitAll')
class RegisterController {

	def mailService
    def springSecurityService

    static allowedMethods = [payConfirmation: "POST"]

    //Renderiza la vista de registro
    def index() { 
        def rc=new RegisterCommand()
        render view: 'register', model: [command: rc]
    }

    //Registra al usuario en el sistema haciendo uso de un comando de registro (clase auxiliar definida al final)
    def register(RegisterCommand command){
        
        def http = new HTTPBuilder( 'https://www.google.com/recaptcha/api/siteverify' )
        def googleResp
        def state
        
        http.request( POST, JSON ) {
            uri.query = [secret:'6LfsGCETAAAAAGVCAjyt8h5Z_0MsodzZff_iyRz2', response: params.get('g-recaptcha-response')]
            headers.Accept = 'application/json'
            response.success = { resp, reader ->                
                assert resp.status == 200
                state=resp.status  
                googleResp=new JsonSlurper().parseText(reader.text)               
            }
            response.'404' = { resp ->
                state=resp.status
            }
        }
        http.handler.failure = { resp ->
            state=resp.status
            render status:400
            return
        }
        
        if (command.hasErrors() || !googleResp.success) {
            if(!googleResp.success){
                flash.message = message(code:'register.error.invalidCaptcha')
            }
            render view: 'register', model: [command: command]
            return
        }
        def locale = RequestContextUtils.getLocale(request)
        def username = params.username
        def fullname = params.fullname
        def mobile = params.mobile
        def phone = params.phone
        def ext
        try{
         ext = Integer.parseInt(params.extension)
        } catch(Exception ex){
         ext = null;
        }
        def address = params.address
        def organization = params.organization
        def password = params.password
        def password2 = params.password2
        def offersChk = params.offersChk?true:false
        def plan=0
        def user =null
        if(plan==0){
            def associatedClient = User.findByUsername('superclient@qvision.com')
            user= new User( username,  password,  fullname, phone,  mobile,  address,  organization, plan, associatedClient, offersChk, null) 
        }
        else{
            user= new User( username,  password,  fullname, phone,  mobile,  address,  organization, plan, null, offersChk, null) 
        }
        user.setExtension(ext?ext:0)
        user.setAvatarFile('avatares-10.png')
        user.save(flush:true, failOnError:true)

        if(plan!=0){
            def clientRole=Role.findByAuthority('ROLE_CLIENT')
            UserRole.create user, clientRole, true
        }
        else {
            def leaderRole=Role.findByAuthority('ROLE_USER_LEADER')
            def demoRole=Role.findByAuthority('ROLE_DEMO')
            UserRole.create user, leaderRole, true
            UserRole.create user, demoRole, true
        }
       
        def token= new Token(username,1).save(flush:true, failOnError:true)
        String url = generateLink('verifyRegistration', [t: token.token])

        mailService.sendMail {
            from "no-replay@thundertest.com"
            to username
            subject g.message(code: 'general.mail.subject.accountConfirmation')
            html( view:"/comercial/mail/accountConfirmation", 
                model:[username:fullname,url:url])
        }

        def config = grailsApplication.config
        def uriLicense = config.redirection.commercial.url
        redirect uri:uriLicense+'redirect/license', params:[eXklU6:username.bytes.encodeBase64().toString(), n9tYCgf:fullname.bytes.encodeBase64().toString(), mVwXyOz:mobile.bytes.encodeBase64().toString(), lang:locale.getLanguage()]
    }

    //Verifica el registro de la cuenta
    def verifyRegistration() {
        def conf = SpringSecurityUtils.securityConfig
        def user
        String defaultTargetUrl = conf.successHandler.defaultTargetUrl
        String token = params.t
        def registrationCode = token ? Token.findByTokenAndType(token,1) : null
        if (!registrationCode) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }
        Token.withTransaction { status ->
            user = User.findByUsername(registrationCode.username)
            if (!user) {
                return
            }
            user.accountLocked = false
            user.save(flush:true)
            registrationCode.delete()
        }

        if (!user) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }

        if(user.accountLocked){
            redirect controller:'login', action:'auth'
            return
        }
        
        springSecurityService.reauthenticate user.username
        flash.message = message(code: 'spring.security.register.complete')
        redirect uri: conf.ui.register.postRegisterUrl ?: defaultTargetUrl
    }


    //Muestra la vista de reestablecimiento de contraseña antes de solicitarla
    def forgotPassword(){
        render view:'forgotPassword'
        return
    }

    //Envía un correo para reestablecer la contraseña
    def sendResetPasswordMail(){
        def user=User.findByUsername(params.username)
        if(user==null){
            flash.error=null
            if(params.username!=null)
                flash.error= message(code: 'general.commercial.notFound.forgotPassword', args:[params.username])
            flash.message=null
            render view:'forgotPassword'
            return;
        }
        def token = new Token(user.getUsername(),2).save(flush:true)
        String url = generateLink('resetPassword', [t: token.token])

        mailService.sendMail {
            from "no-replay@thundertest.com"
            to user.getUsername()
            subject g.message(code: 'general.mail.subject.forgotPassword')
            html( view:"/comercial/mail/forgotPassword", 
                model:[url:url])
        }
        flash.error=null
        flash.message= message(code: 'general.commercial.mail.forgotPassword.success', args:[params.username])
        render view:'forgotPassword'
        return;
    }

    //Página de reestablecimento de la contraseña una vez se da click en cambiar contraseña desde el correo enviado previamente
    def resetPassword(){
        def conf = SpringSecurityUtils.securityConfig
        def user
        String token = params.t
        String defaultTargetUrl = conf.successHandler.defaultTargetUrl
        
        if(springSecurityService.isLoggedIn()){
            redirect uri: defaultTargetUrl
        }

        def registrationCode = token ? Token.findByTokenAndType(token,2) : null
        if (!registrationCode) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }

        Token.withTransaction { status ->
            user = User.findByUsername(registrationCode.username)
            if (!user) {
                redirect uri: defaultTargetUrl
                return
            }
        }

        if (!user) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }

        flash.message=null
        flash.error=null

        render view:'resetPassword', model:[token:registrationCode.token]
        return
    }

    //Restablece (cambia) la contraseña del usuario
    def restorePassword(){
        def conf = SpringSecurityUtils.securityConfig
        String defaultTargetUrl = conf.successHandler.defaultTargetUrl
        def user
        if(params.token==null){
           render status:'404'
           return
        }
        try{
            user = User.findByUsername(Token.findByToken(params.token).username)
        }
        catch(NullPointerException npe){
            render status:'404'
            return
        }

        def password=params.password
        def password2=params.password2
        if(user!=null){
            def String passValidationRegex = conf.register.password.validationRegex ?conf.register.password.validationRegex:'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$'
            def int minLength = conf.register.password.minLength instanceof Number ? conf.register.password.minLength : 8
            def int maxLength = conf.register.password.maxLength instanceof Number ? conf.register.password.maxLength : 64
            
            if(!(password && password.matches(passValidationRegex)) || !(password && password.length() >= minLength) || !(password && password.length() <= maxLength)){
                flash.message=message(code:'com.security.RegisterCommand.password.error.strength')
                render view:'resetPassword', model:[token:params.token]
                return
            }
            if (password != password2) {
                flash.message= message(code:'com.security.RegisterCommand.password2.error.mismatch')
                render view:'resetPassword', model:[token:params.token]
                return
            }

            def token = Token.findByToken(params.token)
            user.setAccountLocked(false)
            user.setPassword(password)
            user.save(flush:true)
            token.delete(flush:true)
            springSecurityService.reauthenticate user.username
            flash.message = message(code: 'spring.security.register.complete')
            redirect uri: conf.ui.register.postRegisterUrl ?: defaultTargetUrl
            return
        }
    }

    //Muestra la vista que permite Verificar la cuenta mediante el establecimiento de la contraseña (aplica cuando se crea una cuenta desde un usuario ya resgitrado)
    def verifyRegistrationByPass() {
        def conf = SpringSecurityUtils.securityConfig
        def user
        String defaultTargetUrl = conf.successHandler.defaultTargetUrl
        if(springSecurityService.isLoggedIn()){
            println "Error por aca"
            redirect uri: defaultTargetUrl
            return
        }
        String token = params.t
        def registrationCode = token ? Token.findByTokenAndType(token,4) : null
        if (!registrationCode) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }
        Token.withTransaction { status ->

            user = User.findByUsername(registrationCode.username)
            if (!user) {
                 redirect uri: defaultTargetUrl
                return
            }
        }

        if (!user) {
            flash.error = message(code: 'spring.security.register.badCode')
            redirect uri: defaultTargetUrl
            return
        }

        if(user.accountLocked){
            render view:'setPassword', model:[token:registrationCode.token, fullname: user.fullname]
            return
        }

        springSecurityService.reauthenticate user.username
        flash.message = message(code: 'spring.security.register.complete')
        redirect uri: conf.ui.register.postRegisterUrl ?: defaultTargetUrl
    }

    //Verifica la cuenta mediante el establecimiento de la contraseña (aplica cuando se crea una cuenta desde un usuario ya resgitrado)
    def verifyAccountByPassword(){
        def conf = SpringSecurityUtils.securityConfig
        String defaultTargetUrl = conf.successHandler.defaultTargetUrl
        def user
        if(params.token==null){
            render status:'404'
            return
        }
        try{
            user = User.findByUsername(Token.findByToken(params.token).username)
        }
          catch(NullPointerException npe){
            render status:'404'
            return
        }

        def password=params.password
        def password2=params.password2
        if(user!=null){
            def String passValidationRegex = conf.register.password.validationRegex ?conf.register.password.validationRegex:'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$'

            def int minLength = conf.register.password.minLength instanceof Number ? conf.register.password.minLength : 8
            def int maxLength = conf.register.password.maxLength instanceof Number ? conf.register.password.maxLength : 64

            
            if(!(password && password.matches(passValidationRegex)) || !(password && password.length() >= minLength) || !(password && password.length() <= maxLength)){

                flash.message=message(code:'com.security.RegisterCommand.password.error.strength')
                render view:'setPassword', model:[token:params.token, fullname: user.fullname]
                return
            }
            if (password != password2) {
                flash.message= message(code:'com.security.RegisterCommand.password2.error.mismatch')
                render view:'setPassword', model:[token:params.token, fullname: user.fullname]
                return
            }

            def token = Token.findByToken(params.token)
            user.setAccountLocked(false)
            user.setPassword(password)
            user.save(flush:true)
            token.delete(flush:true)

            springSecurityService.reauthenticate user.username


            flash.message = message(code: 'spring.security.register.complete')
            redirect uri: conf.ui.register.postRegisterUrl ?: defaultTargetUrl
            return
            
        }
        render status:'404'
    }

    //Genera los links necesarios para los procesos de registro y cambio de contraseña
    protected String generateLink(String action, linkParams) {
        createLink(base: "$request.scheme://$request.serverName:$request.serverPort$request.contextPath",
            controller: 'register', action: action,
            params: linkParams)
    }

    /**********************************************************/
    /***********Métodos de válidación de contraseña************/
    /**********************************************************/

    static final passwordValidator = { String password, command ->
        if (command.username && command.username.equals(password)) {
            return 'com.security.RegisterCommand.password.error.username'
        }

        if (!checkPasswordMinLength(password, command) ||
            !checkPasswordMaxLength(password, command) ||
            !checkPasswordRegex(password, command)) {
            return 'com.security.RegisterCommand.password.error.strength'
        }
    }

    static boolean checkPasswordMinLength(String password, command) {
        def conf = SpringSecurityUtils.securityConfig

        int minLength = conf.register.password.minLength instanceof Number ? conf.register.password.minLength : 8

        password && password.length() >= minLength
    }

    static boolean checkPasswordMaxLength(String password, command) {
        def conf = SpringSecurityUtils.securityConfig

        int maxLength = conf.register.password.maxLength instanceof Number ? conf.register.password.maxLength : 64

        password && password.length() <= maxLength
    }

    static boolean checkPasswordRegex(String password, command) {
        def conf = SpringSecurityUtils.securityConfig

        String passValidationRegex = conf.register.password.validationRegex ?conf.register.password.validationRegex:'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$'

        password && password.matches(passValidationRegex)
    }

    static final password2Validator = { value, command ->
        if (command.password != command.password2) {
            return 'com.security.RegisterCommand.password2.error.mismatch'
        }
    }
}

//Clase auxiliar que ayuda en el proceso de registro
class RegisterCommand {

    String username
    String password
    String password2
    String fullname
    Long phone
    Long mobile
    Integer extension
    String address
    String organization
    Boolean offersChk = false

    public RegisterCommand(){
    }

    static constraints = {
        fullname blank: false, nullable: false
        phone blank: true, nullable: true, validator: {
                if (it && (it <= 1000000 ||  it >= 99999999999999999999)) return ['phoneRange']
                } 
        mobile blank: false, nullable: false, validator: {
                if(it <= 1000000000 ||  it >= 999999999999) return ['celRange']
                } 
        extension blank: true, nullable: true     
        address blank: false, nullable: false
        organization blank: false, nullable: false
        username blank: false,email:true, validator: { value, command ->
            if (value) {
                if (User.findByUsername(value)) {
                    return 'registerCommand.username.unique'
                }
            }
        }
        password blank: false, validator: RegisterController.passwordValidator
        password2 validator: RegisterController.password2Validator
    }
}