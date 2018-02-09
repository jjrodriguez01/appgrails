<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>
<asset:javascript src="jquery.validate_es.js" />
<div class="content-wrapper">
	<!-- Main content -->
	<section class="content" id="principalSection">
		<!-- Small boxes (Stat box) -->
		<sec:ifAllGranted roles="ROLE_CLIENT">
			<g:render template="/user/client/boxes"/>
		</sec:ifAllGranted>
		<sec:ifAllGranted roles="ROLE_USER_LEADER">
			<g:render template="/user/leader/boxes-0"/>
		</sec:ifAllGranted>
		<sec:ifNotGranted  roles="ROLE_USER_LEADER">
			<sec:ifNotGranted roles="ROLE_CLIENT">
				<g:render template="/user/user/boxes-0"/>
			</sec:ifNotGranted>
		</sec:ifNotGranted>

		<!-- /.row -->
		<!-- Main row -->
		<div class="row">
			<!-- Left col -->
			<section class="col-lg-12 connectedSortable">

				<!-- profile box -->
				<div class="box box-success">
					<div class="box-header">
						<i class="fa fa-user"> </i>
						<h3 class="box-title">
							<g:message code="text.profile" />
						</h3>

					</div>
					<div class="box-body ">
						<div class="col-md-12">
							<div class="col-md-3 col-md-offset-1">
								<asset:image class="user-image profileAvatar"  src="avatars/" alt="User Image"/>
								<a href='#' onclick='showAvatarChooser(); return false;'>
								<label>
									<g:message code='text.changeAvatar'/>
								</label>
								</a>
							</div>
							
							<div class="col-md-4 ">
							 <g:form id ="editForm" name="editForm">
								<label class="" for="name"><g:message
										code="register.form.fullname" />: </label> <input id="name" name="name"
									class="form-control profileField" field='fullname' type="text" value="<sec:loggedInUserInfo field='fullName'/>"></input>
									<br/>

								<label for="phone"><g:message code="register.form.phone" />: </label>
								<input id="phone" name="phone" class="form-control profileField" field='phone' type="text" value="<sec:loggedInUserInfo field='phone'/>"></input>
									<br/> 

								<label for="extension">Ext: </label> <input id="extension" name="extension"
								class="form-control profileField" field='extension' type="text" value="<sec:loggedInUserInfo field='extension'/>"></input>
								<br/>

								<label for="mobile"><g:message
									code="register.form.mobile" />: </label> <input id="mobile" name="mobile"
								class="form-control profileField" field='mobile' type="text" value="<sec:loggedInUserInfo field='mobile'/>"></input>
								<br/>

								<label class="" for="address"><g:message
										code="register.form.address" />: </label> <input id="address"
									class="form-control profileField" field='address' type="text" value="<sec:loggedInUserInfo field='address'/>"></input>
									<br/>

								<label for="organization"><g:message
										code="register.form.organization" />: </label> <input id="organization" class="form-control profileField" field='organization' type="text" value="<sec:loggedInUserInfo field='organization'/>"></input>
								<br />
								</g:form>
								<g:if test="${user.suscription}">
									<g:if test="${user.cancelationPending}">
											<label for="organization"> <g:message code="license.cancelPending" /> </label> 
									</g:if>
									<g:elseif test="${sec.loggedInUserInfo(field:'suscription')}">
											<button class="btn"
													style="background-color: #dd4b39; color: white; margin-top: 25px"
													id="cancelSubscription">
												<g:message code="text.cancelSubscription" />
											</button>
									</g:elseif>
								</g:if>	
							</div>
							<div class="col-md-4">
								<sec:ifAnyGranted roles="${functionality23.roles}">
									<button class="btn"
										style="background-color: #4d79ff; color: white; margin-top: 25px"
										id="changeMyPass">
										<g:message code="text.changePassword" />
									</button>
								</sec:ifAnyGranted>
								<div id="changeMyPassDiv"
									style="display: none; border: solid 1px #D2D6DE; margin-top: 20px;">

									<label for="oldPass"
										style="margin-left: 20px; margin-top: 20px;"><g:message
											code="text.actualPass" />: </label> <input id="oldPass"
										class="form-control" type="password"
										style="margin-left: 20px; width: 80%;"></input> <br/><label
										for="newPass" style="margin-left: 20px;"><g:message
											code="text.newPass" />: </label> <input id="newPass"
										class="form-control" type="password"
										style="margin-left: 20px; width: 80%;"></input> <br/><label
										for="newPassConfirm" style="margin-left: 20px;"><g:message
											code="text.confirmPass" />: </label>
										<input id="newPassConfirm" class="form-control" type="password"
										style="margin-left: 20px; width: 80%; margin-bottom: 20px;"></input>
										<button onclick="changePassword()"class="btn btn-info" style="margin-left: 20px; margin-bottom: 10px;">
											<g:message code="general.text.continue" />
										</button>
								</div>
								<br />
							</div>
						</div>

					</div>


				</div>
				<!-- /.box (chat box) -->



			</section>
			<!-- /.Left col -->

		</div>
		<!-- /.row (main row) -->

	</section>
	<!-- /.content -->
</div>
<!-- /.content-wrapper -->
<sec:ifAllGranted roles="ROLE_CLIENT">
	<g:render template="/user/client/footer"/>
</sec:ifAllGranted>
<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/footer"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/footer"/>
</sec:ifNotGranted>




<!-- ./wrapper -->


<div id="modalAndJsSection">




<!-- Modal de cambio de avatar-->
<div id="changeAvatarModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="text.changeAvatar" />
				</h4>
			</div>
			<div class="modal-body ">
				<div id="formNewUser">
					<div class="row" style="margin-bottom:10px">
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-01.png" height="70px" style="box-shadow:0 .5em .5em .5em hsla(192,100%,47%,.8) inset, 0 0 .9em rgba(0, 142, 230, .8)" src="avatars/avatares-01.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-02.png" height="70px" src="avatars/avatares-02.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-03.png" height="70px" src="avatars/avatares-03.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-04.png" height="70px" src="avatars/avatares-04.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-05.png"  height="70px" src="avatars/avatares-05.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-06.png" height="70px" src="avatars/avatares-06.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-07.png" height="70px" src="avatars/avatares-07.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-08.png" height="70px" src="avatars/avatares-08.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-09.png" height="70px" src="avatars/avatares-09.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-10.png" height="70px" src="avatars/avatares-10.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-11.png" height="70px" src="avatars/avatares-11.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-12.png" height="70px" src="avatars/avatares-12.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-13.png" height="70px" src="avatars/avatares-13.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-14.png" height="70px" src="avatars/avatares-14.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-15.png" height="70px" src="avatars/avatares-15.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-16.png" height="70px" src="avatars/avatares-16.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-17.png" height="70px" src="avatars/avatares-17.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<div class="col-md-2 col-xs-4 col-sm-3 col-lg-2">
							<asset:image id="avatares-18.png" height="70px" src="avatars/avatares-18.png" class="img-circle avatarThumb" alt="User Image" />
						</div>
						<br/><br/><br/><br/>

					</div>

					<button type="button" id="formNewUserButton" class="btn btn-info" onclick="changeAvatar()"><g:message code="general.text.continue"/></button>
				</div>
			</div>
		</div>	
	</div>	
</div>
<!-- Fin del modal de cambio de avatar -->







<!-- Modal de expiración de sesión  -->

<div id="expiredSessionModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-warning">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.text.expiredSessionTitle" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="expiredSessionAlert">
					<g:message code="general.text.expiredSessionText" />
				</p>

			</div>
		</div>

	</div>
</div>
<!-- Fin del modal de expiración de sesión-->






<!-- Modal de error -->
<div id="errorModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-danger">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.error" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="errorModalContent">
				
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito -->





<!-- Modal de exito de cambio de pass -->
<div id="successModal" class="modal fade " role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header alert-success">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<g:message code="general.success" />
				</h4>
			</div>
			<div class="modal-body">
				<p id="successModalContent">
					<g:message code='password.successfullyChanged'/>
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito -->


<!-- Modal de confirmación cancelar suscripción  -->

	<div id="confirmCancelSubscription" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-danger">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.text.cancelSubscriptionTitle" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="general.text.cancelSubscriptionText" />
					</p>
					<button class="btn btn-info" id="acceptCancelSubscription"><g:message code="general.text.aceptar" /></button>
					<button class="btn btn-danger" data-dismiss="modal"><g:message code="general.text.cancel" /></button>
				</div>
			</div>

		</div>
	</div>
	<!-- Fin del modal de confirmación cancelar suscripción-->

	<!-- Modal de exito de cancelación suscripción -->
	<div id="successCancelSubscription" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-success">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.text.acceptCancelSubscriptionTitle" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code='general.text.acceptCancelSubscriptionText'/>
					</p>

				</div>

			</div>

		</div>
	</div>
	<!-- Fin del modal de cancelación suscripción -->

<script type="text/javascript">

$("#editForm").validate({
        rules: {
            phone: {digits: true, minlength: 7, maxlength: 20},
            mobile: {digits: true, minlength: 10, maxlength: 12},
            extension: {digits: true, minlength: 1, maxlength: 10}
        }
    });

	var selectedAvatar =  "avatares-01.png"
	$(window).load( function(){
		notificationsInterval = setInterval(getNotifications, 8000);
	})
	
	$(".profileAvatar").each(function(){
			var originalSrc = $(this).attr("src")
			var complemento = "<sec:loggedInUserInfo field="avatarFile"/>"
			$(this).attr("src", originalSrc+complemento)
		})


function changePassword(){
	var actualPass = $('#oldPass').val()
	var newPass = $('#newPass').val()
	var newPassConfirmation = $('#newPassConfirm').val()

	$.ajax({
				url :"${createLink(controller:'user',action:'changePassword')}",
				data:{
					actualPass:actualPass,
					newPass:newPass,
					newPassConfirmation: newPassConfirmation
					},
				success : function(result) {
						$('#oldPass').val('')
						$('#newPass').val('')
						$('#newPassConfirm').val('')
						$('#successModal').modal('show')
					},
				error: function(status, text, result, xhr){
					$('#errorModalContent').html(status.responseText)
					$('#errorModal').modal('show')
					}

				})
}



	
	$("#changeMyPass").click(function(){
		if($('#changeMyPassDiv').is(':visible')){
				$('#changeMyPassDiv').css('display','none')
				$(this).css('background-color','#4d79ff')
			}
		else{
				$('#changeMyPassDiv').css('display','block')
				
				$(this).css('background-color','#002080')
			}

		})
	

	
	$('#expiredSessionModal').on('hidden.bs.modal', function () {
	    location.reload()
	})
	
	function changeAvatar(){
		$.ajax({
				url :"${createLink(controller:'user',action:'changeAvatar')}",
				data:{
					avatar:selectedAvatar,
					},
				success : function(result) {
						location.reload()
					},
				error: function(status, text, result, xhr){
					$('#errorModalContent').html(status.responseText)
					}

				})
	}

	function showAvatarChooser(){

		$('#changeAvatarModal').modal('show')
	}



	$(".avatarThumb").click(function(){
		$(this).css('box-shadow','0 .5em .5em .5em hsla(192,100%,47%,.8) inset, 0 0 .9em rgba(0, 142, 230, .8)')
		selectedAvatar=$(this).attr('id')

		$('.avatarThumb').not(this).each(function(){
			$(this).css('box-shadow','');
		});


	})



	$('.profileField').keyup(function(){
		var field = $(this).attr('field')
		var value = $(this).val()

		$.ajax({
				url :"${createLink(controller:'user',action:'changeField')}",
				data:{
					field:field,
					value:value
					},
				success : function(result) {
						
					},
				error: function(status, text, result, xhr){
					alert('error')
					}
				})
		})

	$('#cancelSubscription').click(function(){
		$('#confirmCancelSubscription').modal('show');
	})

	$('#acceptCancelSubscription').click(function(){
        $('#confirmCancelSubscription').modal('hide');
		$.ajax({
            method: 'POST',
		    url: '${createLink(controller:'user',action:'cancelSubscription')}',
            success: function (result) {
                $('#successCancelSubscription').modal('show');
            },
            error: function (status, text, result, xhr) {

            }
		});
	})
	</script>
</div>
</body>
</html>