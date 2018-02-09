<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Thunder-Test</title>
	<meta name="description" content="Pagina principal de Thunder Test">
	<meta name="author" content="Thundertest">
	<meta
	content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'
	name='viewport'>

	<!-- Bootstrap -->
	<asset:stylesheet src="bootstrap.min.css" />
	<!-- FontAwesome -->
	<asset:stylesheet src='font-awesome/css/font-awesome.css'/>

	<!-- Ionicons -->
	<asset:stylesheet src='ionicons-master/css/ionicons.min.css'/>

	<!-- Skin style -->
	<asset:stylesheet src='skin-blue.css'/>

	<!-- Theme style -->
	<asset:stylesheet src='AdminLTE.css'/>

	<!-- Custom (css propio desarrollado en qv)-->
	<asset:stylesheet src='custom.css'/>

	<script>
	Date.prototype.adjustDate = function(offset) {
		console.log(this)
	    var now = new Date()
		var localOffset = now.getTimezoneOffset();
		var offsetServer = offset
		var modifiedDate = new Date(this.getTime()-((offsetServer+localOffset)*60000))
		var yyyy = modifiedDate.getFullYear().toString();
		var mm = (modifiedDate.getMonth()+1).toString(); // getMonth() is zero-based
	   	var dd  = modifiedDate.getDate().toString();
	   	var hh = modifiedDate.getHours().toString();
	   	var mi = modifiedDate.getMinutes().toString();
	   	var ss = modifiedDate.getSeconds().toString();
	   	return yyyy +"-"+ (mm[1]?mm:"0"+mm[0]) +"-"+ (dd[1]?dd:"0"+dd[0]) + " " + (hh[1]?hh:"0"+hh[0]) + ":" + (mi[1]?mi:"0"+mi[0]) + ":" + (ss[1]?ss:"0"+ss[0]); // padding
	  };
	</script>


	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	         <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"> </script>
	         <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"> </script>
	         <![endif]-->
	     <asset:link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>

	     </head>
	     <body class="skin-blue sidebar-mini"  >
	     	<div class="wrapper">
	     		<header class="main-header">
	     			<!-- Logo -->
	     			<a href="${createLink(controller: 'user', action:'renderIndex')}" class="logo have-tooltip"  data-content="Inicio" style="background-color:#222d32;"> <!-- mini logo for sidebar mini 50x50 pixels -->
	     				<span class="logo-mini" id="miniLogo"> <asset:image src="logos/logo-mini.png" />
	     				</span> <!-- logo for regular state and mobile devices --> <span style="padding-bottom:10px"
	     				class="logo-lg"> <asset:image src="logos/logo.png" />
	     			</span>
	     			</a>
	     		<!-- Header Navbar: style can be found in header.less -->
	     		<nav class="navbar navbar-static-top" role="navigation" style="">
	     			<!-- Sidebar toggle button-->
	     			<a href="#" class="sidebar-toggle" data-toggle="offcanvas"
	     			role="button" id="miniCanvasButton"> <span class="sr-only">Toggle navigation </span>
	     			</a>
	     		<div class="navbar-custom-menu">
	     			<ul class="nav navbar-nav">
	     				<sec:ifAllGranted roles="ROLE_DEMO">
			     			<li id="upgradeLi" class="have-realtime-tooltip"  title="${message(code:'tooltip.upgrade.title')}" data-content="${message(code:'tooltip.upgrade.text')}" data-placement="bottom" style=" background-color:#F39C12">
								<a target="_blank" href="${createLink(controller:'redirect', action:'upgrade')}"  ><g:message code='navBar.upgrade'/> </i></a>
							</li>
						</sec:ifAllGranted>
						<li class="have-realtime-tooltip"  data-content="${message(code:'tooltip.downloadIntaller.text')}" data-placement="bottom">
							<a href="${createLink(controller:'redirect', action:'descargaInstaller')}">
								 <i class="fa fa-cloud-download"></i>
							</a>
	     				</li>


	     				<li class="have-realtime-tooltip"  title="${message(code:'tooltip.help.title')}" data-content="${message(code:'tooltip.help.text')}" data-placement="bottom">
							<a href="${createLink(controller:'help', action:'index')}"  > <i class="fa fa-question-circle" style="color:white"> </i>
		     				</a>
						</li>





						<li class="have-realtime-tooltip"  title="${message(code:'tooltip.executions.title')}" data-content="${message(code:'tooltip.executions.text')}" data-placement="bottom">
							<a href="${createLink(controller:'execution', action:'index')}" class="dropdown-toggle" > <i class="fa fa-play" style="color:#34F77B"> </i>
		     				</a>
						</li>
						<li style="border: 1px solid #337F9C; height:44px; margin-top:3px; margin-bottom:3px"></li>

	     				<li id="messagesNews" class="dropdown messages-menu have-realtime-tooltip"  data-content="${message(code:'tooltip.messages.title')}"  data-placement="bottom">
		     				<a href="#" class="dropdown-toggle" data-toggle="dropdown"> <i class="fa fa-envelope-o"> </i>
		     					<span id="messagesQty"class="label label-success">${notifications.messagesCount}</span>
		     				</a>
			     			<ul class="dropdown-menu" id="messagesBox">
			     				<li class="header" id="messagesHeader">
			     					<g:message code='general.youHave'/> ${notifications.messagesCount} <g:message code='general.messages'/>
			     				</li>
			     				<li>
			     					<!-- inner menu: contains the actual data -->
			     					<ul class="menu" id="messagesBody">
										<g:each in="${notifications.messages}" var="message" status="i">
											<g:if test="${i%2==0}">
												<li alertid="${message.id}" style="background-color:#D9F2FA">
											</g:if>
											<g:else>
												<li alertid="${message.id}">
											</g:else>
												<div>
													<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i>
													</small>
												</div>
												<br/>
												<div style="margin-left:5px">
													<a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa ${message.iconClass}" style="color:${message.iconColor}"></i> <g:message code="${message.message}"/></a>
												<div>
												<br/>
											</li>
										</g:each>

	     							</ul>
	     						</li>
	     					</ul>
	     				</li>

	     				<li id="notificationsNews" class="dropdown notifications-menu have-realtime-tooltip" data-content="${message(code:'tooltip.notifications.title')}"  data-placement="bottom">
		     				<a href="#" class="dropdown-toggle" data-toggle="dropdown">
		     					<i class="fa fa-bell-o"> </i> <span id="notificationsQty" class="label label-warning"> ${notifications.notificationsCount}
		     					</span>
		     				</a>
				     		<ul class="dropdown-menu" id="notificationsBox">
				     			<li class="header" id="notificationsHeader">
				     				<g:message code='general.youHave'/> ${notifications.notificationsCount} <g:message code='general.notifications'/>
				     			</li>
				     			<li>
				     				<!-- inner menu: contains the actual data -->
				     				<ul class="menu" id="notificationsBody">
											<g:each in="${notifications.notifications}" var="notification" status="i">
												<g:if test="${i%2==0}">
													<li alertid="${notification.id}" style="background-color:#D9F2FA">
												</g:if>
												<g:else>
														<li alertid="${notification.id}">
												</g:else>
													<div>
														<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i>
														</small>
													</div>
													<br/>
													<div style="margin-left:5px">
														<a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa ${notification.iconClass}" style="color:${notification.iconColor}"></i> <g:message code="${notification.message}"/></a>
													</div>
													<br/>
												</li>

											</g:each>
				     				</ul>
				     			</li>
				     		</ul>
				     	</li>

	     		<li id="alertsNews" class="dropdown tasks-menu have-realtime-tooltip" data-content="${message(code:'tooltip.alerts.title')}"  data-placement="bottom"><a href="#"
	     			class="dropdown-toggle" data-toggle="dropdown"> <i
	     			class="fa fa-flag-o"> </i> <span class="label label-danger" id="alertsQty">${notifications.alertsCount}
	     		</span>
	     	</a>
	     	<ul class="dropdown-menu" id="alertsBox">
	     		<li class="header" id="alertsHeader">
	     				<g:message code='general.youHave'/> ${notifications.alertsCount} <g:message code='general.alerts'/>

	     		</li>
	     		<li>
	     			<!-- inner menu: contains the actual data -->
	     			<ul class="menu" id="alertsBody">
	     					<g:each in="${notifications.alerts}" var="alert" status="i">
	     						<g:if test="${i%2==0}">
									<li alertid="${alert.id}" style="background-color:#D9F2FA">
								</g:if>
								<g:else>
									<li alertid="${alert.id}">
								</g:else>
									<div>
										<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i>
										</small>
									</div>
									<br/>
									<div style="margin-left:5px">
										<a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa ${alert.iconClass}" style="color:${alert.iconColor}"></i> <g:message code="${alert.message}"/></a>
									</div>
									<br/>
									</li>
							</g:each>

	     			</ul>
	     		</li>
	     	</ul></li>
	     	<!-- User Account: style can be found in dropdown.less -->
	     	<li style="border: 1px solid #337F9C; height:44px; margin-top:3px; margin-bottom:3px"></li>
	     	<li class="dropdown user user-menu"><a href="#"
	     		class="dropdown-toggle" data-toggle="dropdown"><asset:image class="user-image profileImage" id="profileImage"  src="avatars/" alt="User Image"/><span><sec:loggedInUserInfo field="fullName"/></small></span>
	     	</a>
	     	<ul class="dropdown-menu">
	     		<!-- User image -->
	     		<li class="user-header">

	     			<asset:image id="profileImage"  src="avatars/" class="img-circle profileImage" alt="User Image" />

	     			<p>
	     				${sec.username()}<small><sec:loggedInUserInfo field="organization"/></small>
	     			</p></li>
	     			<!-- Menu Body -->
	     			<li class="user-body">
	     				<div class="col-xs-4 text-center">
	     					<a href="${createLink(controller:'help', action:'index')}" class="have-tooltip"   title="${message(code:'tooltip.help.title')}" data-content="${message(code:'tooltip.help.text')}" data-placement="bottom"> <asset:image src="miscellaneous/help.png" /> <br>
	     						<g:message code="navBar.help" />
	     					</a>
	     				</div>
	     				<div class="col-xs-4 text-center">
	     					<a href="?lang=es"> <asset:image src="languages/Spain_flag.png" /> <g:message code="navBar.languages.spanish" />
	     					</a>
	     				</div>
	     				<div class="col-xs-4 text-center">
	     					<a href="?lang=en">  <asset:image src="languages/USA_flag.png" /> <g:message code="navBar.languages.english" />
	     					</a>
	     				</div>
	     			</li>
	     			<!-- Menu Footer-->
	     			<li class="user-footer">
	     				<div class="pull-left">
	     					<a href="${createLink(controller:'user', action:'profile')}" class="btn btn-default btn-flat navLink" ><g:message code="navBar.profile" /> </a>
	     				</div>
	     				<div class="pull-right">
	     					<a href="${createLink(controller:'logout', action:'index')}" class="btn btn-default btn-flat" onclick="flag=true;"> <g:message code="navBar.logout" />
	     					</a>
	     				</div>
	     			</li>
	     		</ul></li>
	     	</ul>
	     </div>
	 </nav>
	</header>

	<!-- Left side column. contains the logo and sidebar -->
	<aside class="main-sidebar" style="" id="aside">
		<!-- sidebar: style can be found in sidebar.less -->
		<section class="sidebar" style="padding-bottom:80px" >
			<!-- Sidebar user panel -->
			<div class="user-panel">
					<div class="pull-left image">
					<g:link controller="user" action="profile" style="max-height:50px">
						<asset:image id="sideProfileImage" src="avatars/" class="img-circle profileImage" alt="User Image" style="max-width:45px;" />
					</g:link>
					</div>
					<div class="pull-left info" style="">
						<p><sec:loggedInUserInfo field="fullName"/></p>

						<a href="#" style=""> <i class="fa fa-circle text-success">  </i> Online
						</a>
					</div>

			</div>

			<!-- sidebar menu: : style can be found in sidebar.less -->
			<ul class="sidebar-menu" id="sideBarMenu">
				<li style="background-color: rgb(30, 40, 44)" class="have-tooltip"   title="${message(code:'tooltip.help.title')}" data-content="${message(code:'tooltip.help.text')}" data-placement="right">
					<g:link controller='help' action='index'>
						<i class="fa fa-question-circle" ></i><span>
						<g:message code="navBar.help"/></span>
					</g:link>
				</li>

				<sec:ifAllGranted  roles='ROLE_CLIENT'>
				<li class="have-tooltip"   title="${message(code:'tooltip.billing.title')}" data-content="${message(code:'tooltip.billing.text')}" data-placement="right">
					<g:link controller='user' action='billing'>
						<i class="fa fa-credit-card" ></i><span>
						<g:message code="navBar.billing"/></span>
					</g:link>
				</li>
				</sec:ifAllGranted >

				<!--Ajuste 04/04/2017 SERGIO MORENO

				<g:if test="${sec.loggedInUserInfo(field:'suscription')}">
				<li class="have-tooltip"   title="${message(code:'tooltip.billing.title')}" data-content="${message(code:'tooltip.billing.text')}" data-placement="right">

					<g:link controller='subscription' action='updateSubscription'>
						<i class="fa fa-usd" ></i><span>
						<g:message code="license.updateTitle"/></span>
					</g:link>
				</li>
				</g:if>

				FIN Ajuste 04/04/2017 SERGIO MORENO-->

				<li class="have-tooltip"   title="${message(code:'tooltip.executions.title')}" data-content="${message(code:'tooltip.executions.text')}" data-placement="right">
					<g:link controller='execution' action='index'>
						<i class="fa fa-play-circle-o" ></i><span>
						<g:message code="general.text.executions"/></span>
					</g:link>
				</li>

				<li class="have-tooltip"   title="${message(code:'tooltip.stage.title')}" data-content="${message(code:'tooltip.stage.text')}" data-placement="right">
					<g:link controller='stage' action='index'>
						<i class="fa fa-exchange"></i><span>
						<g:message code="general.text.stage"/></span>
					</g:link>
				</li>
				<li class="have-tooltip"  title="${message(code:'tooltip.reports.title')}" data-content="${message(code:'tooltip.reports.text')}" data-placement="right">
					<g:link controller='log' action='index'>
						<i class="fa fa-book" ></i><span>
						<g:message code="general.text.evidences"/></span>
					</g:link>
				</li>

				<li class="treeview">
			        <a href="#">
			            <i class="fa fa-product-hunt"></i>
			           		<span><g:message code='general.text.projects'/></span>
			            <i class="fa fa-angle-left pull-right"></i>
			        </a>
			        <ul class="treeview-menu">
						<g:each in='${projects}' var="project">
							<li class="treeview">
					          <a href="#">
					            <i class="fa fa-product-hunt"></i>

						            <g:if test="${project.name.length() < 23}">
						            	<span>
						            		${project.name}
						            	</span>
						            </g:if>
						            <g:else>
						            	<span title="${project.name}" data-toggle="tooltip">
						            		${project.name.substring(0,20)}...
						            	</span>
						            </g:else>

					            <i class="fa fa-angle-left pull-right"></i>
					          </a>
					          <ul class="treeview-menu">

				                <li>
				                  <a href="#"><i class="fa fa-cubes"></i> <g:message code='text.scenarios'/><i class="fa fa-angle-left pull-right"></i></a>
				                  <ul class="treeview-menu">
				                  	<g:each in="${project.scenarios.sort{it.name}}" var="scenario">
				                  	<g:if test="${scenario.enabled}">
				                  		<li>
				                  			<a href="#"><i class="fa fa-cube"></i>
					                  		<g:if test="${scenario.name.length() < 22}">
					                  			<span>${scenario.name}</span>
					                  		</g:if>
					                  		<g:else>
					                  			<span data-toggle="tooltip" title="${scenario.name}">${scenario.name.substring(0,20)}...</span>
					                  		</g:else>
					                  		<i class="fa fa-angle-left pull-right"></i></a>
											<ul class="treeview-menu">
							                 	<li><a href="${createLink(controller:'step', action:'index', id:scenario.id)}" class='navLink'><i class="fa fa-sort-amount-desc"></i><g:message code='text.steps'/></a>
							                 	<li><a href="${createLink(controller:'case', action:'index', id:scenario.id)}" class='navLink'><i class="fa fa-code-fork"></i><g:message code='text.cases'/></a>
							                 	<li><a href="${createLink(controller:'message', action:'scenario', id:scenario.id)}" class='navLink'><i class="fa fa-envelope-o"></i><g:message code='text.messages'/></a>
							                 </ul>
				                  		</li>
				                  	</g:if>	
				                  	</g:each>
				                  </ul>
				                </li>
				                <li>
				                  <a href="#"><i class="fa fa-circle-o"></i> <g:message code='text.pages'/><i class="fa fa-angle-left pull-right"></i></a>
				                  <ul class="treeview-menu">
				                  	<g:each in="${project.pages}" var="page">
				                  		<li><a href="${createLink(controller:'object',action:'index',id:page.id)}?projectId=${project.id}" class='navLink'><i class="fa fa-circle-o"></i>
				                  		<g:if test="${page.name.length() < 23}">
				                  			<span>${page.name}</span>
				                  		</g:if>
				                  		<g:else>
				                  			<span data-toggle="tooltip" title="${page.name}">
				                  				${page.name.substring(0,22)}...
				                  			</span>
				                  		</g:else>
				                  		</a></li>
				                  	</g:each>
				                  </ul>
				                </li>
				             </ul>
							</li>
						</g:each>
					</ul>
				<li  class="treeview">
					<a href="#">
						<i class="fa fa-wrench" ></i><span>
						<g:message code="navBar.moreTools"/></span>
						<!--<i class="fa fa-angle-left pull-right"></i>-->
					</a>
					 <!--<ul class="treeview-menu">
						<li>
					        <a href="${createLink(controller:'validator', action:'index')}">
					            <i class="fa fa-check-square-o"></i>
				            	<span>
				            		<g:message code="navBar.validator"/>
				            	</span>
					        </a>
					    </li>
					</ul>-->
				</li>
			</ul>
		</section>
		<!-- /.sidebar -->
	</aside>

	<asset:javascript src="jquery-2.1.4.js"/>
	<asset:javascript src="bootstrap.min.js"/>
	<asset:javascript src="adminlte.js"/>
	<asset:javascript src="application.js"/>
	<asset:javascript src="sorttable.js"/>
	<asset:javascript src="jquery-sortable.min.js"/>
	<asset:javascript src="jquery.base64.js"/>

	<script>
	var notificationsCount = 0

	$(window).load( function(){

		notificationsCount = 0
		document.addEventListener("click", function(evnt){
    		notificationsCount = 0
		});
		getNotifications()
		 $('[data-toggle="tooltip"]').tooltip({
		 	'container':'body'
		 });
		$('.have-tooltip').popover({
		    trigger: "hover",
		    delay: {show : 1500, hide : 0},
		    container: 'body'
		});

		$('.have-realtime-tooltip').popover({
		    trigger: "hover",
		    delay: {show : 300, hide : 0},
		    container: 'body'
		});

	});


		$(".profileImage").each(function(){
			var originalSrc = $(this).attr("src")
			var complemento = "<sec:loggedInUserInfo field="avatarFile"/>"
			$(this).attr("src", originalSrc+complemento)
		})
		var flag=false;
		var notificationsInterval =null;


	$('#miniCanvasButton').click(function (){

		if(!$('#miniLogo').is(':visible')){
			$('#sideProfileImage').css('width', '35px')
			$('#sideProfileImage').css('height', '35px')
		}
		else{
			$('#sideProfileImage').css('width', '45px')
			$('#sideProfileImage').css('height', '45px')
		}
	})


	function getNotifications() {
		notificationsCount++
				if(notificationsCount == 240+1){
					$('#expiredSessionModal').modal('show');
					window.location.href = '<g:createLink controller="logout" action="index" />';
					return;
				}
				
				$.ajax({
					url :"${createLink(controller:'user',action:'getNotifications')}",
					success : function(result) {
						
						if (!result.activeSession  && !flag) {
							flag=true;
							$('#expiredSessionModal').modal('show');
						}
						else{
							console.log(result.activeSession)
							$('#messagesQty').text(result.messagesCount)
							$('#messagesHeader').text("${message(code:'general.youHave')} "+result.messagesCount+" ${message(code:'general.messages')}")

							if(result.messages.length==0){
								$('#messagesBox').css('height', '50px')
							}
							else if(result.messages.length<4){
								$('#messagesBox').css('height', result.messages.length*80+'px')
							}
							else{
								$('#messagesBox').css('height', '250px')
							}



							$('#notificationsQty').text(result.notificationsCount)
							$('#notificationsHeader').text("${message(code:'general.youHave')} "+result.notificationsCount+" ${message(code:'general.notifications')}")

							if(result.notifications.length==0){
								$('#notificationsBox').css('height', '50px')
							}
							else if(result.notifications.length<4){
								$('#notificationsBox').css('height', result.notifications.length*100+'px')
							}
							else{
								$('#notificationsBox').css('height', '250px')
							}

							$('#alertsQty').text(result.alertsCount)
							$('#alertsHeader').text("${message(code:'general.youHave')} "+result.alertsCount+" ${message(code:'general.alerts')}")


							if(result.alerts.length==0){
								$('#alertsBox').css('height', '50px')
							}
							else if(result.alerts.length<4){
								$('#alertsBox').css('height', result.alerts.length*80+'px')
							}
							else{
								$('#alertsBox').css('height', '250px')
							}

							var messagesHtml=""
							for(var i=0;i<result.messages.length;i++){
								if(result.messages[i].actionNotification==''){
									if(i%2==0){
										messagesHtml+='<li alertid="'+result.messages[i].id+'" style="background-color:#D9F2FA">'
									}
									else{
										messagesHtml+='<li alertid="'+result.messages[i].id+'">'
									}
									messagesHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ new Date(result.messages[i].dateCreated).adjustDate(result.offset)+'</small></div><br/>'
									messagesHtml+='<div style="margin-left:5px"><a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa '+ result.messages[i].iconClass +'" style="color:'+result.messages[i].iconColor+'"></i>  '+ result.messages[i].message+'</a><div><br/></li>'
									}
							}

							$('#messagesBody').html(messagesHtml)
							var notificationsHtml=""
							for(var i=0;i<result.notifications.length;i++){
								if(result.notifications[i].actionNotification==''){
									if(i%2==0){
										notificationsHtml+='<li alertid="'+result.notifications[i].id+'" style="background-color:#D9F2FA">'
									}
									else{
										notificationsHtml+='<li alertid="'+result.notifications[i].id+'">'
									}
									notificationsHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ new Date(result.notifications[i].dateCreated).adjustDate(result.offset)+'</small></div><br/>'
									notificationsHtml+='<div style="margin-left:5px"><a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa '+ result.notifications[i].iconClass +'" style="color:'+result.notifications[i].iconColor+'"></i>  '+ result.notifications[i].message+'</a><div><br/></li>'
								}
							}
							$('#notificationsBody').html(notificationsHtml)

							var alertsHtml=""
							for(var i=0;i<result.alerts.length;i++){
								if(result.alerts[i].actionNotification==''){
									if(result.alerts[i].actionNotification==''){
										if(i%2==0){
										alertsHtml+='<li alertid="'+result.alerts[i].id+'" style="background-color:#D9F2FA">'
										}
										else{
											alertsHtml+='<li alertid="'+result.alerts[i].id+'">'
										}
										alertsHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ new Date(result.notifications[i].dateCreated).adjustDate(result.offset)+'</small></div><br/>'
										alertsHtml+='<div style="margin-left:5px"><a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa '+ result.alerts[i].iconClass +'" style="color:'+result.alerts[i].iconColor+'"></i>  '+ result.alerts[i].message+'</a><div><br/></li>'
									}
								}
							}
							$('#alertsBody').html(alertsHtml)
					}

					},
					error:function(status, text, result, xhr){

						if(result.toLowerCase()=="unauthorized" || result.toLowerCase()=="no autorizado"){
							if(!flag){
								$('#expiredSessionModal').modal('show');
								clearInterval(notificationsInterval)
							}
							flag=true;
						}
					}

					
				});

		}




$('#messagesNews').on('shown.bs.dropdown',function(){
	$('#messagesQty').html('0')
	var ids=""
	$('#messagesBody li').each(function(){
		ids+=$(this).attr('alertid')+","


	})
	$.ajax({
		method: 'POST',
		url: "${createLink(action:'setViewed', controller:'alert')}",
		data:{
			ids: ids,
		},
		success: function(dataCheck) {

		},
		error: function(status, text, result, xhr) {

		}
	});

})


$('#notificationsNews').on('shown.bs.dropdown',function(){
	$('#notificationsQty').html('0')
	var ids=""
	$('#notificationsBody li').each(function(){
		ids+=$(this).attr('alertid')+","
	})
	$.ajax({
		method: 'POST',
		url: "${createLink(action:'setViewed', controller:'alert')}",
		data:{
			ids: ids,
		},
		success: function(dataCheck) {

		},
		error: function(status, text, result, xhr) {

		}
	});
})

$('#alertsNews').on('shown.bs.dropdown',function(){
	$('#alertsQty').html('0')
	var ids=""
	$('#alertsBody li').each(function(){
		ids+=$(this).attr('alertid')+","
	})
	$.ajax({
		method: 'POST',
		url: "${createLink(action:'setViewed', controller:'alert')}",
		data:{
			ids: ids,
		},
		success: function(dataCheck) {

		},
		error: function(status, text, result, xhr) {

		}
	});
});

$('.modal').on('hidden.bs.modal', function() {
	$("body").css('padding-right','0px')
})

</script>
