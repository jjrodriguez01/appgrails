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
					<g:message code="log.executeCases" />
				</li>
			</ul>	
			<div class="tab-content no-padding">
				<sec:ifAnyGranted roles="${functionality25.roles}">
					<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
						<div class="box">
							<div class="box-body"  style="overflow-x:scroll" >
								<div class="col-md-6">
								</div>
								<div class="col-md-6">
									<ol class="breadcrumb pull-right" style="background-color:white">
										<li><g:link controller='user' action='renderIndex'><g:message code='general.home'/></g:link></li>
							        	<sec:ifAnyGranted roles="${functionality24.roles}">
							        		<li><g:link controller='Log' action='index'>${associatedLog.scenario}</g:link></li>
							       		</sec:ifAnyGranted>
							       		<sec:ifAnyGranted roles="${functionality25.roles}">
							       			<li class="active"><g:message code="log.executeCases"/></li>
							       		</sec:ifAnyGranted>
							    	</ol>
								</div>
							<div class="box-header col-md-12">
							<div class="col-md-6">
												
							</div>
							<div class="col-md-6">
												
							</div>
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
						<table id="logsTable" class="table table-bordered table-condensed table-hover sortable paginated">
							<thead>
								<tr>
									<th><g:message code="log.testCase" /></th>
									<th><g:message code="log.browser" /></th>
									<th><g:message code="log.state" /></th>
									<th><g:message code="log.stepCount" /></th>
									<th><g:message code="log.executedSteps" /></th>
									<th><g:message code="log.duration" /></th>
									<th><g:message code="log.viewDetails" /></th>
								</tr>
							</thead>
							<tbody>
								<g:each in="${logs.sort{it.dateCreated}}">
									<tr>
										<td>
											${it.caseName}
										</td>
										<td>
											${it.browser}
										</td>
										
										<g:if test="${!it.isSuccess}">
											<td>
												<small class="label label-danger"><g:message code='general.error'/></small>
											</td>
										</g:if>
										<g:else>
											<td>
												<small class="label label-success"><g:message code='general.success'/></small>
											</td>
										</g:else>
											
									
										<td>
											${it.stepCount}
										</td>
										<td>
											${it.executedStepCount}
										</td>
										<td>
											${it.duration}
										</td>
										<sec:ifAnyGranted roles="${functionality26.roles}">
											<td>
												<a href="${createLink(controller:'Log', action:'stepLogs', id:it.id)}" class="navLink">
												<i class="fa fa-eye"> </i>
												<g:message code="log.details" />
											</a>
											</td>
										</sec:ifAnyGranted>
										<sec:ifNotGranted roles="${functionality26.roles}">
											<td>
												<a href="#" onclick="showDemoRestrictionModal()">
													<i class="fa fa-eye"> </i>
													<g:message code="log.details" />
												</a>
											</td>
										</sec:ifNotGranted>
									</tr>
								</g:each>
							</tbody>
						</table>
						<div class="tab-content no-padding">
							<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
								<div class="box">
								</div>
								<!-- /.box -->
							</div>
						</div>
					</div>
				</sec:ifAnyGranted>
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
	<!-- plantilla para modal de restricciones cuenta demo-->
	<g:render template="/user/restrictionsDemo"/>

		<script type="text/javascript">
			var currentPage = 0;
			var numPerPage = 10;


			
			$(window).load( function(){
				notificationsInterval = setInterval(getNotifications, 8000);
				enableSearch()
				makeTablePaginated()
			})


			$('#rowsPerPageSelect').change(function(){
				numPerPage = $(this).val()
				$('.pager').remove()
				makeTablePaginated()
			}); 

			$('#expiredSessionModal').on('hidden.bs.modal', function () {
				location.reload()
			})
		</script>
</div>
</body>
</html>

