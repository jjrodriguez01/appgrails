package com.security

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import javax.servlet.http.HttpSession;
import com.model.Project
import com.model.UserProject
import com.model.VProjectUser
import com.model.ValidatorProject


@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

	private static final long serialVersionUID = 1

	transient springSecurityService


	String username
	String password
	boolean enabled = true
	boolean accountExpired = false
	boolean accountLocked
	boolean passwordExpired = false
	boolean offersChk = false
	String fullname ="N/A"
	String phone="N/A"
	String mobile="N/A"
	Integer extension
	Integer numeroDeImagenesEvidenciaPorCaso = 1
	Integer numeroDeLicencias =5
	String address ="N/A"
	String organization ="N/A"
	Integer plan //0: demo, 1:Gold, 2:Platinum
	User associatedClient
	static hasMany =[ users:User]
	Date lastWebAction
	Date lastDesktopAction
	Date licenseExpirationDate
	Date dateCreated
	String avatarFile =""
	String browsers =''
	Boolean firstTimeLogged;
	Boolean firstPay = false
	Boolean suscription = false
	Boolean cancelationPending = false





	public User(String username, String password, String fullname,String phone, String mobile, String address, String organization,Integer plan, User associatedClient,boolean offersChk, Date licenseExpirationDate) {
		this()
		this.firstTimeLogged =  true
		this.username = username.toLowerCase();
		this.password = password;
		this.fullname = fullname;
		this.phone = phone;
		this.mobile = mobile;
		this.address = address;
		this.organization = organization;
		this.dateCreated = new Date()
		this.associatedClient = associatedClient
		this.licenseExpirationDate = licenseExpirationDate
		if (this.licenseExpirationDate==null && plan !=0 && plan !=4){
			def Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.YEAR,1)
			this.accountLocked = true
			this.licenseExpirationDate = calendar.getTime();
		}
		else if(this.licenseExpirationDate==null && plan ==0){
			def Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.YEAR,100)
			this.licenseExpirationDate = calendar.getTime();
			this.accountLocked = true
		}
		else if(this.licenseExpirationDate==null && plan ==4){
			def Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.YEAR,100)
			this.licenseExpirationDate = calendar.getTime();
			this.accountLocked = false
		}

		this.plan = plan;
		switch(plan){
			case 0:
				this.numeroDeImagenesEvidenciaPorCaso = 1;
				this.numeroDeLicencias = 1;
				break;
			case 1:
				this.numeroDeImagenesEvidenciaPorCaso = 20;
				this.numeroDeLicencias = 5;
				break;
			case 2:
				this.numeroDeImagenesEvidenciaPorCaso = 50;
				this.numeroDeLicencias = 50;
				break;
			case 3:
				this.numeroDeImagenesEvidenciaPorCaso = 50;
				this.numeroDeLicencias = 200;
				break;
			case 4:
				this.numeroDeImagenesEvidenciaPorCaso = 1;
				this.numeroDeLicencias = 50000000;
				break;
			default:
				this.numeroDeImagenesEvidenciaPorCaso = 1;
				this.numeroDeLicencias = 1;
				break;
		}
	}



	Set<Role> getAuthorities() {
		UserRole.findAllByUser(this)*.role
	}

	def beforeInsert() {
		if(password!=null)
			encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	def boolean isDemo(){
	 	return this.plan==0?true:false
 	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}

	static transients = ['springSecurityService']

	static constraints = {
		username blank: false, unique: true, email:true
		password blank: false, nullable:true
		fullname blank: false, nullable: false
		phone blank: true, nullable: true
		mobile blank: false, nullable: false
		extension blank: true, nullable: true
		address blank: false, nullable: false
		organization blank: false, nullable: false
		associatedClient blank: false, nullable: true
		lastWebAction nullable:true
		lastDesktopAction nullable:true
		avatarFile blank:true, nullable:false
		offersChk blank:false, nullable:false 
		plan blank:false, nullable:false
		browsers nullable:true, blank:true
		cancelationPending nullable:true
		firstPay nullable:true
		suscription nullable:true
	}

	static mapping = {
		password column: '`password`'
		table 'thunderUser'
		version false
		sort 'dateCreated'
		cancelationPending defaultValue: false 
		firstPay defaultValue: false
		suscription defaultValue: false
	}


	def getBasicUsers(){
		if(this.plan!=0){
			if(this.associatedClient && this.associatedClient.username!="superclient@qvision.com")
				return getBasicUsersForLeader()
			return this.users
		}
		else 
			return this.users
	}
	
	def getBasicUsersForLeader(){
		def usersToReturn=[]
		if(this.associatedClient.username!="superclient@qvision.com"){
			for(User user in  this.associatedClient.users){
				if(user.username!= this.username ){
					def roles=user.getAuthorities()
					def flag= true;
					for(def role in roles)
					{
						if(role.getAuthority() == "ROLE_CLIENT") {
							flag=false;
							break;
						}
						
					}
					if(flag && usersToReturn.indexOf(user)==-1)
						usersToReturn.add(user)
				}
			}
		}
		return usersToReturn
	}



	Set<Project> getProjects() {
		UserProject.findAllByUser(this)*.project
	}

	Set<ValidatorProject> getValidatorProjects() {
		VProjectUser.findAllByUser(this)*.validationProject
	}

	void addToProjects(project){
		UserProject.create(this, project).save(flush:true,failOnError:true)
		
	}

	void addToVProjects(project){
		VProjectUser.create(this, project).save(flush:true,failOnError:true)
		
	}

	void removeFromProjects(project){
		if(UserProject.findByUserAndProject(this, project)!=null)
			UserProject.findByUserAndProject(this, project).delete(flush:true)
	}

	void removeFromVProjects(project){
		if(VProjectUser.findByUserAndValidationProject(this, project)!=null)
			VProjectUser.findByUserAndValidationProject(this, project).delete(flush:true)
	}


}
