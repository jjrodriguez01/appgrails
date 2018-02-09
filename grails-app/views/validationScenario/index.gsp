<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

<div class="content-wrapper">
<asset:javascript src="chart.js"/>
	<!-- Main content -->
	<section class="content" id="principalSection">
		<!-- Small boxes (Stat box) -->
		<sec:ifAllGranted roles="ROLE_USER_LEADER">
			<g:render template="/user/leader/boxes-0"/>
		</sec:ifAllGranted>
		<sec:ifNotGranted  roles="ROLE_USER_LEADER">
			<g:render template="/user/user/boxes-0"/>
		</sec:ifNotGranted>
<!-- /.row -->
<!-- Main row -->
		<div class="row">
			<div class="col-xs-12">
				<div class="nav-tabs-custom">

					<!-- Tabs within a box -->
					<ul class="nav nav-tabs pull-right">
						<li class="active">
							<a href="#revenue-chart" data-toggle="tab">
								<i class="fa fa-list-alt" style="color: blue"> </i>
								<g:message code="text.scenarios" />
							</a>
						</li>
						<li>
							<a href="#newScenario-chart" data-toggle="tab">
							<i class="fa fa-plus" style="color: green"> </i> 
							<g:message code="text.new" /> </a>
						</li>
						
						<li class="pull-left header"><i class="fa fa-inbox"> </i> 
							<g:message code="text.scenarios" />
						</li>
					</ul>


					<div class="tab-content no-padding">
						<!-- Morris chart - Sales -->
						<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
							<div class="box">
								<!-- /.box-header -->
								<div class="box-body">
									<div class="col-md-6"></div>		
									<div class="col-md-6">
										<ol class="breadcrumb pull-right" style="background-color:white">
											<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
								        	<li><g:link controller='validator' action='index'>${associatedProject.name}</g:link></li>
								       		<li class="active"><g:message code="text.scenarios"/></li>
								    	</ol>
									</div>
									<label> 
										<g:message code="datatable.showing"/>
									</label> 
									<select id="rowsPerPageSelect" >
										<option value="10">10</option>
										<option value="25">25</option>
										<option value="50">50</option>
										<option value="100">100</option>
									</select>
									<label style="margin-right:50px"> 
										<g:message code="datatable.entries"/>
									</label>
									<div class="pull-right">
										<label for="search">
											<g:message code="datatable.search"/>: 
										</label>
										<input id="datatablesearch" table="scenariosTable"  name="search" type="text">
										</input>
									</div>
									<table id="scenariosTable"
										class="table table-bordered table-striped sortable paginated">
										<thead>
											<tr>
												<th><g:message code="text.name" /></th>
												<th><g:message code="text.type"/></th>
												<th><g:message code="text.initialRow" /></th>
												<th><g:message code="text.finalRow" /></th>
												<th><g:message code="text.separator"/></th>
												<th><g:message code="text.edit" /> / <g:message code="text.delete" /></th>
											</tr>
										</thead>
										<tbody>
											<g:each in="${scenarios}">
												<tr>
													<td>
														<a href="${createLink(controller:'step', action:'index', id:it.id)}" class="navLink" id="name${it.id}" >${it.name}
														</q>
													</td>
													<td>
														<g:if test="${it.type==1}">
															<small class="label label-success"><g:message code="text.validationScenario.type.bySeparator"/></small>
														</g:if>
														<g:elseif test="${it.type==2}">
															<small class="label label-danger"><g:message code="text.validationScenario.type.bySize"/></small>
														</g:elseif>
														<g:elseif test="${it.type==3}">
															<small class="label" style="background-color:#8b6ecc"><g:message code="text.validationScenario.type.fromDataBase"/></small>
														</g:elseif>
													</td>
													
													<td>
														<g:link controller="message" action="scenario" id="${it.id}" class="navLink"><g:message code="text.viewMessages"/>
														</g:link>
													</td>
													<td>
														<g:link controller="step" action="index"
															id="${it.id}" class="navLink"><g:message code="text.viewSteps"/>
														</g:link>
													</td>
													<td>
														<g:link controller="case" action="index"
															id="${it.id}" class="navLink"><g:message code="text.viewCases"/>
														</g:link>
													</td>
													
													<td>
														<a href="#" onclick="showEditScenarioModal(${it.id}); return false;">
															<i class="fa fa-edit"> </i>
														</a>
													
														<a href="#" onclick="setDeletingId(${it.id}); return false;">
															<i class="fa fa-trash-o" style="color:red"> </i>
														</a>
													</td>
												</tr>
											</g:each>
										</tbody>
									</table>
								</div>
								<!-- /.box-body -->
							</div>
							<!-- /.box -->
						</div>
						<div class="chart tab-pane" id="newScenario-chart"
							style="position: relative;">
							<div id="formNewScenario" style="margin-left: 20px; padding-right: 20px;">
								<br/>
								<label for="type"><g:message code="text.type"/></label>
								<select id="newScenarioType" class="form-control">
									<option value="1" selected><g:message code="text.validationScenario.type.bySeparator"/></option>
									<option value="2"><g:message code="text.validationScenario.type.bySize"/></option>
									<option value="3"><g:message code="text.validationScenario.type.fromDataBase"/></option>
								</select>
								<br/>
								<div class="panel panel-primary panel-validator" style="padding:20px" id="validator1">
									<h3 style="margin-top:0px"><g:message code="text.validationScenario.type.bySeparator"/> </h3>
									<label for="name"><g:message code="text.name" /></label> <input
									class="form-control" type="text" name="name" id="name1"><br>
									<label for="description"><g:message
											code="text.description" /></label>
									<textarea class="form-control"
											type="text" name="description" id="description1"></textarea>
									<br/>
									<label for="separator"><g:message code="text.separator" /></label>
									<input class="form-control" type="text" name="separator1" id="separator1"/>
									</br>
									<label for="columns"><g:message code="text.columns" /></label>
									<input class="form-control" type="text" name="columns1" id="columns"/>
									<br>
									<label for="path"><g:message code="text.path" /></label>
									<input class="form-control" type="text" name="path1" id="path1"/><br>
									<button type="button" id="formNewScenarioButton" class="btn btn-info pull-right" onclick="createScenarioBySeparator(this)"><g:message code="general.text.save"/>
									</button><br/>
								</div>
								<div class="panel panel-primary panel-validator" style="padding:20px; display:none" id="validator2">
									<h3 style="margin-top:0px"><g:message code="text.validationScenario.type.bySize"/> </h3>
									<label for="name"><g:message code="text.name" /></label> <input
									class="form-control" type="text" name="name" id="name"><br>
									<label for="cycle"><g:message
											code="text.cycle" /></label> <input class="form-control"
											type="text" name="cycle" id="cycle"><br>
									<label for="version"><g:message
											code="text.version" /></label> <input class="form-control"
											type="text" name="version" id="version"><br>
									
									</br>
									
									<button type="button" id="formNewScenarioButton" class="btn btn-info pull-right"
											 onclick="createScenario(this)"><g:message code="general.text.save"/>
									</button><br/>
								</div>
								<div class="panel panel-primary panel-validator" style="padding:20px; display:none" id="validator3">
									<h3 style="margin-top:0px"><g:message code="text.validationScenario.type.fromDataBase"/> </h3>
									<label for="name"><g:message code="text.name" /></label> <input
									class="form-control" type="text" name="name" id="name"><br>
									<label for="cycle"><g:message
											code="text.cycle" /></label> <input class="form-control"
											type="text" name="cycle" id="cycle"><br>
									<label for="version"><g:message
											code="text.version" /></label> <input class="form-control"
											type="text" name="version" id="version"><br>
									
									</br>
									
									</br>
									<label for="uftProjectRoute" class="uft-related" style="display:none">
										<g:message code="text.uftProjectRoute"/>
									</label>
									<input type="text" class="form-control uft-related" id="uftProjectRoute"  style="display:none">
									</br>
									<button type="button" id="formNewScenarioButton" class="btn btn-info pull-right"
											 onclick="createScenario(this)"><g:message code="general.text.save"/>
									</button><br/>
								</div>
								
							</div>
						</div><br/>
					</div>
				</div>
			</div>
			<!-- /.col -->
		</div>
			<!-- /.row -->
	</section>
	<!-- /.content -->
</div>
<!-- ./wrapper -->

<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/footer"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/footer"/>
</sec:ifNotGranted>


<div id="modalAndJsSection">

	<!-- Modal de edición de scenario -->
	<div id="editScenarioModal" class="modal fade" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h3>
						<g:message code="text.edit" />
						<g:message code="text.scenario" />
					</h3>
				</div>
				<div class="modal-body">
					<div id="formEditScenario"
						style="margin-left: 20px; margin-right: 20px;">
						<label for="name">
							<g:message code="text.name" />
						</label>
						<input class="form-control editInput" type="text" name="name" id="editName"/>
						<br>
						<label for="cycle">
							<g:message code="text.cycle" />
						</label>
						<input class="form-control editInput" type="text" name="cycle" id="editCycle"/>
						<br>
						<label for="version">
							<g:message code="text.version" />
						</label>
						<input class="form-control editInput" type="text" name="version" id="editVersion"/>
						<br>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- fin del modal de edición de scenario -->



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


	<!-- Modal de exito de registro de scenario -->

	<div id="newScenarioSuccessModal" class="modal fade " role="dialog">
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
					<p id="successModalMessage">
						<g:message code="text.successCreateScenario" />
					</p>

				</div>

			</div>

		</div>
	</div>
	<!-- Fin del modal de exito de registro de scenario -->


	<!-- Modal de exito de edición de scenario -->

	<div id="editPageSuccessModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-success">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.success" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="text.successEditPage" />
					</p>

				</div>

			</div>

		</div>
	</div>
	<!-- Fin del modal de exito de edición de scenario -->




	<!-- Modal de error de registro de scenario -->
	<div id="newScenarioErrorModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-error">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.error" />
					</h4>
				</div>
				<div class="modal-body">
					<p id="newScenarioErrorMessage"></p>
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de error de registro de scenario -->


	<!-- Modal de información de scenario -->
	<div id="infoPageModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">

				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h3>
						<g:message code="text.scenarioInfo" />
					</h3>
				</div>
				<div class="modal-body">
					<h5>
						<b> <g:message code="text.name" /> :
						</b>
					</h5>
					<p id="infoNameField"></p>
					<h5>
						<b><g:message code="text.description" /> :</b>
					</h5>
					<p id="infoDescriptionField"></p>
					<h5>
						<b><g:message code="text.typeOfPage" /> :</b>
					</h5>
					<p id="infoIsPrivatePageField"></p>
					<h5>
						<b> <g:message code="text.createdDate" /> :
						</b>
					</h5>
					<p id="infoDateCreatedField"></p>
					<h5>
						<b> <g:message code="text.lastUpdatedDate" /> :
						</b>
					</h5>
					<p id="infoLastUpdatedField"></p>
					<h5>
						<b> <g:message code="text.lastUpdatedBy" /> :
						</b>
					</h5>
					<p id="infoLastUpdatedByField"></p>
				</div>
			</div>

		</div>
	</div>

	<!-- fin del modal de información de scenario -->






	<!-- Modal de confirmación de borrado de scenario -->
	<div id="confirmModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-warning">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.text.confirmTitle" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="general.text.confirmMessage" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="deleteScenario()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->



	<!-- Modal de selección de navegador  -->

	<div id="browserSelectionModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.browserSelection" />
					</h4>
				</div>
				<div class="modal-body">
						<div class="row col-md-12">
								<div class="col-md-2 col-xs-4" id="divch">
									<asset:image src="browsers/ch.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkch" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
							
								<div class="col-md-2 col-xs-4" id="divff">
									<asset:image src="browsers/ff.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkff" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divie">
									<asset:image src="browsers/ie.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkie" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divsa">
									<asset:image src="browsers/sa.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checksa" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="dived">
									<asset:image src="browsers/ed.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checked" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
								<div class="col-md-2 col-xs-4" id="divop">
									<asset:image src="browsers/op.png" height='50px' style="margin-left:10px; margin-bottom:3px;"/>
									<label><input id="checkop" class="ios-switch objectSwitch" type="checkbox">
														<div class="switch"></div></label>
								</div>
						</div>
						<br>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-info"
						onclick="executeWebScenario()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>

		</div>
	</div>
	<!-- Fin del modal de selección de navegador-->




	<!-- Modal de confirmación de forzado de la ejecución -->
	<div id="forceExecutionModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-warning">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.attention" />
					</h4>
				</div>
				<div class="modal-body">
					<p>
						<g:message code="text.forceExecution.message" />
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					<button type="button" class="btn btn-warning "
						onclick="forceExecution()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->




	<script type="text/javascript">
		var editingId=null;
		var flag=true
		var currentPage = 0;
		var numPerPage = 10;
		var oldBrowsers = ""
		var oldExecutingId=""
		var oldExecutionType=0
		var userBrowsers = "${browsers}"
		var curExecutionRequestId = null


		$(window).load( function(){
		    notificationsInterval =	setInterval(getNotifications, 8000);
			enableSearch()
			$('#newScenarioType').val("1")
		})

		$('#newScenarioErrorModal').on('hidden.bs.modal', function() {
			$("body").css('padding-right','0px')
		})

		$('#editScenarioModal').on('hidden.bs.modal', function() {
			editingId!=null
		})


		$('#rowsPerPageSelect').change(function(){
			numPerPage = $(this).val()
			makeTablePaginated()
		}); 

		

	    function setDeletingId(newId) {
	        deletingId = newId
	        $('#confirmModal').modal('show');

	    }


		makeTablePaginated()


		
		function createScenarioBySeparator(button){
			$(button).prop("disabled", true)
			$(button).html("<i class='fa fa-spinner fa-spin'></i>");
			var name = $('#name1').val()
			var description = $('#description1').val()
			var separator = $('#separator1').val()
			var type = 1
			var filePath = $('#path1').val()
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'create', controller:'validationScenario')}",
				data:{
					name:name,
					description:description,
					separator:separator,
					type:type,
					filePath: filePath,
					id:${projectId},
				},
				success: function(dataCheck) {
					location.reload(true)
				},
				error: function(status, text, result, xhr) {
					$('#newScenarioErrorMessage').html(status.responseText)
					$('#newScenarioErrorModal').modal('show');
					$(button).html("${message(code:'general.text.save')}")
					$(button).prop("disabled", false)
				}
			});
		}

		$('.editInput').keyup(function(){
			if(editingId!=null)
				saveScenario()
		})

		function saveScenario(){
			var name = $('#editName').val()
			var cycle = $('#editCycle').val()
			var version = $('#editVersion').val()
			var prefix = ''//$('#editPrefix').val()
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'update', controller:'scenario')}",
				data:{
					id:editingId,
					name:name,
					cycle:cycle,
					version:version,
					prefix: prefix,
					projectId: ${projectId}
				},
				success: function(dataCheck) {
					$('#name'+editingId).text(name)
					$('#cycle'+editingId).text(cycle)
					$('#version'+editingId).text(version)
					$('#prefix'+editingId).text(prefix)

				},
				error: function(status, text, result, xhr) {
					$('#newScenarioErrorMessage').html(status.responseText)
					$('#newScenarioErrorModal').modal('show');
				}
			});
		}






	    function deleteScenario() {
	        $.ajax({
	            method: "POST",
	            url: "${createLink(action:'secureDelete', controller:'scenario')}",
	            data: {
	                id: deletingId,
	                projectId: ${projectId},
	            },
	            success: function(result) {
	                $('#confirmModal').modal('hide')
	                location.reload()
	            },
	            error: function(status, text, result, xhr) {
	                showDeleteErrorModal(status.responseText);
	            }
	        });
	    }




		function showDeleteErrorModal(text){
			$('#confirmModal').modal('hide');
			$('#newScenarioErrorMessage').html(text)
			$('#newScenarioErrorModal').modal('show');
		}



		function showEditScenarioModal(id)
		{

			editingId=id
			$('#editName').val($('#name'+id).text().trim())
			$('#editCycle').val($('#cycle'+id).text().trim())
			$('#editVersion').val($('#version'+id).text().trim())
			//$('#editPrefix').val($('#prefix'+id).text().trim())

			$('#editScenarioModal').modal('show');
		}
		
		
		function showInfoPageModal(name, description, isPrivate, lastUpdated, dateCreated, updatedBy)
		{
			$('#infoNameField').html(name)
			$('#infoDescriptionField').html(description)
			if(isPrivate=="true")
				$('#infoIsPrivatePageField').html("${message(code:'text.private')}")
			else
				$('#infoIsPrivatePageField').html("${message(code:'text.public')}")
			$('#infoLastUpdatedField').html(lastUpdated)
			$('#infoDateCreatedField').html(dateCreated)
			$('#infoLastUpdatedByField').html(updatedBy)
			$('#infoPageModal').modal('show');
			$('#infoPageModal').modal('show');
		}
		
		var flag=false;


		$('#expiredSessionModal').on('hidden.bs.modal', function() {
			location.reload()
		})






		
			
			
			$('.modal').on('hidden.bs.modal', function() {
						$("body").css('padding-right','0px')
					})

			$('#newScenarioType').change(function(){
				var actualVPanel = $("#validator"+$(this).val()) 
				$(".panel-validator").not(actualVPanel).each(function(){
					$(this).hide()
				})
				actualVPanel.show()

			})

	</script>
</div>
</body>
</html>

