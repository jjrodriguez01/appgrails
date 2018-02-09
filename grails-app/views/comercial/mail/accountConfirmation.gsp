<!DOCTYPE html>
<html lang="en">
	

	<head>
		<meta charset="UTF-8">
		<title>Account confirmation</title>
		      <!--Stylesheets Imports -->

	</head>
	<body class="container" >

	<style>
		.btn {
		    display: inline-block;
		    padding: 6px 12px;
		    margin-bottom: 0;
		    font-size: 14px;
		    font-weight: 400;
		    line-height: 1.42857143;
		    text-align: center;
		    white-space: nowrap;
		    vertical-align: middle;
		    -ms-touch-action: manipulation;
		    touch-action: manipulation;
		    cursor: pointer;
		    -webkit-user-select: none;
		    -moz-user-select: none;
		    -ms-user-select: none;
		    user-select: none;
		    background-image: none;
		    border: 1px solid #1f9dd9;
		    border-radius: 4px;
		}

	</style>
		<div style="width:65%;float:center">
			<div style="background-color:#f5f3f3; ">
				<img src="http://www.thundertest.com${createLink(controller:'assets', action:'logos')}/logo.png" alt="Logo thunderTest" style="margin-left:10px;"/>
			</div>
			<h3><b ><g:message code="general.mail.title.accountConfirmation"/></b></h3>
			<p style="padding-right:0px"><g:message code="general.mail.body.accountConfirmation" args="${[username]}"/></p>
			
			<a href="${url}"><button class="btn" style="background-color:#1f9dd9; color:white"><g:message code="general.mail.button.accountConfirmation"/></button></a>
			<p style="margin-top:3px"><g:message code="general.mail.thunderTeam"/></p>
			<div style="background-color:#1f9dd9; height:5px; margin-top:5px;"></div>
			<div style="background-color:#f5f3f3; margin-top:3px;">
				<p style="font-size:10px; text-align:center"  ><g:message code="general.mail.generated.message"/></p>
			</div>
		</div>
	</body>
</html>