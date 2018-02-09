package com.helpers

class Token {

	String username
	Integer type //1:account registration, 2:passwordChange, 3:desktopSessionToken, 4:account registration by password (for users created from client and leader roles), 5: Web session token
	String token
	Date dateCreated

	public Token(String username, Integer type){
		this.type = type
		this.username=username
		this.token = UUID.randomUUID().toString().replaceAll('-', '');
		this.dateCreated = new Date();
		
	}

	public Token(String username, Integer type, String token){
		this.type = type
		this.username=username
		this.token = token
		this.dateCreated = new Date();
		
	}

    static constraints = {
    }

    static mapping={
    	version false
    }
}
