<g:render template="/comercial/navBar"/>
	<!-- Custom (css propio desarrollado en qv)-->
	<asset:stylesheet src='custom.css'/>

<div class="row login-bg">
 	<div class="container" id="login" style="margin-top:50px;">
	 	


 		<g:if test="${flash.message}">
			<br>
			<div id="error-alert" style="margin-bottom:20px">
				<div 
					class="col-xs-8 col-xs-offset-2 col-sm-6 col-sm-offset-3 col-md-6 col-md-offset-3 alert alert-danger"
					style="display: block">
					${flash.message}
				</div>
				<br> <br>
			</div>
		</g:if>
 		<br>
	 	<div class="form-wrapper" >
	 		<form action="${createLink(controller:'login', action:'authenticate')}" method="POST" id="loginForm" class="form-signin wow fadeInUp" autocomplete="off">
	 			<h2 class="form-signin-heading">
	 				<g:message code='login.signInNow'/>
	 			</h2>
	 			<div class="login-wrap">
	 				<input type="text" class="form-control" name="username" id="username"
	 				placeholder="<g:message code='login.username'/>" autofocus maxLength='50'>
	 				<input type="password" class="form-control" name="password" id="password" placeholder="<g:message code='login.password'/>" maxLength='64'>
	 				<label id="remember_me_holder" class="checkbox">
						<input type="checkbox" class="chk" name="remember-me" id="remember_me" style="opacity:0.5; margin-left:0px; display:none"/>
						
						<span class="pull-right">
	 						<g:link controller='register' action='forgotPassword'>
	 							<g:message code='login.forgotPassword'/>
	 						</g:link>
	 					</span>
					</label>
		 			<input class="btn btn-lg btn-login btn-block"  type="submit" id="submit" value="<g:message code='login.login'/>">	
		 			</input>

		 			<div class="registration">
		 				<g:message code='login.dontHaveAccount'/>
		 				<a id="registerLink" href="${createLink(controller:'register', action:'index')}" >
		 					<g:message code='login.createAccount'/>
		 				</a>
		 			</div>
	 			</div>
 			</form>
		</div>
	</div>
</div>
<script>
var uuids = []


	$(document).ready(function(){
		 $('#username').focus();
		 $("#error-alert").fadeTo(10000, 0.01).slideUp();
	});

	 $('#registerLink').click(function(){
          ga('send', 'event', 'Button', 'click', 'Registro desde login');
      })

</script>
</body>
<g:render template="/comercial/footer"/>