<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>
<script >
	Date.prototype.adjustDate = function() {

	    var now = new Date()
		var localOffset = now.getTimezoneOffset();
		var modifiedDate = new Date(this.getTime()-((${offset}+localOffset)*60000))
		var yyyy = modifiedDate.getFullYear().toString();
		var mm = (modifiedDate.getMonth()+1).toString(); // getMonth() is zero-based
	   	var dd  = modifiedDate.getDate().toString();
	   	var hh = modifiedDate.getHours().toString();
	   	var mi = modifiedDate.getMinutes().toString();
	   	var ss = modifiedDate.getSeconds().toString();
	   	return yyyy +"-"+ (mm[1]?mm:"0"+mm[0]) +"-"+ (dd[1]?dd:"0"+dd[0]) + " " + (hh[1]?hh:"0"+hh[0]) + ":" + (mi[1]?mi:"0"+mi[0]) + ":" + (ss[1]?ss:"0"+ss[0]); // padding
	  };
</script>


<asset:stylesheet src='bootstrap-datetimepicker.min.css'/>
<asset:javascript src='moment.js'/>
<asset:javascript src='bootstrap-datetimepicker.min.js'/>
<div class="content-wrapper">
	<!-- Main content -->
	<section class="content"  id="principalSection">
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
								<g:message code="general.text.executions" />
							</a>
						</li>
						<sec:ifAnyGranted roles="${functionality33.roles}">
							<li>
								<a href="#newExecution-chart" data-toggle="tab">
								<i class="fa fa-plus" style="color: green"> </i> 
								<g:message code="text.new" /> </a>
							</li>
						</sec:ifAnyGranted>
						<li>
							<a href="#programmedExecutions-chart" data-toggle="tab">
							<i class="fa fa-list-alt" style="color: blue"> </i>
							<g:message code="text.programmedExecutions" /> </a>
						</li>
						<li class="pull-left header"><i class="fa fa-inbox"> </i> 
							<g:message code="general.text.executions" />
						</li>
					</ul>


					<div class="tab-content no-padding">
						<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
							<div class="box">
								<!-- /.box-header -->
								<div class="box-body">
									<div class="col-md-6">
									</div>
									<div class="col-md-6">
										<ol class="breadcrumb pull-right" style="background-color:white">
											<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
								       		<li class="active"><g:message code="general.text.executions"/></li>
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
									<table id="executionsTable" class="table table-bordered table-striped sortable paginated">
										<thead>
											<tr>
												<th><g:message code="text.executionDate" /></th>
												<th><g:message code="text.executor" /></th>
												<th><g:message code="text.target" /></th>
												<th><g:message code="text.scenario" /></th>
												<th><g:message code="text.progress"/></th>
												<th><g:message code="text.message" /></th>
												<sec:ifAllGranted roles="ROLE_USER_LEADER">
													<th><g:message code="text.delete" /></th>
												</sec:ifAllGranted>
											</tr>
										</thead>
										<tbody>
											<g:each in="${executions}" var="execution">
												<tr executionId='${execution.id}'>
													<td id="execDate${execution.id}">
														<script type="text/javascript">
															$("#execDate${execution.id}").html(new Date("${execution.executionDate}").adjustDate())
														</script>
													</td>
													<td>
														${execution.creator.getFullname()}
													</td>
													<td>
														${execution.target.getFullname()}
													</td>
													<td>
														${execution.scenarioToExecute.getName()}
													</td>
													<td>
														<div class="progress active">
															<div id="progress${execution.id}" class="progress-bar progress-bar-primary progress-bar-striped active"role="progressbar" aria-valuenow="${execution.progress}" aria-valuemin="0" aria-valuemax="100" style="width: ${execution.progress}%; min-width:2em;">
							                     						${execution.progress}%
						                   					</div>
					                   					</div>
													</td>
													<td id="message${execution.id}">
														<g:if test="${message(code: 'execution.stateMessage', default:'')}">					
															<g:message code='${execution.stateMessage}' />
														</g:if>
														<g:else>
															<g:message code='execution.waitingDate' />
														</g:else>
													</td>
													<sec:ifAllGranted roles="ROLE_USER_LEADER">
														<td>
															<a href="#" onclick="setDeletingId(${execution.id}); return false;" style="color:red"><i class="fa fa-trash-o"> </i></a>
														</td>
													</sec:ifAllGranted>
												</tr>
											</g:each>
										</tbody>
									</table>
								</div>
								<!-- /.box-body -->
							</div>
						<!-- /.box -->
						</div>

							<div class="chart tab-pane container" id="newExecution-chart" style="padding-left:15px; margin-right:10px">
								<label for="excecutionType">
									<g:message code="execution.type"/>: 
								</label>
								<div class="btn-group form-control" data-toggle="buttons" style="height:auto">
								    <label class="btn-thunder btn btn-info active" id="oneTime">
								        <input type="radio" name="execType" id="oneTime" value="1" checked>
								    	<g:message code="execution.oneTime"/> </label>
								    <label class="btn-thunder btn btn-default" id="specificDays">
								        <input type="radio" name="execType" id="specificDays" value="2">
								   		<g:message code="execution.specificDays"/> </label>
								    <label class="btn-thunder btn btn-default" id="daily">
								        <input type="radio" name="execType" id="daily" value="3">
								    	<g:message code="execution.daily"/> </label>
								</div><br/><br/>
								<div id="daysDiv" style="display:none">
									<label><g:message code="execution.execDays"/></label>
									<div class="btn-group form-control" data-toggle="buttons" style="height:auto;">
									    <label class="btn-thunder-d  day btn btn-default" value="2">
									        <input type="checkbox">
									    	<g:message code="execution.monday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="3">
									        <input type="checkbox" >
									   		<g:message code="execution.tuesday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="4">
									        <input type="checkbox">
									    	<g:message code="execution.wednesday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="5">
									        <input type="checkbox" >
									    	<g:message code="execution.thursday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="6">
									        <input type="checkbox" >
									    	<g:message code="execution.friday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="7">
									        <input type="checkbox" >
									    	<g:message code="execution.saturday"/> </label>
									    <label class="btn-thunder-d day btn btn-default" value="1">
									        <input type="checkbox" >
									    	<g:message code="execution.sunday"/> </label>
									</div><br/><br/>
								</div>
								<label for="project">
									<g:message code="text.project"/>
								</label>
								<select id="projectSelect" class="form-control">
									<g:each in="${projects}" var="curProject">
										<option value="${curProject.id}">${curProject.name}</option>
									</g:each>
								</select>
								<br/>
								<label for="scenario">
									<g:message code="text.scenario"/>
								</label>
								<select id="scenarioSelect" class="form-control">
									<g:if test="${projects.size()>0}">
									<option value="" isweb="">-</option>
										<g:each in="${projects[0].scenarios.sort{it.name}}" var="curScenario" >
											<g:if test="${curScenario.enabled}">
												<option value="${curScenario.id}" isweb="${curScenario.isWeb()}">${curScenario.name}</option>
											</g:if>
										</g:each>
									</g:if>
								</select>
								<br/>
								<label for="cases"><g:message code="text.cases"/></label>
								<input type="text" id="cases" placeholder="${message(code:'execution.cases.example')}" class="form-control"/>
								<br/>
								<label><g:message code="execution.initDate"/></label>
								<div class="container" style="padding-left:0px">
								    <div class="row" >
								        <div class='col-sm-12'>
								            <input type='text' class="form-control" id='initialDate' />
								        </div>
								        <script type="text/javascript">
								        	 $(function () {
								                $('#initialDate').datetimepicker({
								                	locale:'es',
								                	showTodayButton:true,
								                	showClose:true,
								                	icons:{
											            time: 'fa fa-clock-o',
											            date: 'fa fa-calendar',
											            up: 'fa fa-chevron-up',
											            down: 'fa fa-chevron-down',
											            previous: 'fa fa-chevron-left',
											            next: 'fa fa-chevron-right',
											            today: 'fa fa-dot-circle-o',
											            clear: 'fa fa-trash',
											            close: 'fa fa-times'
											        },
											        toolbarPlacement:'top',
											        showClear:true,
											        minDate:new Date()
								                	
								                });
								            });
								        </script>
								        
							    	</div>
								</div>
								<br/>
								<label> <g:message code="text.target"/></label>
								<div class="btn-group form-control" data-toggle="buttons" style="height:auto;">
								<sec:ifAnyGranted roles="${functionality19.roles}">
									<g:each in="${targets.findAll{it.id!=properUser.id}}" var="target">
										<label  class="btn-thunder-d target btn btn-default" style="width:130px" value="${target.id}">
								        	<input type="checkbox"   >
								    		<asset:image src="avatars/${target.avatarFile}" class="img-circle" style="width:60px; height:60px"/> 
								    		<g:if test="${target.fullname.length() > 17}">
								    			<p>${target.fullname.substring(0,17)}..</p>
									    	</g:if>
								    		<g:else>
								    			<p >${target.fullname}</p>
								    		</g:else>
								    	</label>
									</g:each>
								</sec:ifAnyGranted>
								<sec:ifAnyGranted roles="${functionality18.roles}">
									<label  class="btn-thunder-d target btn btn-default" style="width:130px" value="${properUser.id}">
								       	<input type="checkbox"   >
								    	<asset:image src="avatars/${properUser.avatarFile}" class="img-circle" style="width:60px; height:60px"/> 
								    	<g:if test="${properUser.fullname.length() > 17}">
								    		<p>${properUser.fullname.substring(0,17)}..</p>
									   	</g:if>
								    	<g:else>
								    		<p >${properUser.fullname}</p>
								    	</g:else>
								    </label>
								</sec:ifAnyGranted>

								</div>
								<br/>
								<br/>
								<label id="browsersLabel"> <g:message code="text.browserSelection"/></label>
								<div class="btn-group form-control" data-toggle="buttons" style="height:auto; display:none" id="browsersGroup" >
									<label  class="btn-thunder-d browser btn btn-default" style="width:130px" value="ff">
								       	<input type="checkbox" >
								   		<asset:image src="browsers/ff.png" class="img-circle" style="width:60px; height:60px"/> 
								   	</label>
									<label  class="btn-thunder-d browser btn btn-default" style="width:130px" value="ch">
								       	<input type="checkbox" >
								   		<asset:image src="browsers/ch.png" class="img-circle" style="width:60px; height:60px"/> 
								   	</label>
								   	<label  class="btn-thunder-d browser btn btn-default" style="width:130px" value="op">
							        	<input type="checkbox"  >
							    		<asset:image src="browsers/op.png" class="img-circle" style="width:60px; height:60px"/> 
							    	</label>
							    	<label  class="btn-thunder-d browser btn btn-default" style="width:130px" value="sa">
							        	<input type="checkbox"  >
							    		<asset:image src="browsers/sa.png" class="img-circle" style="width:60px; height:60px"/> 
							    	</label>
							    	<!--<label  class="btn-thunder-d browser btn btn-default" style="width:130px">
								        	<input type="checkbox" name="execDay" id="daily">
								    		<asset:image src="browsers/ed.png" class="img-circle" style="width:60px; height:60px"/> 
								    	</label>
								    	<label  class="btn-thunder-d browser btn btn-default" style="width:130px">
								        	<input type="checkbox" name="execDay" id="daily" >
								    		<asset:image src="browsers/ie.png" class="img-circle" style="width:60px; height:60px"/> 
								    	</label>-->
								</div>
								<br/>
								<br/>
								<button class="btn btn-info pull-right" id="programButton" onclick="programExecution()"><g:message code="execution.create"/></button>
								<br/>
								<br/>
								
							</div>
						
							<div class="chart tab-pane" id="programmedExecutions-chart" style="position: relative;">
								<div class="box">

									<!-- /.box-header -->
									<div class="box-body">

										<div class="col-md-6">
												
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
												<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									       		<li class="active"><g:message code="general.text.executions"/></li>
									    	</ol>
										</div>
										<!-- /.restriccion segun licencia -->
										<sec:ifAnyGranted roles="${functionality33.roles}">
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
										<button class="btn btn-danger pull-right" id="deleteSelection" ><g:message code="text.delete" /> <i class="fa fa-trash"></i></button>
										<label style="padding-top: 6px; margin-right:10px;" class="pull-right">
											<g:message code="general.text.selectAll" />
											<input id="selectAllRowsSwitch" class="ios-switch"  type="checkbox">
											<div class="switch"></div>
										</label>
										<table id="programmedExecutionsTable" class="table table-bordered table-striped sortable paginated">
											<thead>
												<tr>
													<th><g:message code="text.executor" /></th>
													<th><g:message code="text.target" /></th>
													<th><g:message code="text.scenario" /></th>
													<th><g:message code="text.cases"/></th>
													<th><g:message code="text.browsers" /></th>
													<sec:ifAllGranted roles="ROLE_USER_LEADER">
														<th><g:message code="text.delete" /></th>
													</sec:ifAllGranted>
												</tr>
											</thead>
											<tbody>
												<g:each in="${programmedExecutions}" var="execution">
													<tr executionId="${execution.id}" class="trSelectableExecutions" select="0">
														<td>
															${execution.creator}
														</td>
														<td>
															<g:each in="${execution.targets}">

																<a href="#" data-toggle="tooltip" title="${it.fullname}">
																	<asset:image src="avatars/${it.avatarFile}" class="img-circle" style="width:35px; height:35px"/> 
																</a>

															</g:each>
														</td>
														<td>
															${execution.scenario}
														</td>
														<td>
															${execution.cases}
														</td>
														<td>
														<g:each in='${execution.browsers.split(",")}'>
															<asset:image src="browsers/${it.toLowerCase()}.png" class="img-circle" style="width:35px; height:35px"/> 
														</g:each>
														</td>
														<sec:ifAllGranted roles="ROLE_USER_LEADER">
															<td>
																<a href="#" onclick="setProgrammedDeletingId(${execution.id}); return false;" style="color:red"><i class="fa fa-trash-o"> </i></a>
															</td>
														</sec:ifAllGranted>
													</tr>
												</g:each>
											</tbody>
										</table>
										<!-- fin restriccion por licencia -->
										</sec:ifAnyGranted>
										<sec:ifNotGranted roles="${functionality33.roles}">
											<div class="row well" >
												<p style="color:#EB6912;"><b><g:message code="tooltip.upgrade.text" /></b></p>
											</div>
											<br/>
										</sec:ifNotGranted>	
									</div>
									
										<!-- /.box-body -->
								</div>
								<!-- /.box -->
							</div>

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


	<!-- Modal de confirmación de borrado de execution -->
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
						onclick="deleteExecution()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->




	<!-- Modal de confirmación de borrado de execution programada-->
	<div id="programmedConfirmModal" class="modal fade " role="dialog">
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
						onclick="deleteProgrammedExecution()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->



	<!-- Modal de error-->
	<div id="errorModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-danger">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.error" />
					</h4>
				</div>
				<div class="modal-body">
					<p id="modalErrorMessage">
						
					</p>
				</div>
				
			</div>
		</div>
	</div>
	<!-- Final del modal de error -->

	<!-- Modal de confirmación de borrado masivo de Mensajes -->
	<div id="masiveDeleteConfirmModal" class="modal fade " role="dialog">
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
					onclick="masiveDeleteExecutions()">
					<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación de borrado masivo de Mensajes -->




	<script>
	var currentPage = 0;
	var numPerPage = 10;
	var programmedDeletingId
	var executionsToDelete = ""
		
		$(window).load( function(){
			notificationsInterval = setInterval(getNotifications, 8000);
			setInterval(refreshExecutions, 4000);
			 $('[data-toggle="tooltip"]').tooltip(); 
			 $('#scenarioSelect').change()

			if( $('select#projectSelect option').length ==0 || $('select#scenarioSelect option').length ==1){
				$('#programButton').prop('disabled', true);
			}
		})
		makeTablePaginated()

		$('#scenarioSelect').change(function(){
			if( $('select#projectSelect option').length ==0 || $('select#scenarioSelect option').length ==1){
				$('#programButton').prop('disabled', true);
			} else{
				$('#programButton').prop('disabled', false);
			}
		}); 

		$('#rowsPerPageSelect').change(function(){
			numPerPage = $(this).val()
			$('.pager').remove()
			makeTablePaginated()
		}); 

		$('#expiredSessionModal').on('hidden.bs.modal', function(){
			location.reload()
		})




	function setDeletingId(newId) {
		deletingId = newId
		$('#confirmModal').modal('show');
	}

	function setProgrammedDeletingId(newId) {
		programmedDeletingId = newId
		$('#programmedConfirmModal').modal('show');
	}

	function deleteExecution() {
		$.ajax({
			method: "POST",
			url: "${createLink(action:'delete', controller:'execution')}",
			data: {
				id: deletingId,
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



		function deleteProgrammedExecution() {
			$.ajax({
				method: "POST",
				url: "${createLink(action:'deleteProgrammed', controller:'execution')}",
				data: {
					id: programmedDeletingId,
				},
				success: function(result) {
					$('#programmedConfirmModal').modal('hide')
					location.reload()
				},
				error: function(status, text, result, xhr) {
					showDeleteErrorModal(status.responseText);
				}
			});
		}

	function showDeleteErrorModal(text){
		$('#confirmModal').modal('hide');
		$('#newObjectErrorMessage').html(text)
		$('#newObjectErrorModal').modal('show');
	}


	function showErrorModal(text){
		$('#errorModal').modal('hide');
		$('#modalErrorMessage').html(text)
		$('#errorModal').modal('show');
	}



	function refreshExecutions(){

		var currentTrs = $('#executionsTable > tbody > tr')
		for(var i=0; i<currentTrs.length;i++){
			var curId=($(currentTrs[i]).attr('executionId'))
		}
		
		$.ajax({
			method: "POST",
			url: "${createLink(action:'getExecutions', controller:'execution')}",
			success: function(result) {
				if(result.length==0){
					$('#executionsTable >tbody').empty()
				}
				var currentTrs = $('#executionsTable > tbody > tr')
				var trIds = []
				for(var i=0; i<currentTrs.length;i++){
					trIds.push($(currentTrs[i]).attr('executionId'))
				}
				var resultIds = []
				for(var i=0; i<result.length;i++){
					
				}

				for(var i=0; i<result.length;i++){
					var idFlag=false					
					if($.inArray(result[i].id.toString(),trIds)>-1){
						if(result[i].stateMessage == 'text.created'){
							result[i].stateMessage = '${message(code: "execution.waitingDate")}'
						}
						$('#progress'+result[i].id).css('width', result[i].progress+'%').attr('aria-valuenow', result[i].progress); 
						$('#progress'+result[i].id).html(result[i].progress+"%"); 
						$('#message'+result[i].id).html(result[i].stateMessage)
						var removeItem = result[i].id
						trIds = jQuery.grep(trIds, function(value) {
	  					return value != removeItem;
						});
					}
					else{
						var newRow = '<tr executionId="'+result[i].id+'"><td>'+result[i].executionDate.toString().substring(0,19)+'</td><td>'+result[i].creator+'</td><td>'+result[i].host+'</td><td>'+result[i].scenarioToExecute+'</td><td><div class="progress active"><div id="progress'+result[i].id+'" class="progress-bar progress-bar-primary progress-bar-striped active"role="progressbar" aria-valuenow="'+result[i].progress+'" aria-valuemin="0" aria-valuemax="100" style="width: '+result[i].progress+'; min-width:2em;">'+result[i].progress+'%</div></div>'+'</td><td id="message'+result[i].id+'">'+result[i].stateMessage+'</td>'
						<sec:ifAllGranted roles="ROLE_USER_LEADER">
							newRow += '<td><a href="#" onclick="setDeletingId('+result[i].id+'); return false;"><i class="fa fa-trash-o"> </i></a></td>'
						</sec:ifAllGranted>
						$('#executionsTable > tbody').append(newRow)
					}
				}
				for(var i=0; i<trIds.length;i++){
					$('tr[executionId="'+trIds[i]+'"]').remove()
				}
			},
			error: function(status, text, result, xhr) {
				showDeleteErrorModal(status.responseText);
			}
		});
	}

	$('.btn-thunder').click(function(){
		$('.btn-thunder').each(function(){
			$(this).removeClass('btn-default btn-info')
			$(this).addClass('btn-default')
		})
		if($(this).attr('id')=='specificDays'){
			$('#daysDiv').css('display', 'block')
		}
		else{
			$('#daysDiv').css('display', 'none')
		}
		$(this).removeClass('btn-default')
		$(this).addClass(' btn-info ')
	})

	$('.btn-thunder-d').click(function(){
		if(!$(this).hasClass('active')){
			$(this).addClass('btn-info').removeClass('btn-default')
		}
		else{
			$(this).removeClass('btn-info').addClass('btn-default')
		}
	})



	$('#scenarioSelect').change(function(){
		if($("#scenarioSelect option:selected").attr('isweb') == 'true'){
			$('#browsersGroup').css('display','block')
			$('#browsersGroup').css('height','90px')
			$('#browsersLabel').css('display','block')
		}
		else{
			$('#browsersGroup').css('display','none')
			$('#browsersLabel').css('display','none')
		}
	})


	function programExecution(){
		var type = 1
		if($('#specificDays').hasClass('active')){
			type=2
		}
		if($('#daily').hasClass('active')){
			type=3
		}
		var project = $('#projectSelect').val()
		var scenario = $('#scenarioSelect').val()
		var cases = $('#cases').val().trim()
		var initialDate = $('#initialDate').val().trim()
		var daysOfWeek = ""
		var targets = ""
		var browsers = ""
		$('.day').each(function(){
			if($(this).hasClass('active')){
				daysOfWeek+=$(this).attr('value')+","
			}
		})

		$('.target').each(function(){
			if($(this).hasClass('active')){
				targets+=$(this).attr('value')+","
			}
		})

		$('.browser').each(function(){
			if($(this).hasClass('active')){
				browsers+=$(this).attr('value')+","
			}
		})

    	var now = new Date()
		var localOffset = now.getTimezoneOffset();


		$.ajax({
			method: "POST",
			url: "${createLink(action:'programExecution', controller:'execution')}",
			data: {
				execType: type,
				daysOfWeek: daysOfWeek,
				project: project,
				scenario: scenario,
				cases: cases,
				targets: targets,
				browsers: browsers,
				initialDate:initialDate,
				localOffset: localOffset
			},
			success: function(result) {
				//console.log("success")				
				$('#executionSuccessMessage').html("${message(code:'execution.create.success')}")
				$('#executionSaveModal').modal('show')
			},
			error: function(status, text, result, xhr) {
				showErrorModal(status.responseText);
			}
		});
	}

	$("#executionSaveModal").on("hide.bs.modal", function(){
   		location.reload();
	});

	$('#projectSelect').change(function(){
		if( $('select#projectSelect option').length ==0 || $('select#scenarioSelect option').length ==1){
				$('#programButton').prop('disabled', true);
			} else{
				$('#programButton').prop('disabled', false);
			}
		var id = $(this).val()
		$.ajax({
			method: 'POST',
			url: "${createLink(controller:'execution',action:'chooseScenario')}",
			data: {
				id:id					
			},
			success: function(result){
				$('#scenarioSelect').html(result)
			},
			error: function(status, text, result, xhr){
				
			}
		});		
	})

	$('#selectAllRowsSwitch').change(function(){
		if(this.checked) {
			$('.trSelectableExecutions').each(function(i, obj) {
				$(this).css('background-color','#ccd9ff')
				$(this).attr('select','1')
			});
		}
		else{				
			$('.trSelectableExecutions').each(function(i, obj) {			
				$(this).css('background-color','')
				$(this).attr('select','0')			
			});				
		}
	})

	$('.trSelectableExecutions').click(function(){
		var selected = $(this).attr('select')
		if(selected =="0"){
			$(this).css('background-color','#ccd9ff')
			$(this).attr('select','1')
		}
		else{
			$(this).css('background-color','')
			$(this).attr('select','0')
		}
	})

	$("#deleteSelection").click(function() {			
		$("#programmedExecutionsTable > tbody > .trSelectableExecutions").each(function() {
			if($(this).attr('select')=='1'){
				executionsToDelete+=$(this).attr('executionId')+","
			}
		});
		if(executionsToDelete!=""){
			$("#masiveDeleteConfirmModal").modal('show')
		}	
	})

	function masiveDeleteExecutions(){
		$.ajax({
			method: "POST",
			url: "${createLink(action:'deleteMasiveProgrammed', controller:'execution')}",
			data: {
				executionsToDelete: executionsToDelete,
			},
			success: function(result) {
				$('#masiveDeleteConfirmModal').modal('hide')
				location.reload()
			},
			error: function(status, text, result, xhr) {
				$('#masiveDeleteConfirmModal').modal('hide')
				executionsToDelete = ""
				showDeleteErrorModal(status.responseText);
			}
		});
	}

	</script>
	
</div>







