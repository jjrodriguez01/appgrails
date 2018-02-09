//Tamaño de los archivos que se suben en los formularios
grails.controllers.upload.maxFileSize=16000000
grails.controllers.upload.maxRequestSize=16100000

// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'com.security.User'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'com.security.UserRole'
grails.plugin.springsecurity.authority.className = 'com.security.Role'

//Added by hand
	grails.plugin.springsecurity.logout.postOnly = false
	grails.plugin.springsecurity.logout.clearAuthentication = true
	grails.plugin.springsecurity.imagesDir = "objImages/"
	grails.plugin.springsecurity.useHttpSessionEventPublisher = true

	//password requirements 
	grails.plugin.springsecurity.register.password.minLength=8
	grails.plugin.springsecurity.register.password.maxLength=64
	grails.plugin.springsecurity.register.password.validationRegex='^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).*$'

grails.plugin.springsecurity.controllerAnnotations.staticRules = [
	[pattern: '/',               access: ['permitAll']],
	[pattern: '/error',          access: ['permitAll']],
	[pattern: '/index',          access: ['permitAll']],
	[pattern: '/index.gsp',      access: ['permitAll']],
	[pattern: '/shutdown',       access: ['permitAll']],
	[pattern: '/assets/**',      access: ['permitAll']],
	[pattern: '/mapper/**',      access: ['permitAll']],
	[pattern: '/simpleCaptcha/**', access:['permitAll']],
	[pattern: '/dbconsole/**',   access: ['permitAll']],
	[pattern: '/**/js/**',       access: ['permitAll']],
	[pattern: '/**/css/**',      access: ['permitAll']],
	[pattern: '/**/images/**',   access: ['permitAll']],
	[pattern: '/**/Logo.ico', access: ['permitAll']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
	[pattern: '/assets/**',      filters: 'none'],
	[pattern: '/**/js/**',       filters: 'none'],
	[pattern: '/**/css/**',      filters: 'none'],
	[pattern: '/**/images/**',   filters: 'none'],
	[pattern: '/**/favicon.ico', filters: 'none'],
	[pattern: '/**',             filters: 'JOINED_FILTERS']
]



//Mail plugin configuration

grails {
  	mail {
		host = "mail.thundertest.com"
        port = 468
        username = "no-reply@thundertest.com"
        password = "fm8Ao^72"
        props = ["mail.transport.protocol":"smtp",                
                  "mail.smtp.auth":"true", ]
	  }
}



//Redirection configuration depending on the current enviroment
environments {
	development {
		redirection.commercial.url = "http://192.168.100.44:8080/"
		redirect.url="http://localhost:8081"
		//redirection.commercial.url = "http://localhost:8080/"
		pathToPhantomJS = "D:/phantomjs-2.1.1-windows/bin/phantomjs"
		pathToRasterizeJS = "D:/phantomjs-2.1.1-windows/examples/rasterize.js"
		paperSize = "A4"
	}
	production {
		redirection.commercial.url = "http://www.thundertest.com/"
		redirect.url="http://www.thundertest.com"
		pathToPhantomJS = "phantomjs"
		pathToRasterizeJS = "/home/phantomjs/phantomjs-2.1.1/examples/rasterize.js"
		paperSize = "A4"
	}
	test {
		redirection.commercial.url = "http://192.168.100.240:8080/"
		redirect.url="http://localhost:8080"
		pathToPhantomJS = "phantomjs"
		pathToRasterizeJS = "/home/phantomjs/phantomjs-2.1.1/examples/rasterize.js"
		paperSize = "A4"
	}
	preproduction{
		redirection.commercial.url = "http://69.73.183.153:8484/"
	}
	
}



