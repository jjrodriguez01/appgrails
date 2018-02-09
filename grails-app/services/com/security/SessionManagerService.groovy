package com.security

import grails.transaction.Transactional
import javax.servlet.http.HttpSession;

import com.helpers.Token
@Transactional
class SessionManagerService {


	def static HashMap<String, HttpSession> webSessions = new HashMap<String, HttpSession>()
	def static HashMap<String, HttpSession> desktopSessions = new HashMap<String, HttpSession>()

    def forceLogoutUsers = []

	//this method see if the session you are entering by a request in already active or it makes it active by invalidating the other session for the same username
    def verifySession( username,  session,  type) {
            if(username in forceLogoutUsers){                
                forceLogoutUsers.remove(username)                
                return false
            }

            try{
                if( webSessions.get(username)!=null){
                   webSessions.get(username).getCreationTime() > session.getCreationTime()
                    }
                
                session.getId()
                session.getCreationTime()
            }
                
            catch( IllegalStateException iee){
                println "exception controlled: "+iee.getMessage()
                webSessions.remove(username)
                verifySession(username, session, type)
            }
    
            if(type==0){
               if(webSessions.get(username)==null){
                    webSessions.put(username, session)
                    return true;
               }
               if(webSessions.get(username).getId().equals(session.getId())){
                return true;
               }
               if(webSessions.get(username).getCreationTime()>session.getCreationTime()){
                    return false;
               }
               if(webSessions.get(username).getCreationTime()<session.getCreationTime()){
                    webSessions.put(username, session)
                    return true;
               }

    		}
    		else if (type==1){
    			return true
    		}
    		return false;
    		
    	
    }

    def isWebLoggedIn(String username, Date lastWebAction){
    	if(webSessions.get(username)==null){
    		return 'false';
    	}
    	if(secDiff(lastWebAction,new Date())>18){
    		webSessions.remove(username)
    		return 'false';
    	}
    	return 'true';
    }

    def isDesktopLoggedIn(String username,Date lastDesktopAction){
        def token = Token.findByUsernameAndType(username,3)
		if(token==null){
    		return 'false';
    	}
    	if(secDiff(lastDesktopAction,new Date())>8){
    		desktopSessions.remove(username)
    		return 'false';
    	}
    	return 'true';
    }



    def desktopLogout(username){
        desktopSessions.remove(username)
    }

	def secDiff(Date earlierDate, Date laterDate)
	{

		if( earlierDate == null || laterDate == null ) return 0;
		def dif= (int)((laterDate.getTime()/1000) - (earlierDate.getTime()/1000));
		return dif
	}

    def logoutUser(String username){        
        forceLogoutUsers.push(username)        
    }

}
