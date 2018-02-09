<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Thunder-Test</title>
	<meta name="description" content="Pagina principal de Thunder Test">
	<meta name="author" content="QVision">
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


	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	         <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"> </script>
	         <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"> </script>
	         <![endif]-->
	         <link rel="shortcut icon" href="/assets/logos/Logo.ico" type="image/x-icon" />  

	     </head>
	     <body class="skin-blue sidebar-mini"  >
	     	<div class="wrapper">
	     		<header class="main-header">
	     			<!-- Logo -->
	     			<a href="${createLink(controller: 'user', action:'renderIndex')}" class="logo"> <!-- mini logo for sidebar mini 50x50 pixels -->
	     				<span class="logo-mini"> <asset:image src="logos/logo-mini.png" />
	     				</span> <!-- logo for regular state and mobile devices --> <span style="padding-bottom:10px"
	     				class="logo-lg"> <asset:image src="logos/logo.png" /> 
	     			</span>
	     		</a>
	     		<!-- Header Navbar: style can be found in header.less -->
	     		<nav class="navbar navbar-static-top" role="navigation">
	     			<!-- Sidebar toggle button-->
	     			<a href="#" class="sidebar-toggle" data-toggle="offcanvas"
	     			role="button"> <span class="sr-only">Toggle navigation </span>
	     		</a>
	     		<div class="navbar-custom-menu">
	     			<ul class="nav navbar-nav">
	     				<li class="have-tooltip" title="${message(code:'tooltip.help.title')}" data-content="${message(code:'tooltip.help.text')}" data-placement="bottom">
							<a href="${createLink(controller:'help', action:'index')}"  > <i class="fa fa-question-circle" style="color:white"> </i> 
		     				</a>
						</li>
						<li class="have-tooltip" title="${message(code:'tooltip.executions.title')}" data-content="${message(code:'tooltip.executions.text')}" data-placement="bottom">
							<a href="${createLink(controller:'execution', action:'index')}" class="dropdown-toggle" > <i class="fa fa-play" style="color:#34F77B"> </i> 
		     				</a>
						</li>
						<li style="border: 1px solid #337F9C; height:44px; margin-top:3px; margin-bottom:3px"></li>

	     				<li id="messagesNews" class="dropdown messages-menu"><a href="#"
	     					class="dropdown-toggle" data-toggle="dropdown"> <i
	     					class="fa fa-envelope-o"> </i> <span id="messagesQty"class="label label-success">${notifications.messagesCount}
	     				</span>
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
											<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> ${message.dateCreated.toString().substring(0,16)}
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
	     			</ul></li>

	     			<!-- Notifications: style can be found in dropdown.less -->
	     			<li id="notificationsNews" class="dropdown notifications-menu"><a href="#"
	     				class="dropdown-toggle" data-toggle="dropdown"> <i
	     				class="fa fa-bell-o"> </i> <span id="notificationsQty" class="label label-warning"> ${notifications.notificationsCount}
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
											<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> ${notification.dateCreated.toString().substring(0,16)}
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
	     		</ul></li>

	     		<!-- Alerts: style can be found in dropdown.less -->
	     		<li id="alertsNews" class="dropdown tasks-menu"><a href="#"
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
										<small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> ${alert.dateCreated.toString().substring(0,16)}
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
	     	<li class="dropdown user user-menu"><a href="#"
	     		class="dropdown-toggle" data-toggle="dropdown"><asset:image class="user-image profileImage" id="profileImage"  src="avatars/" alt="User Image"/><span> <sec:loggedInUserInfo field="fullName"/></span>
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
	     					<a href="#"> <asset:image src="miscellaneous/help.png" /> <br>
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
	     					<a href="${createLink(controller:'user', action:'profile')}" class="btn btn-default btn-flat navLink"><g:message code="navBar.profile" /> </a>
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
	<aside class="main-sidebar">
		<!-- sidebar: style can be found in sidebar.less -->
		<section class="sidebar">
			<!-- Sidebar user panel -->
			<div class="user-panel">
				<div class="pull-left image">
					<asset:image id="profileImage" src="avatars/" class="img-circle profileImage" alt="User Image" /> 
				</div>
				<div class="pull-left info">
					<p><sec:loggedInUserInfo field="fullName"/></p>

					<a href="#"> <i class="fa fa-circle text-success"> </i> Online
					</a>
				</div>
			</div>

			<!-- sidebar menu: : style can be found in sidebar.less -->
			<ul class="sidebar-menu" id="sideBarMenu">

			<!--Ajuste 04/04/2017 SERGIO MORENO

				<li>

					<g:link controller='subscription' action='updateSubscription'>
						<i class="fa fa-usd" ></i><span>
						<g:message code="license.updateTitle"/></span>
					</g:link>
				</li>

				FIN Ajuste 04/04/2017 SERGIO MORENO-->
				

				<li>
					<g:link controller='execution' action='index'>
						<i class="fa fa-play-circle-o" ></i><span>
						<g:message code="general.text.executions"/></span>
					</g:link>
				</li>

				<li>
					<g:link controller='stage' action='index'>
						<i class="fa fa-exchange"></i><span>
						<g:message code="general.text.stage"/></span>
					</g:link>
				</li>
				<li>
					<g:link controller='log' action='index'>
						<i class="fa fa-book" ></i><span>
						<g:message code="general.text.reports"/></span>
					</g:link>
				</li>


				<g:each in='${projects}' var="project">
					<li class="treeview">
			          <a href="#">
			            <i class="fa fa-product-hunt"></i> <span>${project.name}</span>
			            <i class="fa fa-angle-left pull-right"></i>
			          </a>
			          <ul class="treeview-menu">
		             
		                <li>
		                  <a href="#"><i class="fa fa-cubes"></i> <g:message code='text.scenarios'/><i class="fa fa-angle-left pull-right"></i></a>
		                  <ul class="treeview-menu">
		                  	<g:each in="${project.scenarios}" var="scenario">
		                  		<li><a href="#"><i class="fa fa-cube"></i> ${scenario.name}<i class="fa fa-angle-left pull-right"></i></a>
									<ul class="treeview-menu">
					                 	<li><a href="${createLink(controller:'step', action:'index', id:scenario.id)}" class='navLink'><i class="fa fa-sort-amount-desc"></i><g:message code='text.steps'/></a>
					                 	<li><a href="${createLink(controller:'case', action:'index', id:scenario.id)}" class='navLink'><i class="fa fa-code-fork"></i><g:message code='text.cases'/></a>
					                 	<li><a href="${createLink(controller:'message', action:'scenario', id:scenario.id)}" class='navLink'><i class="fa fa-envelope-o"></i><g:message code='text.messages'/></a>
					                 </ul>
		                  		</li>
		                  	</g:each>
		                  </ul>
		                </li>
		                <li>
		                  <a href="#"><i class="fa fa-circle-o"></i> <g:message code='text.pages'/><i class="fa fa-angle-left pull-right"></i></a>
		                  <ul class="treeview-menu">
		                  	<g:each in="${project.pages}" var="page">
		                  		<li><a href="${createLink(controller:'page',action:'index',id:project.id)}" class='navLink'><i class="fa fa-circle-o"></i> ${page.name}</a></li>
		                  	</g:each>
		                  </ul>
		                </li>
		             </ul>
					</li>
					
				</g:each>
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


	<script>
		
		$(".profileImage").each(function(){
			var originalSrc = $(this).attr("src")
			var complemento = "<sec:loggedInUserInfo field="avatarFile"/>"
			$(this).attr("src", originalSrc+complemento)
		})
		var flag=false;



	function getNotifications() {
				$.ajax({
					url :"${createLink(controller:'user',action:'getNotifications')}",
					success : function(result) {
						console.log(result)
						if (!result.activeSession  && !flag) {
							flag=true;
							$('#expiredSessionModal').modal('show');
						}
						else{
							console.log(result)
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
								$('#notificationsBox').css('height', result.notifications.length*80+'px')	
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
									messagesHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ result.messages[i].dateCreated.toString().replace('T',' ').substring(0,16)+'</small></div><br/>'
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
									notificationsHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ result.notifications[i].dateCreated.toString().replace('T',' ').substring(0,16)+'</small></div><br/>'
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
										alertsHtml+='<div><small class="pull-right " style="color:gray; margin-right:3px; margin-top:3px"><i class="fa fa-clock-o"></i> '+ result.alerts[i].dateCreated.toString().replace('T',' ').substring(0,16)+'</small></div><br/>'
										alertsHtml+='<div style="margin-left:5px"><a href="#" onclick="return false;" style="white-space: normal;word-wrap:break-word; color: black"> <i class="fa '+ result.alerts[i].iconClass +'" style="color:'+result.alerts[i].iconColor+'"></i>  '+ result.alerts[i].message+'</a><div><br/></li>'
										}
								}
							}
							$('#alertsBody').html(alertsHtml)
					}
						
					},
					error:function(status, text, result, xhr){
						if(result.toLowerCase()=="unauthorized" || result.toLowerCase()=="no autorizado"){
							if(!flag)
								$('#expiredSessionModal').modal('show');
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
</script>