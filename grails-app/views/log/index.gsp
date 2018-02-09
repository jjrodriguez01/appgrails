<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

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
					<ul class="nav nav-tabs pull-right">
						<li class="pull-left header"><i class="fa fa-inbox"> </i> 
							<g:message code="log.executeLog" />
						</li>
					</ul>	
					<div class="tab-content no-padding">
						<sec:ifAnyGranted roles="${functionality24.roles}">
							<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
								<div class="box">
									<div class="box-body"  style="overflow-x:scroll" >
										<div class="col-md-6">
													
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
												<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									    		<li class="active"><g:message code="log.executeLog"/></li>
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
											<input id="datatablesearch" table="logsTable"  name="search" type="text">
											</input>
										</div>
										<div id="filters" class="col-md-12" style="margin-bottom:10px; margin-top:10px">
											<div class="col-md-5">
												<div class="col-md-3" style="padding-top:8px">
													<label for="projectFilter">
														<g:message code='log.filterByProject'/>:
													</label>
												</div>
												<div class="col-md-9">
													<select id="projectFilter" class="form-control">
														<option value="null">--</option>
														<g:each in="${logs*.project.flatten().unique()}" var="project">
															<option value="${project.id}">${project.name}</option>
														</g:each>
													</select>
												</div>
											</div>
											<div class="col-md-5">
												<div class="col-md-4" style="padding-top:8px">
													<label for="scenarioFilter">
														<g:message code='log.filterByScenario'/>:
													</label>
												</div>
												<div class="col-md-8">
													<select id="scenarioFilter" class="form-control">
														<option value="null">--</option>
													</select>
												</div>
											</div>
										</div>
										<table id="logsTable" class="table table-bordered table-condensed table-hover sortable paginated">
											<thead>
												<tr>
													<th><g:message code="text.project"/></th>
													<th><g:message code="text.scenario" /></th>
													<th><g:message code="log.state" /></th>
													<th><g:message code="log.cycle" /></th>
													<th><g:message code="log.version" /></th>
													<th><g:message code="log.casesNumber" /></th>
													<th><g:message code="log.failCases" /></th>
													<th><g:message code="log.duration" /></th>
													<th><g:message code="log.dateExecution" /></th>
													<th><g:message code="log.host" /></th>
													<th><g:message code="log.executor" /></th>
													<sec:ifAnyGranted roles="${functionality25.roles}">
														<th><g:message code="log.viewDetails" /></th>
													</sec:ifAnyGranted>
												</tr>
											</thead>
											<tbody>
												<g:each in="${logs.sort{it.dateCreated}.reverse()}">
													
														<tr project="${it.project.id}" scenario="${it.associatedScenario.name}" >
													
														<td>
															${it.project.name}
														</td>
														<td>
															${it.associatedScenario.name}
														</td><td>
														<g:if test="${it.caseFailedCount > 0 || it.caseCount==0}">

															<small class="label label-danger"><g:message code='general.error'/></small>
														</g:if>
														<g:else>
															<small class="label label-success"><g:message code='general.success'/></small>

														</g:else>
														</td>
														<td>
															${it.cycle}
														</td>
														
														<td>
															${it.appVersion}
														</td>
														<td>
															${it.caseCount}
														</td>
														<td>
															${it.caseFailedCount}
														</td>
														<td>
															${it.duration}
														</td>
														<td>
															${it.executionDate}
														</td>
														<td>
															${it.target}
														</td>
														<td>
															${it.executor}
														</td>
														<sec:ifAnyGranted roles="${functionality25.roles}">
															<td>
																<a href="${createLink(controller:'Log', action:'caseLogs', id:it.id)}" class="navLink">
																	<i class="fa fa-eye"> </i>
																	<g:message code="log.details" />
																</a>
															</td>
														</sec:ifAnyGranted>
													</tr>
												</g:each>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</sec:ifAnyGranted>
					</div>
				</div>
			</div>
		</div>
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





	<script type="text/javascript">
		var currentPage = 0;
		var numPerPage = 10;

		$(window).load( function(){
			notificationsInterval = setInterval(getNotifications, 8000);
			enableSearch()
			$('.pager').remove()
			makeTablePaginated()
		})
		

		$('#rowsPerPageSelect').change(function(){
			numPerPage = $(this).val()
			$('.pager').remove()
			makeTablePaginated()
		}); 

		$('#projectFilter').change(function(){
			var tableHtml=""
			if($(this).val()=='null'){
				<g:each in="${logs}" >
								tableHtml+='<tr project="'+"${it.project.id}"+'" scenario="'+"${it.associatedScenario.name}"+'" >'
								
									tableHtml+= '<td>'+"${it.project.name}"+'</td>'
									tableHtml+= '<td>'+ "${it.associatedScenario.name}"+'</td>'
									if(${it.caseFailedCount}>0 || ${it.caseCount==0}){
										tableHtml+='<td><small class="label label-danger">'+"${message(code:'general.error')}"+'</small></td>'
									}
									else{
										tableHtml+='<td><small class="label label-success">'+"${message(code:'general.success')}"+'</small></td>'
									}
									tableHtml+= '<td>'+ "${it.cycle}"+'</td>'
									tableHtml+= '<td>'+ "${it.appVersion}"+'</td>'
									tableHtml+= '<td>'+ "${it.caseCount}"+'</td>'
									tableHtml+= '<td>'+ "${it.caseFailedCount}"+'</td>'
									tableHtml+= '<td>'+ "${it.duration}"+'</td>'
									tableHtml+= '<td>'+ "${it.executionDate}"+'</td>'
									tableHtml+= '<td>'+ "${it.target}"+'</td>'
									tableHtml+= '<td>'+ "${it.executor}"+'</td>'
									<sec:ifAnyGranted roles="${functionality25.roles}">
									tableHtml+='<td><a href="'+"${createLink(controller:'Log', action:'caseLogs', id:it.id)}"+'"><i class="fa fa-eye"> </i>'+"${message(code:'log.details')}"+'</a>	</td>'
									</sec:ifAnyGranted>
									tableHtml+='</tr>'
										
				</g:each>
				$('#logsTable > tbody').html(tableHtml)
				var newHtml = '<option value="null">--</option>'
				$('#scenarioFilter').html(newHtml)
			}
			else{
				var project = $(this).val()
				var scenarios =[]
				<g:each in="${logs}" >
							if("${it.project.id}"==project){
								if($.inArray("${it.associatedScenario.name}",scenarios)==-1){
									scenarios.push("${it.associatedScenario.name}")
								}
								
									tableHtml+='<tr project="'+"${it.project.id}"+'" scenario="'+"${it.associatedScenario.name}"+'" >'
								
									tableHtml+= '<td>'+"${it.project.name}"+'</td>'
									tableHtml+= '<td>'+ "${it.associatedScenario.name}"+'</td>'
									if(${it.caseFailedCount}>0 || ${it.caseCount==0}){
										tableHtml+='<td><small class="label label-danger">'+"${message(code:'general.error')}"+'</small></td>'
									}
									else{
										tableHtml+='<td><small class="label label-success">'+"${message(code:'general.success')}"+'</small></td>'
									}
									tableHtml+= '<td>'+ "${it.cycle}"+'</td>'
									tableHtml+= '<td>'+ "${it.appVersion}"+'</td>'
									tableHtml+= '<td>'+ "${it.caseCount}"+'</td>'
									tableHtml+= '<td>'+ "${it.caseFailedCount}"+'</td>'
									tableHtml+= '<td>'+ "${it.duration}"+'</td>'
									tableHtml+= '<td>'+ "${it.executionDate}"+'</td>'
									tableHtml+= '<td>'+ "${it.target}"+'</td>'
									tableHtml+= '<td>'+ "${it.executor}"+'</td>'
									tableHtml+='<td><a href="'+"${createLink(controller:'Log', action:'caseLogs', id:it.id)}"+'"><i class="fa fa-eye"> </i>'+"${message(code:'log.details')}"+'</a>	</td></tr>'
							}
								
										
				</g:each>
				$('#logsTable > tbody').html(tableHtml)


				var newHtml = '<option value="null">--</option>'
				for(var i=0; i<scenarios.length;i++){
					newHtml+='<option value="'+scenarios[i]+'" >'+scenarios[i]+'</option>'
				}
				$('#scenarioFilter').html(newHtml)

			}
			$('.pager').remove()
			makeTablePaginated()
		})

		$('#scenarioFilter').change(function(){

			var scenario = $(this).val()
			$('#projectFilter').change()
			$('#scenarioFilter option[value="'+scenario+'"]').prop('selected', true);

			if(scenario=='null')
			{
				$('#projectFilter').change()
			}
			else{
				var html = ""
				$('#logsTable > tbody > tr').each(function(){
					if($(this).attr('scenario')==scenario){
						html+='<tr project="'+$(this).attr('project')+'" scenario="'+$(this).attr('scenario')+'" style="'+$(this).attr('style')+'">'+$(this).html()+'</tr>'
					}
				})
				$('#logsTable > tbody').html(html)
			}
			$('.pager').remove()
			makeTablePaginated()
		})

			$('#expiredSessionModal').on('hidden.bs.modal', function () {
				location.reload()
			})


	</script>
</div>
</body>
</html>

