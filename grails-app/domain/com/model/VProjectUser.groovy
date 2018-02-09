package com.model
import com.security.User

//Relacion muchos a muchos entre "user" y "validatorProject"
class VProjectUser {
	ValidatorProject  validationProject
	User user

	public VProjectUser(user, validationProject){
		this.user = user
		this.validationProject = validationProject
	}

	static VProjectUser create(User user, ValidatorProject project, boolean flush = false) {
		def instance = new VProjectUser(user, project)
		instance.save(flush: flush, insert: true)
		instance
	}

    static constraints = {
    }
}
