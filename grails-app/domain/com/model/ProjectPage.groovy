package com.model

class ProjectPage {

	Project project
	Page page
	
    public ProjectPage(Project project, Page page) {
		super();
		this.project = project;
		this.page = page;
	}


	static constraints = {
    }
}
