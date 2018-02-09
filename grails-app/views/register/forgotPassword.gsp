<g:render template="/comercial/navBar"/>
<div class="row login-bg">
	<div class="container" id="login" style="margin-top:50px;">
		<g:if test="${flash.error}">
			<br>
			<div id="error-alert" style="margin-bottom:20px">
				<div 
				class="col-xs-8 col-xs-offset-2 col-sm-6 col-sm-offset-3 col-md-6 col-md-offset-3 alert alert-danger"
				style="display: block">
					${flash.error}
			</div>
			<br> <br>
			</div>
		</g:if>
		<g:if test="${flash.message}">
			<br>
			<div id="success-alert" style="margin-bottom:20px">
				<div 
				class="col-xs-8 col-xs-offset-2 col-sm-6 col-sm-offset-3 col-md-6 col-md-offset-3 alert alert-success"
				style="display: block">
					${flash.message}
			</div>
			<br> <br>
			</div>
		</g:if>
<br>
<g:if test="${!flash.message}">
	<div class="form-wrapper" >

		<form action="${createLink(controller:'register', action:'sendResetPasswordMail')}" method="POST" id="passwordForm" class="form-signin wow fadeInUp" autocomplete="off">
			<h2 class="form-signin-heading" >
				<g:message code='general.commercial.forgotPasswordTitle'/>
			</h2>
			<div class="login-wrap">
				<h5 style="margin-bottom:20px"><g:message code="general.commercial.forgotPasswordMessage"/></h5>
				<input type="text" class="form-control" id="username" name='username' placeholder="<g:message code="register.form.username"/>" />
				<input class="btn btn-lg btn-login form-control"  type="submit" id="submit" value="<g:message code='general.commercial.button.forgotPassword'/>"/>	
			</div>

		</form>
	</div>
</g:if>
</div>
</div>
<script>
	$(document).ready(function(){
		$('#username').focus();
		$("#error-alert").fadeTo(7500, 0.01).slideUp();
		
	});
</script>
</body>

<g:render template="/comercial/footer"/>