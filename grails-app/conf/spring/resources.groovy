// Place your Spring DSL code here
import com.security.MyUserDetailsService
import com.helpers.*
import org.springframework.context.MessageSource 

beans = { 
    userDetailsService(MyUserDetailsService)
   
    /*messageSource(DatabaseMessageSource) {
        messageBundleMessageSource = ref("messageBundleMessageSource")
    }*/

    messageBundleMessageSource(org.grails.spring.context.support.PluginAwareResourceBundleMessageSource) {
         basenames = "WEB-INF/grails-app/i18n/messages"
    }
}