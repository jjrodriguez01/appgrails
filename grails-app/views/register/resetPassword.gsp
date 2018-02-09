<g:render template="/comercial/navBar"/>
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

	<form action="${createLink(controller:'register', action:'restorePassword')}" method="POST" id="passwordForm" class="form-signin wow fadeInUp" autocomplete="off">
		<h2 class="form-signin-heading" >
			<g:message code='general.mail.title.forgotPassword'/>
		</h2>
		<div class="login-wrap">
		<h5 style="margin-bottom:20px"><g:message code="general.mail.resetPasswordMessage"/></h5>
			<input type="password" class="form-control" id="password" name='password' placeholder="<g:message code="register.form.password"/>" />
			<input type="password" class="form-control" name='password2' placeholder="<g:message code="register.form.password2"/>"/>
			<input type="hidden" class="form-control" name='token' value="${token}"/>
			<input class="btn btn-lg btn-login form-control"  type="submit" id="submit" value="<g:message code='general.mail.button.forgotPassword'/>"/>	
	</div>

</form>
</div>
</div>
</div>
<script>
	$(document).ready(function(){
		var originalUrl= window.location.href.indexOf("&lang=")>-1? window.location.href.substring(0,window.location.href.indexOf("&lang=")):window.location.href
		$('#password').focus();
		$("#error-alert").fadeTo(7500, 0.01).slideUp();
		$('#spanishLang').attr('href', originalUrl+"&lang=es")
		$('#englishLang').attr('href', originalUrl+"&lang=en")
	});
</script>
</body>

<g:render template="/comercial/footer"/>