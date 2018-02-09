package com.security

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.userdetails.GrailsUserDetailsService
import grails.plugin.springsecurity.userdetails.NoStackUsernameNotFoundException
import grails.transaction.Transactional
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UsernameNotFoundException

class MyUserDetailsService implements GrailsUserDetailsService {

   /**
    * Some Spring Security classes (e.g. RoleHierarchyVoter) expect at least
    * one role, so we give a user with no granted roles this one which gets
    * past that restriction but doesn't grant anything.
    */
   static final List NO_ROLES = [new SimpleGrantedAuthority(SpringSecurityUtils.NO_ROLE)]

   UserDetails loadUserByUsername(String username, boolean loadRoles)
         throws UsernameNotFoundException {
      return loadUserByUsername(username)
   }

   @Transactional(readOnly=true, noRollbackFor=[IllegalArgumentException, UsernameNotFoundException])
   UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
      username=username.toLowerCase()
      User user = User.findByUsername(username)
      if (!user) throw new NoStackUsernameNotFoundException()

      def authorities = user.authorities.collect {
         new SimpleGrantedAuthority(it.authority)
      }

      return new MyUserDetails(user.username, user.password, user.enabled,
            !user.accountExpired, !user.passwordExpired,
            !user.accountLocked, authorities ?: NO_ROLES, user.id,
            user.fullname,user.organization, user.avatarFile, user.phone, user.extension?user.extension:0, user.mobile, user.address, user.getPlan(), user.suscription)
   }
}