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
						<sec:ifAnyGranted roles="${functionality8.roles}">
							<li>
								<a href="#newScenario-chart" data-toggle="tab">
								<i class="fa fa-plus" style="color: green"> </i> 
								<g:message code="text.new" /> </a>
							</li>
						</sec:ifAnyGranted>
						<li>
							<a href="#statisticsTab" data-toggle="tab" onclick="instanceCharts()">
							<i class="fa fa-line-chart" style="color: green"> </i> 
								<g:message code="general.text.statistics" />
							</a>
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
										<div class="col-md-6">
											
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
												<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									        	<li><g:link controller='project' action='index'>${associatedProject.name}</g:link></li>
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
														<th><g:message code="text.cycle" /></th>
														<th><g:message code="text.version" /></th>
														<g:if test="${showPrefix}">
															<th><g:message code="text.casePrefix" /></th>
														</g:if>
														<th><g:message code="text.messages"/></th>
														<th><g:message code="text.steps"/></th>
														<th><g:message code="text.cases" /></th>
														<sec:ifAnyGranted roles="${functionality17.roles}">
															<th><g:message code="text.execute" /></th>
														</sec:ifAnyGranted>
														<sec:ifAnyGranted roles="${functionality9.roles}">
															<th><g:message code="text.edit" /> / <g:message code="text.delete" /></th>
														</sec:ifAnyGranted>
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
																	<small class="label label-success">THUNDER</small>
																</g:if>
																<g:elseif test="${it.type==2}">
																	<small class="label label-danger">UFT</small>
																</g:elseif>
																<g:elseif test="${it.type==3}">
																	<small class="label" style="background-color:#8b6ecc">RFT</small>
																</g:elseif>
															</td>
															<td id="cycle${it.id}">
																${it.cycle}
															</td>
															<td id="version${it.id}">
																${it.appVersion}
															</td>
															<g:if test="${showPrefix}">
																<td id="prefix${it.id}">
																	${it.casePrefix}
																</td>
															</g:if>
															<td>
															<sec:ifAnyGranted roles="${functionality31.roles}">
																<g:link controller="message" action="scenario" id="${it.id}" class="navLink"><g:message code="text.viewMessages"/>
																</g:link>
															</sec:ifAnyGranted>
															<sec:ifNotGranted roles="${functionality31.roles}">
																<a href="#" onclick="showDemoRestrictionModal()">
																	<g:message code="text.viewMessages" />
																</a>
															</sec:ifNotGranted>
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

															
														<sec:ifAnyGranted roles="${functionality17.roles}">
															<g:if test="${it.isWeb() || it.type == 2}" >
																<td><a href="#" onclick="showBrowsers(${it.id}); return false;"/>
																	<i class="fa fa-play-circle-o" style="color:green; padding-left:30%; font-size:200%; cursor:pointer" ></i>
																	</a>
																</td>
															</g:if>															
															<g:else>
																<td><a href="#" onclick="executeScenario(${it.id}); return false;"/>
																	<i class="fa fa-play-circle-o" style="color:green; padding-left:30%; font-size:200%; cursor:pointer" ></i>
																	</a>
																</td>
															</g:else>
														</sec:ifAnyGranted>

															
															<sec:ifAnyGranted roles="${functionality9.roles}">
																<td>
																	<a href="#" onclick="showEditScenarioModal(${it.id}); return false;">
																		<i class="fa fa-edit"> </i>
																	</a>
																<sec:ifAnyGranted roles="${functionality35.roles}">
																	<a href="#" onclick="setDeletingId(${it.id}); return false;">
																		<i class="fa fa-trash-o" style="color:red"> </i>
																	</a>
																</sec:ifAnyGranted>
																<sec:ifNotGranted roles="${functionality35.roles}">
																	<a href="#" onclick="showDemoRestrictionModal()">
																		<i class="fa fa-trash-o" style="color:red"> </i>
																	</a>
																</sec:ifNotGranted>
																</td>
															</sec:ifAnyGranted>
														</tr>
													</g:each>
												</tbody>
											</table>
									</div>
										<!-- /.box-body -->
								</div>
								<!-- /.box -->
							</div>
							<sec:ifAllGranted roles="ROLE_USER_LEADER">
								<div class="chart tab-pane" id="newScenario-chart"
									style="position: relative;">
									<div id="formNewScenario"
										style="margin-left: 20px; padding-right: 20px;">
										<br/>
										<label for="name"><g:message code="text.name" /></label> <input
											class="form-control" type="text" name="name" id="name"><br>
										<label for="cycle"><g:message
												code="text.cycle" /></label> <input class="form-control"
												type="text" name="cycle" id="cycle"><br>
										<label for="version"><g:message
												code="text.version" /></label> <input class="form-control"
												type="text" name="version" id="version"><br>
										<label for="type"><g:message code="text.type"/></label>
										<select id="newScenarioType" class="form-control" onchange="changeFunc(value);">
											<option value="1" selected>THUNDER</option>
											<sec:ifNotGranted roles="${functionality36.roles}">
											<option value="2">UFT</option>
											<option value="3">RFT</option>
											</sec:ifNotGranted>
											<sec:ifAnyGranted roles="${functionality36.roles}">
											<option value="2">UFT</option>
											<option value="3">RFT</option>
											</sec:ifAnyGranted>
										</select>
										</br>
										<textarea id="newScenarioTypeDescription" class="form-control"  style="resize:vertical" readonly><g:message code="text.thunderDescription"/>
										</textarea>
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
								</div><br/>
							</sec:ifAllGranted>

							<div class="chart tab-pane" id="statisticsTab" style="position: relative;">
								<section class="col-lg-7">
									<div class="box box-success">
										<div class="box-header">
											<i class="ion ion-network"> </i>
											<h3 class="box-title"><g:message code="text.casesByBrowser"/></h3>
											<button class="btn btn-default btn-sm pull-right" data-widget='collapse' 	style="margin-right: 5px; border:1px solid #e0e0eb">
												<i class="fa fa-minus"> </i>
											</button>
										</div>

										<div class="box-body chart">

							                <canvas height="230" width="501" id="barChart" style="height: 230px; width: 501px;">
							                </canvas>
										</div>
										<!-- /.chat -->
										<div class="box-footer no-border">
											<div class="row" style="margin-right:1%; margin-left:4%; margin-top:-6%">
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/ch.png' width="50px" style="margin-left:10%"/>
												</div>
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/ff.png' width="50px" style="margin-left:10%"/>
												</div>
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/ed.png' width="50px" style="margin-left:10%"/>
												</div>
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/sa.png' width="50px" style="margin-left:10%" />
												</div>
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/ie.png' width="50px" style="margin-left:10%"/>
												</div>
												<div  class="col-md-2 col-xs-2 col-sm-2" >
													<asset:image src='browsers/op.png' width="50px" style="margin-left:10%"/>
												</div>
												
											</div>
										</div>
									</div>
									<!-- /.box (cases box) -->

									<!-- Executions box  -->
									<div class="box box-primary">
							            <div class="box-header no-border">
							              <i class="fa fa-line-chart"></i>
							              <h3 class="box-title"><g:message code="text.casesByMonth"/></h3>

							              <div class="box-tools pull-right">
							               <button class="btn btn-default btn-sm pull-right" data-widget='collapse' 	style="margin-right:5px;  border:1px solid #e0e0eb">
												<i class="fa fa-minus"> </i>
											</button>
							               
							              </div>
							            </div>
							            <div class="box-body">
							              <div class="chart">
							               <canvas id="areaChart" width="600" height="300"></canvas>

							              </div>
							            </div>
							            <!-- /.box-body -->
							        </div>
							        <!-- /.box (executions box) -->
								</section>

								<section class="col-lg-5">
									<div class="box box-danger ">
										<div class="box-header">
											<!-- tools box -->
											<div class="pull-right box-tools">
												<button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
												<i class="fa fa-minus"> </i>
												</button>
											</div>
											<i class="ion ion-ios-box"> </i>
											<h3 class="box-title"><g:message code='text.inventory'/></h3>
										</div>
										<div class="box-body">
								          <!-- /.info-box -->
								          <div class="info-box bg-green">
								            <span class="info-box-icon"><i class="ion ion-ios-list-outline"></i></span>

								            <div class="info-box-content">
								              <span class="info-box-text"><g:message code='text.scenarios'/></span>
								              <span class="info-box-number">${associatedProject.scenarios.flatten().size()}</span>

								              <div class="progress">
								                <div class="progress-bar" style="width: ${associatedProject.scenarios.flatten().size()*5%100}%"></div>
								              </div>
								                  <span class="progress-description">
								                      <g:message code="statistic.message.scenarios" args="[associatedProject.scenarios.flatten().size()]"/>
								                  </span>
								            </div>
								            <!-- /.info-box-content -->
								          </div>
								          <!-- /.info-box -->
								          <div class="info-box bg-red">
								            <span class="info-box-icon"><i class="ion ion-network"></i></span>

								            <div class="info-box-content">
								              <span class="info-box-text"><g:message code="text.cases"/></span>
								              <span class="info-box-number">${associatedProject.scenarios.flatten()*.cases.flatten().size()}</span>

								              <div class="progress">
								                <div class="progress-bar" style="width: ${associatedProject.scenarios.flatten()*.cases.flatten().size()*5%100}%"></div>
								              </div>
								                  <span class="progress-description">
								                    <g:message code="statistic.message.cases" args="[associatedProject.scenarios.flatten()*.cases.flatten().size()]"/>
								                  </span>
								            </div>
								            <!-- /.info-box-content -->
								          </div>
								          <!-- /.info-box -->
								          <div class="info-box bg-aqua">
								            <span class="info-box-icon"><i class="ion-ios-browsers-outline"></i></span>

								            <div class="info-box-content">
								              <span class="info-box-text"><g:message code='text.pages'/></span>
								              <span class="info-box-number">${associatedProject.pages.flatten().size()}</span>

								              <div class="progress">
								                <div class="progress-bar" style="width: ${associatedProject.pages.flatten().size()*5%100}%"></div>
								              </div>
								                  <span class="progress-description">
								                   <g:message code="statistic.message.pages" args="[associatedProject.pages.flatten().size()]"/>
								                  </span>
								            </div>
								            <!-- /.info-box-content -->
								          </div>
								          <!-- /.info-box -->
										</div>
										<!-- /.box-body-->
										<div class="box-footer no-border">
											
										</div>
									</div>
									<!-- /.box -->

									<!--  -->
									<div class="box box-default">
							            <div class="box-header ">
							             	<div class="box-tools pull-right">
								                <button class="btn btn-default btn-sm pull-right" data-widget='collapse' style="margin-right: 5px; border:1px solid #e0e0eb">
												<i class="fa fa-minus"> </i>
												</button>
							              	</div>
							              	<i class="ion ion-earth"> </i>
											<h3 class="box-title"><g:message code='text.browsersUsage'/></h3>
							            </div>
							            <!-- /.box-header -->
							            <div class="box-body">
											<div class="row">
												<div class="col-md-8">
													<div class="chart-responsive">
														<canvas style="width: 202px; height: 160px;" width="202" id="pieChart" height="160"></canvas>
													</div>
												</div>
							                	<!-- /.col -->
												<div class="col-md-4">
													<ul class="chart-legend clearfix">
														<li><i class="fa fa-circle-o text-green"></i> Chrome</li>
														<li><i class="fa fa-circle-o text-orange"></i> FireFox</li>
														<li><i class="fa fa-circle-o text-blue"></i> Edge</li>
														<li><i class="fa fa-circle-o text-gray"></i> Safari</li>
														<li><i class="fa fa-circle-o text-aqua"></i> IE</li>
														<li><i class="fa fa-circle-o text-red"></i> Opera</li>
													</ul>
												</div>
							               		 <!-- /.col -->
											</div>
							              <!-- /.row -->
							            </div>
							            <!-- /.box-body -->
							            <div class="box-footer no-padding">
							              
							            </div>
							            <!-- /.footer -->
							        </div>
									<!-- /.box -->
								</section>
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
						<!--
						<label for="prefix">
							<g:message code="text.casePrefix" />
						</label>
						<input class="form-control editInput" type="text" name="prefix" id="editPrefix"/>-->
						
						
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


	<!-- Modal de error de creacion de scenario cuenta demo-->
	<div id="newScenarioDemoModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-warning">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="general.info" />
					</h4>
				</div>
				<div class="modal-body">
					<g:message code="com.model.scenario.restriction.demo" />
				</div>
			</div>
		</div>
	</div>
	<!-- Fin del modal de creacion de scenario demo -->

	<g:render template="/user/restrictionsDemo"/>


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
						<br>
						<br>
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

	<!-- plantilla para modal de restricciones cuenta demo-->
	<g:render template="/user/restrictionsDemo"/>


	<script type="text/javascript">

		var data = {
			    labels: ["", "", "","", "", ""],
			    datasets: [
			        {
			            label: "${message(code:'general.error')}",
			            fillColor: "rgba(230,33,23,0.7)",
			            strokeColor: "rgba(255,0,0,0.9)",
			            highlightFill: "rgba(255,0,0,0.3)",
			            highlightStroke: "rgba(255,0,0,0.4)",
			            data: [${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && !it.isSuccess}},${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && !it.isSuccess}},${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && !it.isSuccess}}]
			        },
			        {
			            label: "${message(code:'general.success')}",
			            fillColor: "rgba(151,187,205,0.5)",
			            strokeColor: "rgba(151,187,205,0.8)",
			            highlightFill: "rgba(151,187,205,0.3)",
			            highlightStroke: "rgba(151,187,205,0.4)",
			            data: [${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome') && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox') && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge') && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari') && it.isSuccess}},${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer') && it.isSuccess}},${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera') && it.isSuccess}}]
			        }
			    ]
			};




			var pieData = [
    
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('chrome')}},
		        color: "#00a65a",
		        highlight: "#3DD991",
		        label: "Chrome"
		    },
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('firefox')}},
		        color: "#f39c12",
		        highlight: "#F5BB5F",
		        label: "FireFox"
		    },
		    
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('edge')}},
		        color: "#0073b7",
		        highlight: "#73A9C9",
		        label: "Edge"
		    },
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('safari')}},
		        color: "#d2d6de",
		        highlight: "#E6E8ED",
		        label:"Safari"
		    },
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('explorer')}},
		        color: "#00c0ef",
		        highlight: "#AEDDE8",
		        label: "IE"
		    },
		    {
		        value: ${associatedProject.logs.flatten()*.logs.flatten().count{it.browser.toLowerCase().contains('opera')}},
		        color:"#dd4b39",
		        highlight: "#E3887D",
		        label: "Opera"
		    }
		]



	var lineData = {
	    labels: ["${message(code:'text.january')}", "${message(code:'text.february')}", "${message(code:'text.march')}", "${message(code:'text.april')}", "${message(code:'text.may')}", "${message(code:'text.june')}", "${message(code:'text.july')}", "${message(code:'text.august')}", "${message(code:'text.september')}", "${message(code:'text.october')}", "${message(code:'text.november')}", "${message(code:'text.december')}"],
	    datasets: [
	        {
	            label: "${message(code:'general.success')}",
	            fillColor: "rgba(0,166,90,0.2)",
	            strokeColor: "rgba(0,160,90,1)",
	            pointColor: "rgba(0,160,90,1)",
	            pointStrokeColor: "rgba(0,160,90,1)",
	            pointHighlightFill: "#43CC8D",
	            pointHighlightStroke: "#43CC8D",
	            data: [${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  &&  it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()   && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString()  && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && it.isSuccess}}]
	        },
	        {
	            label: "${message(code:'general.error')}",
	            fillColor: "rgba(221,75,57,0.2)",
	            strokeColor: "rgba(221,75,57,1)",
	            pointColor: "rgba(221,75,57,1)",
	            pointStrokeColor: "rgba(221,75,57,1)",
	            pointHighlightFill: "#rgba(151,187,205,0.2)",
	            pointHighlightStroke: "rgba(151,187,205,0.6)",
	            data: [${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "01" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "02" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "03" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "04" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "05" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "06" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "07" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "08" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "09" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "10" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "11" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}, ${associatedProject.logs.flatten()*.logs.flatten().count{it.dateCreated.toString().substring(5,7) == "12" && it.dateCreated.toString().substring(0,4) == Calendar.getInstance().get(Calendar.YEAR).toString() && !it.isSuccess}}]
	        }
	    ]
	};



			$('a[href=#statisticsTab]').on('shown.bs.tab', function(){
				var barChartCanvas = $("#barChart").get(0).getContext("2d");
			    var barChart = new Chart(barChartCanvas);
			    var barChartData = data;
			    barChartData.datasets[1].fillColor = "#00a65a";
			    barChartData.datasets[1].strokeColor = "#00a65a";
			    barChartData.datasets[1].pointColor = "#00a65a";
			    var barChartOptions = {
			      //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
			      scaleBeginAtZero: true,
			      //Boolean - Whether grid lines are shown across the chart
			      scaleShowGridLines: true,
			      //String - Colour of the grid lines
			      scaleGridLineColor: "rgba(0,0,0,.05)",
			      //Number - Width of the grid lines
			      scaleGridLineWidth: 1,
			      //Boolean - Whether to show horizontal lines (except X axis)
			      scaleShowHorizontalLines: true,
			      //Boolean - Whether to show vertical lines (except Y axis)
			      scaleShowVerticalLines: true,
			      //Boolean - If there is a stroke on each bar
			      barShowStroke: true,
			      //Number - Pixel width of the bar stroke
			      barStrokeWidth: 2,
			      //Number - Spacing between each of the X value sets
			      barValueSpacing: 5,
			      //Number - Spacing between data sets within X values
			      barDatasetSpacing: 1,
			      //String - A legend template
			      legendTemplate: "",
			      //Boolean - whether to make the chart responsive
			      responsive: true,
			      maintainAspectRatio: true
			    };

			    barChartOptions.datasetFill = false;
			    barChart.Bar(barChartData, barChartOptions);


			    var pieChartCanvas = $("#pieChart").get(0).getContext("2d");
				var myPieChart = new Chart(pieChartCanvas).Doughnut(pieData,barChartOptions);

				var lineChartCanvas = $("#areaChart").get(0).getContext("2d");
				var myLineChart = new Chart(lineChartCanvas).Line(lineData,{
					datasetFill : true,
				});



			})

			


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
			$('.page-number').each(function(){
				$(this).remove()
			})
			numPerPage = $(this).val()
			makeTablePaginated()
		}); 

		

	    function setDeletingId(newId) {
	        deletingId = newId
	        $('#confirmModal').modal('show');

	    }


		makeTablePaginated()


		function getBrowsers(id){
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'getBrowsers', controller:'user')}",
				data:{
					id:id,
				},
				
				success: function(result) {
					console.log('success: '+result)

					userBrowsers = result
					console.log('userBrowsers: '+userBrowsers)
					if(result.indexOf('CH')==-1){
						$('#divch').css('display', 'none')
					}
					if(result.indexOf('FF')==-1){
						$('#divff').css('display', 'none')
					}
					if(result.indexOf('IE')==-1){
						$('#divie').css('display', 'none')
					}
					if(result.indexOf('ED')==-1){
						$('#dived').css('display', 'none')
					}
					if(result.indexOf('SA')==-1){
						$('#divsa').css('display', 'none')
					}
					if(result.indexOf('OP')==-1){
						$('#divop').css('display', 'none')
					}
					$("#checkch").prop("checked", false);
					$("#checkff").prop("checked", false);
					$("#checkie").prop("checked", false);
					$("#checksa").prop("checked", false);
					$("#checked").prop("checked", false);
					$("#checkop").prop("checked", false);
					webScenario = id
					console.log('browsers: '+userBrowsers)
					$('#browserSelectionModal').modal('show')
				},
				error: function(status, text, result, xhr) {
						$("#newScenarioErrorMessage").html(status.responseText)
						$("#newScenarioErrorModal").modal('show')
				}
			});

		}

		
		function createScenario(button){
			$(button).prop("disabled", true)
			$(button).html("<i class='fa fa-spinner fa-spin'></i>");
			var name = $('#name').val()
			var cycle = $('#cycle').val()
			var version = $('#version').val()
			var prefix =''// $('#prefix').val()
			var type = $('#newScenarioType').val()
			var uftRoute = $('#uftProjectRoute').val()
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'create', controller:'scenario')}",
				data:{
					name:name,
					cycle:cycle,
					version:version,
					casePrefix:prefix,
					id: ${projectId},
					type:type,
					uftRoute:uftRoute
				},
				success: function(dataCheck) {
					location.reload(true)
				},
				error: function(status, text, result, xhr) {
					if(status.status == 403){
						$('#newScenarioDemoModal').modal('show');
						$(button).html("${message(code:'general.text.save')}")
						$(button).prop("disabled", false)
					}else{
						$('#newScenarioErrorMessage').html(status.responseText)
						$('#newScenarioErrorModal').modal('show');
						$(button).html("${message(code:'general.text.save')}")
						$(button).prop("disabled", false)
					}
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


		function changeFunc($i) {
			<sec:ifNotGranted roles="${functionality36.roles}">
				 if($i == 2 || $i == 3){
		    	showDemoRestrictionModal();
		    	$("#newScenarioType").val(1);
		    }
			</sec:ifNotGranted>
		   }



	    function deleteScenario() {
	        $.ajax({
	            method: "POST",
	            url: "${createLink(action:'disable', controller:'scenario')}",
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


		function showBrowsers(id){
			getBrowsers(id)
		}

		function executeWebScenario(){
				$('#browserSelectionModal').modal('hide')
				var browsers =""
				if($('#checkch').prop('checked')){
					browsers+='CH,'}
				if($('#checkff').prop('checked')){
					browsers+='FF,'}
				if($('#checkie').prop('checked')){
					browsers+='IE,'}
				if($('#checksa').prop('checked')){
					browsers+='SA,'}
				if($('#checked').prop('checked')){
					browsers+='ED,'}
				if($('#checkop').prop('checked')){
					browsers+='OP,'}
				 $.ajax({
					   url: "${createLink(action:'executeWebScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: webScenario,
							browsers: browsers,
							forced: false,
						},
					success : function(result, status) {
						if(result=="queue"){
							$('#successModalMessage').html("${message(code:'scenario.execution.queued')}")
							$('#newScenarioSuccessModal').modal('show');
							setTimeout(function(){
  								$('#newScenarioSuccessModal').modal('hide')
							}, 3400)
						}
						else if(result=="direct") {
							$('#successModalMessage').html("${message(code:'scenario.execution.direct')}")
							$('#newScenarioSuccessModal').modal('show');
							setTimeout(function(){
  								$('#newScenarioSuccessModal').modal('hide')
							}, 3400)
						}
						else if(result=="confirm"){
							oldBrowsers = browsers
							oldExecutingId=webScenario
							oldExecutionType=1
							$('#forceExecutionModal').modal('show')
						}
						else if(result.indexOf("directWithExtractors")>-1){
								executionType = "direct"
								$('#executionSuccessMessage').html("${message(code:'execution.extractingData')}")
								$('#executionSuccessModal').modal('show');

								curExecutionRequestId = result.substring(result.indexOf(":")+1)
								executionResponseInterval = setInterval(checkExecutionResponse, 600);
						}
						else if(result.indexOf("queueWithExtractors")>-1){
								executionType = "queue"
								$('#executionSuccessMessage').html("${message(code:'execution.extractingData')}")
								$('#executionSuccessModal').modal('show');

								curExecutionRequestId = result.substring(result.indexOf(":")+1)
								executionResponseInterval = setInterval(checkExecutionResponse, 600);
						}
					},error: function(status, text, result, xhr){
							$("#newScenarioErrorMessage").html(status.responseText)
							$("#newScenarioErrorModal").modal('show')
							}
				});
			}



			function forceExecution(){
				$('#forceExecutionModal').modal('hide')
				if(oldExecutionType==1){
					$.ajax({
					   url: "${createLink(action:'executeWebScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: oldExecutingId,
							browsers: browsers,
							forced: true,
						},
						success : function(result, status) {
							if(result=="queue"){
								('#successModalMessage').html("${message(code:'scenario.execution.queued')}")
								$('#newScenarioSuccessModal').modal('show');
							}
							else if(result=="direct") {
								$('#successModalMessage').html("${message(code:'scenario.execution.direct')}")
								$('#newScenarioSuccessModal').modal('show');
							}
						},
						error: function(status, text, result, xhr){
							$("#newScenarioErrorMessage").html(status.responseText)
							$("#newScenarioErrorModal").modal('show')
							}
					});

				}
				if(oldExecutionType==2){
					$.ajax({
					   url: "${createLink(action:'executeScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: oldExecutingId,
							forced: true,
						},
						success : function(result, status) {
							if(result=="queue"){
								('#successModalMessage').html("${message(code:'scenario.execution.queued')}")
								$('#newScenarioSuccessModal').modal('show');
							}
							else if(result=="direct") {
								$('#successModalMessage').html("${message(code:'scenario.execution.direct')}")
								$('#newScenarioSuccessModal').modal('show');
							}
						},
						error: function(status, text, result, xhr){
							$("#newScenarioErrorMessage").html(status.responseText)
							$("#newScenarioErrorModal").modal('show')
							}
					});

				}
				
			}

		
			function executeScenario(id){
				 $.ajax({
					   url: "${createLink(action:'executeScenario', controller:'execution')}",
					   method:"POST",
					data:{ id: id,
						forced:false},
					success : function(result, status) {
						if(result=="queue"){
							('#successModalMessage').html("${message(code:'scenario.execution.queued')}")
							$('#newScenarioSuccessModal').modal('show');
						}
						else if(result=="direct") {
							$('#successModalMessage').html("${message(code:'scenario.execution.direct')}")
							$('#newScenarioSuccessModal').modal('show');
						}
						else if(result=="confirm"){
							oldExecutingId=webScenario
							oldExecutionType=2
							$('#forceExecutionModal').modal('show')
						}
					},
					error: function(status, text, result, xhr){
						$("#newScenarioErrorMessage").html(status.responseText)
						$("#newScenarioErrorModal").modal('show')
						}
				});
			}	
			
			$('.modal').on('hidden.bs.modal', function() {
						$("body").css('padding-right','0px')
					})
			$('#newScenarioType').change(function(){
				if($(this).val()==1){
					$('#newScenarioTypeDescription').text('${message(code:"text.thunderDescription")}')
					$('.uft-related').hide()
				}
				else if($(this).val()==2){
					$('#newScenarioTypeDescription').text('${message(code:"text.uftDescription")}')
					$('.uft-related').show()
				}
				else if($(this).val()==3){
					$('#newScenarioTypeDescription').text('${message(code:"text.rftDescription")}')
					$('.uft-related').hide()
				}

			})

	</script>
</div>
</body>
</html>

