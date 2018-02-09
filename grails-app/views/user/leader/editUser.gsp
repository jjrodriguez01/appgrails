<g:render template="leader/navBar"/>
<!-- Content Wrapper. Contains page content -->

	<div class="content-wrapper">

		<!-- Main content -->
		<section class="content"  id="principalSection">
			<!-- Small boxes (Stat box) -->
			<g:render template="leader/boxes-0"/>
			<!-- /.row -->
			<!-- Main row -->
			<div class="row">
				<!-- Left col -->
				<section class="col-lg-12 connectedSortable" >

					<!-- User List -->
					<div class="box box-primary">
						<div class="box-header">
							<i class="fa fa-users"> </i>
							<h3 class="box-title">
								<g:message code="general.editUser" />
							</h3>
							
						</div>
						<!-- /.box-header -->
						<div class="box-body" id="usersBody">
							<div class='jumbotron' style="padding:10px">
								<h4><b><g:message code="general.generalData"/></b></h4><br/>
								<b><g:message code="register.form.fullname"/>:</b><br/>
								${userToEdit.fullname}<br/><br/>
								<b><g:message code="register.form.mobile"/>:</b><br/>
								${userToEdit.mobile}<br/><br/>
								<b><g:message code="register.form.phone"/>:</b><br/>
								${userToEdit.phone}<br/><br/>
								<b><g:message code="register.form.username"/>:</b><br/>
								${userToEdit.username}<br/><br/>
								<b><g:message code="general.grantAdminPrivileges"/>:</b><br/>
								<g:if test="${isAdmin}">
									<label style="padding-top: 6px; margin-right:100px;" >
										<input id="${userToEdit.id}" class="ios-switch adminSwitch"  type="checkbox" checked>
										<div class="switch"></div>
									</label>
								</g:if>
								<g:else>
									<label style="padding-top: 6px; margin-right:100px;" >
										<input id="${userToEdit.id}" class="ios-switch adminSwitch"  type="checkbox" >
										<div class="switch"></div>
									</label>
								</g:else>
								
							</div>
							<div class='jumbotron' style="padding:10px">
								<h4><b><g:message code="general.projectPermissions"/></b></h4><br/>
								<g:if test="${projects.size()>0}">
									<table class="table table-responsive">
										<thead>
											<th><g:message code="text.name"/></th>
											<th><g:message code="text.description"/></th>
											<th><g:message code="general.grantAccess"/></th>
										</thead>
										<tbody>
											<g:each in="${projects}" var="project">
												<tr>
													<td>${project.name}</td>
													<td>${project.description}</td>
													<g:if test="${project in userProjects}">
														<td>
															<label style="padding-top: 6px; margin-right:100px;" >
																<input id="${project.id}" class="ios-switch projectSwitch"  type="checkbox" checked>
																<div class="switch"></div>
															</label>
														</td>
													</g:if>
													<g:else>
														<td>
															<label style="padding-top: 6px; margin-right:100px;" >
																<input id="${project.id}" class="ios-switch projectSwitch"  type="checkbox" >
																<div class="switch"></div>
															</label>
														</td>
														
													</g:else>
												</tr>
									
											</g:each>
										</tbody>
									</table>
								</g:if>
								
							</div>
						</div>


						<!-- /.box-body -->
						
					</div>
				<!-- /.box -->

				</section>
			</div>
		</section>	
	</div>

<g:render template="leader/footer"/>








<!-- Modal de registro de usuario -->


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
				<p id="expiredSessionAlert"> <g:message code="general.text.expiredSessionText" /></p>

			</div>
		</div>

	</div>
</div>
<!-- Fin del modal de expiración de sesión-->
<!-- Modal de exito para ejecucion -->
	<div id="executionSaveModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-success">
					<button type="button" class="close" data-dismiss="modal" onclick="location.reload();">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.success" />
					</h4>
				</div>
				<div class="modal-body">
					<p id="executionSuccessMessage"></p>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de exito para ejecuciones -->

<script type="text/javascript">


	


	$('#expiredSessionModal').on('hidden.bs.modal', function () {
		location.reload()
	})
	
	$(window).load( function(){
		notificationsInterval = setInterval(getNotifications, 8000);

	})
	$('.adminSwitch').change( function(){
		$('#executionSuccessMessage').html("${message(code:'general.changePrivileges')}")
		$('#executionSaveModal').modal('show')
		var value ='off'
		if($(this).prop('checked')){
			value='on'
		}
		var id=$(this).prop('id')
		$.ajax({
			type: 'POST',
			url: "${createLink(action:'grantLeaderPrivileges', controller:'user')}",
			data: { 
				id: id,
				value:value,
				userId:${userToEdit.id},
				},

				success: function (dataCheck) {
				
				},
				error: function(status, text, result, xhr){
					alert('error')
				}
			});
	})
	$('.projectSwitch').change( function(){
		var value ='off'
		if($(this).prop('checked')){
			value='on'
		}
		var id=$(this).prop('id')
		$.ajax({
			type: 'POST',
			url: "${createLink(action:'grantAccess', controller:'project')}",
			data: { 
				id: id,
				value:value,
				userId:${userToEdit.id},
				},

				success: function (dataCheck) {
				
				},
				error: function(status, text, result, xhr){
					alert('error')
				}
			});
	})

	
</script>
</body>
</html>