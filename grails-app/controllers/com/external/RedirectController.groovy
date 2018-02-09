package com.external

import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.servlet.support.RequestContextUtils;
import com.security.User

@Secured('permitAll')
class RedirectController {

	def springSecurityService
	//def grailsApplication

    def commercialHome(){
    	def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/renderIndex?lang='+locale)
		return
	}
	def commercialLicense(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/licenses?lang='+locale)
		return
	}
	def commercialFeatures(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/features?lang='+locale)
		return
	}
	def commercialDemo(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/demo?lang='+locale)
		return
	}

	def commercialBlog(){
		def locale = RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'post/index?lang='+locale)
		return
	}
	def commercialContact(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/contact?lang='+locale)
		return
	}
	def principal(){
		redirect controller:'user', action:'renderIndex'
	}

	def termsAndConditions(){
		println "asdfasdf"
		render view:'/comercial/termsAndConditions'
	}

	def descargaInstaller(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def config = grailsApplication.config
		redirect(url:config.redirection.commercial.url+'redirect/descargaInstaller?lang='+locale)
		return
	}

	@Secured('ROLE_USER_LEADER')
	def upgrade(){
		def locale = params.locale?params.locale:RequestContextUtils.getLocale(request)
		def user= User.findByUsername(springSecurityService.getPrincipal().getUsername())
		def config = grailsApplication.config
		redirect uri:config.redirection.commercial.url+'redirect/license', params:[eXklU6:user.username.bytes.encodeBase64().toString(), n9tYCgf:user.fullname.bytes.encodeBase64().toString(), mVwXyOz:user.mobile.bytes.encodeBase64().toString(), lang:locale.getLanguage()]

	}

}
