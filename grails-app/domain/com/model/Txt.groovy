package com.model

import com.security.User

class Txt {

	User creator
    String name

    public Txt(User creator, String name){
        this.creator = creator
        this.name = name
    }

	static hasMany=[rows:Row]

    static constraints = {
    }
    static mapping={
    	version false
    }

    //public int getRemainingData(){
    //	return rows.size()
    //}
}
