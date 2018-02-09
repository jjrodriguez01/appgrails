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

<script>
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

	<div class="row">
		<div class="col-xs-12">
			<div class="nav-tabs-custom">
					<!-- Tabs within a box -->
					<ul class="nav nav-tabs pull-right">
						<li class="active">
							<a href="#objectsTab" data-toggle="tab">
								<i class="fa fa-th-large" style="color: blue"> </i>
								<g:message code="text.objects" />
							</a>
						</li>
						<li>
							<a href="#messagesTab" data-toggle="tab" >
							<i class="fa fa-envelope-o" > </i> 
								<g:message code="text.messages" />
							</a>
						</li>
						<li class="pull-left header"><i class="fa fa-exchange"> </i> 
							<g:message code="general.text.stage" />
						</li>
					</ul>


					<div class="tab-content no-padding">
						<div  class="tab-pane active" id="objectsTab">
							<div class="box">
							<!-- /.box-header -->
								<div class="box-header">
									<div class="col-md-6">
										<h3>
											<i class="fa fa-th-large"> </i>
											<g:message code="text.objects" />
										</h3>
									</div>
									<div class="col-md-6">
										<ol class="breadcrumb pull-right" style="background-color:white">
									       	<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									  		<li class="active"><g:message code="general.text.stage"/></li>
									   	</ol>
									</div>
								</div>
								<div class="box-body">
									<div class="row">
										<div class="col-md-3">
											<label for="creatorSelector">
												<g:message code="text.filterByCreator" />
											</label>
											<br/>
											<select id="creatorSelector" name="creatorSelector" class="form-control filter" style="min-width: 100px">
												<option value="null">--</option>
												<g:each in="${objects*.creator.unique()}" var="creator">
													<option value="${creator.id}">${creator.fullname}</option>
												</g:each>
											</select>
										</div>
										<div class="col-md-3">
											<label for="recNameSelector">
												<g:message	code="text.filterByRecName" />
											</label> 
											<br/>
											<select id="recNameSelector" name="recNameSelector" class="form-control filter" style="min-width: 100px">
												<option value="null">--</option>
												<g:each in="${objects*.recName.unique()}" var="recName">
													<option value="${recName}">${recName}</option>
												</g:each>
											</select>
										</div>
										<div class="col-md-3">
											<label for="typeSelector">
												<g:message code="text.filterByType" />
											</label>
											<br/>
											<select id="typeSelector" name="typeSelector" class="form-control filter" style="min-width: 100px">
												<option value="null">--</option>
												<option value="1">WEB</option>
												<option value="2">GUI</option>
												<option value="3">CLI</option>
												<option value="4">UFT</option>
											</select>
										</div>
										
									</div>
									<br>
										<button class="btn btn-danger pull-right" id="deleteSelection" ><g:message code="text.delete" /> <i class="fa fa-trash"></i></button>
										<button id="addToPageButton" class="pull-right btn btn-info" style="margin-right:10px">
											<g:message code="text.addToPage" />
										</button>										
									<label style="padding-top: 6px; margin-right:70px;" class="pull-right">
										<g:message code="general.text.selectAll" /><input id="selectAllSwitch" class="ios-switch"  type="checkbox">
										<div class="switch"></div>
									</label>
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
									<label for="search">
										<g:message code="datatable.search"/>: 
									</label>
									<input id="datatablesearch" table="objectsTable"  name="search" type="text"></input>
									<table id="objectsTable" class="table table-bordered table-striped sortable paginated">
										<thead>
											<tr>
												<th><g:message code="text.name" /></th>
												<th><g:message code="text.referenceImage" /></th>
												<th><g:message code="text.creator" /></th>
												<th><g:message code="text.recName" /></th>
												<th><g:message code="text.createdDate" /></th>
												<th><g:message code="text.type"/></th>
												<th><g:message code="text.select" /></th>
												<th><g:message code="text.delete"/></th>
											</tr>
										</thead>
										<tbody>
											<g:each status="i" var="obj" in="${objects.findAll{!it.autoGenerated}}">
													<tr type="${obj.pType}" creator="${obj.creator.id}" recName="${obj.recName}">
														<td >
															${obj.name}
														</td>
														<td><img  class="zoomImage " style="max-height:50px; max-width:150px;"
															src="${createLink(controller: 'stage', action:'renderImage', params:[idOb:obj.imageUrl])}" />
														</td>
														<td>
															${obj.creator.fullname}
														</td>
														<td>
															${obj.recName}
														</td>
														<td id="dateCreated${obj.id}">

															<script>
																$('#dateCreated${obj.id}').html(new Date("${obj.dateCreated}").adjustDate())
															</script>
														</td>
														<td id="type${obj.id}">
															<g:if test="${obj.pType==1}">
																<small class="label label-success">WEB</small>
															</g:if>
															<g:elseif test="${obj.pType==2}">
																<small class="label label-info">GUI</small>
															</g:elseif>
															<g:elseif test="${obj.pType==3}">
																<small class="label label-warning">CLI</small>
															</g:elseif>
															<g:elseif test="${obj.pType==4}">
																<small class="label label-danger">UFT</small>
															</g:elseif>
															<g:elseif test="${obj.pType==5}">
																<small class="label" style="background-color:#8b6ecc">RFT</small>
															</g:elseif>
															
														</td>
														<td>
															<label>
																<input id="${obj.id}" type="checkbox" class="ios-switch objcheck" />
																<div class="switch"></div>
															</label>
														</td>
														<td>
															<g:if test="${obj.creator.username==curUsername}">
																<a href="#" onclick="confirmDelete(${obj.id}); return false;" style="color:red"><i class="fa fa-trash"></i></a>
															</g:if>
															<g:else>
																<a href="#" onclick="return false;"><i class="fa fa-trash"></i></a>
															</g:else>
														</td>
													</tr>
											</g:each>
										</tbody>
									</table>
								</div>
								<!-- /.box-body -->
								<!-- box footer -->
								<div class="box-footer"></div>
							</div>
							<!-- /.box -->
						</div>
						<!--Tab -->


						
							<!-- Messages Tab-->
							<div class="tab-pane" id="messagesTab">
								<div class="box">
									<div class="box-header">
										<div class="col-md-6">
												<h3>
													<i class="fa  fa-envelope-o"> </i>
													<g:message code="text.messages"/>
												</h3>
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
										       	<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
										  		<li class="active"><g:message code="general.text.stage"/></li>
										   	</ol>
										</div>
									</div>
									<!-- /.box-header -->
									<sec:ifAnyGranted roles="${functionality10.roles}">
									<div class="box-body row">
										<div style="margin-right:5%; margin-bottom:5%">
										<button id="addMessageToPageButton" class="pull-right btn btn-info" >
											<g:message code="text.addToPage" />
										</button>
										</div>
											<div class="col-md-3">
												<label class="form-control ">
													<g:message	code="general.text.selectAll" />
													<input	id="selectAllObjects" type="checkbox" class="ios-switch objectSwitch " />
													<div class="switch pull-right"></div>
												</label>
												<table class="table table-bordered table-condensed table-hover  paginated" id="sObjectsTable">
													<tbody  id="selectable">
														<g:each  status="i" var="obj" in="${objects}">
															<tr idObj="${obj.id}" class="trSelectable" select="0">
																<td style="border:solid 1px  #ccccb3;"  >
																	${obj.name}
																</td>
																<td style="border:solid 1px  #ccccb3;" >
																	<img  class="zoomImage objImg" style="max-height:50px;  max-width:150px" src="${createLink(controller: 'stage', action:'renderImage', params:[idOb:obj.imageUrl])}" />
																</td>
															</tr>
														</g:each>
													</tbody>
												</table>
											</div>
											<div class="col-md-1">
												<br><br><br>
												<g:each  var="i" in="${ (0..<messages.size()/2) }">
													<br>
												</g:each>
												
												<div  class="icon caretButton" style="color:green; margin-left:45%; cursor:pointer;">
													<i class="fa  fa-angle-double-right fa-5x"></i>
													<br/>
												</div>
												
											</div>
										<sec:ifNotGranted roles='${functionality10.roles}'>
											<div class="col-md-12 ">
										</sec:ifNotGranted>
										<sec:ifAnyGranted roles="${functionality10.roles}">
											<div class="col-md-8 row">
										</sec:ifAnyGranted>
											<label style="padding-top: 6px; margin-right:100px;" class="pull-right">
												<g:message code="general.text.selectAll" />
												<input id="selectAllMessagesSwitch" class="ios-switch"  type="checkbox">
												<div class="switch"></div>
											</label>
											<label>
											<g:message code="datatable.showing"/></label>
											<select id="messageRowsPerPageSelect" >
												<option value="10">10</option>
												<option value="25">25</option>
												<option value="50">50</option>
												<option value="100">100</option>
											</select>
											<label style="margin-right:45px">  <g:message code="datatable.entries"/>
											</label>
											<label for="search">
												<g:message code="datatable.search"/>: 
											</label>
											<input id="datatablesearch" table="messagesTable" name="search" type="text"/>
											
											<table id="messagesTable" class="table table-bordered table-condensed table-hover sortable paginated">
												<thead>
													<tr>
														<th><g:message code="text.object" /></th>
														<th><g:message code="text.referenceImage"/></th>
														<th><g:message code="text.type" /></th>
														<th><g:message code="text.message" /></th>
														<th><g:message code="text.byClueWords" /></th>
														<th><g:message code="text.addToPage" /></th>
														<sec:ifAnyGranted roles="${functionality11.roles}">
															<th><g:message code="text.edit" />/<g:message code="text.delete" /></th>
														</sec:ifAnyGranted>
													</tr>
												</thead>
												<tbody>
													<g:each status="i" in="${messages.sort{it.dateCreated}}" var="message">
														<tr id="${message.id}" class="messageTr">
															<td class="tdObj" id="${message.id}" idObj="${message.object.id}"imageUrl="${message.object.imageUrl}">
																${message.object.name} 
															</td>
															<td>
																<img id="img${message.id}" class="zoomImage " style="max-height:50px; max-width:150px" src="${createLink(controller: 'stage', action:'renderImage', params:[idOb:message.object.imageUrl])}" />
															</td>
															<td>
																<g:if test="${message.type==1}">
																	<span class="label bg-blue spanMsg" id="span${message.id}" value="1"><g:message code="general.pending"/></span>
																</g:if>
																<g:elseif test="${message.type==2}">
																	<span class="label label-danger spanMsg" id="span${message.id}" value="2"><g:message code="general.error"/></span>
																</g:elseif>
																<g:elseif test="${message.type==3}">
																	<span class="label label-success spanMsg" id="span${message.id}" value="3"><g:message code="general.success"/></span>
																</g:elseif>
															</td>
															<td id="td${message.id}" original="${message.message}">
															
																		${message.message}		
																										
															</td>
															<td>
																<g:if test="${message.byClueWords}">
																	<label>
																		<input id="${message.id}" type="checkbox" class="ios-switch enabledcheck" checked/>
																		<div class="switch"></div>
																	</label>
																</g:if>
																<g:else>
																	<label>
																		<input id="${message.id}" type="checkbox" class="ios-switch enabledcheck" />
																		<div class="switch"></div>
																	</label>
																</g:else>
															</td>
															<td>
																<label>
																	<input id="${message.id}" obj="${message.object.id}" type="checkbox" class="ios-switch messageChk"/>
																	<div class="switch"></div>
																</label>
															</td>
															<sec:ifAnyGranted roles="${functionality11.roles}">
																<td>
																	<a href="#" onclick='showEditMessageModal(${message.id}); return false;' >
																	<i class="fa fa-pencil-square-o "> </i></a>

																	<a style="color:red;" href="#" onclick="setMessageDeletingId(${message.id}); return false;">
																	<i class="fa fa-trash-o"> </i></a>
																</td>
															</sec:ifAnyGranted>
														</tr>	
													</g:each>
												</tbody>
											</table>
										</div>
										</sec:ifAnyGranted>
										<sec:ifNotGranted roles="${functionality10.roles}">
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
							<!--Tab -->
					</div>
					<!--Tab content-->
			</div>
			<!--Nav Tabs-->
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

	<!-- Modal de creación de página -->
	<div id="newPageModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">

				<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h3>
						<g:message code="text.newPage" />
					</h3>
				</div>
				<div class="modal-body">
					<div id="" style="margin-left: 20px; margin-right: 20px;">
						<label for="project"><g:message code="text.project" /></label> <select
						id="projectsSelect" class="form-control" name="project">
						<g:each in="${projects}">
						<option value="${it.id}">
							${it.name}
						</option>
					</g:each>
				</select>
				<br> 
				<label for="name"><g:message code="text.name" /></label>
				<input class="form-control" type="text" name="name" id="pageName"><br>
				<label for="description"><g:message code="text.description" /></label>
				<input class="form-control" type="text" name="description"
				id="pageDescription"><br> <label><g:message
				code="text.privatePage" /><input id="isPrivatePage"
				type="checkbox" class="ios-switch" />
				<div class="switch"></div></label> <br> <br> <input type="button"
				id="formNewPageButton" class="btn btn-info" value="<g:message code='general.text.continue' />"
				onclick="savePage(this)">
			</div>
		</div>
	</div>
	<div style="display: none" id="loadingStateEdit" class="overlay">
		<i class="fa fa-refresh fa-spin"></i>
	</div>
	</div>


	</div>

	<!-- fin del modal de creación de página -->



	<!-- Modal de creación de página para mensaje -->
	<div id="newPageModalForMessage" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">

				<div class="modal-header alert-info">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h3>
						<g:message code="text.newPage" />
					</h3>
				</div>
				<div class="modal-body">
					<div id="" style="margin-left: 20px; margin-right: 20px;">
						<label for="project"><g:message code="text.project" /></label> 
						<select id="projectsSelectForMessage" class="form-control" name="project">
							<g:each in="${projects}">
								<option value="${it.id}">
									${it.name}
								</option>
							</g:each>
						</select>
						<br> 
						<label for="name"><g:message code="text.name" /></label>
						<input class="form-control" type="text" name="name" id="pageNameForMessage"><br>
						<label for="description"><g:message code="text.description" /></label>
						<input class="form-control" type="text" name="description"
						id="pageDescriptionForMessage"><br> <label><g:message
						code="text.privatePage" /><input id="isPrivatePage"
						type="checkbox" class="ios-switch" />
						<div class="switch"></div></label> <br> <br> <input type="button"
						id="formNewPageButtonForMessage" class="btn btn-info" value="<g:message code='general.text.continue' />" onclick="savePageForMessage()">
					</div>
				</div>
			</div>
			<div style="display: none" id="loadingStateEdit" class="overlay">
				<i class="fa fa-refresh fa-spin"></i>
			</div>
		</div>
	</div>

	<!-- fin del modal de creación de página para mensaje-->






	<!-- Modal de confirmación de borrado de objeto -->
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
						onclick="deleteObject()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de confirmación de borrado de objeto -->
	<div id="confirmMessageModal" class="modal fade " role="dialog">
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
						onclick="deleteMessage()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de confirmación de borrado de objeto -->
	<div id="confirmMessageDeleteModal" class="modal fade " role="dialog">
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
						onclick="masiveDeleteObject()">
						<g:message code="general.text.continue" />
					</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Final del modal de confirmación -->

	<!-- Modal de error de creación de página -->

	<div id="newPageErrorModal" class="modal fade " role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header alert-error">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.error" />
					</h4>
				</div>
				<div class="modal-body">
					<p id="newPageErrorMessage"></p>
				</div>
			</div>

		</div>
	</div>

	<!--Fin del modal de error de creación de página-->




	<!-- Modal de selección de la página -->

	<div id="pageSelectModal" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-success">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.selectThePage" />
					</h4>
				</div>
				<div class="modal-body">
					<label for="projectSelect"><g:message code="text.project"/></label>
						<select id="projectSelect" class="form-control">
							<g:each in="${projects}" var="project">
								<option value="${project.id}">${project.name}</option>
							</g:each>
						</select><br/>
						<label for="pageSelect"><g:message code="text.page"/></label>
						<select id="pageSelect" class="form-control">
						<g:if test="${pagesGroups.size()>0}">
							<g:if test="${pagesGroups[0].size()>0}">
								<g:each in="${pagesGroups[0]}" var="page">
									<option value="${page.id}">${page.name}</option>
								</g:each>
							</g:if>
							<g:else>
								<option value="null"> </option>
						</g:else>
						</g:if>
						<g:else>
							<option value="null"> </option>
						</g:else>
						<option value="new" style="color: #00C0EF;" >✚ <g:message code="text.newPage"/></option>
						</select>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					
					
					<g:if test="${pagesGroups.size()>0}">
							<g:if test="${pagesGroups[0].size()>0}">
								<button type="button" id="addObjectsButton"class="btn btn-success "
									onclick="addObjectsToPage()">
									<g:message code="general.text.continue" />
								</button>
							</g:if>
							<g:else>
								<button type="button" id="addObjectsButton"class="btn btn-success "
									onclick="addObjectsToPage()" disabled>
									<g:message code="general.text.continue" />
								</button>
							</g:else>
					</g:if>
					<g:else>
							<button type="button" id="addObjectsButton"class="btn btn-success "
								onclick="addObjectsToPage()" disabled>
								<g:message code="general.text.continue" />
							</button>
					</g:else>
				</div>


			</div>

		</div>
	</div>
	<!-- Fin del modal de selección de página -->



	<!-- Modal de selección de la página para mensaje-->

	<div id="pageSelectModalForMessage" class="modal fade " role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header alert-success">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">
						<g:message code="text.selectThePage" />
					</h4>
				</div>
				<div class="modal-body">
					<label for="projectSelectForMessage"><g:message code="text.project"/></label>
						<select id="projectSelectForMessage" class="form-control">
							<g:each in="${projects}" var="project">
								<option value="${project.id}">${project.name}</option>
							</g:each>
						</select><br/>
						<label for="pageSelectForMessage"><g:message code="text.page"/></label>
						<select id="pageSelectForMessage" class="form-control">
						<g:if test="${pagesGroups.size()>0}">
							<g:if test="${pagesGroups[0].size()>0}">
								<g:each in="${pagesGroups[0]}" var="page">
									<option value="${page.id}">${page.name}</option>
								</g:each>
							</g:if>
							<g:else>
								<option value="null"> </option>
						</g:else>
						</g:if>
						<g:else>
							<option value="null"> </option>
						</g:else>
						<option value="new" style="color: #00C0EF;" >✚ <g:message code="text.newPage"/></option>
						</select>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">
						<g:message code="general.text.cancel" />
					</button>
					
					
					<g:if test="${pagesGroups.size()>0}">
							<g:if test="${pagesGroups[0].size()>0}">
								<button type="button" id="addMessagesButton"class="btn btn-success "
									onclick="addMessagesToPage()">
									<g:message code="general.text.continue" />
								</button>
							</g:if>
							<g:else>
								<button type="button" id="addMessagesButton"class="btn btn-success "
									onclick="addMessagesToPage()" disabled>
									<g:message code="general.text.continue" />
								</button>
							</g:else>
					</g:if>
					<g:else>
							<button type="button" id="addMessagesButton"class="btn btn-success "
								onclick="addMessagesToPage()" disabled>
								<g:message code="general.text.continue" />
							</button>
					</g:else>
				</div>


			</div>

		</div>
	</div>
	<!-- Fin del modal de selección de página para mensaje-->



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

	<!-- Modal de edición de message -->
<div id="editMessageModal" class="modal fade" role="dialog" >
	<div class="modal-dialog">
		<!-- Modal content-->
		<div class="modal-content" style="overflow-y: auto;">
			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.edit" />
					<g:message code="text.message" />
				</h3>
			</div>
			<div class="modal-body">
				<br>
				<div id="formEditMessage" style="margin-left: 20px; margin-right: 20px; margin-bottom:30px;">
					
					<label for="editObjectsDropdown"><g:message
					code="text.object" /></label> 
					<select  class="form-control" id="editObjectsDropdown">
							<g:each status="j" var="object" in="${objects}">
								<option style="color:#555" id="${object.id}" value="${object.id}" imageUrl="${object.imageUrl}">
									${object.name}
								</option>
							</g:each>
						
					</select>
					<label for="editTypeDropdown"><g:message code="text.type"/></label>
					<select class="form-control" id="editTypeDropdown">
						<option value="1"><g:message code="general.pending"/></option>
						<option value="2"><g:message code="general.error"/></option>
						<option value="3"><g:message code="general.success"/></option>
					</select>
					<br> 
					<label for="editMessageMessage">
						<g:message code="text.message"/>
					</label>
				
					<div id="editMessageClueDiv" style="display:none; margin-bottom:20px">
			
					</div>
					<br class="editCluebr" style="display:none"/>
					<input id="editMessageMessage" name="editMessageMessage" type="text" class="form-control"/>
					<button id="editMessageAddClue" class="btn btn-default pull-right" style="display:none; margin-top:10px;"><g:message code="text.add"/><i class="fa fa-plus"></i></button>
					<div id="editClueWordsBr">
						<br/>
						<br/>
					</div>
					<label class="form-control" style="margin-top:10px">
						<g:message code="text.byClueWords" />
						<input id="editByClueWords" type="checkbox" class="ios-switch " />
						<div class="switch"></div>
					</label>
					<br/>
					
				</div>
			</div>
		</div>
	</div>
</div>
<!-- fin del modal de edición de message -->



	<asset:javascript src="zoom.js"/>


	<script>
	var objectsToAdd=""
	var objectsToDelete=""
	var currentPage = 0;
	var numPerPage = 10;
	var currentProject
	var objectDeletingId
	var fullyLoaded = false;

	var messagesToAdd=""
	var messageDeletingId = null;
	var messageEditPrincipalHtml=""

		
		$(window).load( function(){
			notificationsInterval = setInterval(getNotifications, 8000);
			enableSearch()
			executeSupportScripts()
		})

		$('#expiredSessionModal').on('hidden.bs.modal', function(){
			location.reload()
		})

		$('#rowsPerPageSelect').change(function(){
			numPerPage = $(this).val()
			$('.pager').remove()
			makeTablePaginated()
		}); 

		$('#messageRowsPerPageSelect').change(function(){
			numPerPage = $(this).val()
			$('.pager').remove()
			makeTablePaginated()
		}); 

		$('#addToPageButton').click(	
			function (){
		        $("#pageSelect")[0].selectedIndex = 0;
				objectsToAdd =""
					$('.objcheck').each(function(i, obj) {
			    		if($(this).prop('checked')){
								objectsToAdd+=$(this).attr('id')+","
				    		}
					});
				if(objectsToAdd!=""){
					$("#pageSelectModal").modal('show')
				}
			}
		);

		$('#deleteSelection').click(	
			function (){		        
				objectsToDelete =""
					$('.objcheck').each(function(i, obj) {
			    		if($(this).prop('checked')){
							objectsToDelete+=$(this).attr('id')+","
				    	}
					});
				if(objectsToDelete!=""){
					$("#confirmMessageDeleteModal").modal('show')
				}
			}
		);

		function masiveDeleteObject(){			
			$.ajax({
				type: 'POST',
			    url: "${createLink(action:'deleteObjects', controller:'stage')}",
			    data:{
			   		objectsToDelete:objectsToDelete
			   	},
				success: function (dataCheck) {
				   location.reload(true)				   
				},
				error: function(status, text, result, xhr){
					$('#newPageErrorMessage').html(status.responseText)
					$('#newProjectErrorModal').modal('show');
				}			
			});
		}


		$('#addMessageToPageButton').click(	
			function (){
		        $("#pageSelectForMessage")[0].selectedIndex = 0;
				messagesToAdd =""
					$('.messageChk').each(function(i, obj) {
			    		if($(this).prop('checked')){
								messagesToAdd+=$(this).attr('id')+","
				    		}
					});
				if(messagesToAdd!=""){
					$("#pageSelectModalForMessage").modal('show')
				}
			}
		);

		function confirmDelete(id){
			objectDeletingId =id
			$('#confirmModal').modal('show')
		}



		$('#pageSelect').change( function (e) {
		var val = $(this).val()
			if(val=="new"){
				showNewPageModal()
			}
			
		})


		$('#pageSelectForMessage').change( function (e) {
		var val = $(this).val()
			if(val=="new"){
				showNewPageModalForMessage()
			}
			
		})



		function addObjectsToPage(){
			var page= $('#pageSelect').val()
			$.ajax({
				type: 'POST',
			    url: "${createLink(action:'saveObjects', controller:'page')}",
			    data:{
			   		objectsToSave:objectsToAdd,
			   		id: page
			   		},
					success: function (dataCheck) {
					   location.reload(true)
					},
					error: function(status, text, result, xhr){
							$('#newPageErrorMessage').html(status.responseText)
							$('#newProjectErrorModal').modal('show');
					}			
				});
		}



		function addMessagesToPage(){
			var page= $('#pageSelectForMessage').val()
			$.ajax({
				type: 'POST',
			    url: "${createLink(action:'saveMessages', controller:'page')}",
			    data:{
			   		messagesToSave:messagesToAdd,
			   		id: page
			   		},
					success: function (dataCheck) {
					   location.reload(true)
					},
					error: function(status, text, result, xhr){
							$('#newPageErrorMessage').html(status.responseText)
							$('#newProjectErrorModal').modal('show');
					}			
				});
		}	

		function savePage(button) {
			$(button).prop("disabled", true)
			$(button).html("<i class='fa fa-spinner fa-spin'></i>");
			var description=$('#pageDescription').val()
			var name=$('#pageName').val()
			var isPrivate = $("#isPrivatePage").prop('checked')
			
			var project = $('#projectsSelect').val()
			$.ajax({
				type: 'POST',
				url: "${createLink(action:'saveWithObjects', controller:'page')}",
				data: { 
					description: description,
					name:name,
					isPrivate:isPrivate,
					projectId:project,
					objectsToSave:objectsToAdd },

					success: function (dataCheck) {
						location.reload()
					},
					error: function(status, text, result, xhr){
						var errors = status.responseText
						$(button).html("${message(code:'general.text.save')}")
						$(button).prop("disabled", false)
						$('#loadingStateEdit').css("display","none");
						$('#newPageModal').modal('hide');
						$('#newPageErrorMessage').html(errors)
						$('#newPageErrorModal').modal('show');
					}
				});
		}


		function savePageForMessage() {
			var description=$('#pageDescriptionForMessage').val()
			var name=$('#pageNameForMessage').val()
			var isPrivate = $("#isPrivatePageForMessage").prop('checked')
			
			var project = $('#projectsSelectForMessage').val()
			$.ajax({
				type: 'POST',
				url: "${createLink(action:'saveWithMessages', controller:'page')}",
				data: { 
					description: description,
					name:name,
					isPrivate:isPrivate,
					projectId:project,
					messagesToSave:messagesToAdd },

					success: function (dataCheck) {
						location.reload()
					},
					error: function(status, text, result, xhr){
						var errors = status.responseText
						
						$('#loadingStateEdit').css("display","none");
						$('#newPageModal').modal('hide');
						$('#newPageErrorMessage').html(errors)
						$('#newPageErrorModal').modal('show');
					}
				});
		}





		function showNewPageModal(){
			$('#pageSelectModal').modal('hide')
			$('#newPageModal').modal('show')
		}

		function showNewPageModalForMessage(){
			$('#pageSelectModalForMessage').modal('hide')
			$('#newPageModalForMessage').modal('show')
		}

		$('#newPageModal').on('show.bs.modal', function(){
			if(currentProject){
				$('#projectsSelect').val(currentProject)
			}
		})

		$('#newPageModalForMessage').on('show.bs.modal', function(){
			if(currentProject){
				$('#projectsSelect').val(currentProject)
			}
		})

	function deleteObject(){
		$.ajax({
				type: 'POST',
			    url: "${createLink(action:'deleteObject', controller:'stage')}",
			    data:{
			   		id: objectDeletingId
			   		},
					success: function (dataCheck) {
					   location.reload(true)
					},
					error: function(status, text, result, xhr){
							$('#newPageErrorMessage').html(status.responseText)
							$('#newProjectErrorModal').modal('show');
					}			
				});
	}
	function deleteMessage(){
		$.ajax({
				type: 'POST',
			    url: "${createLink(action:'deleteFromStage', controller:'message')}",
			    data:{
			   		id: messageDeletingId
			   		},
					success: function (dataCheck) {
						$('#confirmMessageModal').modal('hide');
					    $('#'+messageDeletingId+'.messageTr').remove()
					},
					error: function(status, text, result, xhr){
							$('#newPageErrorMessage').html(status.responseText)
							$('#newProjectErrorModal').modal('show');
					}			
				});
	}



		
		$("#selectAllSwitch").change(function() {
		    if(this.checked) {
		    	$('.objcheck:visible').each(function(i, obj) {
		    		$(this).prop('checked',true)
				});
		    }
		    else{
		    	$('.objcheck:visible').each(function(i, obj) {
		    		$(this).prop('checked',false)
				});
		    }
	    })


	$('#projectSelect').change( function (e) {
		console.log('${pagesGroups}')
		var index = $(this).prop('selectedIndex')
		currentProject = $(this).val()
		<g:each in="${pagesGroups}" var="pageGroup" status="i">
			if(index==${i}){
				$('#pageSelect').empty()
				<g:if test="${pageGroup.size()==0}">
						$('#pageSelect').append('<option value="null"> </option>')
						$('#addObjectsButton').prop('disabled', true);
				</g:if>
				<g:else>
					$('#addObjectsButton').prop('disabled', false);
					<g:each in="${pageGroup}" var="page">
						$('#pageSelect').append('<option value="${page.id}">${page.name}</option>')
					</g:each>
				</g:else>
				var texto = "${message(code:'text.newPage')}"
				$('#pageSelect').append('<option value="new" style="color: #00C0EF;" >✚ '+texto+'</option>')
			}
		</g:each>
	});

	$('#projectSelectForMessage').change( function (e) {
		console.log('${pagesGroups}')
		var index = $(this).prop('selectedIndex')
		currentProject = $(this).val()
		<g:each in="${pagesGroups}" var="pageGroup" status="i">
			if(index==${i}){
				$('#pageSelectForMessage').empty()
				<g:if test="${pageGroup.size()==0}">
						$('#pageSelectForMessage').append('<option value="null"> </option>')
						$('#addMessagesButton').prop('disabled', true);
				</g:if>
				<g:else>
					$('#addMessagesButton').prop('disabled', false);
					<g:each in="${pageGroup}" var="page">
						$('#pageSelectForMessage').append('<option value="${page.id}">${page.name}</option>')
					</g:each>
				</g:else>
				var texto = "${message(code:'text.newPage')}"
				$('#pageSelectForMessage').append('<option value="new" style="color: #00C0EF;" >✚ '+texto+'</option>')
			}
		</g:each>
	});



	    $('#selectAllObjects').change(function(){
			if(this.checked) {
				$('.trSelectable').each(function(i, obj) {
					$(this).css('background-color','#ccd9ff')
					$(this).attr('select','1')
				});
			}
			else{
				$('.trSelectable').each(function(i, obj) {
					$(this).css('background-color','')
					$(this).attr('select','0')
				});
			}


		})


		$('.trSelectable').click(function(){
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


	function setMessageDeletingId(newId){
		messageDeletingId = newId
		$('#confirmMessageModal').modal('show');
	}



	function showEditMessageModal(id )
	{
		
		editingId=id

		$('#editObjectsDropdown option[value='+$('#'+editingId+'.tdObj').attr('idObj')+']').prop('selected', true);
		$('#editObjectsDropdown').change()
		
		$('#editMessageMessage').attr('original',$('#td'+editingId).attr('original'))
		$('#editTypeDropdown option[value='+$('#span'+editingId).attr('value')+']').prop('selected', true);
		if($('#'+editingId+".enabledcheck").prop('checked')){
			$('#editClueWordsBr').show()
			
			$('#editByClueWords').prop('checked',true)
			var splittedMessage = $('#td'+editingId).attr('original').split('#;#')
			var html="";
			for(var i=0; i<splittedMessage.length;i++){
				if(i%6==0){
					html+="<div style='margin-bottom:2px'>"
				}
				html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
				if(i%6==5){
					html+="</div>"
				}
			}
			$('#editMessageClueDiv').html(html)
			$('#editMessageClueDiv').css('display','block')
			$('#editMessageAddClue').css('display','block')
			$('.editCluebr').each(function(){
				$(this).css('display','block')
			})
			$('#editMessageMessage').val('')
		}
		else{
			$('#editClueWordsBr').hide()
			$('#editByClueWords').prop('checked',false)
			$('#editMessageMessage').val($('#td'+editingId).attr('original'))
			$('#editMessageClueDiv').css('display','none')
			$('#editMessageAddClue').css('display','none')
			$('.editCluebr').each(function(){
				$(this).css('display','none')
			})

		}

		


		
		
		$('#editMessageModal').modal('show');
	}






	$('.caretButton').click(function (){
		var objs = ""
		$( "#sObjectsTable > tbody > .trSelectable" ).each(function() {
			if($(this).attr('select')=='1'){
				var id = $(this).attr('idobj')
				objs+=  ( id  )+"," ;
			}
		});
		if(objs!=""){
			$.ajax({
				method: 'POST',
				url: "${createLink(action:'createFromStageObject', controller:'message')}",
				data:{
					objects:objs,
				},
				success: function(result) {
					for(var j=0;j<result.length;j++){
						$('#messagesTable').append('<tr id="'+result[j].id+'" class="messageTr"><td class="">'+result[j].object+'</td><td><img  class="zoomImage " style="max-height:50px; max-width:150px" src="'+"${createLink(controller:'stage', action:'renderImage')}"+'?idOb='+result[j].imageUrl+'"</td><td><span class="label bg-blue">'+"${message(code:'general.pending')}"+'</span></td><td id="td'+result[j].id+'" original="'+result[j].message+'">'+result[j].message+'</td><td><label><input id="'+result[j].id+'" type="checkbox" class="ios-switch enabledcheck" /><div class="switch"></div></label></td><td><label><input id="'+result[j].id+'" obj="'+result[j].objectId+'" type="checkbox" class="ios-switch messageChk"/><div class="switch"></div></label></td><td><a href="#" onclick="showEditMessageModal('+result[j].id+'); return false;" ><i class="fa fa-pencil-square-o "></i></a><a style="color:red;" href="#" onclick="setMessageDeletingId('+result[j].id+'); return false;"><i class="fa fa-trash-o"> </i></a></td></tr>')
					}
					executeSupportScripts()
					
					
				},
				error: function(status, text, result, xhr) {
					alert("error")
				}
			});

		}
	})




	$('.caretButton').mousedown(function (){
		$(this).css('color','orange')
	})
	$('.caretButton').mouseup(function (){
		$(this).css('color','green')
	})

 $('#editObjectsDropdown').change(function(){
 	var newId =  $('#editObjectsDropdown option:selected').val()
 	var newVal =  $('#editObjectsDropdown option:selected').text()
 	var newUrl = $('#editObjectsDropdown option:selected').attr('imageUrl')

 	$('#'+editingId+'.tdObj').text(newVal.trim())
 	$('#img'+editingId).attr('src', '${createLink(controller:"stage", action:"renderImage")}?idOb='+newUrl)
	updateInRealTime()
 })


$('#editTypeDropdown').change(function(){

	if($(this).val()=='1'){
		var element = $('#span'+editingId)
		element.text("${message(code:'general.pending')}")
		element.removeClass()
		element.addClass('label bg-blue spanMsg')
		element.attr('value', '1')
	}
	else if($(this).val()=='2'){
		var element = $('#span'+editingId)
		element.text("${message(code:'general.error')}")
		element.removeClass()
		element.addClass('label label-danger spanMsg')
		element.attr('value', '2')
	}
	else if($(this).val()=='3'){
		var element = $('#span'+editingId)
		element.text("${message(code:'general.success')}")
		element.removeClass()
		element.addClass('label label-success spanMsg')
		element.attr('value', '3')
	}	

	updateInRealTime()
 })

$('#editMessageMessage').keyup(function (){
	if(!$('#'+editingId+".enabledcheck").prop('checked')){
			$('#td'+editingId).text($(this).val())
			$('#td'+editingId).attr('original',$(this).val())
			updateInRealTime()		
	}

})





	function updateInRealTime() {
		var object = $('#editObjectsDropdown option:selected').val()
		var byClueWords = $('#editByClueWords').prop('checked')
		var message = $('#editMessageMessage').val()
		if(byClueWords)
		 message = $('#editMessageMessage').attr('original')
		
		var type = $('#editTypeDropdown option:selected').val()
		var all = $('#editMessageScopeSelect').prop('selectedIndex') == 0?true:false
		var scope ='ALL'
		if(!all){
			scope=$('#editMessageFromRange').val()+"#"+$('#editMessageToRange').val()
		}


		$.ajax({
			method: 'POST',
			url: "${createLink(action:'updateFromStage', controller:'message')}",
			data:{
				
				id: editingId,
				object:object,
				message:message,
				byClueWords:byClueWords,
				type:type,
				scope:scope,
			},
			success: function(dataCheck) {
				
			},
			error: function(status, text, result, xhr) {
				$('#editMessageModal').modal('hide');
				$('#messageErrorMessage').html(status.responseText)
				$('#messageErrorModal').modal('show');
			}
		});

	}





$('#editByClueWords').change(function(){
	var currentMessage =""
	if(this.checked){
		$('#'+editingId+".enabledcheck").prop('checked', true)
		currentMessage = $('#editMessageMessage').val().trim()
		$('#editMessageMessage').attr('original',currentMessage)
		var newMessages = currentMessage.split(' ')
		var html="" 
		var tdHtml =""
		for(var i=0;i<newMessages.length;i++){
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
			tdHtml+= '<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
			if(i%3==2)
				tdHtml+="<div style='margin-bottom:2px;'></div>"


		}
		$('#editClueWordsBr').show()
		$('#editMessageClueDiv').html(html)
		$('#td'+editingId).html(tdHtml)
		$('#td'+editingId).attr('original',currentMessage)
		$('#editMessageClueDiv').css('display','block')
		$('#editMessageAddClue').css('display','block')
		$('#editMessageMessage').val("")
		$('.editCluebr').each(function(){
			$(this).css('display','block')
		})

	}
	else{
		$('#'+editingId+".enabledcheck").prop('checked', false)	
		$('#'+editingId+".enabledcheck").change()	
		currentMessage = $('#td'+editingId).attr('original')
		$('#editMessageClueDiv').css('display','none')
		$('#editMessageAddClue').css('display','none')
		$('.editCluebr').each(function(){
			$(this).css('display','none')
		})
		$('#editClueWordsBr').hide()
		$('#editMessageMessage').val(currentMessage)


	}
	updateInRealTime()
})

$('#editMessageAddClue').click(function(){
	var newMessage = $('#editMessageMessage').val().trim()
	var splittedMessage = newMessage.split(' ')
	var curOriginal = $('#editMessageMessage').attr('original')

	$('#editMessageMessage').attr('original',curOriginal+" "+newMessage)
	$('#td'+editingId).attr('original',curOriginal+" "+newMessage)
	var html = $('#editMessageClueDiv').html()
	var tdHtml = $('#td'+editingId).html()
	var curCount = $('#editMessageClueDiv span').size()
	for(var i=0;i<splittedMessage.length;i++){
		if(((curCount+i)%3)==0){
			tdHtml+="<div style='margin-bottom:2px'></div>"
		}
		
		if(((curCount+i)%6)==0){
			html+="<div style='margin-bottom:2px'></div>"
		}
			html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
			tdHtml+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+splittedMessage[i]+'</span>'
		

	}
	
	$('#td'+editingId).html(tdHtml)
	$('#editMessageClueDiv ').html(html)
	updateInRealTime()
})


function executeSupportScripts(){

		$('.messageChk').change(function(i, obj) {
			var curObj = $(this).attr('obj')
			if(this.checked){
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', true)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', true)
				})


			}
			else{
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', false)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', false)
				})

			}
		});




		$('.objcheck').change(function(i, obj) {
			var curObj = $(this).attr('id')
			if(this.checked){
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', true)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', true)
				})


			}
			else{
				$('.messageChk').each(function(){
					if($(this).attr('obj')==curObj)
						$(this).prop('checked', false)
				})
				$('.objcheck').each(function(){
					if($(this).attr('id')==curObj)
						$(this).prop('checked', false)
				})

			}
		});


		$('.enabledcheck').change(function(){
			var currentMessage = $('#td'+$(this).attr('id')).attr('original')
			var byClueWords = "false"
			if(this.checked){
				byClueWords="true"
				var newMessages = []
				var newOriginal = currentMessage

				if(currentMessage.split('#;#').length>1){
					newMessages = currentMessage.split('#;#')	
				}
				else{
					newOriginal = currentMessage.split(' ').join('#;#')
					newMessages = currentMessage.split(' ')	
				}
				
				var html=""
				for(var i=0;i<newMessages.length;i++){
					if(i%3==0){
						html+="<div style='margin-bottom:2px'>"
					}
					html+='<span class="label label-info" style="margin-right:5px; margin-left:5px;">'+newMessages[i]+'</span>'
					if(i%3==2){
						html+="</div>"
					}
				}
				$('#td'+$(this).attr('id')).html(html)
				$('#td'+$(this).attr('id')).attr('original',newOriginal)

			}
			else{
				var newMessage = currentMessage.split('#;#').join(" ")
				$('#td'+$(this).attr('id')).html(newMessage)
				$('#td'+$(this).attr('id')).attr('original',newMessage)
			}


				if(fullyLoaded){
					$.ajax({
							method: 'POST',
							url: "${createLink(action:'changeByClueWords', controller:'message')}",
							data:{
								id: $(this).attr('id'),
								byClueWords: byClueWords,
							},
							success: function(dataCheck) {
							
							},
							error: function(status, text, result, xhr) {
								alert("error")
						}
					});
				}
		})





		$("#selectAllMessagesSwitch").change(function() {


			if(this.checked) {
				$('.messageChk').each(function(i, obj) {
					$(this).prop('checked',true)
				});


			}
			else{
				$('.messageChk').each(function(i, obj) {
					$(this).prop('checked',false)
				});
			}
		})
			fullyLoaded=false;
			setZoomImages()
			$('.pager').remove()
			makeTablePaginated()
			$('.enabledcheck').each(function()
				{
					$(this).change()
				})
			fullyLoaded=true;
}





$('.filter').change(function (){
	var objects = ""
	 <g:each status="i" var="obj" in="${objects.findAll{!it.autoGenerated}}">
		 objects += '<tr type="${obj.pType}" creator="${obj.creator.id}" recName="${obj.recName}"><td >${obj.name}</td><td><img  class="zoomImage " style="max-height:50px; max-width:150px;" src="${createLink(controller: "stage", action:"renderImage", params:[idOb:obj.imageUrl])}" /></td><td>${obj.creator.fullname}</td><td>${obj.recName}</td><td id="dateCreated${obj.id}">'+ new Date("${obj.dateCreated}").adjustDate() + '</td><td id="type${obj.id}">'
		<g:if test="${obj.pType==1}">
		 	objects+= '<small class="label label-success">WEB</small>'
		</g:if>
		<g:elseif test="${obj.pType==2}">
			objects += '<small class="label label-info">GUI</small>'
		</g:elseif>
		<g:elseif test="${obj.pType==3}">
			objects += '<small class="label label-warning">CLI</small>'
		</g:elseif>
		<g:elseif test="${obj.pType==4}">
			objects += '<small class="label label-danger">UFT</small>'
		</g:elseif>
		<g:elseif test="${obj.pType==5}">
			objects +='<small class="label" style="background-color:#8b6ecc">RFT</small>'
		</g:elseif>
		objects += '</td><td><label><input id="${obj.id}" type="checkbox" class="ios-switch objcheck" /><div class="switch"></div></label></td><td><g:if test="${obj.creator.username==curUsername}"><a href="#" onclick="confirmDelete(${obj.id}); return false;" style="color:red"><i class="fa fa-trash"></i></a></g:if><g:else><a href="#" onclick="return false;"><i class="fa fa-trash"></i></a></g:else></td></tr>'
	</g:each>

	$('#objectsTable > tbody').html($(objects)) 
	var creator =  $('#creatorSelector').val()
	var recName = $('#recNameSelector').val()
	var type = $('#typeSelector').val()
	$('#objectsTable > tbody tr').each(function(){
		$(this).attr('class', '')
		if(creator!='null'){
			if($(this).attr('creator')!==creator){
				$(this).remove()
			}
		}
		if(recName!='null'){
			if($(this).attr('recName')!=recName){
				$(this).remove()
			}
		}
		if(type!='null'){
			if($(this).attr('type')!==type){
				$(this).remove()
			}
		}
	})
	$('.pager').remove()
	makeTablePaginated()
})










		
</script>

</div>