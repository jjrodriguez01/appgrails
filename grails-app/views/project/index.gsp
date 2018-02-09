<sec:ifAllGranted roles="ROLE_USER_LEADER">
	<g:render template="/user/leader/navBar"/>
</sec:ifAllGranted>
<sec:ifNotGranted  roles="ROLE_USER_LEADER">
	<g:render template="/user/user/navBar"/>
</sec:ifNotGranted>

<div class="content-wrapper">
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
								<g:message code="text.projects" />
							</a>
						</li>
						<sec:ifAnyGranted roles="${functionality3.roles}">
							<li>
								<a href="#newProject-chart" data-toggle="tab">
								<i class="fa fa-plus" style="color: green"> </i> 
								<g:message code="text.new" /> </a>
							</li>
						</sec:ifAnyGranted>						
						<li class="pull-left header"><i class="fa fa-inbox"> </i> 
							<g:message code="text.projects" />
						</li>
					</ul>


					<div class="tab-content no-padding">
						<div class="chart tab-pane active" id="revenue-chart" style="position: relative;">
							<div class="box">

								<!-- /.box-header -->
								<div class="box-body" style="overflow-x:scroll">
										<div class="col-md-6">
											
										</div>
										<div class="col-md-6">
											<ol class="breadcrumb pull-right" style="background-color:white">
									        	<li><g:link controller='user' action='renderIndex'><g:message code="general.home"/></g:link></li>
									       		<li class="active"><g:message code="text.projects"/></li>
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
										<input id="datatablesearch" table="projectsTable"  name="search" type="text">
										</input>
									</div>
											<table id="projectsTable"
												class="table table-bordered table-striped sortable paginated">
												<thead>
													<tr>
														<th><g:message code="text.name" /></th>
														<th><g:message code="text.description" /></th>
														<th><g:message code="text.scenarios"/></th>
														<th><g:message code="text.pages" /></th>
														<th><g:message code="text.info" /></th>
														<sec:ifAnyGranted roles="${functionality4.roles}">
															<th><g:message code="text.edit" /></th>
														</sec:ifAnyGranted>
													</tr>
												</thead>
												<tbody>
													<g:each in="${projects}">
														<tr>
															<td>																
																<g:if test="${it.name.length()>80 && it.name.indexOf(' ')<0}">
																	<a id="link${it.id}" href="${createLink(controller:'scenario', action:'index', id:it.id)}" class='customLink navLink' data-toggle="tooltip" title="${it.name}">
																			${it.name.substring(0,80)}...
																	</a>
																</g:if>
																<g:else>
																	<a id="link${it.id}" href="${createLink(controller:'scenario', action:'index', id:it.id)}" class='customLink navLink' >
																	${it.name}
																	</a>
																</g:else>																
																<script>																
																</script>
															</td>
															<td id="description${it.id}">
																${it.description}
															</td>
															<td>
																<g:link controller="scenario" action="index" class="navLink"
																	id="${it.id}">
																	<g:message code="text.viewScenarios" />
																</g:link>
															</td>
															<td>
																<g:link controller="page" action="index"
																		id="${it.id}" class="navLink">
																	<g:message code="text.viewPages" />
																</g:link>
															</td>
															<td>
																<!--a href="#"
																	onclick="showInfoProjectModal('${it.name}', '${it.description}','${it.lastUpdated}','${it.dateCreated}','${it.lastUpdater.fullname}'); return false;"-->
																	<a href="#"
																	onclick="showInfoProject(${it.id},'${it.lastUpdater.fullname}'); return false;">
																	<g:message code="text.info"/>
																</a>
															</td>
															<sec:ifAnyGranted roles="${functionality4.roles}">
																<td>
																	<a href="#"
																		onclick="showEditProjectModal(${it.id}); return false;">
																		<i class="fa fa-edit"> </i>
																	</a>
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
								<div class="chart tab-pane" id="newProject-chart"
									style="position: relative; height: 300px;">
									<form id="formNewProject"
										style="margin-left: 20px; padding-right: 20px;">
										<br/>
										<label for="name"><g:message code="text.name" /></label> <input
											class="form-control" type="text" name="name" id="name"><br>
										<label for="description"><g:message
												code="text.description" /></label> <input class="form-control"
												type="text" name="description" id="description"><br>
										<button type="button" id="formNewUserButton" class="btn btn-info pull-right"
												 onclick="createProject(this)"><g:message code="general.text.save"/>
										</button>

									</form>
								</div>
							</sec:ifAllGranted>
						
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
<!-- Modal de edición de proyecto -->
<div id="editProjectModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">

			<div class="modal-header alert-info">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.edit" />
					<g:message code="text.project" />
				</h3>
			</div>
			<div class="modal-body">
				<div id="formEditProject"
					style="margin-left: 20px; margin-right: 20px;">

					<label for="name"><g:message code="text.name" /></label> <input
						class="form-control editInput" type="text" name="name" id="editName"><br>
					<label for="description"><g:message code="text.description" /></label>
					<input class="form-control editInput" type="text" name="description"
						id="editDescription"><br> 
				</div>
			</div>
		</div>

	</div>
</div>

<!-- fin del modal de edición de proyecto -->



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


<!-- Modal de exito de registro de proyecto -->

<div id="newProjectSuccessModal" class="modal fade " role="dialog">
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
				<p>
					<g:message code="text.successCreateProject" />
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito de registro de proyecto -->


<!-- Modal de exito de edición de proyecto -->

<div id="editProjectSuccessModal" class="modal fade " role="dialog">
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
				<p>
					<g:message code="text.successEditProject" />
				</p>

			</div>

		</div>

	</div>
</div>
<!-- Fin del modal de exito de edición de proyecto -->




<!-- Modal de error de registro de proyecto -->
<div id="newProjectErrorModal" class="modal fade " role="dialog">
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
				<p id="newProjectErrorMessage"></p>
			</div>
		</div>
	</div>
</div>
<!-- Fin del modal de error de registro de proyecto -->

<!-- Modal de informacion de creacion de proyectos para demo -->
<div id="createProjectInfoModal" class="modal fade " role="dialog">
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
				<g:message code="com.model.Project.restriction.demo" />
			</div>
		</div>
	</div>
</div>
<!-- Fin del modal de info de proyecto -->


<!-- Modal de información de proyecto -->
<div id="infoProjectModal" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
		
			<div class="modal-header alert-info">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h3>
					<g:message code="text.projectInfo" />
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
		<div style="display: none" id="loadingStateEdit" class="overlay">
			<i class="fa fa-refresh fa-spin"></i>
		</div>
	</div>
</div>



<div id="theme-options" class="admin-options">
    <a data-original-title="Color schemes and layout options" id="btn-options" href="javascript:void(0);" onclick="showHideReports();" class="btn btn-primary theme-switcher tooltip-button" data-placement="left" title="">
        <i class="fa fa-file-pdf-o"></i>
    </a>
    <div style="height: 192.429px; z-index:9999" id="theme-switcher-wrapper" class="container">
        <div style="position: relative; overflow: hidden; width: auto; height: 100%; margin:0px 10px;" class="slimScrollDiv">
            <div style="overflow: hidden; width: auto; height: 100%;" >
            <g:form method="post" controller="reports" action="reportGenerate">            	
            	<h4 class="header" style="padding-bottom:8px; padding-top:8px;"><g:message code="general.text.reports"/></h4>
            	<select class="form-control" name="projecId" style="margin-bottom:10px;">
					<g:each in="${projects}">
						<option value="${it.id}" selected="">${it.name}</option>
					</g:each>
				</select>
				<select class="form-control" name="reportType" style="margin-bottom:10px;">
					<option value="reportGeneral" selected=""><g:message code="general.text.generalReport"/></option>
					<option value="excelReport" ><g:message code="general.text.excelReport"/></option>
				</select>				
				<input type="submit" id="generateReport" class="btn btn-info pull-right" value="<g:message code="general.text.generate"  />" />
			</g:form>
            </div>
        </div>
    </div>
</div>

<!-- fin del modal de información de proyecto -->


<script type="text/javascript">

	function showHideReports(){
		if(${projects.size() >= 1}){
			if($("#theme-options").hasClass("active")){
				$("#theme-options").removeClass("active")
			} else {
				$("#theme-options").addClass("active")
			}
		}
	} 

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
		


var editingId=null;
var flag=true
var currentPage = 0;
var numPerPage = 10;


	
	$(window).load( function(){

		notificationsInterval=setInterval(getNotifications, 8000);
		enableSearch()
	})

$('#newProjectErrorModal').on('hidden.bs.modal', function() {
		$("body").css('padding-right','0px')
	})


$('#rowsPerPageSelect').change(function(){
	numPerPage = $(this).val()
	$('.pager').remove()
	makeTablePaginated()
}); 
	
 	makeTablePaginated()

	function createProject(button){
		$(button).prop("disabled", true)
		$(button).html("<i class='fa fa-spinner fa-spin'></i>");
		
		$.ajax({
			url : "${createLink(controller:'project', action:'create')}",
			data:{name:$("#name").val(), description: $("#description").val()},
			success : function(result) {
				window.location.reload(true)
			},
			error: function(status, text, result, xhr){
					if(status.status == 403){
						$(button).html("${message(code:'general.text.save')}")
						$(button).prop("disabled", false)
						$('#createProjectInfoModal').modal('show');
					}else{
						$(button).html("${message(code:'general.text.save')}")
						$(button).prop("disabled", false)
						$('#newProjectErrorMessage').html(status.responseText)
						$('#newProjectErrorModal').modal('show');
					}
				}
		});
	}

	function hideConfirmModal(){
		$('#confirmationModal').modal('hide');
		location.reload()
		
	}

	function showDeleteErrorModal(){
		$('#confirmationModal').modal('hide');
		$('#newProjectErrorMessage').html("${message(code:'text.unexpectedError')}")
		$('#newProjectErrorModal').modal('show');
	}


	function saveProject(){
		var name = $('#editName').val()
		var description = $('#editDescription').val()
		$.ajax({
			url : "${createLink(controller:'project', action:'update')}",
			data:{id:editingId, name:name, description: description },
			success : function(result) {
				if(name!="" && description!=""){
					$('#link'+editingId).text(name)
					$('#description'+editingId).text(description)
				}
				//location.reload()
			},
			error: function(status, text, result, xhr){
				$('#newProjectErrorMessage').html(status.responseText)
				$('#newProjectErrorModal').modal('show');
				}
		});

	}

	$(".editInput").change(function(){
			if(editingId!=null){
				saveProject()
			}
			
		}
	)





	function showEditProjectModal(id){
		console.log("entra el id es: "+id+" el nombre es: "+name+", la descripción es: "+description)
		editingId=id
		$('#editName').val($('#link'+id).text().trim())
		$('#editDescription').val($('#description'+id).text().trim())
		$('#editProjectModal').modal('show');
	}
	
	function showInfoProjectModal(name, description, lastUpdated, dateCreated, updatedBy){

		$('#infoNameField').html(name)
		$('#infoDescriptionField').html(description)
		$('#infoLastUpdatedField').html(new Date(lastUpdated).adjustDate())
		$('#infoDateCreatedField').html(new Date(dateCreated).adjustDate())
		$('#infoLastUpdatedByField').html(updatedBy)
		$('#infoProjectModal').modal('show');
	}

	function showInfoProject(id, updatedBy){
		$.ajax({
			url : "${createLink(controller:'project', action:'showInfo')}",
			data:{id:id},
			success : function(result) {
				$('#infoNameField').html(result.name)
				$('#infoDescriptionField').html(result.description)
				$('#infoLastUpdatedField').html(new Date(result.lastUpdated).adjustDate())
				$('#infoDateCreatedField').html(new Date(result.dateCreated).adjustDate())
				$('#infoLastUpdatedByField').html(updatedBy)
				$('#infoProjectModal').modal('show');
			},
			error: function(status, text, result, xhr){
				$('#newProjectErrorMessage').html(status.responseText)
				$('#newProjectErrorModal').modal('show');
			}
		});
		
	}
	
	var flag=false;


	$("#editProjectModal").on('hidden.bs.modal', function() {
		editingId=null;
	})




	$('#expiredSessionModal').on('hidden.bs.modal', function() {
		location.reload()
	})
	$('#newProjectSuccessModal').on('hidden.bs.modal', function() {
		location.reload()
	})
	$('#editProjectSuccessModal').on('hidden.bs.modal', function() {
		location.reload()
	})
</script>
</div>
</body>
</html>

