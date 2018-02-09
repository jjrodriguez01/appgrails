

import grails.plugin.springsecurity.userdetails.GrailsUser
import org.springframework.security.core.GrantedAuthority
import com.helpers.Token
import java.util.TimeZone

class MyUserDetails extends GrailsUser {

   final String fullName
   final String organization
   final String avatarFile
   final String phone
   final Integer extension
   final String mobile
   final String address
   final Integer plan
   final Integer offset
   final Boolean suscription 

   MyUserDetails(String username, String password, boolean enabled,
                 boolean accountNonExpired, boolean credentialsNonExpired,
                 boolean accountNonLocked,
                 Collection<GrantedAuthority> authorities,
                 long id, String fullname, String organization, String avatarFile, String phone, Integer extension, String mobile, String address, Integer plan, Boolean suscription) {
      super(username, password, enabled, accountNonExpired,
            credentialsNonExpired, accountNonLocked, authorities, id)


      def length = fullname.length()
      if(length>21){
        def firstPartNewie = fullname.substring(0,21)
        def lastSpace = firstPartNewie.lastIndexOf(' ') 
        if(lastSpace>0){
          this.fullName = fullname.substring(0, lastSpace)
        }
        else{
          this.fullName = firstPartNewie
        }
        
      }
      else{
              this.fullName = fullname
      }

      this.organization = organization
      this.avatarFile = avatarFile
      this.phone = phone
      this.mobile = mobile
      this.extension = extension
      this.address = address
      this.plan = plan+1
      TimeZone tz = Calendar.getInstance().getTimeZone();
      this.offset = tz.getRawOffset()/60000
      this.suscription = suscription
     

   }
}