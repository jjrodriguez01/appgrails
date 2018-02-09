package com.model

import com.security.User;
import java.util.Date;

class Project {
	String name
	String description
	Date dateCreated
	Date lastUpdated
	User creator
	User lastUpdater
	static hasMany =[scenarios:Scenario, logs:ExecutionLog]

	def Set<Page> getPages() {
		ProjectPage.findAllByProject(this)*.page
	}
	
	def void addToPages(page) {
		new ProjectPage(this, page).save(flush:true,failOnError:true)
	}
	
	

    public Project(String name, String description, User creator) {
		this();
		this.name = name;
		this.description = description;
		this.creator = creator;
		this.lastUpdater=creator;
	}

	static constraints = {
		name blank:false,  nullable:false
		description blank:false,  nullable:false
		creator nullable:false
    }
	
	static mapping ={
		version false
		description  sqlType: "TEXT"
		name 		 sqlType: "TEXT"
	}


	//Validator que garantiza que el cliente asociado al usuario no tiene dos proyectos con el mismo nombre
	 static final projectValidator = { value, project ->
        if (Project.countByNameAndCreator(project.name, project.creator.associatedClient)>0) {
            return 'com.model.project.name.error.unique'
        }
    }
}
